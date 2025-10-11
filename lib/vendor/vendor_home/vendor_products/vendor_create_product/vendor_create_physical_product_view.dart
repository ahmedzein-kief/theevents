import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/network/api_endpoints/vendor_api_end_point.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/products/create_product/attribute_sets_data_response.dart';
import 'package:event_app/models/vendor_models/products/create_product/global_options_data_response.dart';
import 'package:event_app/models/vendor_models/products/create_product/product_overview_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/product_post_data_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_product_dimensions_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_product_seo_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_search_product_data_response.dart';
import 'package:event_app/models/vendor_models/products/edit_product/new_product_view_data_response.dart';
import 'package:event_app/models/vendor_models/products/holder_models/digital_links_model.dart';
import 'package:event_app/models/vendor_models/products/holder_models/faq_model.dart';
import 'package:event_app/models/vendor_models/products/holder_models/product_options_post_model.dart';
import 'package:event_app/models/vendor_models/products/holder_models/upload_images_model.dart';
import 'package:event_app/models/vendor_models/products/vendor_get_product_general_settings_model.dart' hide TextData;
import 'package:event_app/vendor/Components/data_tables/custom_data_tables.dart';
import 'package:event_app/vendor/components/app_bars/vendor_common_app_bar.dart';
import 'package:event_app/vendor/components/bottom_sheets/draggable_bottom_sheet.dart';
import 'package:event_app/vendor/components/checkboxes/custom_checkboxes.dart';
import 'package:event_app/vendor/components/dropdowns/custom_dropdown.dart';
import 'package:event_app/vendor/components/dropdowns/custom_multiselect_dropdown.dart';
import 'package:event_app/vendor/components/enums/enums.dart';
import 'package:event_app/vendor/components/settings_components/simple_card.dart';
import 'package:event_app/vendor/components/status_constants/product_type_constants.dart';
import 'package:event_app/vendor/components/status_constants/seo_index_constants.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/cross_selling_products_search_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/digital_attachment_links_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/digital_attachments_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/product_sections/vendor_product_overview_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/product_sections/vendor_product_seo_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/product_sections/vendor_product_shipping_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/product_sections/vendor_product_variations_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/related_products_search_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/upload_images_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/vendor_product_attributes_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/vendor_product_faq_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/vendor_product_options_screen.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';

import '../../../components/text_fields/custom_editable_text_field.dart';
import '../../../view_models/vendor_products/vendor_get_products_view_model.dart';

class VendorCreatePhysicalProductView extends StatefulWidget {
  const VendorCreatePhysicalProductView({
    super.key,
    this.productType,
    this.initialProductId,
  });

  final VendorProductType? productType;
  final String? initialProductId;

  @override
  State<VendorCreatePhysicalProductView> createState() => VendorCreatePhysicalProductViewState();
}

class VendorCreatePhysicalProductViewState extends State<VendorCreatePhysicalProductView> with MediaQueryMixin {
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
  final TextEditingController _digitalImageCountController = TextEditingController();
  final TextEditingController _digitalLinksCountController = TextEditingController();
  final TextEditingController _attributesCountController = TextEditingController();
  final TextEditingController _productOptionsCountController = TextEditingController();
  final TextEditingController _relatedProductsCountController = TextEditingController();
  final TextEditingController _crossSellingProductsCountController = TextEditingController();
  final TextEditingController _faqsCountController = TextEditingController();

  List<UploadImagesModel>? selectedImages;
  List<UploadImagesModel>? selectedDigitalImages;
  List<DigitalLinksModel>? selectedDigitalLinks;
  List<Map<String, dynamic>>? selectedAttributes;
  List<GlobalOptionsData>? selectedProductOptions;
  List<SearchProductRecord> selectedRelatedProducts = [];
  List<SearchProductRecord> selectedCrossSellingProducts = [];
  ParentFAQModel? selectedParentFaqs;

  /// generate license code for digital products
  bool _generateLicenseCode = false;
  final _formKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  String? _productId;

