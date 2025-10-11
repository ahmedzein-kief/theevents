// import 'dart:developer';
//
// import 'package:event_app/core/constants/vendor_app_strings.dart';
// import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
// import 'package:event_app/models/checkout_models/checkout_data_models.dart';
// import 'package:event_app/views/cart_screens/shipping_address_view_screen.dart';
// import 'package:event_app/views/cart_screens/shipping_method_view_screen.dart';
// import 'package:event_app/views/payment_screens/payment_view_screen.dart';
// import 'package:event_app/views/profile_page_screens/terms_and_condtion_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pay/pay.dart'; // Apple Pay package
// import 'package:provider/provider.dart';
//
// import '../../core/constants/app_strings.dart';
// import '../../core/services/shared_preferences_helper.dart';
// import '../../core/styles/custom_text_styles.dart';
// import '../../core/utils/custom_toast.dart';
// import '../../core/widgets/custom_items_views/coupon_text_field.dart';
// import '../../core/widgets/custom_items_views/custom_add_to_cart_button.dart';
// import '../../provider/checkout_provider/checkout_provider.dart';
//
// // Updated PaymentScreen with Apple Pay integration
// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({
//     super.key,
//     required this.onNext,
//     this.trackedStartCheckout,
//     required this.paymentMethod,
//     required this.isNewAddress,
//   });
//
//   final String? trackedStartCheckout;
//   final Map<String, String> paymentMethod;
//   final VoidCallback onNext;
//   final bool isNewAddress;
//
//   @override
//   State<PaymentScreen> createState() => _ShippingAddressScreenState();
// }
//
// class _ShippingAddressScreenState extends State<PaymentScreen> {
//   bool _isTermsAccepted = false;
//   bool hasTCError = false;
//   Map<String, String> initialShippingMethod = {
//     'method_id': '3',
//     'method_amount': '39.00',
//   };
//   SessionCheckoutData? sessionCheckoutData;
//
//   Map<String, dynamic> appliedCouponData = {
//     'coupon_code': '',
//     'is_valid_coupon': false,
//     'message': '',
//   };
//
//   // Apple Pay configuration
//   static const String defaultApplePayConfigString = '''
// {
//     "provider": "apple_pay",
//     "data": {
//       "merchantIdentifier": "merchant.com.yourapp.id",
//       "displayName": "Your App Name",
//       "merchantCapabilities": ["3DS", "debit", "credit"],
//       "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
//       "countryCode": "AE",
//       "currencyCode": "AED"
//     }
//   }''';
//
//   /// +++++++++++++++++++++++ function checkbox  --------------------------------------
//   void _toggleCheckbox(bool? value) {
//     setState(() {
//       hasTCError = value == false;
//       _isTermsAccepted = value!;
//     });
//   }
//
//   @override
//   void initState() {
//     fetchData(sessionCheckoutData, initialShippingMethod);
//     super.initState();
//   }
//
//   Future<bool> fetchData(
//     SessionCheckoutData? sessionCheckoutData,
//     Map<String, String> shippingMethod,
//   ) async {
//     final token = await SecurePreferencesUtil.getToken();
//     final provider = Provider.of<CheckoutProvider>(context, listen: false);
//     return provider.fetchCheckoutData(
//       context,
//       widget.trackedStartCheckout ?? '',
//       token ?? '',
//       sessionCheckoutData,
//       shippingMethod,
//     );
//   }
//
//   Future<String?> checkoutPayment(
//     CheckoutResponse? checkoutData,
//     Map<String, String> paymentMethod,
//     bool isNewAddress,
//   ) async {
//     if (checkoutData == null) return null;
//
//     final token = await SecurePreferencesUtil.getToken();
//     final provider = Provider.of<CheckoutProvider>(context, listen: false);
//
//     setState(() {
//       provider.isLoading = true;
//     });
//     return provider.checkoutPaymentLink(
//       context,
//       widget.trackedStartCheckout ?? '',
//       token ?? '',
//       checkoutData,
//       paymentMethod,
//       isNewAddress,
//     );
//   }
//
//   Future<bool> applyRemoveCouponCode(String couponCode, bool isApply) async {
//     final token = await SecurePreferencesUtil.getToken();
//     final provider = Provider.of<CheckoutProvider>(context, listen: false);
//
//     setState(() {
//       provider.isLoading = true;
//     });
//     return provider.applyRemoveCouponCode(
//       context,
//       widget.trackedStartCheckout ?? '',
//       token ?? '',
//       couponCode,
//       isApply,
//     );
//   }
//
//   // Apple Pay handlers
//   Future<void> onApplePayResult(paymentResult) async {
//     try {
//       final provider = Provider.of<CheckoutProvider>(context, listen: false);
//
//       setState(() {
//         provider.isLoading = true;
//       });
//
//       // Process Apple Pay payment
//       // You'll need to implement the Apple Pay processing logic here
//       // This typically involves sending the payment token to your backend
//
//       final bool success = await _processApplePayment(paymentResult);
//
//       if (success) {
//         // Navigate to success screen or handle successful payment
//         widget.onNext();
//         CustomSnackbar.showSuccess(
//           context,
//           'Payment completed successfully',
//         );
//       } else {
//         CustomSnackbar.showError(
//           context,
//           'Apple Pay payment failed. Please try again.',
//         );
//       }
//     } catch (e) {
//       CustomSnackbar.showError(
//         context,
//         'Apple Pay payment error: ${e.toString()}',
//       );
//     } finally {
//       setState(() {
//         Provider.of<CheckoutProvider>(context, listen: false).isLoading = false;
//       });
//     }
//   }
//
//   Future<bool> _processApplePayment(paymentResult) async {
//     // Implement your Apple Pay processing logic here
//     // This should send the payment token to your backend for processing
//
//     try {
//       // Example implementation:
//       // final response = await ApiService.processApplePayment(
//       //   paymentToken: paymentResult.token,
//       //   amount: totalAmount,
//       //   orderId: widget.tracked_start_checkout,
//       // );
//
//       // For now, simulate processing
//       await Future.delayed(const Duration(seconds: 2));
//       return true; // Return actual result from your backend
//     } catch (e) {
//       log('Apple Pay processing error: $e');
//       return false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dynamic screenWidth = MediaQuery.sizeOf(context).width;
//     final dynamic screenHeight = MediaQuery.sizeOf(context).height;
//     return RefreshIndicator(
//       color: Colors.black,
//       onRefresh: () async {
//         fetchData(sessionCheckoutData, initialShippingMethod);
//       },
//       child: Consumer<CheckoutProvider>(
//         builder: (BuildContext context, CheckoutProvider provider, Widget? child) {
//           sessionCheckoutData = provider.checkoutData?.data?.sessionCheckoutData;
//           if (provider.isLoading) {
//             return const Center(
//               child: SizedBox(
//                 width: 50,
//                 height: 50,
//                 child: CircularProgressIndicator(color: Colors.black),
//               ),
//             );
//           }
//
//           return Center(
//             child: Column(
//               children: <Widget>[
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ShippingMethodViewScreen(
//                           shippingMethod: initialShippingMethod,
//                           onSelectShippingMethod: (Map<String, String> shippingMethod) async {
//                             setState(() {
//                               initialShippingMethod = shippingMethod;
//                               provider.isLoading = true;
//                             });
//                             final result = await fetchData(
//                               provider.checkoutData?.data?.sessionCheckoutData,
//                               shippingMethod,
//                             );
//                             if (result) {
//                               setState(() {
//                                 provider.isLoading = false;
//                               });
//                             } else {
//                               setState(() {
//                                 provider.isLoading = false;
//                               });
//                             }
//                           },
//                         ),
//                         ShippingAddressViewScreen(
//                           checkoutToken: widget.trackedStartCheckout,
//                           checkoutData: provider.checkoutData?.data,
//                           loadCheckoutData: (bool checkoutData) {
//                             if (checkoutData) {
//                               fetchData(
//                                 sessionCheckoutData,
//                                 initialShippingMethod,
//                               );
//                             }
//                           },
//                         ),
//                         Divider(
//                           color: Theme.of(context).colorScheme.onPrimary.withAlpha((0.08 * 255).toInt()),
//                         ),
//                         CustomTextFieldWithCoupon(
//                           labelText: AppStrings.couponLabel.tr,
//                           hintText: AppStrings.couponHint.tr,
//                           couponData: appliedCouponData,
//                           onValueChange: (value) {
//                             setState(() {
//                               if (value == null || value.isEmpty) {
//                                 setState(() {
//                                   appliedCouponData = {
//                                     'coupon_code': '',
//                                     'is_valid_coupon': false,
//                                     'message': '',
//                                   };
//                                 });
//                               } else {
//                                 appliedCouponData = {
//                                   'coupon_code': appliedCouponData['coupon_code'],
//                                   'is_valid_coupon': appliedCouponData['is_valid_coupon'],
//                                   'message': appliedCouponData['message'],
//                                 };
//                               }
//                             });
//                           },
//                           onCouponApplyRemove: (couponCode, isApply) async {
//                             if (couponCode.isNotEmpty) {
//                               final result = await applyRemoveCouponCode(
//                                 couponCode,
//                                 isApply,
//                               );
//                               if (result) {
//                                 final resulData = await fetchData(
//                                   sessionCheckoutData,
//                                   initialShippingMethod,
//                                 );
//                                 if (resulData) {
//                                   setState(() {
//                                     if (isApply) {
//                                       appliedCouponData = {
//                                         'coupon_code': couponCode,
//                                         'is_valid_coupon': true,
//                                         'message': AppStrings.couponAppliedSuccess.tr,
//                                       };
//                                     } else {
//                                       appliedCouponData = {
//                                         'coupon_code': '',
//                                         'is_valid_coupon': false,
//                                         'message': AppStrings.couponRemovedSuccess.tr,
//                                       };
//                                     }
//                                     provider.isLoading = false;
//                                   });
//                                 }
//                               } else {
//                                 setState(() {
//                                   if (isApply) {
//                                     appliedCouponData = {
//                                       'coupon_code': couponCode,
//                                       'is_valid_coupon': false,
//                                       'message': AppStrings.couponInvalidOrExpired.tr,
//                                     };
//                                   } else {
//                                     appliedCouponData = {
//                                       'coupon_code': '',
//                                       'is_valid_coupon': false,
//                                       'message': '',
//                                     };
//                                   }
//                                   provider.isLoading = false;
//                                 });
//                               }
//                             }
//                           },
//                         ),
//                         SizedBox(height: screenHeight * 0.03),
//                         Divider(
//                           color: Theme.of(context).colorScheme.onPrimary.withAlpha((0.08 * 255).toInt()),
//                         ),
//                         _totalView(),
//                         Padding(
//                           padding: EdgeInsets.only(
//                             top: screenHeight * 0.02,
//                             right: screenWidth * 0.02,
//                             left: screenWidth * 0.02,
//                             bottom: screenHeight * 0.02,
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Checkbox(
//                                     activeColor: Theme.of(context).colorScheme.onPrimary,
//                                     checkColor: Theme.of(context).colorScheme.primary,
//                                     value: _isTermsAccepted,
//                                     onChanged: _toggleCheckbox,
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => const TermsAndCondtionScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           AppStrings.acceptTermsAndConditions.tr,
//                                         ),
//                                         RichText(
//                                           text: TextSpan(
//                                             children: [
//                                               TextSpan(
//                                                 text: AppStrings.readOurTermsAndConditions.tr,
//                                                 style: GoogleFonts.inter(
//                                                   color: Colors.grey,
//                                                   decoration: TextDecoration.underline,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               if (hasTCError)
//                                 Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 12.0),
//                                     child: Text(
//                                       AppStrings.mustAcceptTerms.tr,
//                                       style: const TextStyle(
//                                         color: Colors.red,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Payment button section
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//                   child: _buildPaymentButton(provider),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildPaymentButton(CheckoutProvider provider) {
//     final bool isApplePaySelected = widget.paymentMethod['payment_method'] == 'apple_pay';
//
//     if (isApplePaySelected && _isTermsAccepted) {
//       // Show Apple Pay button
//       return Column(
//         children: [
//           // Apple Pay Button
//           Container(
//             width: double.infinity,
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             child: ApplePayButton(
//               paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePayConfigString),
//               paymentItems: _buildPaymentItems(provider),
//               style: ApplePayButtonStyle.whiteOutline,
//               type: ApplePayButtonType.buy,
//               margin: const EdgeInsets.only(top: 15.0),
//               onPaymentResult: onApplePayResult,
//               loadingIndicator: const Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           // Terms validation message
//           if (hasTCError)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 AppStrings.mustAcceptTerms.tr,
//                 style: const TextStyle(
//                   color: Colors.red,
//                   fontSize: 12,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//         ],
//       );
//     } else if (!isApplePaySelected) {
//       // Show regular payment button
//       return AppCustomButton(
//         onPressed: () async {
//           if (!_isTermsAccepted) {
//             CustomSnackbar.showError(
//               context,
//               AppStrings.mustAcceptTerms.tr,
//             );
//             setState(() {
//               hasTCError = true;
//             });
//             return;
//           }
//
//           final checkoutURL = await checkoutPayment(
//             provider.checkoutData,
//             widget.paymentMethod,
//             widget.isNewAddress,
//           );
//
//           if (checkoutURL != null) {
//             // Navigate to PaymentViewScreen
//             // PaymentViewScreen will handle success navigation and cart clearing
//             await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PaymentViewScreen(
//                   checkoutUrl: checkoutURL,
//                 ),
//               ),
//             );
//
//             // Reset loading state after returning from PaymentViewScreen
//             setState(() {
//               provider.isLoading = false;
//             });
//           } else {
//             setState(() {
//               provider.isLoading = false;
//             });
//             CustomSnackbar.showError(
//               context,
//               VendorAppStrings.paymentLinkError.tr,
//             );
//           }
//         },
//         icon: CupertinoIcons.forward,
//         title: AppStrings.continueToPayment.tr,
//         isLoading: provider.isLoading,
//       );
//     } else {
//       return const SizedBox.shrink();
//     }
//   }
//
//   List<PaymentItem> _buildPaymentItems(CheckoutProvider provider) {
//     final orderAmount = provider.checkoutData?.data?.formattedPrices.orderAmount ?? '0.00';
//     final cleanAmount = orderAmount.replaceAll(RegExp(r'[^0-9.]'), '');
//
//     return [
//       PaymentItem(
//         label: 'Total',
//         amount: cleanAmount,
//         status: PaymentItemStatus.final_price,
//       ),
//     ];
//   }
//
//   Widget _totalView() {
//     final dynamic screenWidth = MediaQuery.sizeOf(context).width;
//     final dynamic screenHeight = MediaQuery.sizeOf(context).height;
//     return Consumer<CheckoutProvider>(
//       builder: (BuildContext context, CheckoutProvider value, Widget? child) => Padding(
//         padding: EdgeInsets.only(
//           top: screenHeight * 0.02,
//           right: screenWidth * 0.02,
//           bottom: screenHeight * 0.02,
//           left: screenWidth * 0.02,
//         ),
//         child: Container(
//           width: screenWidth,
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.primary,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withAlpha((0.2 * 255).toInt()),
//                 spreadRadius: 1,
//                 blurRadius: 5,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       AppStrings.subTotalColon.tr,
//                       style: cartSubtotal(context),
//                     ),
//                     Text(
//                       (value.checkoutData?.data?.formattedPrices.subTotal ?? AppStrings.loading.tr)
//                           .replaceAll('AED', AppStrings.currencyAED.tr),
//                       style: cartSubtotal(context),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(AppStrings.taxColon.tr, style: cartSubtotal(context)),
//                     Text(
//                       (value.checkoutData?.data?.formattedPrices.tax ?? AppStrings.loading.tr)
//                           .replaceAll('AED', AppStrings.currencyAED.tr),
//                       style: cartSubtotal(context),
//                     ),
//                   ],
//                 ),
//               ),
//               if (appliedCouponData['is_valid_coupon'])
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         AppStrings.couponCodeText.tr,
//                         style: cartSubtotal(context),
//                       ),
//                       Text(
//                         "${appliedCouponData['coupon_code'] ?? AppStrings.loading.tr}",
//                         style: cartSubtotal(context),
//                       ),
//                     ],
//                   ),
//                 ),
//               if (appliedCouponData['is_valid_coupon'])
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 4.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         AppStrings.couponCodeAmount.tr,
//                         style: cartSubtotal(context),
//                       ),
//                       Text(
//                         '${AppStrings.currencyAED.tr}${value.checkoutData?.data?.couponDiscountAmount ?? AppStrings.loading.tr}',
//                         style: cartSubtotal(context),
//                       ),
//                     ],
//                   ),
//                 ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '${AppStrings.shippingFee.tr}:  ',
//                       style: cartSubtotal(context),
//                     ),
//                     Text(
//                       (value.checkoutData?.data?.formattedPrices.shippingAmount ?? AppStrings.loading.tr)
//                           .replaceAll('AED', AppStrings.currencyAED.tr),
//                       style: cartSubtotal(context),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(AppStrings.totalColon.tr, style: cartTotal(context)),
//                     Text(
//                       (value.checkoutData?.data?.formattedPrices.orderAmount ?? AppStrings.loading.tr)
//                           .replaceAll('AED', AppStrings.currencyAED.tr),
//                       style: cartTotal(context),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
