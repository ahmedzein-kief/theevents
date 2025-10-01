import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/PriceRow.dart';
import 'package:event_app/models/checkout_models/checkout_data_models.dart';
import 'package:event_app/provider/checkout_provider/checkout_provider.dart';
import 'package:event_app/views/cart_screens/widgets/payment_buttons.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/gift_card/payments_methods.dart';
import 'package:event_app/views/profile_page_screens/terms_and_condtion_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/services/shared_preferences_helper.dart';

class ConsolidatedPaymentScreen extends StatefulWidget {
  const ConsolidatedPaymentScreen({
    super.key,
    required this.onNext,
    this.trackedStartCheckout,
    required this.isNewAddress,
  });

  final String? trackedStartCheckout;
  final VoidCallback onNext;
  final bool isNewAddress;

  @override
  State<ConsolidatedPaymentScreen> createState() => _ConsolidatedPaymentScreenState();
}

class _ConsolidatedPaymentScreenState extends State<ConsolidatedPaymentScreen> {
  final GlobalKey _paymentButtonsKey = GlobalKey();
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

    if (!mounted) return false; // ✅ check before using context

    final provider = Provider.of<CheckoutProvider>(context, listen: false);
    return provider.fetchCheckoutData(
      context,
      widget.trackedStartCheckout ?? '',
      token ?? '',
      sessionCheckoutData,
      shippingMethod,
    );
  }

  Future<bool> applyRemoveCouponCode(String couponCode, bool isApply) async {
    final token = await SecurePreferencesUtil.getToken();

    if (!mounted) return false; // ✅ safeguard

    final provider = Provider.of<CheckoutProvider>(context, listen: false);

    setState(() {
      provider.isLoading = true;
    });

    return provider.applyRemoveCouponCode(
      context,
      widget.trackedStartCheckout ?? '',
      token ?? '',
      couponCode,
      isApply,
    );
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

  // Only showing the changed section - the rest remains the same

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
          // Grand Total Row
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

          // Payment Buttons - No key needed anymore
          PaymentButtons(
            provider: provider,
            paymentMethod: paymentMethod,
            isDarkMode: isDarkMode,
            isNewAddress: widget.isNewAddress,
            trackedStartCheckout: widget.trackedStartCheckout,
            onNext: widget.onNext,
          ),
        ],
      ),
    );
  }
}
