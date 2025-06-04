import 'dart:async';

import 'package:dio/dio.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/products/create_product/product_overview_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/product_post_data_model.dart';
import 'package:event_app/models/vendor_models/products/edit_product/edit_variations_data_response.dart';
import 'package:event_app/models/vendor_models/products/edit_product/new_product_view_data_response.dart';
import 'package:event_app/models/vendor_models/products/holder_models/digital_links_model.dart';
import 'package:event_app/models/vendor_models/products/holder_models/upload_images_model.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/vendor/components/app_bars/vendor_modify_sections_app_bar.dart';
import 'package:event_app/vendor/components/bottom_sheets/draggable_bottom_sheet.dart';
import 'package:event_app/vendor/components/dropdowns/custom_dropdown.dart';
import 'package:event_app/vendor/components/enums/enums.dart';
import 'package:event_app/vendor/components/settings_components/simple_card.dart';
import 'package:event_app/vendor/components/status_constants/product_type_constants.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/digital_attachment_links_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/digital_attachments_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/product_sections/vendor_product_overview_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/product_sections/vendor_product_shipping_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/upload_images_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/vendor_create_physical_product_view.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_edit_product/vendor_create_update_variation_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_edit_product/vendor_get_product_variations_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../models/vendor_models/products/create_product/attribute_sets_data_response.dart';
import '../../../../../models/vendor_models/products/create_product/vendor_product_dimensions_model.dart';
import '../../../../../core/helper/validators/validator.dart';
import '../../../../components/checkboxes/custom_checkboxes.dart';
import '../../../../view_models/vendor_products/vendor_edit_product/vendor_get_selected_product_attibutes_view_model.dart';

class VendorEditVariations extends StatefulWidget {
  const VendorEditVariations(
      {super.key, this.productVariationsID, required this.productID});
  final String? productVariationsID;
  final String productID;

  @override
  _VendorEditVariationsState createState() => _VendorEditVariationsState();
}

