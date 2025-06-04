import 'dart:developer';

import 'package:event_app/models/checkout_models/checkout_data_models.dart';
import 'package:event_app/views/cart_screens/shipping_address_view_screen.dart';
import 'package:event_app/views/cart_screens/shipping_method_view_screen.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/order_pages_screens/order_page.dart';
import 'package:event_app/views/payment_screens/payment_view_screen.dart';
import 'package:event_app/views/profile_page_screens/terms_and_condtion_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/services/shared_preferences_helper.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_items_views/coupon_text_field.dart';
import '../../core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import '../../provider/checkout_provider/checkout_provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.onNext,
    this.tracked_start_checkout,
    required this.paymentMethod,
  });
  final String? tracked_start_checkout;
  final Map<String, String> paymentMethod;
  final VoidCallback onNext;

  @override
  State<PaymentScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<PaymentScreen> {
  bool _isTermsAccepted = false;
  bool hasTCError = false;
  Map<String, String> initialShippingMethod = {
    'method_id': '3',
    'method_amount': '39.00',
  };
  SessionCheckoutData? sessionCheckoutData;

  Map<String, dynamic> appliedCouponData = {
    'coupon_code': '',
    'is_valid_coupon': false,
    'message': '',
  };

  /// +++++++++++++++++++++++ function checkbox  --------------------------------------
  void _toggleCheckbox(bool? value) {
    setState(() {
      hasTCError = value == false;
      _isTermsAccepted = value!;
    });
  }

  @override
  void initState() {
    fetchData(sessionCheckoutData, initialShippingMethod);
    super.initState();
  }

  Future<bool> fetchData(
    SessionCheckoutData? sessionCheckoutData,
    Map<String, String> shippingMethod,
  ) async {
    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<CheckoutProvider>(context, listen: false);
    return provider.fetchCheckoutData(
      context,
      widget.tracked_start_checkout ?? '',
      token ?? '',
      sessionCheckoutData,
      shippingMethod,
    );
  }

  Future<String?> checkoutPayment(
      CheckoutResponse? checkoutData, Map<String, String> paymentMethod) async {
    if (checkoutData == null) return null;

    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<CheckoutProvider>(context, listen: false);

    setState(() {
      provider.isLoading = true;
    });
    return provider.checkoutPaymentLink(
      context,
      widget.tracked_start_checkout ?? '',
      token ?? '',
      checkoutData,
      paymentMethod,
    );
  }

  Future<bool> applyRemoveCouponCode(String couponCode, bool isApply) async {
    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<CheckoutProvider>(context, listen: false);

    setState(() {
      provider.isLoading = true;
    });
    return provider.applyRemoveCouponCode(
      context,
      widget.tracked_start_checkout ?? '',
      token ?? '',
      couponCode,
      isApply,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        fetchData(sessionCheckoutData, initialShippingMethod);
      },
      child: Consumer<CheckoutProvider>(
        builder:
            (BuildContext context, CheckoutProvider provider, Widget? child) {
          sessionCheckoutData =
              provider.checkoutData?.data?.sessionCheckoutData;
          if (provider.isLoading) {
            return const Center(
              child: SizedBox(
                width: 50, // Set the desired width
                height: 50, // Set the desired height
                child: CircularProgressIndicator(color: Colors.black),
              ),
            );
          }

          return Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PaymentConfirmText(),
                        ShippingMethodViewScreen(
                          shippingMethod: initialShippingMethod,
                          onSelectShippingMethod:
                              (Map<String, String> shippingMethod) async {
                            setState(() {
                              initialShippingMethod = shippingMethod;
                              provider.isLoading = true;
                            });
                            final result = await fetchData(
                              provider.checkoutData?.data?.sessionCheckoutData,
                              shippingMethod,
                            );
                            if (result) {
                              setState(() {
                                provider.isLoading = false;
                              });
                            } else {
                              setState(() {
                                provider.isLoading = false;
                              });
                            }
                          },
                        ),
                        ShippingAddressViewScreen(
                          checkoutToken: widget.tracked_start_checkout,
                          checkoutData: provider.checkoutData?.data,
                          loadCheckoutData: (bool checkoutData) {
                            if (checkoutData) {
                              fetchData(
                                  sessionCheckoutData, initialShippingMethod);
                            }
                          },
                        ),
                        Divider(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.08)),
                        CustomTextFieldWithCoupon(
                          labelText: 'Coupons',
                          hintText: 'Enter Coupon',
                          couponData: appliedCouponData,
                          onValueChange: (value) {
                            setState(() {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  appliedCouponData = {
                                    'coupon_code': '',
                                    'is_valid_coupon': false,
                                    'message': '',
                                  };
                                });
                              } else {
                                appliedCouponData = {
                                  'coupon_code':
                                      appliedCouponData['coupon_code'],
                                  'is_valid_coupon':
                                      appliedCouponData['is_valid_coupon'],
                                  'message': appliedCouponData['message'],
                                };
                              }
                            });
                          },
                          onCouponApplyRemove: (couponCode, isApply) async {
                            if (couponCode.isNotEmpty) {
                              final result = await applyRemoveCouponCode(
                                  couponCode, isApply);
                              if (result) {
                                final resulData = await fetchData(
                                    sessionCheckoutData, initialShippingMethod);
                                if (resulData) {
                                  setState(() {
                                    if (isApply) {
                                      appliedCouponData = {
                                        'coupon_code': couponCode,
                                        'is_valid_coupon': true,
                                        'message':
                                            'Coupon applied successfully!',
                                      };
                                    } else {
                                      appliedCouponData = {
                                        'coupon_code': '',
                                        'is_valid_coupon': false,
                                        'message':
                                            'Coupon removed successfully!',
                                      };
                                    }

                                    provider.isLoading = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  if (isApply) {
                                    appliedCouponData = {
                                      'coupon_code': couponCode,
                                      'is_valid_coupon': false,
                                      'message':
                                          'This coupon is invalid or expired!',
                                    };
                                  } else {
                                    appliedCouponData = {
                                      'coupon_code': '',
                                      'is_valid_coupon': false,
                                      'message': '',
                                    };
                                  }

                                  provider.isLoading = false;
                                });
                              }
                            }
                          },
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Divider(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.08)),
                        _totalView(),
                        Padding(
                          padding: EdgeInsets.only(
                            top: screenHeight * 0.02,
                            right: screenWidth * 0.02,
                            left: screenWidth * 0.02,
                            bottom: screenHeight * 0.02,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    focusColor: Colors.black,
                                    activeColor: Colors.black,
                                    checkColor: Colors.white,
                                    value: _isTermsAccepted,
                                    onChanged: _toggleCheckbox,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const TermsAndCondtionScreen(),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                            'I accept the terms & conditions'),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Read our T&Cs',
                                                style: GoogleFonts.inter(
                                                  color: Colors.grey,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (hasTCError)
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'You must accept terms & condition to proceed',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: AppCustomButton(
                    onPressed: () async {
                      if (!_isTermsAccepted) {
                        setState(() {
                          hasTCError = true;
                        });
                        return;
                      }

                      final checkoutURL = await checkoutPayment(
                          provider.checkoutData, widget.paymentMethod);
                      log('checkoutURL: $checkoutURL, widget.paymentMethod: ${widget.paymentMethod}');
                      if (checkoutURL != null) {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentViewScreen(
                              checkoutUrl: checkoutURL,
                            ),
                          ),
                        );

                        setState(() {
                          provider.isLoading = false;
                        });

                        if (result) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderPageScreen(),
                            ),
                            (route) => route.settings.name == '/homeScreen',
                          );
                        }
                      } else {
                        setState(() {
                          provider.isLoading = false;
                        });
                      }
                    },
                    icon: CupertinoIcons.forward,
                    title: 'Continue To Payment',
                    isLoading: provider.isLoading,
                    // isChecked: _isChecked,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _totalView() {
    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;
    return Consumer<CheckoutProvider>(
      builder: (BuildContext context, CheckoutProvider value, Widget? child) =>
          Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.02,
          right: screenWidth * 0.02,
          bottom: screenHeight * 0.02,
          left: screenWidth * 0.02,
        ),
        child: Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.subTotal, style: cartSubtotal(context)),
                    Text(
                      (value.checkoutData?.data?.formattedPrices?.subTotal ??
                              'loading..')
                          .replaceAll('AED', 'AED '),
                      style: cartSubtotal(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.tax, style: cartSubtotal(context)),
                    Text(
                      (value.checkoutData?.data?.formattedPrices?.tax ??
                              'loading..')
                          .replaceAll('AED', 'AED '),
                      style: cartSubtotal(context),
                    ),
                  ],
                ),
              ),
              if (appliedCouponData['is_valid_coupon'])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.couponCodeText,
                          style: cartSubtotal(context)),
                      Text(
                        "${appliedCouponData['coupon_code'] ?? 'loading..'}",
                        style: cartSubtotal(context),
                      ),
                    ],
                  ),
                ),
              if (appliedCouponData['is_valid_coupon'])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.couponCodeAmount,
                          style: cartSubtotal(context)),
                      Text(
                        "AED ${value.checkoutData?.data?.couponDiscountAmount ?? 'loading..'}",
                        style: cartSubtotal(context),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.shippingFee, style: cartSubtotal(context)),
                    Text(
                      (value.checkoutData?.data?.formattedPrices
                                  ?.shippingAmount ??
                              'loading..')
                          .replaceAll('AED', 'AED '),
                      style: cartSubtotal(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.total, style: cartTotal(context)),
                    Text(
                      (value.checkoutData?.data?.formattedPrices?.orderAmount ??
                              'loading..')
                          .replaceAll('AED', 'AED '),
                      style: cartTotal(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
