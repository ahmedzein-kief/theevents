import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/network/api_endpoints/vendor_api_end_point.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/products/create_product/global_options_data_response.dart';
import 'package:event_app/models/vendor_models/products/create_product/product_overview_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/product_post_data_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_product_dimensions_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_product_seo_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_search_product_data_response.dart';
import 'package:event_app/models/vendor_models/products/holder_models/faq_model.dart';
import 'package:event_app/models/vendor_models/products/holder_models/product_options_post_model.dart';
import 'package:event_app/models/vendor_models/products/holder_models/upload_images_model.dart';
import 'package:event_app/models/vendor_models/products/vendor_get_product_general_settings_model.dart'
    hide TextData;
import 'package:event_app/vendor/components/app_bars/vendor_common_app_bar.dart';
import 'package:event_app/vendor/components/bottom_sheets/draggable_bottom_sheet.dart';
import 'package:event_app/vendor/components/dropdowns/custom_dropdown.dart';
import 'package:event_app/vendor/components/dropdowns/custom_multiselect_dropdown.dart';
import 'package:event_app/vendor/components/settings_components/simple_card.dart';
import 'package:event_app/vendor/components/status_constants/product_type_constants.dart';
import 'package:event_app/vendor/components/status_constants/seo_index_constants.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/product_sections/vendor_product_overview_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/product_sections/vendor_product_seo_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/product_sections/vendor_product_shipping_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/related_products_search_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/upload_images_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/vendor_product_options_screen.dart';
import 'package:event_app/vendor/view_models/vendor_packages/create_package/vendor_create_package_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_packages/create_package/vendor_get_view_package_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_packages/vendor_get_packages_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';

import '../../../../models/vendor_models/products/edit_product/new_product_view_data_response.dart';
import '../../components/text_fields/custom_editable_text_field.dart';
import '../../view_models/vendor_packages/create_package/vendor_get_package_general_settings_view_model.dart';
import '../vendor_products/vendor_create_product/vendor_create_physical_product_view.dart';

class VendorCreatePackageView extends StatefulWidget {
  VendorCreatePackageView({
    super.key,
    this.packageID,
  });

  String? packageID;

  @override
  State<VendorCreatePackageView> createState() =>
      VendorCreatePackageViewState();
}