class _VendorEditVariationsState extends State<VendorEditVariations>
    with MediaQueryMixin {
  VendorProductOverviewModel? overviewModel;

  final TextEditingController _imageCountController = TextEditingController();
  final TextEditingController _digitalImageCountController =
      TextEditingController();
  final TextEditingController _digitalLinksCountController =
      TextEditingController();

  List<UploadImagesModel>? selectedImages;
  List<UploadImagesModel>? selectedDigitalImages;
  List<DigitalLinksModel>? selectedDigitalLinks;

  ProductPostDataModel variationPostDataModel = ProductPostDataModel();

  /// edit attributes
  List<AttributeSetsData> _selectedAttributesSet = [];
  final Map<String, String> _finalAttributesDataForCreateVariation = {};
  List<ProductAttributeSet> listAttributes = [];
  VariationProduct? overview;
  List<Attachment> attachments = [];
  bool _generateLicenseCode = false;
  bool _authGenerateSku = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await _onRefresh();
    });
  }

  bool _isProcessing = false;

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Future _onRefresh() async {
    try {
      setProcessing(true);

      /// adding new product
      if (widget.productVariationsID == null && widget.productID.isNotEmpty) {
        /// ******** Get all attributes set start **********
        final vendorGetAttributesSetProvider =
            Provider.of<VendorCreateProductViewModel>(context, listen: false);
        await vendorGetAttributesSetProvider.getAttributeSetsData();

        /// ******** Get all attributes set end **********

        /// ******** Get selected attributes set start **********
        final vendorGetSelectedAttributesSetProvider =
            context.read<VendorGetSelectedAttributesViewModel>();
        final result = await vendorGetSelectedAttributesSetProvider
            .vendorGetSelectedProductAttributes(productID: widget.productID);
        if (result) {
          _selectedAttributesSet = vendorGetSelectedAttributesSetProvider
                  .attributeSetsApiResponse.data?.data ??
              [];
        }

        /// ******** Get selected attributes set end **********
      } else {
        final provider =
            Provider.of<VendorCreateProductViewModel>(context, listen: false);
        await provider.getEditVariations(
            context, widget.productVariationsID ?? '');

        if (provider.editVariationsApiResponse.status == ApiStatus.COMPLETED) {
          _generateLicenseCode = provider
                  .editVariationsApiResponse.data?.data?.generateLicenseCode ==
              1;
          listAttributes = provider
                  .editVariationsApiResponse.data?.data?.productAttributeSets ??
              [];
          overview = provider.editVariationsApiResponse.data?.data?.product;

          overviewModel = VendorProductOverviewModel(
            sku: overview?.sku ?? '',
            price: overview?.price.toString() ?? '',
            priceSale: overview?.salePrice?.toString() ?? '',
            chooseDiscountPeriod:
                (overview?.startDate?.toString().isNotEmpty ?? false) &&
                    (overview?.endDate?.toString().isNotEmpty ?? false),
            fromDate: overview?.startDate?.toString() ?? '',
            toDate: overview?.endDate?.toString() ?? '',
            costPerItem: overview?.costPerItem?.toString() ?? '0',
            barcode: overview?.barcode?.toString() ?? '',
            withWareHouseManagement:
                overview?.withStorehouseManagement.toString() == '1',
            quantity: overview?.quantity?.toString() ?? '0',
            allowCustomerCheckoutWhenProductIsOutOfStock:
                overview?.allowCheckoutWhenOutOfStock.toString() == '1',
            stockStatus: overview?.stockStatus.value.toString() ?? 'in_stock',
          );

          attachments =
              provider.editVariationsApiResponse.data?.data?.attachments ?? [];

          selectedImages =
              provider.editVariationsApiResponse.data?.data?.variationImages
                  .map(
                    (images) => UploadImagesModel(
                      serverUrl: images.url,
                      serverFullUrl: images.fullURL,
                      hasFile: false,
                    ),
                  )
                  .toList();
          _updateImageCount();

          selectedDigitalLinks = [];
          selectedDigitalImages = [];
          final List<String> productFilesIds = [];
          for (final Attachment attachment in attachments ?? []) {
            /// adding id's to product files in post model
            productFilesIds.add(attachment.id.toString());

            /// links and attachments
            if (attachment.isExternalLink ?? false) {
              selectedDigitalLinks?.add(
                DigitalLinksModel(
                  isSaved: true,
                  fileName: attachment.name,
                  fileLink: attachment.externalLink,
                  size: attachment.size?.split(' ').first ?? '',
                  fileNameController:
                      TextEditingController(text: attachment.name ?? ''),
                  fileLinkController: TextEditingController(
                      text: attachment.externalLink ?? ''),
                  sizeController:
                      TextEditingController(text: attachment.size ?? ''),
                  unit: attachment.size?.split(' ').last ?? '',
                ),
              );
            } else {
              selectedDigitalImages?.add(
                UploadImagesModel(fileName: attachment.name, hasFile: true),
              );
            }
          }
          variationPostDataModel.productFiles = productFilesIds;
          _updateDigitalImageCount();
          _updateDigitalLinksCount();
        }
      }

      setProcessing(false);
    } catch (e) {
      setProcessing(false);
      print('Error: $e');
    }
  }

  /// Function to execute when user will leave the page
  void _return() {
    Navigator.pop(context);
  }

  /// save Function TODO: Implement create update here
  Future _createUpdateVariation() async {
    try {
      /// **** assign values to post data model start ***
      _handleOverViewData(overviewModel);
      _handleShippingData(vendorProductDimensionsModel);
      variationPostDataModel.addedAttributes = {
        for (final attr in listAttributes)
          '${attr.id}': attr.attributes.isNotEmpty
              ? (attr.attributes
                      .firstWhere((childAttr) => childAttr.isDefault == 1)
                      .id
                      ?.toString() ??
                  '')
              : '',
      };

      /// if creating new product
      if (widget.productID.isNotEmpty && widget.productVariationsID == null) {
        variationPostDataModel.addedAttributes =
            _finalAttributesDataForCreateVariation;
      }

      final List<String> serverImages = selectedImages
              ?.where((e) => e.serverUrl.isNotEmpty)
              .map((e) => e.serverUrl)
              .toList() ??
          [];
      variationPostDataModel.images = serverImages;
      variationPostDataModel.productFilesExternal = selectedDigitalLinks
              ?.where((test) => test.isSaved == false)
              .toList() ??
          [];
      variationPostDataModel.productFilesInput = selectedDigitalImages;
      variationPostDataModel.generateLicenseCode =
          _generateLicenseCode ? '1' : '0';
      variationPostDataModel.autoGenerateSku = _authGenerateSku ? '1' : '0';

      /// **** assign values to post data model start ****
      void logFormData(FormData formData) {
        for (final field in formData.fields) {
          print('Field: ${field.key} = ${field.value}');
        }
        for (final file in formData.files) {
          print('File: ${file.key} = ${file.value.filename}');
        }
      }

      // Usage:
      final formData = variationPostDataModel.toVariationFormData();
      logFormData(formData);

      /// update variation
      if (widget.productVariationsID != null) {
        print(
            '********************** Inside Update variation *************************');
        final updateProductVariationProvider =
            context.read<VendorCreateUpdateVariationViewModel>();
        final result =
            await updateProductVariationProvider.vendorUpdateProductVariation(
                context: context,
                variationID: widget.productVariationsID!,
                productPostDataModel: variationPostDataModel);
        if (result) {
          await _onRefresh();
          context.read<VendorGetProductVariationsViewModel>().clearList();
          context
              .read<VendorGetProductVariationsViewModel>()
              .vendorGetProductVariations(productID: widget.productID);
        }
      } else {
        print(
            '********************** Inside Create variation *************************');
        final createVariationProvider =
            context.read<VendorCreateUpdateVariationViewModel>();
        final result =
            await createVariationProvider.vendorCreateProductVariation(
                context: context,
                productID: widget.productID,
                productPostDataModel: variationPostDataModel);
        if (result) {
          context.read<VendorGetProductVariationsViewModel>().clearList();
          context
              .read<VendorGetProductVariationsViewModel>()
              .vendorGetProductVariations(productID: widget.productID);
        }
      }
    } catch (e) {
      print('Error inside create update function: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _return();
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: VendorModifySectionsAppBar(
          title: 'Edit Variations (${widget.productVariationsID})',
          onGoBack: _return,
        ),
        body: Utils.modelProgressHud(
          processing: _isProcessing,
          child: Utils.pageRefreshIndicator(
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  // Main UI
                  _buildUi(context),

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
                          Row(
                            children: [
                              /// close button
                              Flexible(
                                flex: 1,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8.0),
                                    child: CustomAppButton(
                                      borderRadius: 4,
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      buttonText: 'Close',
                                      borderColor: Colors.black,
                                      buttonColor: Colors.transparent,
                                      onTap: () async {
                                        _return();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              /// save button
                              Flexible(
                                flex: 1,
                                child: Container(
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8.0),
                                    child: CustomAppButton(
                                      borderRadius: 4,
                                      buttonText: 'Save',
                                      buttonColor: AppColors.lightCoral,
                                      onTap: () async {
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          _createUpdateVariation();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onRefresh: _onRefresh,
          ),
        ),
      ),
    );
  }

  Widget _buildUi(BuildContext context) =>
      Consumer<VendorCreateProductViewModel>(
        builder: (context, provider, _) {
          final ApiStatus? apiStatus =
              provider.editVariationsApiResponse.status;
          final isDigital = provider.editVariationsApiResponse.data?.data
                  ?.product.productType.value
                  ?.toLowerCase() ==
              VendorProductType.digital.name.toLowerCase();

          /// set variation product type in model
          variationPostDataModel.productType = isDigital
              ? ProductTypeConstants.DIGITAL
              : ProductTypeConstants.PHYSICAL;

          if (apiStatus == ApiStatus.LOADING && listAttributes.isEmpty) {
            return Utils.pageLoadingIndicator(context: context);
          }

          if (apiStatus == ApiStatus.ERROR) {
            return ListView(
              children: [
                Utils.somethingWentWrong(),
              ],
            );
          }

          return Padding(
            padding: EdgeInsets.only(
                left: kPadding, right: kPadding, bottom: kLargePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kFormFieldSpace,
                kSmallSpace,
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.productVariationsID == null &&
                            widget.productID.isNotEmpty) ...{
                          _buildCreateVariationAttributes(),
                        },

                        _buildAttributes(list: listAttributes),
                        kSmallSpace,
                        if (isDigital) ...{
                          CustomCheckboxWithTitle(
                            isChecked: _generateLicenseCode,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _generateLicenseCode = value;
                                  variationPostDataModel.generateLicenseCode =
                                      _generateLicenseCode ? '1' : '0';
                                });
                              }
                            },
                            title:
                                'Generate license code after purchasing this product?',
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        },
                        _overviewSection(
                            overview: overview, provider: provider),

                        /// auto generate sku
                        if (overviewModel?.sku == null ||
                            overviewModel?.sku.isEmpty == true)
                          CustomCheckboxWithTitle(
                            isChecked: _authGenerateSku,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _authGenerateSku = value;
                                  variationPostDataModel.autoGenerateSku =
                                      _authGenerateSku ? '1' : '0';
                                });
                              }
                            },
                            title: 'Auto generate SKU?',
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),

                        /// shipping
                        if (widget.productVariationsID == null &&
                            widget.productID.isNotEmpty) ...{
                          _shippingSection(context: context),
                        },

                        kSmallSpace,
                        _imagesSection(),
                        kSmallSpace,
                        if (isDigital) ...{
                          _digitalAttachments(),
                          kSmallSpace,
                        },
                        if (isDigital) ...{
                          _digitalAttachmentsLinks(),
                          kSmallSpace,
                        },
                      ],
                    ),
                  ),
                ),
                kExtraLargeSpace,
              ],
            ),
          );
        },
      );

  Widget _buildCreateVariationAttributes() => Column(
        children: _selectedAttributesSet
            .map(
              (attribute) => Column(
                children: [
                  fieldTitle(
                    text: attribute.title.toString(),
                    required: true,
                  ),
                  CustomDropdown(
                    validator: Validator.fieldCannotBeEmpty,
                    textStyle: const TextStyle(color: Colors.black),
                    menuItemsList: attribute.attributes
                        .map(
                          (elements) => DropdownMenuItem(
                            value: elements.id.toString(),
                            child: Text(
                              elements.title,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      print(value.toString());
                      _finalAttributesDataForCreateVariation
                          .addAll({attribute.id.toString(): value.toString()});
                      print(_finalAttributesDataForCreateVariation);
                    },
                  ),
                  kFormFieldSpace,
                ],
              ),
            )
            .toList(),
      );

  Widget _buildAttributes({required List<ProductAttributeSet> list}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...list.map(
            (variation) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kSmallSpace,

                /// **Label Above Dropdown**
                Text(
                  variation.title, // Null safety check
                  style: headingFields()
                      .copyWith(fontSize: 13, fontWeight: FontWeight.w400),
                ),

                /// **Dropdown**
                CustomDropdown(
                  hintText: 'Select Attribute Value',
                  value: variation.attributes.isNotEmpty
                      ? variation.attributes.firstWhere(
                          (x) => x.isDefault.toString() == '1',
                          orElse: () => variation
                              .attributes.first, // Provide a fallback value
                        )
                      : null,
                  textStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                  menuItemsList: variation.attributes
                      .map(
                        (val) => DropdownMenuItem(
                          value: val,
                          child: Text(val.title ?? ''),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    print('value $value');
                    if (value is EditAttributeData) {
                      print('selected attribute');
                      for (final item in listAttributes) {
                        for (final attr in item.attributes) {
                          if (attr.id == value.id) {
                            attr.isDefault = 1;
                          } else {
                            attr.isDefault = 0;
                          }
                        }
                      }

                      for (final item in listAttributes) {
                        for (final attr in item.attributes) {
                          print(
                              'Updated Attribute ID: ${attr.id}, isDefault: ${attr.isDefault}');
                        }
                      }
                      setState(() {});
                    }
                  },
                ),

                kExtraSmallSpace,
              ],
            ),
          ),
        ],
      );

  /// overview section
  Widget _overviewSection(
          {required VariationProduct? overview,
          required VendorCreateProductViewModel provider}) =>
      Column(
        children: [
          TitleWithArrow(
            title: 'Overview',
            textStyle: createProductTextStyle(),
            onTap: () async {
              try {
                await showOverviewDetails(overview: overview);
              } catch (e) {
                print('Error: $e');
              }
            },
          ),
          if (overviewModel != null)
            SimpleCard(
              expandedContentPadding: EdgeInsets.symmetric(
                  horizontal: kMediumPadding, vertical: kExtraSmallPadding),
              expandedContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align the content to the left
                children: [
                  showDetail(label: 'Sku', value: overviewModel?.sku),
                  showDetail(label: 'Price', value: overviewModel?.price),
                  showDetail(
                      label: 'Sale Price', value: overviewModel?.priceSale),
                  if (overviewModel?.chooseDiscountPeriod ?? false)
                    Column(
                      children: [
                        showDetail(
                            label: 'From', value: overviewModel?.fromDate),
                        showDetail(label: 'To', value: overviewModel?.toDate),
                      ],
                    ),
                  showDetail(
                      label: 'Cost per item',
                      value: overviewModel?.costPerItem),
                  showDetail(label: 'Barcode', value: overviewModel?.barcode),
                  if (overviewModel?.withWareHouseManagement ?? false)
                    showDetail(
                        label: 'Quantity', value: overviewModel?.quantity),
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

  void _handleOverViewData(VendorProductOverviewModel? result) {
    // if (result != null) {
    overviewModel = result;
    variationPostDataModel.sku = overviewModel?.sku ??
        context
            .read<VendorCreateProductViewModel>()
            .generalSettingsApiResponse
            .data
            ?.data
            ?.sku
            ?.toString() ??
        '';
    variationPostDataModel.price = overviewModel?.price ?? '0';
    variationPostDataModel.salePrice = overviewModel?.priceSale ?? '0';
    variationPostDataModel.startDate = overviewModel?.fromDate ?? '';
    variationPostDataModel.endDate = overviewModel?.toDate ?? '';
    variationPostDataModel.costPerItem = overviewModel?.costPerItem ?? '0';
    variationPostDataModel.barcode = overviewModel?.barcode ?? '';
    variationPostDataModel.withStorehouseManagement =
        overviewModel?.withWareHouseManagement ?? false ? '1' : '0';
    variationPostDataModel.allowCheckoutWhenOutOfStock =
        overviewModel?.allowCustomerCheckoutWhenProductIsOutOfStock ?? false
            ? '1'
            : '0';
    variationPostDataModel.quantity =
        overviewModel?.withWareHouseManagement ?? false
            ? overviewModel?.quantity ?? '0'
            : '0';
    variationPostDataModel.stockStatus =
        overviewModel?.stockStatus ?? 'in_stock';
    // }
    setState(() {});
  }

  /// *------------------------ shipping section start ------------------------***
  VendorProductDimensionsModel? vendorProductDimensionsModel;

  Future _openShippingSection() async {
    vendorProductDimensionsModel = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => VendorProductShippingView(
            vendorProductDimensionsModel: vendorProductDimensionsModel),
      ),
    );

    _handleShippingData(vendorProductDimensionsModel);
    setState(() {});
  }

  void _handleShippingData(vendorProductDimensionsModel) {
    if (vendorProductDimensionsModel != null) {
      variationPostDataModel.weight =
          vendorProductDimensionsModel?.weight ?? '';
      variationPostDataModel.length =
          vendorProductDimensionsModel?.length ?? '';
      variationPostDataModel.wide = vendorProductDimensionsModel?.width ?? '';
      variationPostDataModel.height =
          vendorProductDimensionsModel?.height ?? '';
    }
  }

  /// shipping section for create product only
  Widget _shippingSection({required BuildContext context}) => Column(
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
                  horizontal: kMediumPadding, vertical: kExtraSmallPadding),
              expandedContent: Column(
                children: [
                  showDetail(
                      label: 'Weight (g)',
                      value: vendorProductDimensionsModel?.weight),
                  showDetail(
                      label: 'Length (cm)',
                      value: vendorProductDimensionsModel?.length),
                  showDetail(
                      label: 'Width (cm)',
                      value: vendorProductDimensionsModel?.width),
                  showDetail(
                      label: 'Height (cm)',
                      value: vendorProductDimensionsModel?.height),
                ],
              ),
            ),
        ],
      );

  /// *------------------------ shipping section end ------------------------***

  /// Upload images
  Widget _imagesSection() => Column(
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

  /// For Digital Product
  Widget _digitalAttachments() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithArrow(
            title: 'Digital Attachments',
            textStyle: createProductTextStyle(),
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
  Widget _digitalAttachmentsLinks() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithArrow(
            title: 'Digital Attachment Links',
            textStyle: createProductTextStyle(),
            onTap: _openDigitalLinksScreen,
          ),
          if (selectedDigitalLinks?.isNotEmpty == true)
            TextFormField(
              controller: _digitalLinksCountController,
              readOnly: true, // Prevent manual input
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon:
                    Icon(Icons.attach_file, color: AppColors.lightCoral),
              ),
              onTap: _openDigitalLinksScreen,
            ),
        ],
      );

  Future<void> _openDigitalPickerScreen() async {
    final List<UploadImagesModel>? images = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DigitalAttachmentsScreen(
          initialImages: selectedDigitalImages,
        ),
      ),
    );

    if (images != null) {
      final List<String> serverImages = images
          .where((e) => e.serverUrl.isNotEmpty)
          .map((e) => e.serverUrl)
          .toList();
      print('Selected Digital Images: $serverImages');
    } else {}

    setState(() {
      selectedDigitalImages = images;
      for (final e in selectedDigitalImages ?? []) {
        print(e);
      }
      _updateDigitalImageCount();
    });
  }

  Future<void> _openDigitalLinksScreen() async {
    final List<DigitalLinksModel>? links = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DigitalLinksScreen(
          initialLinks: selectedDigitalLinks,
        ),
      ),
    );

    if (links != null) {
      // List<String> serverImages = links.where((e) => e.serverUrl.isNotEmpty).map((e) => e.serverUrl).toList();
      // print('Selected Digital Links: $serverImages');
    } else {}

    setState(() {
      selectedDigitalLinks = links;
      for (final e in selectedDigitalLinks ?? []) {
        print(e.toString());
      }
      _updateDigitalLinksCount();
    });
  }

  Future<void> _openImagePickerScreen() async {
    final List<UploadImagesModel>? images = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadImagesScreen(
          initialImages: selectedImages,
        ),
      ),
    );

    if (images != null) {
      final List<String> serverImages = images
          .where((e) => e.serverUrl.isNotEmpty)
          .map((e) => e.serverUrl)
          .toList();
      print('Selected Server Images: $serverImages');
    } else {}

    setState(() {
      selectedImages = images;
      _updateImageCount();
    });
  }

  void _updateImageCount() {
    if (selectedImages != null) {
      _imageCountController.text = selectedImages!.isNotEmpty
          ? '${selectedImages?.length} image(s) selected'
          : 'No images selected';
    } else {
      _imageCountController.clear();
    }
  }

  void _updateDigitalImageCount() {
    if (selectedDigitalImages != null) {
      _digitalImageCountController.text = selectedDigitalImages!.isNotEmpty
          ? '${selectedDigitalImages?.length} attachment(s) selected'
          : 'No attachments selected';
    } else {
      _digitalImageCountController.clear();
    }
  }

  void _updateDigitalLinksCount() {
    if (selectedDigitalLinks != null) {
      _digitalLinksCountController.text = selectedDigitalLinks!.isNotEmpty
          ? '${selectedDigitalLinks?.length} link(s) added'
          : 'No links added';
    } else {
      _digitalLinksCountController.clear();
    }
  }

  Future<void> showOverviewDetails(
      {required VariationProduct? overview}) async {
    // overviewModel = VendorProductOverviewModel(
    //   sku: overview?.sku ?? '',
    //   price: overview?.price.toString() ?? '',
    //   priceSale: overview?.salePrice?.toString() ?? '',
    //   chooseDiscountPeriod:
    //       ((overview?.startDate?.toString().isNotEmpty ?? false) &&
    //           (overview?.endDate?.toString().isNotEmpty ?? false)),
    //   fromDate: overview?.startDate?.toString() ?? '',
    //   toDate: overview?.endDate?.toString() ?? '',
    //   costPerItem: overview?.costPerItem.toString() ?? '',
    //   barcode: '',
    //   withWareHouseManagement:
    //       overview?.withStorehouseManagement.toString() == '1',
    //   quantity: overview?.quantity?.toString() ?? '0',
    //   allowCustomerCheckoutWhenProductIsOutOfStock:
    //       overview?.allowCheckoutWhenOutOfStock.toString() == '1',
    //   stockStatus: overview?.stockStatus?.value.toString() ?? 'in_stock',
    // );

    final result = await showDraggableModalBottomSheet(
      context: context,
      builder: (scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.13,
                height: 5,
                margin: const EdgeInsets.only(top: 8.0),
                // Replace `kSmallPadding`
                decoration: BoxDecoration(
                  color: AppColors.lightCoral,
                  // Replace with `AppColors.lightCoral`
                  borderRadius:
                      BorderRadius.circular(8.0), // Replace `kSmallCardRadius`
                ),
              ),
            ),
            VendorProductOverviewView(
              overviewModel: overviewModel,
              productType: ProductTypeConstants.PHYSICAL,
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      overviewModel = result;
    }
    setState(() {});
  }
}