  @override
  void initState() {
    _productId = widget.initialProductId;
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await _onRefresh();
    });
    super.initState();
  }

  Future _onRefresh() async {
    try {
      setProcessing(true);

      /// set package id
      _currentProductId = _productId;

      if (!mounted) return;
      final provider = Provider.of<VendorCreateProductViewModel>(context, listen: false);

      await provider.vendorGetProductGeneralSettings();
      await provider.getAttributeSetsData();
      await provider.vendorGetProductTags();

      if (_productId != null) {
        log('PRODUCT ID ==> $_productId');

        if (!mounted) return;
        await provider.getProductView(context, _productId!);

        final viewData = provider.vendorProductViewApiResponse.data;

        populateViewData(viewData);
      } else {
        _initializeProductCategories();
        _initializeBrandDropdownMenuItems();
        _initializeProductCollections();
        _initializeProductLabel();
        _initializeProductTaxes();
        _initializeProductTags();
      }
      setProcessing(false);
    } catch (e) {
      setProcessing(false);
      log('Error: $e');
    }
  }

  String? _currentProductId;
  String? _slugID;
  String? _currentProductType;

  void populateViewData([NewProductViewDataResponse? data]) {
    final productViewData = data?.data;

    /// set product type:
    _currentProductType = createProductPostData.productType = productViewData?.productType?.value ?? '';
    // set slug id
    _slugID = productViewData?.slugId?.toString() ?? '';
    _nameController.text = createProductPostData.name = productViewData?.name ?? '';
    _permalinkController.text = createProductPostData.slug = productViewData?.slug ?? '';
    createProductPostData.slugId = productViewData?.slugId.toString() ?? '';
    _descriptionController.text = createProductPostData.description = productViewData?.description ?? '';
    if (_descriptionController.text.isNotEmpty) {
      _descriptionQuilController.document = Document.fromDelta(
        convertHtmlToDelta(htmlContent: _descriptionController.text),
      );
    }
    _contentController.text = createProductPostData.content = productViewData?.content ?? '';
    if (_contentController.text.isNotEmpty) {
      _contentQuilController.document = Document.fromDelta(
        convertHtmlToDelta(htmlContent: _contentController.text),
      );
    }

    createProductPostData.categories = productViewData?.categories ?? [];
    _initializeProductCategories(categories: productViewData?.categories ?? []);

    createProductPostData.brandId = productViewData?.brandId.toString() ?? '';
    _initializeBrandDropdownMenuItems();

    createProductPostData.productCollections = productViewData?.collections ?? [];
    _initializeProductCollections(
      collections: productViewData?.collections ?? [],
    );

    createProductPostData.productLabels = productViewData?.labels ?? [];
    _initializeProductLabel(labels: productViewData?.labels ?? []);

    createProductPostData.taxes = productViewData?.taxes ?? [];
    _initializeProductTaxes(taxes: productViewData?.taxes ?? []);

    _initializeProductTags(tags: productViewData?.tags ?? []);

    if (productViewData?.images?.isNotEmpty == true) {
      selectedImages = productViewData?.images
          ?.map(
            (image) => UploadImagesModel(
              serverUrl: image.image,
              serverFullUrl: image.imageUrl,
              hasFile: false,
            ),
          )
          .toList();

      createProductPostData.images =
          selectedImages?.where((e) => e.serverUrl.isNotEmpty).map((e) => e.serverUrl).toList();

      /// no need to convert just update the images count.
      _updateImageCount();
      // _handleImagesData(selectedImages);
    }

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

    selectedRelatedProducts = productViewData?.relatedProducts
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
    _handleRelatedProductsData(selectedRelatedProducts);

    selectedCrossSellingProducts = productViewData?.crossSaleProducts
            ?.map(
              (crossSells) => SearchProductRecord(
                image: crossSells.imageUrl,
                name: crossSells.name,
                id: crossSells.id,
                controller: TextEditingController(),
                priceFormat: 'AED${crossSells.crossPrice?.toString() ?? ''}',
                originalPrice: crossSells.price?.toDouble(),
                salePriceFormat: crossSells.salePriceFormat,
                price: double.tryParse(crossSells.crossPrice ?? ''),
                originalPriceFormat: crossSells.priceFormat,
                salePrice: crossSells.salePrice?.toDouble(),
                priceType: crossSells.crossPriceType,
              ),
            )
            .toList() ??
        [];
    _handleCrossSellingProductsData(selectedCrossSellingProducts);

    //// initialize overview data
    overviewModel = VendorProductOverviewModel(
      sku: productViewData?.sku ?? '',
      price: productViewData?.price.toString() ?? '',
      priceSale: productViewData?.salePrice?.toString() ?? '',
      chooseDiscountPeriod: (productViewData?.startDate?.toString().isNotEmpty ?? false) &&
          (productViewData?.endDate?.toString().isNotEmpty ?? false),
      fromDate: productViewData?.startDate?.toString() ?? '',
      toDate: productViewData?.endDate?.toString() ?? '',
      costPerItem: productViewData?.costPerItem.toString() ?? '',
      barcode: productViewData?.barcode?.toString() ?? '',
      withWareHouseManagement: productViewData?.withStorehouseManagement.toString() == '1',
      quantity: productViewData?.quantity?.toString() ?? '0',
      allowCustomerCheckoutWhenProductIsOutOfStock: productViewData?.allowCheckoutWhenOutOfStock.toString() == '1',
      stockStatus: productViewData?.stockStatus?.value.toString() ?? 'in_stock',
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

    /// faq
    selectedParentFaqs = ParentFAQModel();
    productViewData?.faqItems?.forEach((innerList) {
      if (innerList.length < 2) return; // Skip if not a valid FAQ pair
      selectedParentFaqs?.listFaq.add(
        FAQModel(
          question: innerList[0].value ?? '',
          answer: innerList[1].value ?? '',
        ),
      );
      log(
        'Added FAQModel: Q: ${innerList[0].value} | A: ${innerList[1].value}',
      );
    });

    log('data --> ${productViewData?.selectedExistingFaqs?.length}');

    selectedParentFaqs?.listExistingFaqs = productViewData?.selectedExistingFaqs ?? [];
    _handleFaqData(selectedParentFaqs);

    /// initialize the seo data
    vendorProductSeoModel = VendorProductSeoModel(
      title: productViewData?.seoMeta?.seoTitle ?? '',
      description: productViewData?.seoMeta?.seoDescription ?? '',
      keywords: productViewData?.seoMeta?.keywords?.map((element) => element['value'].toString()).toList() ?? [],
      type: productViewData?.seoMeta?.index ?? SeoIndexConstants.INDEX,
    );
    _handleSeoData(vendorProductSeoModel);

    // / Digital external links     /// Digital attachments
    if ((productViewData?.productType?.value?.toLowerCase() ?? '') == ProductTypeConstants.DIGITAL) {
      /// license code
      _generateLicenseCode = productViewData?.generateLicenseCode == '1';
      selectedDigitalLinks = [];
      selectedDigitalImages = [];
      final List<String> productFilesIds = [];
      for (final Attachment attachment in productViewData?.attachments ?? []) {
        /// adding id's to product files in post model
        productFilesIds.add(attachment.id.toString());

        /// external links
        if (attachment.isExternalLink ?? false) {
          selectedDigitalLinks?.add(
            DigitalLinksModel(
              isSaved: true,
              fileName: attachment.name,
              fileLink: attachment.externalLink,
              size: attachment.size?.split(' ').first ?? '',
              unit: attachment.size?.split(' ').last ?? '',
            ),
          );
        }

        /// external files
        if (attachment.isExternalLink == false) {
          selectedDigitalImages?.add(
            UploadImagesModel(fileName: attachment.name, hasFile: true),
          );
        }
      }
      createProductPostData.productFiles = productFilesIds;

      log('selectedDigitalLinks ===> ${selectedDigitalLinks?.length}');
      log('selectedDigitalImages ===> ${selectedDigitalImages?.length}');

      _handleDigitalLinksData(selectedDigitalLinks);
      _handleDigitalAttachmentsData(selectedDigitalImages);
    }
  }

  // ************************************ CREATE UPDATE PRODUCT FUNCTION START *********************************************

  // /TODO: IMPLEMENT CREATE UPDATE PRODUCT API HERE:-
  Future<bool> _createUpdateProduct() async {
    try {
      setProcessing(true);

      /// ***------------ converting content text to html and storing in content controller start --------***
      createProductPostData.content =
          _contentController.text = convertDeltaToHtml(quilController: _contentQuilController);
      createProductPostData.description =
          _descriptionController.text = convertDeltaToHtml(quilController: _descriptionQuilController);
      _handleSeoData(vendorProductSeoModel);

      /// ***------------ converting content text to html and storing in content controller end --------***

      void logFormData(FormData formData) {
        for (final field in formData.fields) {
          log('Field: ${field.key} = ${field.value}');
        }
        for (final file in formData.files) {
          log('File: ${file.key} = ${file.value.filename}');
        }
      }

      // Usage:
      final formData = createProductPostData.toFormData();
      logFormData(formData);

      if (!mounted) return false;
      final createUpdateProvider = Provider.of<VendorCreateProductViewModel>(context, listen: false);

      /// create product
      if (_currentProductId == null) {
        /// set the product type:
        createProductPostData.productType = getProductType(productType: widget.productType!);
        final result = await createUpdateProvider.createProduct(
          context: context,
          productPostDataModel: createProductPostData,
        );
        if (result) {
          /// on success go back and refresh the products list
          if (!mounted) return false;
          _productId =
              context.read<VendorCreateProductViewModel>().vendorCreateProductApiResponse.data?.data.id.toString();
          await _onRefresh();
          if (!mounted) return false;
          context.read<VendorGetProductsViewModel>().clearList();
          context.read<VendorGetProductsViewModel>().vendorGetProducts();
          // Navigator.pop(context);
        }
      } else {
        /// note: product is already set in populateViewData()
        final result = await createUpdateProvider.vendorUpdateProduct(
          context: context,
          productID: _productId ?? '',
          productPostDataModel: createProductPostData,
        );
        if (result) {
          // Navigator.pop(context);
          await _onRefresh();
        }
      }

      setProcessing(false);
      return true;
    } catch (e) {
      setProcessing(false);
      log('Error is: $e');
      return false;
    }
  }

  // ************************************ CREATE UPDATE PRODUCT FUNCTION END *********************************************

  /// ***---------------------------- Images Section start ------------------------*** ///
  void _updateImageCount() {
    if (selectedImages != null) {
      _imageCountController.text =
          selectedImages!.isNotEmpty ? '${selectedImages?.length} image(s) selected' : 'No images selected';
    } else {
      _imageCountController.clear();
    }
  }

  void _updateDigitalImageCount() {
    if (selectedDigitalImages != null) {
      _digitalImageCountController.text = selectedDigitalImages!.isNotEmpty
          ? '${selectedDigitalImages?.length} attachment(s) selected'
          : VendorAppStrings.noAttachmentsSelected.tr;
    } else {
      _digitalImageCountController.clear();
    }
  }

  void _updateDigitalLinksCount() {
    if (selectedDigitalLinks != null) {
      _digitalLinksCountController.text =
          selectedDigitalLinks!.isNotEmpty ? '${selectedDigitalLinks?.length} link(s) added' : 'No links added';
    } else {
      _digitalLinksCountController.clear();
    }
  }

  void _updateAttributesCount() {
    if (selectedAttributes != null) {
      _attributesCountController.text = selectedAttributes!.isNotEmpty
          ? '${selectedAttributes?.length} attribute(s) selected'
          : 'No attributes selected';
    } else {
      _attributesCountController.clear();
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

  void _updateRelatedProductsCount() {
    if (selectedRelatedProducts.isNotEmpty) {
      _relatedProductsCountController.text = selectedRelatedProducts.isNotEmpty
          ? '${selectedRelatedProducts.length} related product(s) selected'
          : 'No related products selected';
    } else {
      _relatedProductsCountController.clear();
    }
  }

  void _updateCrossSellingProductsCount() {
    if (selectedCrossSellingProducts.isNotEmpty) {
      _crossSellingProductsCountController.text = selectedCrossSellingProducts.isNotEmpty
          ? '${selectedCrossSellingProducts.length} cross-selling product(s) selected'
          : 'No cross-selling products selected';
    } else {
      selectedCrossSellingProducts.clear();
    }
  }

  void _updateFAQsCount() {
    if (selectedParentFaqs != null) {
      _faqsCountController.text = selectedParentFaqs!.listFaq.isNotEmpty
          ? '${selectedParentFaqs!.listFaq.length} FAQ(s) selected'
          : 'No FAQs selected';
    } else {
      _faqsCountController.clear();
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
      final List<String> serverImages = images.where((e) => e.serverUrl.isNotEmpty).map((e) => e.serverUrl).toList();
      createProductPostData.images = serverImages;
      log('Selected Server Images: $serverImages');
    } else {
      createProductPostData.images = [];
    }

    setState(() {
      selectedImages = images;
      _updateImageCount();
    });
  }

  /// ***---------------------------- Product Images Section end ------------------------*** ///

  /// ***---------------------------- Digital Attachments Section start ------------------------*** ///
  Future<void> _openDigitalPickerScreen() async {
    final List<UploadImagesModel>? images = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DigitalAttachmentsScreen(
          initialImages: selectedDigitalImages,
        ),
      ),
    );
    _handleDigitalAttachmentsData(images);
  }

  void _handleDigitalAttachmentsData(List<UploadImagesModel>? images) {
    if (images != null) {
      setState(() {
        selectedDigitalImages = images;
        createProductPostData.productFilesInput = selectedDigitalImages;
        _updateDigitalImageCount();
      });
    }
  }

  /// ***---------------------------- Digital Attachments Section end ------------------------*** ///

  /// ***---------------------------- Digital Links Section start ------------------------*** ///
  Future<void> _openDigitalLinksScreen() async {
    final List<DigitalLinksModel>? links = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DigitalLinksScreen(
          initialLinks: selectedDigitalLinks,
        ),
      ),
    );
    _handleDigitalLinksData(links);
  }

  void _handleDigitalLinksData(links) {
    if (links != null) {
      // List<String> serverImages = links.where((e) => e.serverUrl.isNotEmpty).map((e) => e.serverUrl).toList();
      // log('Selected Digital Links: $serverImages');
    } else {}

    setState(() {
      selectedDigitalLinks = links;
      createProductPostData.productFilesExternal =
          selectedDigitalLinks?.where((test) => test.isSaved == false).toList() ?? [];
      for (final e in selectedDigitalLinks ?? []) {
        log(e.toString());
      }
      _updateDigitalLinksCount();
    });
  }

  /// ***---------------------------- Digital Links Section end ------------------------*** ///

  /// ***---------------------------- Attributes Section start ------------------------*** ///
  Future<void> _openAttributesScreen(
    AttributeSetsDataResponse? attributesData,
  ) async {
    final attributes = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VendorProductAttributesScreen(
          productId: _productId,
          initialAttributes: selectedAttributes,
          listAttributesSets: attributesData?.data,
        ),
      ),
    );

    if (attributes == null) {
      attributeVariationInterchange();
    }

    if (attributes is List<Map<String, dynamic>>?) {
      _handleAttributesData(attributes);
    }
  }

  void _handleAttributesData(attributes) {
    if (attributes != null) {
      log('attributes $attributes');
      createProductPostData.addedAttributes = {
        for (final attr in attributes) '${attr["id"]}': '${attr["value_id"]}',
      };
    } else {
      createProductPostData.addedAttributes = {};
    }

    setState(() {
      selectedAttributes = attributes;
      _updateAttributesCount();
    });
  }

  /// ***---------------------------- Attributes Section start ------------------------*** ///

  /// ***---------------------------- Products options Section start ------------------------*** ///
  Future<void> _openProductOptionsScreen(
    List<GlobalOptions> globalOptions,
  ) async {
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
              affectType: value.affectType.toString(),
              affectPrice: value.affectPrice.toString(),
              id: value.id.toString(),
              order: valueIndex.toString(),
              // Use value index
              optionValue: option.getType().toLowerCase() == 'location' ? value.optionValue.toString() : '',
            );
          }).toList(),
        );
      }).toList();

      /// converting to the list of map or json objects
      createProductPostData.options = selectedOptions.map((option) => option.toJson()).toList();
    } else {
      createProductPostData.options = [];
    }

    setState(() {
      selectedProductOptions = options;
      _updateProductOptionsCount();
    });
  }

  /// ***---------------------------- Products options Section end ------------------------*** ///

  /// ***---------------------------- Related Products Section start ------------------------*** ///
  Future<void> _openRPSearchScreen() async {
    final List<SearchProductRecord> relatedProducts = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RelatedProductsSearchScreen(
          title: VendorAppStrings.relatedProducts.tr,
          dataId: _productId,
          selectedRelatedProducts: selectedRelatedProducts,
        ),
      ),
    );
    _handleRelatedProductsData(relatedProducts);
  }

  void _handleRelatedProductsData(List<SearchProductRecord> relatedProducts) {
    if (relatedProducts.isNotEmpty) {
      final relatedIds = relatedProducts
          .map((e) => e.id.toString())
          .toSet() // Ensures uniqueness
          .join(',');

      createProductPostData.relatedProducts = relatedIds;
    } else {
      createProductPostData.relatedProducts = '';
    }
    setState(() {
      selectedRelatedProducts = relatedProducts;
      _updateRelatedProductsCount();
    });
  }

  /// ***---------------------------- Related Products Section end ------------------------*** ///

  /// ***---------------------------- Cross Selling Products Section start ------------------------*** ///
  Future<void> _openCSSearchScreen() async {
    final List<SearchProductRecord> crossSellingProducts = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrossSellingProductsSearchScreen(
          title: VendorAppStrings.crossSellingProducts.tr,
          dataId: _productId,
          selectedCrossSellingProducts: selectedCrossSellingProducts,
        ),
      ),
    );

    _handleCrossSellingProductsData(crossSellingProducts);
  }

  void _handleCrossSellingProductsData(crossSellingProducts) {
    if (crossSellingProducts.isNotEmpty) {
      final selectedCrossSellingProducts = {
        for (final element in crossSellingProducts)
          element.id.toString(): {
            'id': element.id.toString(),
            'price': element.price.toString(),
            'price_type': element.priceType,
          },
      };

      createProductPostData.crossSaleProducts = selectedCrossSellingProducts;
    } else {
      createProductPostData.crossSaleProducts = {};
    }

    setState(() {
      selectedCrossSellingProducts = crossSellingProducts;
      _updateCrossSellingProductsCount();
    });
  }

  /// ***---------------------------- Cross Selling Products Section start ------------------------*** ///

  /// ***---------------------------- FAQ's Section start ------------------------*** ///
  ParentFAQModel? parentFAQModel;

  Future<void> _openProductFAQScreen(List<Faqs> listFaq) async {
    final ParentFAQModel parentFAQModel = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VendorProductFaqScreen(
          listFaq: listFaq,
          parentFAQModel: selectedParentFaqs,
        ),
      ),
    );

    _handleFaqData(parentFAQModel);
  }

  void _handleFaqData(parentFAQModel) {
    if (parentFAQModel.listExistingFaqs.isNotEmpty) {
      /// selected faq's
      createProductPostData.selectedExistingFaqs = parentFAQModel.listExistingFaqs;
    } else {
      createProductPostData.selectedExistingFaqs = [];
    }

    if (parentFAQModel.listFaq.isNotEmpty) {
      /// new faq_schema_config i.e. new faq questions
      createProductPostData.faqSchemaConfig = parentFAQModel.listFaq
          .map(
            (element) => [
              {'key': 'question', 'value': element.question},
              {'key': 'answer', 'value': element.answer},
            ],
          )
          .toList();
    } else {
      createProductPostData.faqSchemaConfig = [];
    }

    setState(() {
      selectedParentFaqs = parentFAQModel;
      _updateFAQsCount();
    });
  }

  /// ***---------------------------- FAQ's Section End ------------------------*** ///

  /// ***---------------------------- Overview Section start ------------------------*** ///
  VendorProductOverviewModel? overviewModel;

  Future<void> _openOverviewView() async {
    final overviewSelectedData = await showDraggableModalBottomSheet<VendorProductOverviewModel>(
      context: context,
      builder: (scrollController) => Container(
        color: Theme.of(context).cardColor,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              AppUtils.dragHandle(context: context),
              VendorProductOverviewView(
                overviewModel: overviewModel,
                productType: (widget.productType == VendorProductType.physical)
                    ? ProductTypeConstants.PHYSICAL
                    : ProductTypeConstants.DIGITAL,
              ),
            ],
          ),
        ),
      ),
    );
    if (overviewSelectedData != null) {
      overviewModel = overviewSelectedData;
      _handleOverViewData(overviewModel);
    }
  }

  void _handleOverViewData(result) {
    // if (result != null) {
    overviewModel = result;
    createProductPostData.sku = overviewModel?.sku ??
        context.read<VendorCreateProductViewModel>().generalSettingsApiResponse.data?.data?.sku?.toString() ??
        '';
    createProductPostData.price = overviewModel?.price ?? '0';
    createProductPostData.salePrice = overviewModel?.priceSale ?? '0';
    createProductPostData.startDate = overviewModel?.fromDate ?? '';
    createProductPostData.endDate = overviewModel?.toDate ?? '';
    createProductPostData.costPerItem = overviewModel?.costPerItem ?? '0';
    createProductPostData.barcode = overviewModel?.barcode ?? '';
    createProductPostData.withStorehouseManagement = overviewModel?.withWareHouseManagement ?? false ? '1' : '0';
    createProductPostData.allowCheckoutWhenOutOfStock =
        overviewModel?.allowCustomerCheckoutWhenProductIsOutOfStock ?? false ? '1' : '0';
    createProductPostData.quantity =
        overviewModel?.withWareHouseManagement ?? false ? overviewModel?.quantity ?? '0' : '0';
    createProductPostData.stockStatus = overviewModel?.stockStatus ?? 'in_stock';
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
          vendorProductDimensionsModel: vendorProductDimensionsModel,
        ),
      ),
    );

    log('vendorProductDimensionsModel $vendorProductDimensionsModel');
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

  /// ***---------------------------- Product has variations Section start ------------------------*** ///
  Future _openProductHasVariationsView() async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => VendorProductHasVariationsView(
          productID: _productId,
        ),
      ),
    );

    if (result == null) {
      attributeVariationInterchange();
    }
  }

  Future attributeVariationInterchange() async {
    final provider = Provider.of<VendorCreateProductViewModel>(context, listen: false);

    await provider.getProductView(context, _productId!);

    setState(() {});
  }

  /// ***---------------------------- Product has variations Section end ------------------------*** ///

  /// ***---------------------------- Product Search Engine Optimization Section start ------------------------*** ///
  VendorProductSeoModel? vendorProductSeoModel;

  Future _openSeoOptimizeView() async {
    vendorProductSeoModel = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => VendorProductSeoView(vendorProductSeoModel: vendorProductSeoModel),
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
          : (_nameController.text.trim().isNotEmpty ? _nameController.text : ''),
      'seo_description': (vendorProductSeoModel?.description.trim().isNotEmpty ?? false)
          ? vendorProductSeoModel!.description
          : (_descriptionController.text.trim().isNotEmpty ? _descriptionController.text : ''),
      'index': vendorProductSeoModel?.type ?? SeoIndexConstants.INDEX,
    };

