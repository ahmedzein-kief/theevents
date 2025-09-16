import 'dart:developer';
import 'dart:io' show Platform;

import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/core/utils/custom_toast.dart';
import 'package:event_app/core/widgets/PriceRow.dart';
import 'package:event_app/core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import 'package:event_app/models/checkout_models/checkout_data_models.dart';
import 'package:event_app/provider/checkout_provider/checkout_provider.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/gift_card/payments_methods.dart';
import 'package:event_app/views/payment_screens/payment_view_screen.dart';
import 'package:event_app/views/profile_page_screens/terms_and_condtion_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class ConsolidatedPaymentScreen extends StatefulWidget {
  const ConsolidatedPaymentScreen({
    super.key,
    required this.onNext,
    this.tracked_start_checkout,
    required this.isNewAddress,
  });

  final String? tracked_start_checkout;
  final VoidCallback onNext;
  final bool isNewAddress;

  @override
  State<ConsolidatedPaymentScreen> createState() => _ConsolidatedPaymentScreenState();
}

class _ConsolidatedPaymentScreenState extends State<ConsolidatedPaymentScreen> {
  Map<String, String> paymentMethod = {};
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

  // Apple Pay configuration
  static const String defaultApplePayConfigString = '''
{
    "provider": "apple_pay",
    "data": {
      "merchantIdentifier": "merchant.com.logicalyinfotech.events",
      "displayName": "TheEvents",
      "merchantCapabilities": ["3DS", "debit", "credit"],
      "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
      "countryCode": "AE",
      "currencyCode": "AED"
    }
  }''';

