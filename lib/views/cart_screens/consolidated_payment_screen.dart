import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/core/widgets/loading_indicator.dart';
import 'package:event_app/provider/checkout_provider/checkout_provider.dart';
import 'package:event_app/views/cart_screens/widgets/coupon_section.dart';
import 'package:event_app/views/cart_screens/widgets/order_summary_section.dart';
import 'package:event_app/views/cart_screens/widgets/payment_footer.dart';
import 'package:event_app/views/cart_screens/widgets/payment_header.dart';
import 'package:event_app/views/cart_screens/widgets/payment_methods_section.dart';
import 'package:event_app/views/cart_screens/widgets/shipping_address_section.dart';
import 'package:event_app/views/cart_screens/widgets/terms_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Map<String, String> _paymentMethod = {};

  static const _defaultShippingMethod = {
    'method_id': '3',
    'method_amount': '39.00',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    final token = await SecurePreferencesUtil.getToken();
    if (!mounted || token == null) return;

    final provider = context.read<CheckoutProvider>();
    await provider.initializeCheckout(
      checkoutToken: widget.trackedStartCheckout ?? '',
      token: token,
      shippingMethod: _defaultShippingMethod,
    );
  }

  Future<void> _handleRefresh() async {
    final token = await SecurePreferencesUtil.getToken();
    if (!mounted || token == null) return;

    final provider = context.read<CheckoutProvider>();
    await provider.fetchCheckoutData(
      widget.trackedStartCheckout ?? '',
      token,
      null,
      _defaultShippingMethod,
      paymentMethod: _paymentMethod['payment_method'],
    );
  }

  Future<void> _handleCouponAction(String couponCode, bool isApply) async {
    final token = await SecurePreferencesUtil.getToken();
    if (!mounted || token == null) return;

    final provider = context.read<CheckoutProvider>();
    await provider.handleCouponAction(
      context: context,
      checkoutToken: widget.trackedStartCheckout ?? '',
      token: token,
      couponCode: couponCode,
      isApply: isApply,
      shippingMethod: _defaultShippingMethod,
    );
  }

  Future<void> _handlePaymentMethodChange(Map<String, String> method) async {
    // Update the payment method first
    setState(() => _paymentMethod = method);

    // If wallet is selected, refetch checkout data
    // if (method['payment_method'] == 'wallet') {
    await _handleRefresh();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RefreshIndicator(
      color: Colors.black,
      onRefresh: _handleRefresh,
      child: Consumer<CheckoutProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return _buildLoadingState();
          }

          return _buildContent(provider, isDark);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: LoadingIndicator(),
    );
  }

  Widget _buildContent(CheckoutProvider provider, bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: Column(
        children: [
          PaymentHeader(isDark: isDark),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PaymentMethodsSection(
                    provider: provider,
                    isDark: isDark,
                    onMethodChanged: _handlePaymentMethodChange,
                  ),
                  const SizedBox(height: 20),
                  CouponSection(
                    provider: provider,
                    couponState: provider.couponState,
                    isDark: isDark,
                    isLoading: provider.isCouponLoading,
                    onCouponChanged: provider.updateCouponInput,
                    onCouponAction: _handleCouponAction,
                  ),
                  const SizedBox(height: 20),
                  OrderSummarySection(
                    provider: provider,
                    couponState: provider.couponState,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  ShippingAddressSection(
                    provider: provider,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),
                  TermsSection(isDark: isDark),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          PaymentFooter(
            provider: provider,
            paymentMethod: _paymentMethod,
            isDark: isDark,
            isNewAddress: widget.isNewAddress,
            trackedStartCheckout: widget.trackedStartCheckout,
            onNext: widget.onNext,
          ),
        ],
      ),
    );
  }
}
