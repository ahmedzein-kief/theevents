import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/core/utils/custom_toast.dart';
import 'package:event_app/core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import 'package:event_app/models/checkout_models/checkout_data_models.dart';
import 'package:event_app/provider/checkout_provider/checkout_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/app_utils.dart';
import '../../../provider/information_icons_provider/payment_methods_provider.dart';

class PaymentButtons extends StatefulWidget {
  final CheckoutProvider provider;
  final Map<String, String> paymentMethod;
  final bool isDarkMode;
  final bool isNewAddress;
  final String? trackedStartCheckout;
  final VoidCallback onNext;

  const PaymentButtons({
    super.key,
    required this.provider,
    required this.paymentMethod,
    required this.isDarkMode,
    required this.isNewAddress,
    this.trackedStartCheckout,
    required this.onNext,
  });

  @override
  State<PaymentButtons> createState() => _PaymentButtonsState();
}

class _PaymentButtonsState extends State<PaymentButtons> {
  bool _isProcessing = false;

  // Apple Pay handlers
  Future<void> onApplePayResult(
    paymentResult,
    CheckoutResponse? checkoutData,
    Map<String, String> paymentMethod,
    bool isNewAddress,
  ) async {
    if (_isProcessing) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final bool success = await _processApplePayment(
        paymentResult,
        checkoutData,
        paymentMethod,
        isNewAddress,
      );

      if (!mounted) return;

      if (success) {
        widget.onNext();
        AppUtils.showToast(
          'Payment completed successfully',
          isSuccess: true,
        );
      } else {
        AppUtils.showToast(
          'Apple Pay payment failed. Please try again.',
        );
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showToast(
          'Apple Pay payment error: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
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
      if (token == null) {
        return false;
      }

      if (!mounted) return false;

      final provider = Provider.of<CheckoutProvider>(context, listen: false);

      await provider.checkoutPaymentLink(
        context,
        widget.trackedStartCheckout ?? '',
        token,
        checkoutData,
        paymentMethod,
        isNewAddress,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

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
  Widget build(BuildContext context) {
    final bool isApplePaySelected = widget.paymentMethod['payment_method'] == 'apple_pay';
    final bool isWalletSelected = widget.paymentMethod['payment_method'] == 'wallet';

    // Use provider's isProcessingPayment flag to check if we should show loading
    final isProcessingPayment = widget.provider.isProcessingPayment || _isProcessing;

    return Consumer<PaymentMethodsProvider>(
      builder: (context, paymentMethodsProvider, child) {
        if (paymentMethodsProvider.isLoading) {
          return const SizedBox.shrink();
        }

        return Row(
          children: [
            /// TODO(Apple Pay): Add Apple Pay Button
            // Apple Pay Button (if available and selected)
            // if (Platform.isIOS && isApplePaySelected)
            //   Expanded(
            //     child: SizedBox(
            //       child: ApplePayButton(
            //         height: 45,
            //         paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePayConfigString),
            //         paymentItems: _buildPaymentItems(widget.provider),
            //         style: ApplePayButtonStyle.whiteOutline,
            //         type: ApplePayButtonType.buy,
            //         onPaymentResult: (paymentResult) => onApplePayResult(
            //             paymentResult, widget.provider.checkoutData, widget.paymentMethod, widget.isNewAddress),
            //         loadingIndicator: const Center(
            //           child: CircularProgressIndicator(),
            //         ),
            //       ),
            //     ),
            //   ),
            if (!isApplePaySelected)
              Expanded(
                child: AppCustomButton(
                  onPressed: isProcessingPayment ? () {} : () => _handlePaymentPress(isWalletSelected),
                  icon: CupertinoIcons.forward,
                  title: AppStrings.payNowTitle.tr,
                  isLoading: isProcessingPayment,
                ),
              ),
          ],
        );
      },
    );
  }

  /// Main payment handler - coordinates the payment flow
  Future<void> _handlePaymentPress(bool isWalletSelected) async {
    // Prevent multiple simultaneous payment attempts
    if (_isProcessing || widget.provider.isProcessingPayment) {
      return;
    }

    if (!mounted) return;

    setState(() => _isProcessing = true);

    try {
      final token = await SecurePreferencesUtil.getToken();
      if (token == null) {
        if (mounted) {
          AppUtils.showToast('Authentication token not found');
        }
        return;
      }

      if (!mounted) return;

      final provider = Provider.of<CheckoutProvider>(context, listen: false);

      if (isWalletSelected) {
        provider.payWithWallet(
          context,
          widget.trackedStartCheckout ?? '',
          provider.checkoutData,
          widget.isNewAddress,
        );
        // Wallet payment handles its own navigation
      } else {
        // Use the new provider method that handles navigation
        provider.processGatewayPayment(
          context: context,
          checkoutToken: widget.trackedStartCheckout ?? '',
          token: token,
          paymentMethod: widget.paymentMethod,
          isNewAddress: widget.isNewAddress,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          context,
          'Payment failed: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  List<PaymentItem> _buildPaymentItems(CheckoutProvider provider) {
    final orderAmount = provider.checkoutData?.data?.formattedPrices.orderAmount ?? '0.00';
    final cleanAmount = orderAmount.replaceAll(RegExp(r'[^0-9.]'), '');
    final grandTotal = double.tryParse(cleanAmount) ?? 0.0;

    return [
      PaymentItem(
        label: 'Total',
        amount: grandTotal.toStringAsFixed(2),
        status: PaymentItemStatus.final_price,
      ),
    ];
  }

  @override
  void dispose() {
    _isProcessing = false;
    super.dispose();
  }
}
