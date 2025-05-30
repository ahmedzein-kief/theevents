import 'package:event_app/models/vendor_models/products/create_product/product_overview_model.dart';
import 'package:event_app/models/vendor_models/products/vendor_get_product_general_settings_model.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/utils/mixins_and_constants/media_query_mixin.dart';
import 'package:event_app/utils/validator/validator.dart';
import 'package:event_app/vendor/components/checkboxes/custom_checkboxes.dart';
import 'package:event_app/vendor/components/date_time_picker/date_time_picker.dart';
import 'package:event_app/vendor/components/radio_buttons/custom_radio_button.dart';
import 'package:event_app/vendor/components/status_constants/product_type_constants.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/view_models/vendor_packages/create_package/vendor_get_package_general_settings_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VendorProductOverviewView extends StatefulWidget {
  final String productType;
  final VendorProductOverviewModel? overviewModel;

  VendorProductOverviewView({this.overviewModel, required this.productType});

  @override
  _VendorProductOverviewViewState createState() => _VendorProductOverviewViewState();
}

class _VendorProductOverviewViewState extends State<VendorProductOverviewView> with MediaQueryMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///controllers
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(text: '0');
  final TextEditingController _priceSaleController = TextEditingController(text: '0');
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _costPerItemController = TextEditingController(text: '0');
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '0');
  final TextEditingController _stockStatusController = TextEditingController();
  final TextEditingController _defaultDiscountController = TextEditingController();
  final TextEditingController _showCurrentAppliedDiscountController = TextEditingController();

  bool _chooseDiscountPeriod = false;
  bool _withWareHouseManagement = false;
  bool _allowCustomerCheckoutWhenProductIsOutOfStock = false;

  /// focus nodes
  final FocusNode _skuFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _priceSaleFocusNode = FocusNode();
  final FocusNode _fromDateFocusNode = FocusNode();
  final FocusNode _toDateFocusNode = FocusNode();
  final FocusNode _costPerItemFocusNode = FocusNode();
  final FocusNode _barcodeFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();

  /// error text
  String? startDateErrorText;
  String? endDateErrorText;
  String? salePriceErrorText;

  /// validate dates
  void validateDateAndAssignErrors(String? startDate, String? endDate) {
    // Reset previous errors
    startDateErrorText = null;
    endDateErrorText = null;
    setState(() {});

    // If either field is empty, skip validation
    if (startDate == null || startDate.isEmpty || endDate == null || endDate.isEmpty) {
      return;
    }

    try {
      // Parse dates
      DateTime start = DateTime.parse(startDate);
      DateTime end = DateTime.parse(endDate);

      // Check if start date is after end date
      if (start.isAfter(end)) {
        startDateErrorText = "Start date cannot be after end date.";
        endDateErrorText = "End date must be after start date.";
        setState(() {});
      }
      if (start.isAtSameMomentAs(end)) {
        setState(() {
          endDateErrorText = "End date must be after start date.";
        });
      } else {
        setState(() {
          endDateErrorText = null; // Clear error if dates are valid
        });
      }
    } catch (e) {
      startDateErrorText = "Invalid date format.";
      endDateErrorText = "Invalid date format.";
    }
  }

  /// validate sale price
  String? validateSalePrice({
    required TextEditingController priceController,
    required TextEditingController salePriceController,
    required TextEditingController discountController,
  }) {
    try {
      // Parse values safely from controllers
      double price = double.tryParse(priceController.text.trim()) ?? 0;
      double salePrice = double.tryParse(salePriceController.text.trim()) ?? 0;
      double defaultDiscount = double.tryParse(discountController.text.trim()) ?? 0;

      String? errorText;

      // Rule 1: Sale price cannot be greater than price
      if (salePrice > price) {
        errorText = "Sale price cannot be greater than the original price.";
      }

      // Rule 2: If price is 0, sale price must also be 0
      if (price == 0 && salePrice != 0) {
        errorText = "Since the original price is 0, sale price must also be 0.";
      }

      // Rule 3: If price is not zero, sale price cannot be zero
      if (price != 0 && salePrice == 0) {
        salePriceController.text = price.toStringAsFixed(2); // Assign price to sale price
      }

      // Rule 4: If default discount is not 0, enforce minimum sale price
      if (defaultDiscount > 0) {
        double minAllowedPrice = price - (price * (defaultDiscount / 100));
        if (salePrice < minAllowedPrice) {
          errorText = "Sale price cannot be less than $minAllowedPrice after applying the ${defaultDiscount}% default discount.";
        }
      }

      setState(() {});
      return errorText; // Return error text (null if no errors)
    } catch (e) {
      return "Invalid input. Please enter valid numeric values.";
    }
  }

  /// calculates the discount percentage
  double calculateDiscountPercentage(String priceStr, String salePriceStr) {
    try {
      // Convert input values from String to double
      double price = double.tryParse(priceStr) ?? 0;
      double salePrice = double.tryParse(salePriceStr) ?? 0;

      // If price is 0 or price and sale price are the same, return 0% discount
      if (price == 0 || price == salePrice || salePriceStr.isEmpty) return 0;

      // Calculate discount percentage
      double discountPercentage = ((price - salePrice) / price) * 100;

      // Ensure discount percentage is never negative
      return discountPercentage.clamp(0, 100);
    } catch (e) {
      return 0; // Return 0 if there's an invalid input
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      final overviewModel = widget.overviewModel;

// Assign text field values to controllers with null safety checks
      _skuController.text = overviewModel?.sku != null
          ? overviewModel?.sku ?? ''
          : (widget.productType == ProductTypeConstants.PACKAGE)
              ? context.read<VendorGetPackageGeneralSettingsViewModel>().generalSettingsApiResponse.data?.data?.sku?.toString() ?? ''
              : context.read<VendorCreateProductViewModel>().generalSettingsApiResponse.data?.data?.sku?.toString() ?? '';
      _priceController.text = overviewModel?.price ?? '0';
      _priceSaleController.text = overviewModel?.priceSale ?? '0';
      _defaultDiscountController.text = (widget.productType == ProductTypeConstants.PACKAGE)
          ? context.read<VendorGetPackageGeneralSettingsViewModel>().generalSettingsApiResponse.data?.data?.defaultDiscountPercent.toString() ?? '0'
          : context.read<VendorCreateProductViewModel>().generalSettingsApiResponse.data?.data?.defaultDiscountPercent.toString() ?? '0';
      _fromDateController.text = overviewModel?.fromDate ?? '';
      _toDateController.text = overviewModel?.toDate ?? '';
      _costPerItemController.text = overviewModel?.costPerItem ?? '0';
      _barcodeController.text = overviewModel?.barcode ?? '';
      _quantityController.text = overviewModel?.quantity ?? '0';
      _stockStatusController.text = overviewModel?.stockStatus ?? 'in_stock';

// Assign boolean values to variables with null safety checks
      _chooseDiscountPeriod = overviewModel?.chooseDiscountPeriod ?? false;
      _withWareHouseManagement = overviewModel?.withWareHouseManagement ?? false;
      _allowCustomerCheckoutWhenProductIsOutOfStock = overviewModel?.allowCustomerCheckoutWhenProductIsOutOfStock ?? false;
      setState(() {});
    });
    super.initState();
  }

  void _return() {
    if (mounted) {
      Map<String, dynamic> map = {
        'sku': _skuController.text,
        'price': _priceController.text,
        'priceSale': _priceSaleController.text,
        'chooseDiscountPeriod': _chooseDiscountPeriod,
        'fromDate': _fromDateController.text,
        'toDate': _toDateController.text,
        'costPerItem': _costPerItemController.text,
        'barcode': _barcodeController.text,
        'withWareHouseManagement': _withWareHouseManagement,
        'quantity': _quantityController.text,
        'allowCustomerCheckoutWhenProductIsOutOfStock': _allowCustomerCheckoutWhenProductIsOutOfStock,
        'stockStatus': _stockStatusController.text,
      };

      Navigator.pop(context, VendorProductOverviewModel.fromMap(map));
    }
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.addPostFrameCallback((callback){
    // _return();
    // });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildUi(context);
  }

  Widget _buildUi(BuildContext context) {
    final VendorGetPackageGeneralSettingsViewModel packageGeneralSettings = context.read<VendorGetPackageGeneralSettingsViewModel>();
    final VendorCreateProductViewModel productGeneralSettings = context.read<VendorCreateProductViewModel>();

    /// SETTINGS STOCK STATUS LIST
    final List<StockStatuses> _stockStatuses = widget.productType == ProductTypeConstants.PACKAGE
        ? packageGeneralSettings.generalSettingsApiResponse.data?.data?.stockStatuses ?? []
        : productGeneralSettings.generalSettingsApiResponse.data?.data?.stockStatuses ?? [];
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: kPadding, right: kPadding, top: viewInsets.top, bottom: viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    labelText: "SKU",
                    required: false,
                    hintText: "Enter SKU",
                    focusNode: _skuFocusNode,
                    nextFocusNode: _priceFocusNode,
                    controller: _skuController,
                  ),
                  kFormFieldSpace,

                  /// Price
                  CustomTextFormField(
                    labelText: "Price",
                    required: false,
                    hintText: "Enter Price",
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    prefix: texFieldPrefix(screenWidth: screenWidth, text: 'AED'),
                    focusNode: _priceFocusNode,
                    nextFocusNode: _priceSaleFocusNode,
                    controller: _priceController,
                    onChanged: (value) {
                      setState(() {
                        if (_priceSaleController.text.isNotEmpty) {
                          _showCurrentAppliedDiscountController.text = calculateDiscountPercentage(_priceController.text, _priceSaleController.text).toString();
                        }
                      });
                    },
                  ),
                  kFormFieldSpace,

                  /// Sale Price
                  CustomTextFormField(
                    labelText: "Sale Price",
                    required: false,
                    hintText: "Enter Sale Price",
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    prefix: texFieldPrefix(screenWidth: screenWidth, text: 'AED'),
                    focusNode: _priceSaleFocusNode,
                    nextFocusNode: _fromDateFocusNode,
                    controller: _priceSaleController,
                    errorText: salePriceErrorText,
                    onChanged: (value) {
                      setState(() {
                        _showCurrentAppliedDiscountController.text = calculateDiscountPercentage(_priceController.text, _priceSaleController.text).toString();
                      });
                    },
                  ),

                  /// choose from and to date
                  Wrap(
                    spacing: kPadding,
                    runSpacing: kPadding,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "Discount ",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: TextDecoration.none,
                            )),
                        TextSpan(
                            text: Validator.formatToTwoDecimalPlaces(_showCurrentAppliedDiscountController.text),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            )),
                        TextSpan(
                            text: "% from original price.",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: TextDecoration.none,
                            )),
                      ])),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _fromDateController.clear();
                            _toDateController.clear();
                            _chooseDiscountPeriod = !_chooseDiscountPeriod;

                            /// toggle discount period
                          });
                        },
                        child: Text(
                          _chooseDiscountPeriod ? "Cancel" : "Choose Discount Period",
                          style: TextStyle(color: AppColors.lightCoral, decoration: TextDecoration.none, fontSize: 13),
                        ),
                      )
                    ],
                  ),
                  kSmallSpace,

                  if (_chooseDiscountPeriod)
                    Column(
                      children: [
                        /// From Date
                        CustomTextFormField(
                          labelText: "From Date",
                          required: false,
                          readOnly: true,
                          hintText: "YY-MM-DD HH:mm:ss",
                          // keyboardType: TextInputType.da,
                          focusNode: _fromDateFocusNode,
                          nextFocusNode: _toDateFocusNode,
                          controller: _fromDateController,
                          errorText: startDateErrorText,
                          onTap: () {
                            setState(() {
                              showCupertinoDateTimePicker(
                                  context: context,
                                  onDateTimeChanged: (value) {
                                    startDateErrorText = null;
                                    _fromDateController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(value);
                                  });
                            });
                          },
                        ),
                        kFormFieldSpace,

                        /// To Date
                        CustomTextFormField(
                          labelText: "To Date",
                          required: false,
                          readOnly: true,
                          hintText: "YY-MM-DD HH:mm:ss",
                          keyboardType: TextInputType.datetime,
                          focusNode: _toDateFocusNode,
                          nextFocusNode: _costPerItemFocusNode,
                          controller: _toDateController,
                          errorText: endDateErrorText,
                          onTap: () {
                            setState(() {
                              showCupertinoDateTimePicker(
                                  context: context,
                                  onDateTimeChanged: (value) {
                                    endDateErrorText = null;
                                    _toDateController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(value);
                                  });
                            });
                          },
                        ),
                        kFormFieldSpace,
                      ],
                    ),

                  /// Cost Per Item
                  CustomTextFormField(
                    labelText: "Cost Per Item",
                    required: false,
                    hintText: "Enter Cost Per Item",
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    prefix: texFieldPrefix(screenWidth: screenWidth, text: 'AED'),
                    focusNode: _costPerItemFocusNode,
                    nextFocusNode: _barcodeFocusNode,
                    controller: _costPerItemController,
                  ),
                  Text("Customer won't see this price.",
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                      )),
                  kFormFieldSpace,

                  /// Barcode
                  CustomTextFormField(
                    labelText: "Barcode (ISBN, UPC, GTIN, etc.)",
                    required: false,
                    hintText: "Enter Barcode",
                    focusNode: _barcodeFocusNode,
                    nextFocusNode: _quantityFocusNode,
                    controller: _barcodeController,
                  ),
                  kFormFieldSpace,

                  /// with storehouse management
                  Column(
                    children: [
                      CustomCheckboxWithTitle(
                          isChecked: _withWareHouseManagement,
                          title: "With storehouse management.",
                          onChanged: (value) {
                            setState(() {
                              _withWareHouseManagement = value!;
                              if (value == true) {
                                _quantityController.text = '0';
                                _stockStatusController.text = '';
                              } else {
                                _allowCustomerCheckoutWhenProductIsOutOfStock = false;
                                _stockStatusController.text = 'in_stock';
                              }
                            });
                          }),
                      kMediumSpace,
                    ],
                  ),

                  // show quantity if with storehouse management
                  if (_withWareHouseManagement)
                    Column(
                      children: [
                        /// Quantity
                        CustomTextFormField(
                          labelText: "Quantity",
                          required: false,
                          hintText: "Enter Quantity",
                          keyboardType: TextInputType.number,
                          focusNode: _quantityFocusNode,
                          nextFocusNode: null,
                          // No next focus node as this is the last field
                          controller: _quantityController,
                        ),
                        kMinorSpace,

                        /// Allow customers when item is not available
                        CustomCheckboxWithTitle(
                            isChecked: _allowCustomerCheckoutWhenProductIsOutOfStock,
                            title: "Allow customer checkout when this product is out of stock.",
                            onChanged: (value) {
                              setState(() {
                                _allowCustomerCheckoutWhenProductIsOutOfStock = value!;
                              });
                            }),
                        kFormFieldSpace,
                      ],
                    ),

                  /// stock status
                  if (!_withWareHouseManagement)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        fieldTitle(text: "Stock Status"),
                        Wrap(
                          spacing: screenWidth * 0.01,
                          runSpacing: screenWidth * 0.01,
                          children: _stockStatuses.map((element) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: kExtraSmallPadding),
                                  child: VendorCustomRadioListTile(
                                    value: element.value,
                                    groupValue: _stockStatusController.text,
                                    title: element.label?.toString() ?? '',
                                    onChanged: (value) {
                                      setState(() {
                                        _stockStatusController.text = value;
                                      });
                                    },
                                  ),
                                );
                              }).toList() ??
                              [],
                        ),
                      ],
                    ),
                  kFormFieldSpace,
                  kFormFieldSpace,

                  /// save function
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      kCancelButton(screenWidth: screenWidth, context: context),
                      kFormFieldSpace,
                      SizedBox(
                          width: screenWidth * 0.25,
                          child: CustomAppButton(
                              buttonText: "Save",
                              buttonColor: AppColors.lightCoral,
                              onTap: () {
                                /// validate sale price
                                setState(() {
                                  salePriceErrorText = validateSalePrice(
                                      priceController: _priceController, salePriceController: _priceSaleController, discountController: _defaultDiscountController);
                                });
                                validateDateAndAssignErrors(_fromDateController.text, _toDateController.text);
                                if ((_formKey.currentState?.validate() ?? false) && startDateErrorText == null && endDateErrorText == null && salePriceErrorText == null) {
                                  _return();
                                }
                              })),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}

Widget texFieldPrefix({required dynamic screenWidth, dynamic padding, dynamic text, dynamic textStyle, dynamic onTap, dynamic tooltipMessage}) => Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltipMessage ?? '',
        child: InkResponse(
          onTap: onTap,
          radius: kCardRadius,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: padding ?? EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Text(text, style: textStyle, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
