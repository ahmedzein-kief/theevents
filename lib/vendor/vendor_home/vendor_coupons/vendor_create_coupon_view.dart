import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/vendor/components/app_bars/vendor_common_app_bar.dart';
import 'package:event_app/vendor/components/buttons/custom_action_button.dart';
import 'package:event_app/vendor/components/checkboxes/custom_checkboxes.dart';
import 'package:event_app/vendor/components/date_time_picker/date_time_picker.dart';
import 'package:event_app/vendor/components/dropdowns/custom_dropdown.dart';
import 'package:event_app/vendor/components/settings_components/simple_card.dart';
import 'package:event_app/vendor/components/text_fields/custom_date_time_picker_field.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/vendor_home/vendor_coupons/coupon_view_utils.dart';
import 'package:event_app/vendor/view_models/vendor_coupons/vendor_create_coupon_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_coupons/vendor_generate_coupon_code_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_coupons/vendor_get_coupons_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VendorCreateCouponView extends StatefulWidget {
  const VendorCreateCouponView({super.key});

  @override
  State<VendorCreateCouponView> createState() => _VendorCreateCouponViewState();
}

class _VendorCreateCouponViewState extends State<VendorCreateCouponView>
    with MediaQueryMixin {
  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// controllers and focus nodes
  final TextEditingController _couponCodeController = TextEditingController();
  final TextEditingController _couponNameController = TextEditingController();
  final TextEditingController _numberOfCouponsController =
      TextEditingController();
  final TextEditingController _couponTypeController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  /// state variable to observe new coupon code generation process
  bool isGeneratingCoupon = false;

  /// is creating unlimited coupons
  bool isUnlimitedCoupon = true;

  /// display coupon code at checkout
  bool isCouponCodeVisible = false;

  /// Never expires
  bool isNeverExpired = true;

  /// coupon Type
  CouponType couponType = CouponType.amount;

  void setCouponType(couponType) {
    setState(() {
      this.couponType = couponType;
    });
  }

  bool _isProcessing = false;

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  @override
  void initState() {
    super.initState();
    // Get the current date and time
    final DateTime now = DateTime.now();
    // Format the date and time
    final String formattedDate =
        DateFormat('yyyy-MM-dd').format(now); // e.g., "2025/01/27"
    final String formattedTime =
        DateFormat('HH:mm').format(now); // e.g., "14:30"

    // Assign the values to the controllers
    _startDateController.text = formattedDate;
    _startTimeController.text = formattedTime;
    _endDateController.text = formattedDate;
    _endTimeController.text = formattedTime;
    couponType = CouponType.amount;
  }

  @override
  void dispose() {
    // Dispose of all TextEditingControllers
    _couponCodeController.dispose();
    _couponNameController.dispose();
    _numberOfCouponsController.dispose();
    _couponTypeController.dispose();
    _discountController.dispose();
    _startDateController.dispose();
    _startTimeController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();

    super.dispose(); // Always call super.dispose()
  }

  /// Method to generate Coupon code
  Future<void> _generateCouponCode(
      VendorGenerateCouponCodeViewModel provider) async {
    try {
      setProcessing(true);
      await provider.vendorGenerateCouponCode();
      if (provider.apiResponse.status == ApiStatus.COMPLETED) {
        _couponCodeController.text =
            provider.apiResponse.data?.data.toString() ?? '';
      }
      setProcessing(false);
    } catch (e) {
      setProcessing(false);
      _couponCodeController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const VendorCommonAppBar(title: 'Coupons'),
        body: Utils.modelProgressHud(
            processing: _isProcessing, child: _buildUi(context)),
        backgroundColor: AppColors.bgColor,
      );

  Widget _buildUi(context) => Padding(
        padding: EdgeInsets.all(kSmallPadding),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// Basic Information
                SimpleCard(
                  expandedContent: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Generate coupon code
                      ChangeNotifierProvider(
                        create: (context) =>
                            VendorGenerateCouponCodeViewModel(),
                        child: Consumer<VendorGenerateCouponCodeViewModel>(
                          builder: (context, provider, _) =>
                              CustomTextFormField(
                            labelText: 'Create Coupon Code',
                            labelTextStyle:
                                CouponViewUtils.couponLabelTextStyle(),
                            required: true,
                            hintText: '',
                            borderRadius: 4,
                            controller: _couponCodeController,
                            validator: Validator.fieldCannotBeEmpty,
                            suffix: CustomActionButton(
                              isLoading: provider.apiResponse.status ==
                                  ApiStatus.LOADING,
                              name: 'Generate Coupon Code',
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: AppColors.lightCoral, // Default color
                              ),
                              onPressed: () async {
                                await _generateCouponCode(provider);
                              },
                            ),
                          ),
                        ),
                      ),

                      /// short description of coupon code use
                      Text(
                        'Customers will enter this coupon code when they checkout',
                        style: subtitleTextStyle(context),
                        textAlign: TextAlign.start,
                      ),
                      kFormFieldSpace,

                      /// Coupon name
                      CustomTextFormField(
                        labelText: 'Coupon Name',
                        showTitle: false,
                        required: false,
                        validator: Validator.fieldCannotBeEmpty,
                        borderRadius: 4,
                        hintText: 'Enter Coupon name',
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                        controller: _couponNameController,
                      ),
                      kSmallSpace,

                      /// is unlimited coupon
                      CustomCheckboxWithTitle(
                        isChecked: isUnlimitedCoupon,
                        title: 'Unlimited coupon?',
                        onChanged: (value) {
                          setState(() {
                            isUnlimitedCoupon = value ?? false;

                            /// setting and clearing the values
                            if (isUnlimitedCoupon) {
                              _numberOfCouponsController.clear();
                            } else {
                              _numberOfCouponsController.text = '1';
                            }
                          });
                        },
                      ),
                      // kFormFieldSpace,

                      /// show text field to get the number of coupons as input
                      if (!isUnlimitedCoupon)
                        Column(
                          children: [
                            kSmallSpace,
                            CustomTextFormField(
                              labelText: 'Enter Number',
                              labelTextStyle:
                                  CouponViewUtils.couponLabelTextStyle(),
                              required: !isUnlimitedCoupon,
                              showTitle: true,
                              keyboardType: TextInputType.number,
                              borderRadius: 4,
                              validator: Validator.validateNumberOfCoupons,
                              hintText: 'Enter Number of Coupons',
                              controller: _numberOfCouponsController,
                            ),
                            kSmallSpace,
                          ],
                        ),

                      /// Display coupon code at the checkout page ?
                      CustomCheckboxWithTitle(
                        isChecked: isCouponCodeVisible,
                        title: 'Display coupon code at the checkout page?',
                        subTitle:
                            'The list of coupon codes will be displayed at the checkout page and customers can choose to apply.',
                        onChanged: (value) {
                          setState(() {
                            isCouponCodeVisible = value ?? false;
                          });
                        },
                      ),
                      kFormFieldSpace,

                      /// Vertical Divider
                      const Divider(
                        color: AppColors.softBlueGrey,
                        thickness: 1,
                      ),
                      kFormFieldSpace,

                      /// Select Coupon Type
                      fieldTitle(text: 'Coupon type'),
                      kExtraSmallSpace,
                      CustomDropdown(
                        menuItemsList: CouponViewUtils.couponTypeMenuItems(),
                        textColor: AppColors.stoneGray,
                        textStyle: CouponViewUtils.couponLabelTextStyle()
                            .copyWith(color: AppColors.stoneGray),
                        hintText: 'Select Coupon type',
                        borderRadius: 4,
                        value: couponType,
                        onChanged: (value) {
                          setCouponType(value);
                          _couponTypeController.text =
                              CouponViewUtils.getTypeOption(couponType);
                        },
                      ),
                      kFormFieldSpace,

                      /// Enter Discount
                      CustomTextFormField(
                        labelText: 'Discount',
                        labelTextStyle: CouponViewUtils.couponLabelTextStyle(),
                        showTitle: false,
                        required: true,
                        validator: Validator.validateDiscountOfCoupons,
                        hintText: '',
                        borderRadius: 4,
                        prefix: CouponViewUtils.discountFieldPrefixAndSuffix(
                            couponType: couponType,
                            isPrefix: true,
                            screenWidth: screenWidth),
                        suffix: CouponViewUtils.discountFieldPrefixAndSuffix(
                            couponType: couponType,
                            isPrefix: false,
                            screenWidth: screenWidth),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        controller: _discountController,
                      ),
                      kFormFieldSpace,
                    ],
                  ),
                ),
                kFormFieldSpace,

                /// **********************************************************************************************************

                /// Time
                SimpleCard(
                  expandedContentPadding: EdgeInsets.zero,
                  expandedContent: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: kPadding,
                            right: kPadding,
                            top: kPadding,
                            bottom: kSmallPadding),
                        child: Text(
                          'Time',
                          style: CouponViewUtils.couponLabelTextStyle(),
                        ),
                      ),

                      const Divider(
                        color: AppColors.softBlueGrey,
                      ),

                      /// other things
                      Padding(
                        padding: EdgeInsets.all(kPadding),
                        child: Column(
                          children: [
                            /// Start Date and time
                            fieldTitle(
                                text: 'Start Date',
                                textStyle:
                                    CouponViewUtils.couponLabelTextStyle()),
                            kSmallSpace,
                            CustomDateTimePickerField(
                              date: _startDateController,
                              time: _startTimeController,
                              readOnly: false,
                              onDateTap: () => showCupertinoDateTimePicker(
                                context: context,
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (date) {
                                  setState(() {
                                    _startDateController.text =
                                        DateFormat('yyyy-MM-dd').format(date);
                                  });
                                },
                              ),
                              onTimeTap: () => showCupertinoDateTimePicker(
                                context: context,
                                mode: CupertinoDatePickerMode.time,
                                onDateTimeChanged: (time) {
                                  setState(() {
                                    _startTimeController.text =
                                        DateFormat('HH:mm').format(time);
                                  });
                                },
                              ),
                            ),
                            kFormFieldSpace,

                            // End Date and time
                            fieldTitle(
                                text: 'End Date',
                                textStyle:
                                    CouponViewUtils.couponLabelTextStyle()),
                            kSmallSpace,
                            CustomDateTimePickerField(
                              date: _endDateController,
                              time: _endTimeController,
                              readOnly: isNeverExpired,
                              onDateTap: () => showCupertinoDateTimePicker(
                                context: context,
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (date) {
                                  setState(() {
                                    _endDateController.text =
                                        DateFormat('yyyy-MM-dd').format(date);
                                  });
                                },
                              ),
                              onTimeTap: () => showCupertinoDateTimePicker(
                                context: context,
                                mode: CupertinoDatePickerMode.time,
                                onDateTimeChanged: (time) {
                                  setState(() {
                                    _endTimeController.text =
                                        DateFormat('HH:mm').format(time);
                                  });
                                },
                              ),
                            ),

                            /// Is Expire Date required
                            CustomCheckboxWithTitle(
                              isChecked: isNeverExpired,
                              title: 'Never Expired?',
                              titleStyle:
                                  CouponViewUtils.couponLabelTextStyle(),
                              onChanged: (value) {
                                setState(() {
                                  isNeverExpired = value ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// **********************************************************************************************************
                kFormFieldSpace,

                /// Save and cancel Button
                SimpleCard(
                  expandedContentPadding: EdgeInsets.all(kSmallPadding),
                  expandedContent: Row(
                    children: [
                      ChangeNotifierProvider(
                        create: (context) => VendorCreateCouponViewModel(),
                        child: Consumer<VendorCreateCouponViewModel>(
                          builder: (context, provider, _) => CustomAppButton(
                            buttonText: 'Save',
                            mainAxisSize: MainAxisSize.min,
                            borderRadius: kSmallButtonRadius,
                            buttonColor: AppColors.lightCoral,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth / 20, vertical: 5),
                            isLoading: provider.apiResponse.status ==
                                ApiStatus.LOADING,
                            onTap: () async {
                              /// We have to refresh the coupons list so clear list and call the coupons api again
                              try {
                                setProcessing(true);
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _creteForm();
                                  await provider.vendorCreateCoupon(
                                      form: form, context: context);
                                  // setProcessing(false);

                                  /// Calling the get vendor coupons api
                                  final getCouponsProvider =
                                      Provider.of<VendorGetCouponsViewModel>(
                                          context,
                                          listen: false);
                                  getCouponsProvider.clearList();
                                  getCouponsProvider.vendorGetCoupons();
                                  setProcessing(false);
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                setProcessing(false);
                              }
                              setProcessing(false);
                            },
                          ),
                        ),
                      ),
                      kSmallSpace,
                      CustomAppButton(
                        buttonText: 'Cancel',
                        textStyle: CouponViewUtils.couponLabelTextStyle(),
                        mainAxisSize: MainAxisSize.min,
                        borderRadius: kSmallButtonRadius,
                        buttonColor: Colors.transparent,
                        borderColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth / 20, vertical: 5),
                        onTap: () {
                          /// Simply Go back
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  dynamic form = {};

  void _creteForm() {
    form = {
      'code': _couponCodeController.text,
      'title': _couponNameController.text,
      'is_unlimited': isUnlimitedCoupon ? 1 : 0,
      if (!isUnlimitedCoupon) 'quantity': _numberOfCouponsController.text,
      'display_at_checkout': isCouponCodeVisible ? 1 : 0,
      'type_option': CouponViewUtils.getTypeOption(couponType),
      'value': _discountController.text,
      'start_date': _startDateController.text,
      'start_time': _startTimeController.text,
      'unlimited_time': isNeverExpired ? 1 : 0,
      if (!isNeverExpired) 'end_date': _endDateController.text,
      if (!isNeverExpired) 'end_time': _endTimeController.text,
    };
  }
}