  @override
  void initState() {
    super.initState();
    fetchData(sessionCheckoutData, initialShippingMethod);
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
    CheckoutResponse? checkoutData,
    Map<String, String> paymentMethod,
    bool isNewAddress,
  ) async {
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
      isNewAddress,
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

  // Apple Pay handlers
  Future<void> onApplePayResult(
    paymentResult,
    CheckoutResponse? checkoutData,
    Map<String, String> paymentMethod,
    bool isNewAddress,
  ) async {
    log('paymentResult: $paymentResult');
    final provider = Provider.of<CheckoutProvider>(context, listen: false);
    try {
      setState(() {
        provider.isLoading = true;
      });

      final bool success = await _processApplePayment(paymentResult, checkoutData, paymentMethod, isNewAddress);

      if (success) {
        widget.onNext();
        CustomSnackbar.showSuccess(
          context,
          'Payment completed successfully',
        );
      } else {
        CustomSnackbar.showError(
          context,
          'Apple Pay payment failed. Please try again.',
        );
      }
    } catch (e) {
      CustomSnackbar.showError(
        context,
        'Apple Pay payment error: ${e.toString()}',
      );
    } finally {
      setState(() {
        provider.isLoading = false;
      });
    }
  }

  Future<bool> _processApplePayment(
    paymentResult,
    CheckoutResponse? checkoutData,
    Map<String, String> paymentMethod,
    bool isNewAddress,
  ) async {
    try {
      if (checkoutData == null) return false;

      final token = await SecurePreferencesUtil.getToken();
      final provider = Provider.of<CheckoutProvider>(context, listen: false);

      setState(() {
        provider.isLoading = true;
      });
      provider.checkoutPaymentLink(
        context,
        widget.tracked_start_checkout ?? '',
        token ?? '',
        checkoutData,
        paymentMethod,
        isNewAddress,
      );
      return true;
    } catch (e) {
      log('Apple Pay processing error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        fetchData(sessionCheckoutData, initialShippingMethod);
      },
      child: Consumer<CheckoutProvider>(
        builder: (BuildContext context, CheckoutProvider provider, Widget? child) {
          sessionCheckoutData = provider.checkoutData?.data?.sessionCheckoutData;
          if (provider.isLoading) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(color: Colors.black),
              ),
            );
          }

          return Scaffold(
            backgroundColor: isDarkMode ? theme.scaffoldBackgroundColor : Colors.white,
            body: Column(
              children: [
                // Header
                _buildHeader(screenWidth, screenHeight, isDarkMode),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Payment Methods Section
                        _buildPaymentMethodsSection(provider, screenWidth, screenHeight, isDarkMode),

                        const SizedBox(height: 20),

                        // Order Summary Section
                        _buildOrderSummarySection(provider, screenWidth, screenHeight, isDarkMode),

                        const SizedBox(height: 20),

                        // Shipping Address Section
                        _buildShippingAddressSection(provider, screenWidth, screenHeight, isDarkMode),

                        const SizedBox(height: 20),

                        // Terms and Conditions Section
                        _buildTermsSection(screenWidth, screenHeight, isDarkMode),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Total and Payment Buttons
                _buildTotalAndPaymentButtons(provider, screenWidth, screenHeight, isDarkMode),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(double screenWidth, double screenHeight, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.02,
      ),
      child: Column(
        children: [
          // Title
          Text(
            AppStrings.payment.tr,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection(
      CheckoutProvider provider, double screenWidth, double screenHeight, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.choosePaymentMethod.tr,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          PaymentMethods(
            amount: provider.checkoutData?.data?.formattedPrices.subTotal,
            onSelectionChanged: (selectedMethod) {
              setState(() {
                paymentMethod = selectedMethod;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection(
      CheckoutProvider provider, double screenWidth, double screenHeight, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.orderSummary.tr,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Subtotal
          _buildSummaryRow(
            AppStrings.subtotalUpper.tr,
            provider.checkoutData?.data?.formattedPrices.subTotal ?? '0.00 AED',
            isDarkMode,
          ),

          // Tax
          _buildSummaryRow(
            AppStrings.taxVat.tr,
            provider.checkoutData?.data?.formattedPrices.tax ?? '0.00 AED',
            isDarkMode,
          ),

          // Shipping Amount
          _buildSummaryRow(
            AppStrings.shipping.tr,
            provider.checkoutData?.data?.formattedPrices.shippingAmount ?? '0.00 AED',
            isDarkMode,
          ),

          // Coupon Discount (only show if there's a discount)
          if ((provider.checkoutData?.data?.couponDiscountAmount ?? 0) > 0)
            _buildSummaryRow(
              AppStrings.couponDiscount.tr,
              '-${provider.checkoutData?.data?.formattedPrices.couponDiscountAmount ?? '0.00 AED'}',
              isDarkMode,
              isDiscount: true,
            ),

          // Promotion Discount (only show if there's a discount)
          if ((provider.checkoutData?.data?.promotionDiscountAmount ?? 0) > 0)
            _buildSummaryRow(
              AppStrings.promotionDiscount.tr,
              '-${provider.checkoutData?.data?.formattedPrices.promotionDiscountAmount ?? '0.00 AED'}',
              isDarkMode,
              isDiscount: true,
            ),

          // Divider before total
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(thickness: 1),
          ),

          // Order Total (emphasized)
          _buildSummaryRow(
            AppStrings.totalUpper.tr,
            provider.checkoutData?.data?.formattedPrices.orderAmount ?? '0.00 AED',
            isDarkMode,
            isTotal: true,
          ),
        ],
      ),
    );
  }

// Helper method to build individual summary rows
  Widget _buildSummaryRow(
    String label,
    String value,
    bool isDarkMode, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          PriceRow(
              price: value,
              currencyColor: isDiscount ? Colors.green : (isDarkMode ? Colors.white : Colors.black),
              currencySize: 12,
              style: GoogleFonts.inter(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                color: isDiscount ? Colors.green : (isDarkMode ? Colors.white : Colors.black),
              )),
        ],
      ),
    );
  }

// --- SHIPPING ADDRESS SECTION ---
  Widget _buildShippingAddressSection(
    CheckoutProvider provider,
    double screenWidth,
    double screenHeight,
    bool isDarkMode,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.deliverTo.tr,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // Address details
          if (provider.checkoutData?.data?.sessionCheckoutData != null)
            _buildAddressDetails(provider, isDarkMode)
          else
            Text(
              AppStrings.noAddressSelected.tr,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

// --- ADDRESS DETAILS ---
  Widget _buildAddressDetails(CheckoutProvider provider, bool isDarkMode) {
    final sessionData = provider.checkoutData!.data!.sessionCheckoutData;
    final addressId = sessionData.addressId;

    final addresses = provider.checkoutData!.data!.addresses;
    final selectedAddress =
        addresses.any((a) => a.id == addressId) ? addresses.firstWhere((a) => a.id == addressId) : null;

    if (selectedAddress == null) {
      return Text(
        AppStrings.addressDetailsNotFound.tr,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.red,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAddressRow(AppStrings.fullName.tr, selectedAddress.name, isDarkMode),
        buildAddressRow(AppStrings.address.tr, selectedAddress.address, isDarkMode),
        buildAddressRow(AppStrings.city.tr, selectedAddress.locationCity.name, isDarkMode),
        buildAddressRow(AppStrings.areaState.tr, selectedAddress.locationState.name, isDarkMode),
        buildAddressRow(AppStrings.country.tr, selectedAddress.locationCountry.name, isDarkMode),
        buildAddressRow(AppStrings.phoneNumber.tr, selectedAddress.phone, isDarkMode),
        buildAddressRow(AppStrings.email.tr, selectedAddress.email, isDarkMode),
      ],
    );
  }

// --- SINGLE ADDRESS ROW ---
  Widget buildAddressRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection(double screenWidth, double screenHeight, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            AppStrings.termsNote.tr,
            style: GoogleFonts.lato(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsAndCondtionScreen(),
                ),
              );
            },
            child: Text(
              AppStrings.readOurTermsAndConditions.tr,
              style: GoogleFonts.lato(
                color: Colors.blue,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAndPaymentButtons(
      CheckoutProvider provider, double screenWidth, double screenHeight, bool isDarkMode) {
    final orderAmount = provider.checkoutData?.data?.formattedPrices.orderAmount ?? '0.00';
    final cleanAmount = orderAmount.replaceAll(RegExp(r'[^0-9.]'), '');
    final grandTotal = double.parse(cleanAmount);

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          // Grand Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.grandTotal.tr,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              PriceRow(
                price: grandTotal.toStringAsFixed(1),
                currencySize: 16,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              )
            ],
          ),

          const SizedBox(height: 16),

          // Payment Buttons
          _buildPaymentButtons(provider, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildPaymentButtons(CheckoutProvider provider, bool isDarkMode) {
    final bool isApplePaySelected = paymentMethod['payment_method'] == 'apple_pay';

    return Row(
      children: [
        // Apple Pay Button (if available and selected)
        if (Platform.isIOS && isApplePaySelected)
          Expanded(
            child: SizedBox(
              child: ApplePayButton(
                height: 45,
                paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePayConfigString),
                paymentItems: _buildPaymentItems(provider),
                style: ApplePayButtonStyle.whiteOutline,
                type: ApplePayButtonType.buy,
                onPaymentResult: (paymentResult) =>
                    onApplePayResult(paymentResult, provider.checkoutData, paymentMethod, widget.isNewAddress),
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),

        if (!isApplePaySelected)
          // Pay Now Button (for all methods)
          Expanded(
            child: AppCustomButton(
              onPressed: () async {
                final checkoutURL = await checkoutPayment(
                  provider.checkoutData,
                  paymentMethod,
                  widget.isNewAddress,
                );

                if (checkoutURL != null) {
                  await Navigator.push(
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
                } else {
                  setState(() {
                    provider.isLoading = false;
                  });
                  CustomSnackbar.showError(
                    context,
                    VendorAppStrings.paymentLinkError.tr,
                  );
                }
              },
              icon: CupertinoIcons.forward,
              title: AppStrings.payNowTitle.tr,
              isLoading: provider.isLoading,
            ),
          ),
      ],
    );
  }

  List<PaymentItem> _buildPaymentItems(CheckoutProvider provider) {
    final orderAmount = provider.checkoutData?.data?.formattedPrices.orderAmount ?? '0.00';
    final cleanAmount = orderAmount.replaceAll(RegExp(r'[^0-9.]'), '');
    final grandTotal = double.parse(cleanAmount);

    return [
      PaymentItem(
        label: 'Total',
        amount: grandTotal.toStringAsFixed(1),
        status: PaymentItemStatus.final_price,
      ),
    ];
  }
}