// Add optional keywords only if they are not null or empty
    if (vendorProductSeoModel?.keywords.isNotEmpty ?? false) {
      // / Currently throwing the server error /// TODO: uncomment this for seo keywords
      createProductPostData.seoMeta?['seo_keywords'] = jsonEncode(
        vendorProductSeoModel!.keywords.map((keyword) => {'value': keyword}).toList(),
      );
    }
  }

  /// ***---------------------------- Product Search Engine Optimization Section end ------------------------*** ///

  /// ***---------------------------- Brand Section start ------------------------*** ///
  List<DropdownMenuItem> _brandDropdownMenuItemsList = [];

  void _initializeBrandDropdownMenuItems() {
    final provider = context.read<VendorCreateProductViewModel>();
    _brandDropdownMenuItemsList = provider.generalSettingsApiResponse.data?.data?.brands
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
    final provider = context.read<VendorCreateProductViewModel>();
    _categoryDropdownItems = provider.generalSettingsApiResponse.data?.data?.productCategories
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
  final _productCollectionsController = MultiSelectController<ProductCollections>();
  List<DropdownItem<ProductCollections>> _productCollectionsDropdownItems = [];

  void _initializeProductCollections({List<int> collections = const []}) {
    final provider = context.read<VendorCreateProductViewModel>();
    _productCollectionsDropdownItems = provider.generalSettingsApiResponse.data?.data?.productCollections
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
    final provider = context.read<VendorCreateProductViewModel>();
    _productLabelDropdownItems = provider.generalSettingsApiResponse.data?.data?.productLabels
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
    final provider = context.read<VendorCreateProductViewModel>();
    _productTaxesDropdownItems = provider.generalSettingsApiResponse.data?.data?.taxes
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
    _productTagsDropdownItems = provider.productTagsApiResponse.data?.vendorProductTags
            ?.map(
              (tag) => DropdownItem(
                label: tag.toString(),
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

    final String textToSlug = _permalinkController.text.isNotEmpty ? _permalinkController.text : _nameController.text;

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
    final createProductSlugProvider = Provider.of<VendorCreateProductViewModel>(context, listen: false);
    try {
      final slugGenerated = await createProductSlugProvider.vendorCreateProductSlug(
        productName: slug,
        productID: _productId,
        slugID: _slugID,
        context: context,
      );
      if (slugGenerated != null) {
        setState(() {
          createProductPostData.slug = slugGenerated;
          createProductPostData.slugId = _slugID ?? '0';
          _permalinkController.text =
              createProductSlugProvider.vendorCreateSlugApiResponse.data?.data?.toString() ?? '';
        });
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  /// ***---------------------------- create slug Section end ------------------------*** ///

  String getHeaderText() {
    switch (widget.productType) {
      case VendorProductType.physical:
        return AppStrings.products.tr;
      case VendorProductType.digital:
        return VendorAppStrings.digitalAttachments.tr;
      default:
        return AppStrings.productDetails.tr;
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
      appBar: VendorCommonAppBar(
        title: _productId == null ? getHeaderText() : '${AppStrings.edit.tr} ${AppStrings.products.tr} $_productId',
      ),
      body: AppUtils.modelProgressHud(
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
            Consumer<VendorCreateProductViewModel>(
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
                    SafeArea(
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                                child: CustomAppButton(
                                  borderRadius: 4,
                                  buttonText: AppStrings.save.tr,
                                  buttonColor: AppColors.lightCoral,
                                  onTap: () async {
                                    _handleOverViewData(overviewModel);

                                    /// assign some default values if nothing is selected in overview because we need to assign 0 to quantity and prices
                                    setState(() {});
                                    /*if (_formKey.currentState?.validate() ?? false) {
                                          await _createUpdateProduct();
                                        }*/

                                    if (_formKey.currentState?.validate() ?? false) {
                                      await _createUpdateProduct();
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
                                          final result = await _createUpdateProduct();
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

  Widget _buildUi({required ThemeData theme, required BuildContext context}) => Consumer<VendorCreateProductViewModel>(
        builder: (context, provider, _) {
          final settings = provider.generalSettingsApiResponse.data?.data;
          final viewData = provider.vendorProductViewApiResponse.data?.data;

          log(
            'view data ==> ${viewData?.totalVariations} || $_productId',
          );

          /// Build overview, general info, image
          final List<Widget> sections = [
            _generalInformation(
              theme: theme,
              context: context,
              provider: provider,
            ),
            _overviewSection(
              theme: theme,
              context: context,
              provider: provider,
            ),
            _imagesSection(theme: theme, context: context),
          ];

          ///Build shipping
          if (_productId == null && widget.productType?.name == VendorProductType.physical.name) {
            sections.add(_shippingSection(theme: theme, context: context));
          }

          if (_productId != null &&
              viewData?.totalVariations == 0 &&
              viewData?.productType?.value?.toLowerCase() == VendorProductType.physical.name) {
            sections.add(_shippingSection(theme: theme, context: context));
          }

          if (_productId == null && widget.productType?.name == VendorProductType.digital.name) {
            sections.add(_digitalAttachments(theme: theme, context: context));
            sections.add(_digitalAttachmentsLinks(theme: theme, context: context));
          }

          if (_productId != null &&
              viewData?.totalVariations == 0 &&
              viewData?.productType?.value?.toLowerCase() == VendorProductType.digital.name) {
            sections.add(_digitalAttachments(theme: theme, context: context));
            sections.add(_digitalAttachmentsLinks(theme: theme, context: context));
          }

          ///Build variations
          if (_productId != null && (viewData?.totalVariations ?? 0) > 0) {
            sections.add(
              _productVariationsSection(
                theme: theme,
                context: context,
                provider: provider,
              ),
            );
          }

          ///Build attributes
          if (_productId == null || viewData?.totalVariations == 0) {
            sections.add(
              _attributesSection(
                theme: theme,
                context: context,
                provider: provider,
              ),
            );
          }

          ///Build product options
          if (settings?.isEnabledProductOptions == true && settings?.globalOptions?.isNotEmpty == true) {
            sections.add(
              _productOptionsSection(
                theme: theme,
                context: context,
                globalOptions: settings!.globalOptions!,
              ),
            );
          }

          ///Build related products, cross products, faqs and seo
          sections.addAll([
            _relatedProducts(theme: theme, context: context),
            _crossSellingProducts(theme: theme, context: context),
            _productFaqsSection(
              theme: theme,
              context: context,
              listFaq: settings?.faqs ?? [],
            ),
            _seoSection(theme: theme, context: context),
          ]);

          /// Return ListView with dynamically built sections
          return Padding(
            padding: EdgeInsets.only(
              left: kPadding,
              right: kPadding,
              top: kPadding,
              bottom: 80,
            ),
            child: ListView.separated(
              itemCount: provider.generalSettingsApiResponse.status == ApiStatus.ERROR ? 1 : sections.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (provider.generalSettingsApiResponse.status == ApiStatus.ERROR) {
                  return AppUtils.somethingWentWrong();
                }
                return sections[index];
              },
            ),
          );
        },
      );

  final QuillController _descriptionQuilController = QuillController.basic();
  final QuillController _contentQuilController = QuillController.basic();

  /// General Information
  Column _generalInformation({
    required ThemeData theme,
    required BuildContext context,
    required VendorCreateProductViewModel provider,
  }) {
    final settings = provider.generalSettingsApiResponse.data?.data;

    /// general settings data
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// product name
        CustomTextFormField(
          labelText: AppStrings.name.tr,
          required: true,
          hintText: AppStrings.enterName.tr,
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
            final createSlugApiResponse = createProductSlugProvider.vendorCreateSlugApiResponse.status;
            return CustomTextFormField(
              labelText: VendorAppStrings.permalink.tr,
              required: true,
              hintText: '',
              maxLines: 1,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              prefix: texFieldPrefix(
                screenWidth: screenWidth,
                text: VendorApiEndpoints.vendorProductBaseUrl,
                padding: EdgeInsets.only(left: screenWidth * 0.04),
              ),
              validator: Validator.validatePermalink,
              suffix: _permalinkController.text.isNotEmpty || _nameController.text.isNotEmpty
                  ? InkResponse(
                      highlightColor: AppColors.lightCoral.withAlpha((0.5 * 255).toInt()),
                      splashColor: AppColors.lightCoral.withAlpha((0.3 * 255).toInt()),
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
                              child: AppUtils.pageLoadingIndicator(context: context),
                            )
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

        /// description
        fieldTitle(text: AppStrings.description.tr),
        CustomEditableTextField(
          placeholder: '',
          showToolBar: false,
          fieldHeight: 100,
          quillController: _descriptionQuilController,
        ),
        kFormFieldSpace,

        /// content
        fieldTitle(text: VendorAppStrings.content.tr),
        CustomEditableTextField(
          placeholder: '',
          showToolBar: false,
          fieldHeight: 100,
          quillController: _contentQuilController,
        ),
        kFormFieldSpace,

        /// brands
        fieldTitle(text: AppStrings.brands.tr),
        kMinorSpace,
        CustomDropdown(
          menuItemsList: _brandDropdownMenuItemsList,
          hintText: VendorAppStrings.selectBrand.tr,
          value: _brandDropdownMenuItemsList.map((item) => item.value).firstWhere(
                (id) => id == createProductPostData.brandId,
                orElse: () => null,
              ),
          onChanged: (value) {
            createProductPostData.brandId = value;
          },
        ),
        kFormFieldSpace,

        /// categories
        fieldTitle(text: AppStrings.categories.tr),
        kMinorSpace,
        CustomMultiselectDropdown(
          dropdownItems: _categoryDropdownItems,
          dropdownController: _categoriesController,
          hintText: AppStrings.categories.tr,
          onSelectionChanged: (value) {
            if (value is List<ProductCategories>) {
              final List<int> selectedCategoryIds = value.where((e) => e.id != null).map((e) => e.id!).toList();
              createProductPostData.categories = selectedCategoryIds;
              log('Selected Categories: $selectedCategoryIds');
            } else {
              log('Unexpected data type: ${value.runtimeType}');
            }
          },
        ),
        kFormFieldSpace,

        /// product collections
        fieldTitle(text: VendorAppStrings.relatedProducts.tr),
        kMinorSpace,
        CustomMultiselectDropdown(
          dropdownItems: _productCollectionsDropdownItems,
          dropdownController: _productCollectionsController,
          hintText: VendorAppStrings.selectProductCollection.tr,
          onSelectionChanged: (value) {
            if (value is List<ProductCollections>) {
              final List<int> selectedCollectionIds = value.where((e) => e.id != null).map((e) => e.id!).toList();
              createProductPostData.productCollections = selectedCollectionIds;
              log('Selected Product Collections: $selectedCollectionIds');
            } else {
              log('Unexpected data type: ${value.runtimeType}');
            }
          },
        ),
        kFormFieldSpace,

        /// labels
        fieldTitle(text: VendorAppStrings.enterLabel.tr),
        kMinorSpace,
        CustomMultiselectDropdown(
          dropdownItems: _productLabelDropdownItems,
          dropdownController: _productLabelController,
          hintText: VendorAppStrings.selectLabels.tr,
          onSelectionChanged: (value) {
            if (value is List<ProductLabels>) {
              final List<int> selectedLabelsIds = value.where((e) => e.id != null).map((e) => e.id!).toList();
              createProductPostData.productLabels = selectedLabelsIds;
              log('Selected Labels: $selectedLabelsIds');
            } else {
              log('Unexpected data type: ${value.runtimeType}');
            }
          },
        ),
        kFormFieldSpace,

        /// taxes
        if (settings?.isTaxEnabled ?? true)
          Column(
            children: [
              fieldTitle(text: VendorAppStrings.selectTaxes.tr),
              kMinorSpace,
              CustomMultiselectDropdown(
                dropdownItems: _productTaxesDropdownItems,
                dropdownController: _productTaxesController,
                hintText: VendorAppStrings.selectTaxes.tr,
                onSelectionChanged: (value) {
                  if (value is List<Taxes>) {
                    final List<int> selectedTaxesIds = value.where((e) => e.id != null).map((e) => e.id!).toList();
                    createProductPostData.taxes = selectedTaxesIds;
                    log('Selected Taxes: $selectedTaxesIds');
                  } else {
                    log('Unexpected data type: ${value.runtimeType}');
                  }
                },
              ),
              kFormFieldSpace,
            ],
          ),

        /// tags
        fieldTitle(text: AppStrings.tags.tr),
        kMinorSpace,
        CustomMultiselectDropdown(
          dropdownItems: _productTagsDropdownItems,
          dropdownController: _productTagsController,
          hintText: VendorAppStrings.selectTags.tr,
          onSelectionChanged: (value) {
            log('Selected Tags: $value');
            if (value is List<String>) {
              final List<Map<String, String>> selectedTags =
                  value.where((e) => e.isNotEmpty).map((e) => {'value': e}).toList();
              createProductPostData.tag = selectedTags;
              log('Selected Tag: $selectedTags');
            } else {
              log('Unexpected data type: ${value.runtimeType}');
            }
          },
        ),

        /// generate license code:
        if (_currentProductType == ProductTypeConstants.DIGITAL || widget.productType == VendorProductType.digital)
          Column(
            children: [
              kFormFieldSpace,
              CustomCheckboxWithTitle(
                isChecked: _generateLicenseCode,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _generateLicenseCode = value;
                      createProductPostData.generateLicenseCode = _generateLicenseCode ? '1' : '0';
                    });
                  }
                },
                title: VendorAppStrings.generateLicenseCodeAfterPurchase.tr,
              ),
            ],
          ),
      ],
    );
  }

  /// Upload images
  Widget _imagesSection({
    required ThemeData theme,
    required BuildContext context,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithArrow(
            title: VendorAppStrings.uploadImages.tr,
            textStyle: createProductTextStyle(context),
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
  Widget _overviewSection({
    required ThemeData theme,
    required BuildContext context,
    required VendorCreateProductViewModel provider,
  }) =>
      Column(
        children: [
          TitleWithArrow(
            title: AppStrings.overview.tr,
            textStyle: createProductTextStyle(context),
            onTap: () async {
              try {
                await _openOverviewView();
              } catch (e) {
                log('Error: $e');
              }
            },
          ),
          if (overviewModel != null)
            SimpleCard(
              expandedContentPadding: EdgeInsets.symmetric(
                horizontal: kMediumPadding,
                vertical: kExtraSmallPadding,
              ),
              expandedContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align the content to the left
                children: [
                  showDetail(label: VendorAppStrings.sku.tr, value: overviewModel?.sku),
                  showDetail(label: VendorAppStrings.price.tr, value: overviewModel?.price),
                  showDetail(
                    label: VendorAppStrings.salePrice.tr,
                    value: overviewModel?.priceSale,
                  ),
                  if (overviewModel?.chooseDiscountPeriod ?? false)
                    Column(
                      children: [
                        showDetail(
                          label: VendorAppStrings.fromDate.tr,
                          value: overviewModel?.fromDate,
                        ),
                        showDetail(label: VendorAppStrings.toDate.tr, value: overviewModel?.toDate),
                      ],
                    ),
                  showDetail(
                    label: VendorAppStrings.costPerItem.tr,
                    value: overviewModel?.costPerItem,
                  ),
                  showDetail(label: 'Barcode', value: overviewModel?.barcode),
                  if (overviewModel?.withWareHouseManagement ?? false)
                    showDetail(
                      label: 'Quantity',
                      value: overviewModel?.quantity,
                    ),
                  if (!(overviewModel?.withWareHouseManagement ?? true))
                    showDetail(
                      label: 'Stock Status',
                      value: (overviewModel?.stockStatus != null && overviewModel?.stockStatus.isNotEmpty == true)
                          ? provider.generalSettingsApiResponse.data?.data?.stockStatuses
                                  ?.firstWhere(
                                    (element) => element.value == overviewModel?.stockStatus,
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

  /// Product variation's
  Widget _productVariationsSection({
    required ThemeData theme,
    required BuildContext context,
    required VendorCreateProductViewModel provider,
  }) =>
      TitleWithArrow(
        title: VendorAppStrings.productVariations.tr,
        textStyle: createProductTextStyle(context),
        onTap: () async {
          try {
            _openProductHasVariationsView();
          } catch (e) {
            log('Error: $e');
          }
        },
      );

  /// shipping section : visible for physical product only
  Widget _shippingSection({
    required ThemeData theme,
    required BuildContext context,
  }) =>
      Column(
        children: [
          TitleWithArrow(
            title: VendorAppStrings.shippingFee.tr,
            textStyle: createProductTextStyle(context),
            onTap: () async {
              try {
                await _openShippingSection();
              } catch (e) {
                log('Error: $e');
              }
            },
          ),
          if (vendorProductDimensionsModel != null)
            SimpleCard(
              expandedContentPadding: EdgeInsets.symmetric(
                horizontal: kMediumPadding,
                vertical: kExtraSmallPadding,
              ),
              expandedContent: Column(
                children: [
                  showDetail(
                    label: VendorAppStrings.weightG.tr,
                    value: vendorProductDimensionsModel?.weight,
                  ),
                  showDetail(
                    label: VendorAppStrings.lengthCm.tr,
                    value: vendorProductDimensionsModel?.length,
                  ),
                  showDetail(
                    label: VendorAppStrings.widthCm.tr,
                    value: vendorProductDimensionsModel?.width,
                  ),
                  showDetail(
                    label: VendorAppStrings.heightCm.tr,
                    value: vendorProductDimensionsModel?.height,
                  ),
                ],
              ),
            ),
        ],
      );

  /// For Digital Product
  Widget _digitalAttachments({
    required ThemeData theme,
    required BuildContext context,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithArrow(
            title: VendorAppStrings.digitalAttachments.tr,
            textStyle: createProductTextStyle(context),
            onTap: _openDigitalPickerScreen,
          ),
          if (selectedDigitalImages?.isNotEmpty == true)
            TextFormField(
              controller: _digitalImageCountController,
              readOnly: true, // Prevent manual input
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.image, color: AppColors.lightCoral),
              ),
              onTap: _openDigitalPickerScreen,
            ),
        ],
      );

  /// For Digital Product
  Widget _digitalAttachmentsLinks({
    required ThemeData theme,
    required BuildContext context,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithArrow(
            title: VendorAppStrings.digitalAttachmentLinks.tr,
            textStyle: createProductTextStyle(context),
            onTap: _openDigitalLinksScreen,
          ),
          if (selectedDigitalLinks?.isNotEmpty == true)
            TextFormField(
              controller: _digitalLinksCountController,
              readOnly: true, // Prevent manual input
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.attach_file, color: AppColors.lightCoral),
              ),
              onTap: _openDigitalLinksScreen,
            ),
        ],
      );

  /// attributes section
  Widget _attributesSection({
    required ThemeData theme,
    required BuildContext context,
    required VendorCreateProductViewModel provider,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithArrow(
            title: VendorAppStrings.attributes.tr,
            textStyle: createProductTextStyle(context),
            onTap: () => _openAttributesScreen(provider.attributeSetsApiResponse.data),
          ),
          if (selectedAttributes?.isNotEmpty == true)
            TextFormField(
              controller: _attributesCountController,
              readOnly: true, // Prevent manual input
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onTap: () => _openAttributesScreen(provider.attributeSetsApiResponse.data),
            ),
        ],
      );

  Widget _productOptionsSection({
    required ThemeData theme,
    required BuildContext context,
    required List<GlobalOptions> globalOptions,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithArrow(
            title: VendorAppStrings.productOptions.tr,
            textStyle: createProductTextStyle(context),
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

  Widget _relatedProducts({
    required ThemeData theme,
    required BuildContext context,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithArrow(
            title: VendorAppStrings.relatedProducts.tr,
            textStyle: createProductTextStyle(context),
            onTap: () => _openRPSearchScreen(),
          ),
          if (selectedRelatedProducts.isNotEmpty == true)
            TextFormField(
              controller: _relatedProductsCountController,
              readOnly: true, // Prevent manual input
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onTap: _openRPSearchScreen,
            ),
        ],
      );

  Widget _crossSellingProducts({
    required ThemeData theme,
    required BuildContext context,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithArrow(
            title: VendorAppStrings.crossSellingProducts.tr,
            textStyle: createProductTextStyle(context),
            onTap: () => _openCSSearchScreen(),
          ),
          if (selectedCrossSellingProducts.isNotEmpty == true)
            TextFormField(
              controller: _crossSellingProductsCountController,
              readOnly: true, // Prevent manual input
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onTap: _openCSSearchScreen,
            ),
        ],
      );

  /// Product FAQ's
  Widget _productFaqsSection({
    required ThemeData theme,
    required BuildContext context,
    required List<Faqs> listFaq,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithArrow(
            title: VendorAppStrings.productFaqs.tr,
            textStyle: createProductTextStyle(context),
            onTap: () => _openProductFAQScreen(listFaq),
          ),
          if (selectedParentFaqs?.listFaq.isNotEmpty == true)
            TextFormField(
              controller: _faqsCountController,
              readOnly: true, // Prevent manual input
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onTap: () => _openProductFAQScreen(listFaq),
            ),
        ],
      );

  /// Search Engine Optimization
  Widget _seoSection({
    required ThemeData theme,
    required BuildContext context,
  }) =>
      Column(
        children: [
          TitleWithArrow(
            title: VendorAppStrings.searchEngineOptimization.tr,
            textStyle: createProductTextStyle(context),
            onTap: _openSeoOptimizeView,
          ),
          if ((_permalinkController.text.isNotEmpty &&
                  vendorProductSeoModel?.title != null &&
                  (vendorProductSeoModel?.title.isNotEmpty ?? false)) ||
              _nameController.text.isNotEmpty)
            SimpleCard(
              expandedContentPadding: EdgeInsets.symmetric(
                horizontal: kMediumPadding,
                vertical: kExtraSmallPadding,
              ),
              expandedContent: vendorProductSeoModel?.type == SeoIndexConstants.NO_INDEX
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
                            color: AppColors.royalIndigo,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          VendorApiEndpoints.vendorProductBaseUrl + _permalinkController.text,
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
                                vendorProductSeoModel?.description.isNotEmpty == true
                                    ? " - ${removeHtmlTags(htmlString: vendorProductSeoModel?.description ?? '')}"
                                    : (_descriptionController.text.isNotEmpty
                                        ? " - ${removeHtmlTags(htmlString: vendorProductSeoModel?.description ?? '')}"
                                        : ''),
                                // Only show "-" if description or text is not empty
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
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

TextStyle createProductTextStyle(BuildContext context) =>
    detailsTitleStyle.copyWith(fontSize: 16, color: Theme.of(context).colorScheme.onPrimary);

class TitleWithArrow extends StatelessWidget {
  const TitleWithArrow({
    super.key,
    required this.title,
    this.onTap,
    this.textStyle,
  });

  final String title;
  final VoidCallback? onTap;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(child: Text(title, style: textStyle)),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      );
}

Widget showDetail({required String label, String? value}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value?.isNotEmpty ?? false ? value ?? '--' : '--',
              ),
            ),
          ],
        ),
        kExtraSmallSpace,
      ],
    );

String getProductType({required VendorProductType productType}) {
  switch (productType) {
    case VendorProductType.physical:
      return ProductTypeConstants.PHYSICAL;
    case VendorProductType.digital:
      return ProductTypeConstants.DIGITAL;
    case VendorProductType.none:
      return '';
  }
}