class VendorCreatePackageViewState extends State<VendorCreatePackageView>
    with MediaQueryMixin {
  ///controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _permalinkController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  /// focus nodes
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _permalinkFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  final ProductPostDataModel createProductPostData = ProductPostDataModel();

  final TextEditingController _imageCountController = TextEditingController();
  final TextEditingController _attributesCountController =
      TextEditingController();
  final TextEditingController _productOptionsCountController =
      TextEditingController();
  final TextEditingController _relatedProductsCountController =
      TextEditingController();
  final TextEditingController _crossSellingProductsCountController =
      TextEditingController();
  final TextEditingController _faqsCountController = TextEditingController();

  List<UploadImagesModel>? selectedImages;
  List<UploadImagesModel>? selectedDigitalImages;
  List<Map<String, dynamic>>? selectedAttributes;
  List<GlobalOptionsData>? selectedProductOptions;
  List<SearchProductRecord> selectedPackageProducts = [];
  List<SearchProductRecord> selectedCrossSellingProducts = [];
  ParentFAQModel? selectedParentFaqs;

  final _formKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  List<String> createItems = [];

  /// Current package Id
  String? _currentPackageId;
  String? _slugID;

  @override
  void initState() {
    createItems.add('general information');
    createItems.add('images');
    createItems.add('overview');
    if (widget.packageID == null) {
      createItems.add('shipping');
    }
    createItems.add('package Products');
    createItems.add('product options');
    createItems.add('seo');
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      /// ser package id
      _currentPackageId = widget.packageID;
      await _onRefresh();
    });
    super.initState();
  }

  Future _onRefresh() async {
    try {
      setProcessing(true);

      final createProductProvider =
          Provider.of<VendorCreateProductViewModel>(context, listen: false);
      await createProductProvider.vendorGetProductTags();

      /// it is defined in create product
      final packageSettingsProvider =
          context.read<VendorGetPackageGeneralSettingsViewModel>();
      await packageSettingsProvider.vendorGetPackageGeneralSettings();
      _handleOverViewData(overviewModel);
      _initializeProductCategories();
      _initializeBrandDropdownMenuItems();
      _initializeProductCollections();
      _initializeProductLabel();
      _initializeProductTaxes();
      _initializeProductTags();

      if (_currentPackageId != null) {
        print('PRODUCT ID ==> ${widget.packageID}');
        final vewPackageProvider =
            context.read<VendorGetViewPackageViewModel>();
        await vewPackageProvider.vendorViewPackage(context, _currentPackageId!);
        populateViewData(vewPackageProvider.vendorProductViewApiResponse.data);
      }

      setProcessing(false);
    } catch (e) {
      setProcessing(false);
      print('Error: $e');
    }
  }

  void populateViewData([NewProductViewDataResponse? data]) {
    final productViewData = data?.data;

    // set slug id
    _slugID = createProductPostData.slugId =
        productViewData?.slugId?.toString() ?? '';
    _nameController.text =
        createProductPostData.name = productViewData?.name ?? '';
    _permalinkController.text =
        createProductPostData.slug = productViewData?.slug ?? '';
    createProductPostData.slugId = productViewData?.slugId.toString() ?? '';
    _descriptionController.text =
        createProductPostData.description = productViewData?.description ?? '';
    if (_descriptionController.text.isNotEmpty) {
      _descriptionQuilController.document = Document.fromDelta(
          convertHtmlToDelta(htmlContent: _descriptionController.text),);
    }
    _contentController.text =
        createProductPostData.content = productViewData?.content ?? '';
    if (_contentController.text.isNotEmpty) {
      _contentQuilController.document = Document.fromDelta(
          convertHtmlToDelta(htmlContent: _contentController.text),);
    }
    createProductPostData.categories = productViewData?.categories ?? [];
    _initializeProductCategories(categories: productViewData?.categories ?? []);

    createProductPostData.brandId = productViewData?.brandId.toString() ?? '';
    _initializeBrandDropdownMenuItems();

    createProductPostData.productCollections =
        productViewData?.collections ?? [];
    _initializeProductCollections(
        collections: productViewData?.collections ?? [],);

    createProductPostData.productLabels = productViewData?.labels ?? [];
    _initializeProductLabel(labels: productViewData?.labels ?? []);

    createProductPostData.taxes = productViewData?.taxes ?? [];
    _initializeProductTaxes(taxes: productViewData?.taxes ?? []);

    _initializeProductTags(tags: productViewData?.tags ?? []);

    selectedImages = productViewData?.images
        ?.map(
          (image) => UploadImagesModel(
            serverUrl: image.image,
            serverFullUrl: image.imageUrl,
            hasFile: false,
          ),
        )
        .toList();
    createProductPostData.images = selectedImages
        ?.where((e) => e.serverUrl.isNotEmpty)
        .map((e) => e.serverUrl)
        .toList();
    _updateImageCount();

    /// product options
    selectedProductOptions = productViewData?.options
        ?.map(
          (option) => GlobalOptionsData(
            updatedAt: option.updatedAt ?? '',
            optionType: option.optionType ?? '',
            nameController: TextEditingController(),
            optionTypeController: TextEditingController(),
            values: option.values
                    ?.map(
                      (x) => GlobalOptionsValues(
                        updatedAt: x.updatedAt ?? '',
                        affectType: x.affectType!,
                        createdAt: x.createdAt!,
                        optionId: x.optionId!,
                        optionValue: x.optionValue,
                        affectPrice: x.affectPrice!,
                        id: x.id!,
                        order: x.order!,
                        optionValueController: TextEditingController(),
                        priceController: TextEditingController(),
                      ),
                    )
                    .toList() ??
                [],
            name: option.name ?? '',
            createdAt: option.createdAt ?? '',
            id: option.id!,
            required: option.required!,
          ),
        )
        .toList();
    _handleProductOptionsData(selectedProductOptions);

    selectedPackageProducts = productViewData?.relatedProducts
            ?.map(
              (relatedProduct) => SearchProductRecord(
                image: relatedProduct.imageUrl,
                name: relatedProduct.name,
                id: relatedProduct.id,
                controller: TextEditingController(),
              ),
            )
            .toList() ??
        [];
    _handlePackageProductsData(selectedPackageProducts);

    //// initialize overview data
    overviewModel = VendorProductOverviewModel(
      sku: productViewData?.sku ?? '',
      price: productViewData?.price.toString() ?? '',
      priceSale: productViewData?.salePrice?.toString() ?? '',
      chooseDiscountPeriod:
          (productViewData?.startDate?.toString().isNotEmpty ?? false) &&
              (productViewData?.endDate?.toString().isNotEmpty ?? false),
      fromDate: productViewData?.startDate?.toString() ?? '',
      toDate: productViewData?.endDate?.toString() ?? '',
      costPerItem: productViewData?.costPerItem.toString() ?? '',
      barcode: productViewData?.barcode?.toString() ?? '',
      withWareHouseManagement:
          productViewData?.withStorehouseManagement.toString() == '1',
      quantity: productViewData?.quantity?.toString() ?? '0',
      allowCustomerCheckoutWhenProductIsOutOfStock:
          productViewData?.allowCheckoutWhenOutOfStock.toString() == '1',
      stockStatus: productViewData?.stockStatus?.value.toString() ?? '',
    );
    _handleOverViewData(overviewModel);

    /// initialize the shipping data:
    vendorProductDimensionsModel = VendorProductDimensionsModel(
      weight: productViewData?.weight?.toString() ?? '',
      length: productViewData?.length?.toString() ?? '',
      width: productViewData?.wide?.toString() ?? '',
      height: productViewData?.height?.toString() ?? '',
    );
    _handleShippingData(vendorProductDimensionsModel);

    /// initialize the seo data
    vendorProductSeoModel = VendorProductSeoModel(
      title: productViewData?.seoMeta?.seoTitle ?? '',
      description: productViewData?.seoMeta?.seoDescription ?? '',
      keywords: productViewData?.seoMeta?.keywords
              ?.map((element) => element['value'].toString())
              .toList() ??
          [],
      type: productViewData?.seoMeta?.index ?? SeoIndexConstants.INDEX,
    );
    _handleSeoData(vendorProductSeoModel);
  }

  Future<bool> _createUpdatePackage() async {
    try {
      setProcessing(true);

      /// set the product type
      createProductPostData.productType = ProductTypeConstants.PACKAGE;

      /// ***------------ converting content text to html and storing in content controller start --------***
      createProductPostData.content = _contentController.text =
          convertDeltaToHtml(quilController: _contentQuilController);
      createProductPostData.description = _descriptionController.text =
          convertDeltaToHtml(quilController: _descriptionQuilController);
      _handleSeoData(vendorProductSeoModel);

      /// ***------------ converting content text to html and storing in content controller end --------***

      final provider =
          Provider.of<VendorCreatePackageViewModel>(context, listen: false);

      void logFormData(FormData formData) {
        for (final field in formData.fields) {
          print('Field: ${field.key} = ${field.value}');
        }
        for (final file in formData.files) {
          print('File: ${file.key} = ${file.value.filename}');
        }
      }

      // Usage:
      final formData = createProductPostData.toFormData();
      logFormData(formData);

      /// update package
      if (_currentPackageId != null &&
          (_currentPackageId?.isNotEmpty == true)) {
        final result = await provider.vendorUpdatePackage(
            context: context,
            packageID: widget.packageID ?? '',
            productPostDataModel: createProductPostData,);
        if (result) {
          await _onRefresh();
        }
      } else {
        final result = await provider.vendorCreatePackage(
            context: context, productPostDataModel: createProductPostData,);
        if (result) {
          _currentPackageId =
              provider.vendorCreatePackageApiResponse.data?.data.id.toString();
          print('Current Package ID:=> $_currentPackageId');

          /// on success go back and refresh the products list
          final allProductProvider =
              Provider.of<VendorGetPackagesViewModel>(context, listen: false);
          allProductProvider.clearList();
          allProductProvider.vendorGetPackages();
          // widget.packageID = _currentPackageId;
          // await _onRefresh();
          Navigator.pop(context);
        }
      }

      setProcessing(false);
      return true;
    } catch (e) {
      setProcessing(false);
      print('Error: $e');
      return false;
    }
  }

  /// ***---------------------------- Images Section start ------------------------*** ///
  void _updateImageCount() {
    if (selectedImages != null) {
      _imageCountController.text = selectedImages!.isNotEmpty
          ? '${selectedImages?.length} image(s) selected'
          : 'No images selected';
    } else {
      _imageCountController.clear();
    }
  }

  void _updateProductOptionsCount() {
    if (selectedProductOptions != null) {
      _productOptionsCountController.text = selectedProductOptions!.isNotEmpty
          ? '${selectedProductOptions?.length} options(s) selected'
          : 'No options selected';
    } else {
      _productOptionsCountController.clear();
    }
  }

  void _updatePackageProductsCount() {
    if (selectedPackageProducts.isNotEmpty) {
      _relatedProductsCountController.text = selectedPackageProducts.isNotEmpty
          ? '${selectedPackageProducts.length} related product(s) selected'
          : 'No related products selected';
    } else {
      _relatedProductsCountController.clear();
    }
  }

  /// ***---------------------------- Product Images Section start ------------------------*** ///
  Future<void> _openImagePickerScreen() async {
    final List<UploadImagesModel>? images = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadImagesScreen(
          initialImages: selectedImages,
        ),
      ),
    );
    _handleImagesData(images);
  }

  void _handleImagesData(List<UploadImagesModel>? images) {
    if (images != null) {
      final List<String> serverImages = images
          .where((e) => e.serverUrl.isNotEmpty)
          .map((e) => e.serverUrl)
          .toList();
      createProductPostData.images = serverImages;
      print('Selected Server Images: $serverImages');
    } else {
      createProductPostData.images = [];
    }

    setState(() {
      selectedImages = images;
      _updateImageCount();
    });
  }

  /// ***---------------------------- Product Images Section end ------------------------*** ///

  /// ***---------------------------- Products options Section start ------------------------*** ///
  Future<void> _openProductOptionsScreen(
      List<GlobalOptions> globalOptions,) async {
    final List<GlobalOptionsData>? options = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VendorProductOptionsScreen(
          globalOptions: globalOptions,
          selectedOptions: selectedProductOptions ?? [],
        ),
      ),
    );

    _handleProductOptionsData(options);
  }

  void _handleProductOptionsData(List<GlobalOptionsData>? options) {
    if (options != null) {
      final selectedOptions = options.asMap().entries.map((entry) {
        final int index = entry.key; // Get index
        final option = entry.value;

        return ProductOption(
          optionType: option.optionType,
          name: option.name,
          id: option.id.toString(),
          required: option.required == 1 ? 'on' : '',
          order: index.toString(),
          // Use index here
          values: option.values.asMap().entries.map((valueEntry) {
            final int valueIndex = valueEntry.key; // Get index for values
            final value = valueEntry.value;
            return OptionValues(
              affectType: value.affectType.toString() ?? '',
              affectPrice: value.affectPrice.toString(),
              id: value.id.toString() ?? '',
              order: valueIndex.toString(),
              // Use value index
              optionValue: option.getType().toLowerCase() == 'location'
                  ? value.optionValue.toString() ?? ''
                  : '',
            );
          }).toList(),
        );
      }).toList();

      /// converting to the list of map or json objects
      createProductPostData.options =
          selectedOptions.map((option) => option.toJson()).toList();
    } else {
      createProductPostData.options = [];
    }

    setState(() {
      selectedProductOptions = options;
      _updateProductOptionsCount();
    });
  }

  /// ***---------------------------- Products options Section end ------------------------*** ///

  Future<void> _openPackageProductSearchScreen() async {
    final List<SearchProductRecord> packageProducts = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RelatedProductsSearchScreen(
          title: 'Package products',
          dataId: widget.packageID,
          selectedRelatedProducts: selectedPackageProducts,
        ),
      ),
    );
    _handlePackageProductsData(packageProducts);
  }

  void _handlePackageProductsData(List<SearchProductRecord> packageProducts) {
    if (packageProducts.isNotEmpty) {
      final relatedIds = packageProducts
          .map((e) => e.id.toString())
          .toSet() // Ensures uniqueness
          .join(',');

      createProductPostData.packageProducts = relatedIds;
    } else {
      createProductPostData.packageProducts = '';
    }

    setState(() {
      selectedPackageProducts = packageProducts;
      _updatePackageProductsCount();
    });
  }

  /// ***---------------------------- Overview Section start ------------------------*** ///
  VendorProductOverviewModel? overviewModel;

  Future<void> _openOverviewView() async {
    final overviewSelectedData =
        await showDraggableModalBottomSheet<VendorProductOverviewModel>(
      context: context,
      builder: (scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Utils.dragHandle(context: context),
            VendorProductOverviewView(
              overviewModel: overviewModel,
              productType: ProductTypeConstants.PACKAGE,
            ),
          ],
        ),
      ),
    );
    if (overviewSelectedData != null) {
      _handleOverViewData(overviewSelectedData);
    }
  }

  void _handleOverViewData(result) {
    // if (result != null) {
    overviewModel = result;
    print('result==> ${overviewModel?.price}');
    createProductPostData.sku = overviewModel?.sku ??
        context
            .read<VendorGetPackageGeneralSettingsViewModel>()
            .generalSettingsApiResponse
            .data
            ?.data
            ?.sku
            ?.toString() ??
        '';
    createProductPostData.price = overviewModel?.price ?? '0';
    createProductPostData.salePrice = overviewModel?.priceSale ?? '0';
    createProductPostData.startDate = overviewModel?.fromDate ?? '';
    createProductPostData.endDate = overviewModel?.toDate ?? '';
    createProductPostData.costPerItem = overviewModel?.costPerItem ?? '0';
    createProductPostData.barcode = overviewModel?.barcode ?? '';
    createProductPostData.withStorehouseManagement =
        overviewModel?.withWareHouseManagement ?? false ? '1' : '0';
    createProductPostData.allowCheckoutWhenOutOfStock =
        overviewModel?.allowCustomerCheckoutWhenProductIsOutOfStock ?? false
            ? '1'
            : '0';
    createProductPostData.quantity =
        overviewModel?.withWareHouseManagement ?? false
            ? overviewModel?.quantity ?? '0'
            : '0';
    createProductPostData.stockStatus =
        overviewModel?.stockStatus ?? 'in_stock';
    // }
    setState(() {});
  }

  /// ***---------------------------- Overview Section start ------------------------*** ///

  /// ***---------------------------- Shipping Section start ------------------------*** ///
  VendorProductDimensionsModel? vendorProductDimensionsModel;

  Future _openShippingSection() async {
    vendorProductDimensionsModel = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => VendorProductShippingView(
            vendorProductDimensionsModel: vendorProductDimensionsModel,),
      ),
    );

    _handleShippingData(vendorProductDimensionsModel);
    setState(() {});
  }

  void _handleShippingData(vendorProductDimensionsModel) {
    if (vendorProductDimensionsModel != null) {
      createProductPostData.weight = vendorProductDimensionsModel?.weight ?? '';
      createProductPostData.length = vendorProductDimensionsModel?.length ?? '';
      createProductPostData.wide = vendorProductDimensionsModel?.width ?? '';
      createProductPostData.height = vendorProductDimensionsModel?.height ?? '';
    }
  }

  /// ***---------------------------- shipping Section start ------------------------*** ///

  /// ***---------------------------- Product Search Engine Optimization Section start ------------------------*** ///
  VendorProductSeoModel? vendorProductSeoModel;

  Future _openSeoOptimizeView() async {
    vendorProductSeoModel = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) =>
            VendorProductSeoView(vendorProductSeoModel: vendorProductSeoModel),
      ),
    );
    _handleSeoData(vendorProductSeoModel);
    setState(() {});
  }

  /// handle seo data if no data is available also
  void _handleSeoData(vendorProductSeoModel) {
    createProductPostData.seoMeta = {
      'seo_title': (vendorProductSeoModel?.iso.trim().isNotEmpty ?? false)
          ? vendorProductSeoModel!.iso
          : (_nameController.text.trim().isNotEmpty
              ? _nameController.text
              : ''),
      'seo_description':
          (vendorProductSeoModel?.description.trim().isNotEmpty ?? false)
              ? vendorProductSeoModel!.description
              : (_descriptionController.text.trim().isNotEmpty
                  ? _descriptionController.text
                  : ''),
      'index': vendorProductSeoModel?.type ?? SeoIndexConstants.INDEX,
    };

// Add optional keywords only if they are not null or empty
    if (vendorProductSeoModel?.keywords.isNotEmpty ?? false) {
      // / Currently throwing the server error /// TODO: uncomment this for seo keywords
      createProductPostData.seoMeta?['seo_keywords'] = jsonEncode(
        vendorProductSeoModel!.keywords
            .map((keyword) => {'value': keyword})
            .toList(),
      );
    }
  }

  /// ***---------------------------- Product Search Engine Optimization Section end ------------------------*** ///

  /// ***---------------------------- Brand Section start ------------------------*** ///
  List<DropdownMenuItem> _brandDropdownMenuItemsList = [];

  void _initializeBrandDropdownMenuItems() {
    final provider = context.read<VendorGetPackageGeneralSettingsViewModel>();
    _brandDropdownMenuItemsList =
        provider.generalSettingsApiResponse.data?.data?.brands
                ?.map(
                  (brand) => DropdownMenuItem(
                    value: brand.id.toString(),
                    child: Text(brand.value?.toString() ?? ''),
                  ),
                )
                .toList() ??
            [];
  }

  /// ***---------------------------- Brand Section start ------------------------*** ///

  /// ***---------------------------- Categories Section start ------------------------*** ///
  final _categoriesController = MultiSelectController<ProductCategories>();
  List<DropdownItem<ProductCategories>> _categoryDropdownItems = [];

  void _initializeProductCategories({List<int> categories = const []}) {
    final provider = context.read<VendorGetPackageGeneralSettingsViewModel>();
    _categoryDropdownItems =
        provider.generalSettingsApiResponse.data?.data?.productCategories
                ?.map(
                  (productCategory) => DropdownItem(
                    label: productCategory.name?.toString() ?? '',
                    value: productCategory,
                    selected: categories.contains(productCategory.id),
                  ),
                )
                .toList() ??
            [];
    _categoriesController.setItems(_categoryDropdownItems);
  }

  /// ***---------------------------- Categories Section end ------------------------*** ///

  /// ***---------------------------- Product Collection Section start ------------------------*** ///
  final _productCollectionsController =
      MultiSelectController<ProductCollections>();
  List<DropdownItem<ProductCollections>> _productCollectionsDropdownItems = [];

  void _initializeProductCollections({List<int> collections = const []}) {
    final provider = context.read<VendorGetPackageGeneralSettingsViewModel>();
    _productCollectionsDropdownItems =
        provider.generalSettingsApiResponse.data?.data?.productCollections
                ?.map(
                  (productCollection) => DropdownItem(
                    label: productCollection.value?.toString() ?? '',
                    value: productCollection,
                    selected: collections.contains(productCollection.id),
                  ),
                )
                .toList() ??
            [];
    _productCollectionsController.setItems(_productCollectionsDropdownItems);
  }

  /// ***---------------------------- Product Collection Section end ------------------------*** ///

  /// ***---------------------------- Product Collection Section start ------------------------*** ///
  final _productLabelController = MultiSelectController<ProductLabels>();
  List<DropdownItem<ProductLabels>> _productLabelDropdownItems = [];

  void _initializeProductLabel({List<int> labels = const []}) {
    final provider = context.read<VendorGetPackageGeneralSettingsViewModel>();
    _productLabelDropdownItems =
        provider.generalSettingsApiResponse.data?.data?.productLabels
                ?.map(
                  (label) => DropdownItem(
                    label: label.value?.toString() ?? '',
                    value: label,
                    selected: labels.contains(label.id),
                  ),
                )
                .toList() ??
            [];
    _productLabelController.setItems(_productLabelDropdownItems);
  }

  /// ***---------------------------- Product Collection Section end ------------------------*** ///

  /// ***---------------------------- Product Collection Section start ------------------------*** ///
  final _productTaxesController = MultiSelectController<Taxes>();
  List<DropdownItem<Taxes>> _productTaxesDropdownItems = [];

  void _initializeProductTaxes({List<int> taxes = const []}) {
    final provider = context.read<VendorGetPackageGeneralSettingsViewModel>();
    _productTaxesDropdownItems =
        provider.generalSettingsApiResponse.data?.data?.taxes
                ?.map(
                  (productTax) => DropdownItem(
                    label: productTax.value?.toString() ?? '',
                    value: productTax,
                    selected: taxes.contains(productTax.id),
                  ),
                )
                .toList() ??
            [];
    _productTaxesController.setItems(_productTaxesDropdownItems);
  }

  /// ***---------------------------- Product Collection Section end ------------------------*** ///

  /// ***---------------------------- Product Tags Section start ------------------------*** ///
  final _productTagsController = MultiSelectController<String>();
  List<DropdownItem<String>> _productTagsDropdownItems = [];

  void _initializeProductTags({List<String> tags = const []}) {
    final provider = context.read<VendorCreateProductViewModel>();
    _productTagsDropdownItems =
        provider.productTagsApiResponse.data?.vendorProductTags
                ?.map(
                  (tag) => DropdownItem(
                    label: tag.toString() ?? '',
                    value: tag.toString(),
                    selected: tags.contains(tag),
                  ),
                )
                .toList() ??
            [];
    _productTagsController.setItems(_productTagsDropdownItems);
  }

  /// ***---------------------------- Product Tags Section end ------------------------*** ///

  /// ***---------------------------- create slug Section start ------------------------*** ///
  Timer? _debounce;

  void _onSlugChange() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    final String textToSlug = _permalinkController.text.isNotEmpty
        ? _permalinkController.text
        : _nameController.text;
    if (textToSlug.isNotEmpty) {
      _debounce = Timer(const Duration(milliseconds: 500), () async {
        await _createSlug(slug: textToSlug);
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  /// Create slug function
  Future _createSlug({required String slug}) async {
    final createProductSlugProvider =
        Provider.of<VendorCreateProductViewModel>(context, listen: false);
    try {
      final slugGenerated =
          await createProductSlugProvider.vendorCreateProductSlug(
              productName: slug,
              productID: widget.packageID,
              slugID: _slugID,
              context: context,);
      if (slugGenerated != null) {
        setState(() {
          createProductPostData.slug = slugGenerated;
          createProductPostData.slugId = _slugID ?? '0';
          _permalinkController.text = createProductSlugProvider
                  .vendorCreateSlugApiResponse.data?.data
                  ?.toString() ??
              '';
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// ***---------------------------- create slug Section end ------------------------*** ///

  /// Get Title text
  String getHeaderText() {
    if (widget.packageID != null) {
      return 'Edit #${widget.packageID}';
    } else {
      return 'Create New Package';
    }
  }

  @override
  void dispose() {
    /// Dispose controllers
    _nameController.dispose();
    _permalinkController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _imageCountController.dispose();
    _attributesCountController.dispose();
    _productOptionsCountController.dispose();
    _relatedProductsCountController.dispose();
    _crossSellingProductsCountController.dispose();
    _faqsCountController.dispose();

    /// Dispose focus nodes
    _nameFocusNode.dispose();
    _permalinkFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: VendorCommonAppBar(title: getHeaderText()),
      body: Utils.modelProgressHud(
        context: context,
        processing: _isProcessing,
        child: Stack(
          children: [
            // Main UI
            Form(
              key: _formKey,
              child: _buildUi(theme: theme, context: context),
            ),
            // Positioned Widget at the Bottom for (save) and (save & exit)
            Consumer<VendorGetPackageGeneralSettingsViewModel>(
              builder: (context, createProductProvider, _) => Positioned(
                left: 0,
                right: 0,
                bottom: 0, // Adjust as needed
                child: Column(
                  children: [
                    const Divider(
                      color: Colors.grey,
                      height: 1,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0,),
                              child: CustomAppButton(
                                borderRadius: 4,
                                buttonText: 'Save',
                                buttonColor: AppColors.lightCoral,
                                onTap: () async {
                                  _handleOverViewData(overviewModel);

                                  /// assign some default values if nothing is selected in overview because we need to assign 0 to quantity and prices
                                  setState(() {});

                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    final result = await _createUpdatePackage();
                                    if (result) {
                                      /// on success go back and refresh the products list
                                      // final allProductProvider = Provider.of<VendorGetPackagesViewModel>(context, listen: false);
                                      // allProductProvider.clearList();
                                      // allProductProvider.vendorGetPackages();
                                      // Navigator.pop(context);
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        /*Flexible(
                              flex: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                  child: CustomAppButton(
                                    borderRadius: 4,
                                    borderColor: AppColors.lightCoral,
                                    buttonText: "Save & Exit",
                                    buttonColor: Colors.white,
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onTap: () async {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        final result = await _createUpdatePackage();
                                        if (result) {
                                          /// on success go back and refresh the products list
                                          final allProductProvider = Provider.of<VendorGetProductsViewModel>(context, listen: false);
                                          allProductProvider.clearList();
                                          allProductProvider.vendorGetProducts();
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            )*/
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUi({required ThemeData theme, required BuildContext context}) =>
      Consumer<VendorGetPackageGeneralSettingsViewModel>(
        builder: (context, provider, _) {
          final settings = provider.generalSettingsApiResponse.data?.data;
          return Padding(
            padding: EdgeInsets.only(
                left: kPadding, right: kPadding, top: kPadding, bottom: 80,),
            child: ListView.separated(
              itemCount:
                  provider.generalSettingsApiResponse.status == ApiStatus.ERROR
                      ? 1
                      : createItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (provider.generalSettingsApiResponse.status ==
                    ApiStatus.ERROR) {
                  return Utils.somethingWentWrong();
                }

                final sections = [
                  _generalInformation(
                      theme: theme, context: context, provider: provider,),
                  _imagesSection(theme: theme, context: context),
                  _overviewSection(
                      theme: theme, context: context, provider: provider,),
                  if (widget.packageID == null)
                    _shippingSection(
                      theme: theme,
                      context: context,
                    ),
                  _packageProducts(
                    theme: theme,
                    context: context,
                  ),
                  _productOptionsSection(
                    theme: theme,
                    context: context,
                    globalOptions: settings?.globalOptions ?? [],
                  ),
                  _seoSection(theme: theme, context: context),
                ];
                return sections[index];
              },
            ),
          );
        },
      );

  final QuillController _descriptionQuilController = QuillController.basic();
  final QuillController _contentQuilController = QuillController.basic();

  /// General Information
  Widget _generalInformation(
      {required ThemeData theme,
      required BuildContext context,
      required VendorGetPackageGeneralSettingsViewModel provider,}) {
    final settings = provider.generalSettingsApiResponse.data?.data;

    /// general settings data
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// product name
        CustomTextFormField(
          labelText: 'Name',
          required: true,
          hintText: 'Enter Name',
          maxLength: 250,
          focusNode: _nameFocusNode,
          nextFocusNode: _permalinkFocusNode,
          controller: _nameController,
          validator: Validator.productName,
          onChanged: (value) {
            createProductPostData.name = value ?? '';
            _handleOverViewData(overviewModel);
            _handleSeoData(vendorProductSeoModel);

            /// updating the seo data as well
            _onSlugChange();
          },
        ),

        /// permalink
        Consumer<VendorCreateProductViewModel>(
          builder: (context, createProductSlugProvider, _) {
            final createSlugApiResponse =
                createProductSlugProvider.vendorCreateSlugApiResponse.status;
            return CustomTextFormField(
              labelText: 'Permalink',
              required: true,
              hintText: '',
              maxLines: 1,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              prefix: texFieldPrefix(
                  screenWidth: screenWidth,
                  text: VendorApiEndpoints.vendorProductBaseUrl,
                  padding: EdgeInsets.only(left: screenWidth * 0.04),),
              validator: Validator.validatePermalink,
              suffix: _permalinkController.text.isNotEmpty ||
                      _nameController.text.isNotEmpty
                  ? InkResponse(
                      highlightColor: AppColors.lightCoral.withOpacity(0.5),
                      splashColor: AppColors.lightCoral.withOpacity(0.3),
                      radius: 10,
                      onTap: createSlugApiResponse != ApiStatus.LOADING
                          ? () {
                              _onSlugChange();
                            }
                          : null,
                      child: createSlugApiResponse == ApiStatus.LOADING
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child:
                                  Utils.pageLoadingIndicator(context: context),)
                          : const Icon(
                              Icons.edit,
                            ),
                    )
                  : kShowVoid,
              focusNode: _permalinkFocusNode,
              nextFocusNode: _descriptionFocusNode,
              controller: _permalinkController,
              onChanged: (value) {
                setState(() {
                  _onSlugChange();
                });
              },
            );
          },
        ),
        kFormFieldSpace,

        // /// description
        fieldTitle(text: 'Description'),
        CustomEditableTextField(
            placeholder: '',
            showToolBar: false,
            fieldHeight: 100,
            quillController: _descriptionQuilController,),
        kFormFieldSpace,
        // /// content
        fieldTitle(text: 'Content'),
        CustomEditableTextField(
            placeholder: '',
            showToolBar: false,
            fieldHeight: 100,
            quillController: _contentQuilController,),
        kFormFieldSpace,

        /// brands
        fieldTitle(text: 'Brand'),
        kMinorSpace,
        CustomDropdown(
          menuItemsList: _brandDropdownMenuItemsList,
          textColor: Colors.black,
          hintText: 'Select Brand',
          value:
              _brandDropdownMenuItemsList.map((item) => item.value).firstWhere(
                    (id) => id == createProductPostData.brandId,
                    orElse: () => null,
                  ),
          onChanged: (value) {
            createProductPostData.brandId = value;
          },
        ),
        kFormFieldSpace,

        /// categories
        fieldTitle(text: 'Categories'),
        kMinorSpace,
        CustomMultiselectDropdown(
          dropdownItems: _categoryDropdownItems,
          dropdownController: _categoriesController,
          hintText: 'Select Categories',
          onSelectionChanged: (value) {
            if (value is List<ProductCategories>) {
              final List<int> selectedCategoryIds =
                  value.where((e) => e.id != null).map((e) => e.id!).toList();
              createProductPostData.categories = selectedCategoryIds;
              print('Selected Categories: $selectedCategoryIds');
            } else {
              print('Unexpected data type: ${value.runtimeType}');
            }
          },
        ),
        kFormFieldSpace,

        /// product collections
        fieldTitle(text: 'Product Collections'),
        kMinorSpace,
        CustomMultiselectDropdown(
          dropdownItems: _productCollectionsDropdownItems,
          dropdownController: _productCollectionsController,
          hintText: 'Select Product Collection',
          onSelectionChanged: (value) {
            if (value is List<ProductCollections>) {
              final List<int> selectedCollectionIds =
                  value.where((e) => e.id != null).map((e) => e.id!).toList();
              createProductPostData.productCollections = selectedCollectionIds;
              print('Selected Product Collections: $selectedCollectionIds');
            } else {
              print('Unexpected data type: ${value.runtimeType}');
            }
          },
        ),
        kFormFieldSpace,

        /// labels
        fieldTitle(text: 'Labels'),
        kMinorSpace,
        CustomMultiselectDropdown(
          dropdownItems: _productLabelDropdownItems,
          dropdownController: _productLabelController,
          hintText: 'Select Labels',
          onSelectionChanged: (value) {
            if (value is List<ProductLabels>) {
              final List<int> selectedLabelsIds =
                  value.where((e) => e.id != null).map((e) => e.id!).toList();
              createProductPostData.productLabels = selectedLabelsIds;
              print('Selected Labels: $selectedLabelsIds');
            } else {
              print('Unexpected data type: ${value.runtimeType}');
            }
          },
        ),
        kFormFieldSpace,

        /// taxes
        if (settings?.isTaxEnabled ?? true)
          Column(
            children: [
              fieldTitle(text: 'Taxes'),
              kMinorSpace,
              CustomMultiselectDropdown(
                dropdownItems: _productTaxesDropdownItems,
                dropdownController: _productTaxesController,
                hintText: 'Select Taxes',
                onSelectionChanged: (value) {
                  if (value is List<Taxes>) {
                    final List<int> selectedTaxesIds = value
                        .where((e) => e.id != null)
                        .map((e) => e.id!)
                        .toList();
                    createProductPostData.taxes = selectedTaxesIds;
                    print('Selected Taxes: $selectedTaxesIds');
                  } else {
                    print('Unexpected data type: ${value.runtimeType}');
                  }
                },
              ),
              kFormFieldSpace,
            ],
          ),

        /// tags
        fieldTitle(text: 'Tags'),
        kMinorSpace,
        CustomMultiselectDropdown(
          dropdownItems: _productTagsDropdownItems,
          dropdownController: _productTagsController,
          hintText: 'Select Tags',
          onSelectionChanged: (value) {
            print('Selected Tags: $value');
            if (value is List<String>) {
              final List<Map<String, String>> selectedTags = value
                  .where((e) => e.isNotEmpty)
                  .map((e) => {'value': e})
                  .toList();
              createProductPostData.tag = selectedTags;
              print('Selected Tag: $selectedTags');
            } else {
              print('Unexpected data type: ${value.runtimeType}');
            }
          },
        ),
        kFormFieldSpace,
      ],
    );
  }

  /// Upload images
  Widget _imagesSection(
          {required ThemeData theme, required BuildContext context,}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithArrow(
            title: 'Upload Images',
            textStyle: createProductTextStyle(),
            onTap: _openImagePickerScreen,
          ),
          if (selectedImages?.isNotEmpty == true)
            TextFormField(
              controller: _imageCountController,
              readOnly: true, // Prevent manual input
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.image, color: AppColors.lightCoral),
              ),
              onTap: _openImagePickerScreen,
            ),
        ],
      );

  /// overview section
  Widget _overviewSection(
          {required ThemeData theme,
          required BuildContext context,
          required VendorGetPackageGeneralSettingsViewModel provider,}) =>
      Column(
        children: [
          TitleWithArrow(
            title: 'Overview',
            textStyle: createProductTextStyle(),
            onTap: () async {
              try {
                await _openOverviewView();
              } catch (e) {
                print('Error: $e');
              }
            },
          ),
          if (overviewModel != null)
            SimpleCard(
              expandedContentPadding: EdgeInsets.symmetric(
                  horizontal: kMediumPadding, vertical: kExtraSmallPadding,),
              expandedContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align the content to the left
                children: [
                  showDetail(label: 'Sku', value: overviewModel?.sku),
                  showDetail(label: 'Price', value: overviewModel?.price),
                  showDetail(
                      label: 'Sale Price', value: overviewModel?.priceSale,),
                  if (overviewModel?.chooseDiscountPeriod ?? false)
                    Column(
                      children: [
                        showDetail(
                            label: 'From', value: overviewModel?.fromDate,),
                        showDetail(label: 'To', value: overviewModel?.toDate),
                      ],
                    ),
                  showDetail(
                      label: 'Cost per item',
                      value: overviewModel?.costPerItem,),
                  showDetail(label: 'Barcode', value: overviewModel?.barcode),
                  if (overviewModel?.withWareHouseManagement ?? false)
                    showDetail(
                        label: 'Quantity', value: overviewModel?.quantity,),
                  if (!(overviewModel?.withWareHouseManagement ?? true))
                    showDetail(
                      label: 'Stock Status',
                      value: (overviewModel?.stockStatus != null &&
                              overviewModel?.stockStatus.isNotEmpty == true)
                          ? provider.generalSettingsApiResponse.data?.data
                                  ?.stockStatuses
                                  ?.firstWhere(
                                    (element) =>
                                        element.value ==
                                        overviewModel?.stockStatus,
                                  )
                                  .label ??
                              '--' // Fallback to 'Unknown' if not found
                          : null,
                    ),
                ],
              ),
            ),
        ],
      );

  /// shipping section : visible for physical product only
  Widget _shippingSection(
          {required ThemeData theme, required BuildContext context,}) =>
      Column(
        children: [
          TitleWithArrow(
            title: 'Shipping',
            textStyle: createProductTextStyle(),
            onTap: () async {
              try {
                await _openShippingSection();
              } catch (e) {
                print('Error: $e');
              }
            },
          ),
          if (vendorProductDimensionsModel != null)
            SimpleCard(
              expandedContentPadding: EdgeInsets.symmetric(
                  horizontal: kMediumPadding, vertical: kExtraSmallPadding,),
              expandedContent: Column(
                children: [
                  showDetail(
                      label: 'Weight (g)',
                      value: vendorProductDimensionsModel?.weight,),
                  showDetail(
                      label: 'Length (cm)',
                      value: vendorProductDimensionsModel?.length,),
                  showDetail(
                      label: 'Width (cm)',
                      value: vendorProductDimensionsModel?.width,),
                  showDetail(
                      label: 'Height (cm)',
                      value: vendorProductDimensionsModel?.height,),
                ],
              ),
            ),
        ],
      );

  /// package products
  Widget _packageProducts(
          {required ThemeData theme, required BuildContext context,}) =>
      Column(
        children: [
          TitleWithArrow(
            title: 'Package Products',
            textStyle: createProductTextStyle(),
            onTap: () => _openPackageProductSearchScreen(),
          ),
          if (selectedPackageProducts.isNotEmpty == true)
            TextFormField(
              controller: _relatedProductsCountController,
              readOnly: true, // Prevent manual input
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onTap: () => _openPackageProductSearchScreen(),
            ),
        ],
      );

  /// product options
  Widget _productOptionsSection({
    required ThemeData theme,
    required BuildContext context,
    required List<GlobalOptions> globalOptions,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithArrow(
            title: 'Product Options',
            textStyle: createProductTextStyle(),
            onTap: () => _openProductOptionsScreen(globalOptions),
          ),
          if (selectedProductOptions?.isNotEmpty == true)
            TextFormField(
              controller: _productOptionsCountController,
              readOnly: true, // Prevent manual input
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onTap: () => _openProductOptionsScreen(globalOptions),
            ),
        ],
      );

  /// Search Engine Optimization
  Widget _seoSection(
          {required ThemeData theme, required BuildContext context,}) =>
      Column(
        children: [
          TitleWithArrow(
            title: 'Search Engine Optimization',
            textStyle: createProductTextStyle(),
            onTap: _openSeoOptimizeView,
          ),
          if ((_permalinkController.text.isNotEmpty &&
                  vendorProductSeoModel?.title != null &&
                  (vendorProductSeoModel?.title.isNotEmpty ?? false)) ||
              _nameController.text.isNotEmpty)
            SimpleCard(
              expandedContentPadding: EdgeInsets.symmetric(
                  horizontal: kMediumPadding, vertical: kExtraSmallPadding,),
              expandedContent: vendorProductSeoModel?.type ==
                      SeoIndexConstants.NO_INDEX
                  ? Row(
                      children: [
                        const Icon(
                          CupertinoIcons.clear_circled,
                          size: 15,
                          color: AppColors.peachyPink,
                        ),
                        kExtraSmallSpace,
                        const Text(
                          'No index',
                          style: TextStyle(color: AppColors.peachyPink),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vendorProductSeoModel?.title.isEmpty ?? true
                              ? _nameController.text
                              : vendorProductSeoModel?.title ?? '',
                          style: const TextStyle(
                              color: AppColors.royalIndigo, fontSize: 18,),
                        ),
                        Text(
                          VendorApiEndpoints.vendorProductBaseUrl +
                              _permalinkController.text,
                          style: const TextStyle(
                            color: AppColors.deepForestGreen,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              DateFormat('MMM dd, yyyy').format(DateTime.now()),
                              style: const TextStyle(color: AppColors.darkGrey),
                            ),
                            Expanded(
                              child: Text(
                                vendorProductSeoModel?.description.isNotEmpty ==
                                        true
                                    ? " - ${removeHtmlTags(htmlString: vendorProductSeoModel?.description ?? '')}"
                                    : (_descriptionController.text.isNotEmpty
                                        ? " - ${removeHtmlTags(htmlString: vendorProductSeoModel?.description ?? '')}"
                                        : ''),
                                // Only show "-" if description or text is not empty
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 13,),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
        ],
      );
}
