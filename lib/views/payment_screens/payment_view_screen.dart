import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_strings.dart';
import '../../core/services/shared_preferences_helper.dart';
import '../../core/widgets/bottom_navigation_bar.dart';
import '../../provider/cart_item_provider/cart_item_provider.dart';

class PaymentResult {
  final bool isSuccess;
  final String? orderId;
  final String? errorMessage;

  PaymentResult({
    required this.isSuccess,
    this.orderId,
    this.errorMessage,
  });

  @override
  String toString() {
    return 'PaymentResult(isSuccess: $isSuccess, orderId: $orderId, errorMessage: $errorMessage)';
  }
}

class PaymentViewScreen extends StatefulWidget {
  const PaymentViewScreen({
    super.key,
    required this.checkoutUrl,
    this.paymentType,
  });

  final String checkoutUrl;
  final String? paymentType; // 'subscription', 'gift_card', or null for regular payments

  @override
  State<PaymentViewScreen> createState() => PaymentViewState();
}

class PaymentViewState extends State<PaymentViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasNavigatedBack = false; // Prevent multiple navigation calls

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(true)
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));

    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          log('onPageStarted url $url');
          setState(() {
            _isLoading = true;
          });

          _checkPaymentResult(url);
        },
        onPageFinished: (String url) {
          setState(() {
            _isLoading = false;
          });

          _checkPaymentResult(url);

          // Inject CSS for mobile responsiveness
          _controller.runJavaScript('''
            (function() {
              var viewport = document.querySelector("meta[name=viewport]");
              if (!viewport) {
                var meta = document.createElement('meta');
                meta.name = 'viewport';
                meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes';
                document.getElementsByTagName('head')[0].appendChild(meta);
              }
              
              var style = document.createElement('style');
              style.textContent = `
                body {
                  font-size: 16px !important;
                  -webkit-text-size-adjust: 100% !important;
                  -ms-text-size-adjust: 100% !important;
                }
                
                * {
                  max-width: 100% !important;
                  box-sizing: border-box !important;
                }
                
                .container, .payment-container {
                  width: 100% !important;
                  max-width: 100% !important;
                  padding: 10px !important;
                }
                
                input, button, select {
                  font-size: 16px !important;
                  min-height: 44px !important;
                }
                
                @media screen and (max-width: 768px) {
                  body {
                    zoom: 1 !important;
                    transform: none !important;
                  }
                }
              `;
              document.head.appendChild(style);
            })();
          ''');
        },
        onProgress: (int progress) {
          // Optional: Add progress indicator
        },
        onWebResourceError: (WebResourceError error) {
          log('WebView error: ${error.description}');
          // Handle network errors
          if (!_hasNavigatedBack) {
            _handlePaymentResult(
              widget.paymentType == null
                  ? PaymentResult(
                      isSuccess: false,
                      orderId: null,
                      errorMessage: 'Network error: ${error.description}',
                    )
                  : false,
            );
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          log('onNavigationRequest request.url ${request.url}');
          _checkPaymentResult(request.url);
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  void _checkPaymentResult(String url) {
    if (_hasNavigatedBack) return; // Prevent multiple callbacks

    final lowerUrl = url.toLowerCase();

    // Define success patterns based on payment type
    final List<String> successPatterns = _getSuccessPatterns();
    final List<String> failurePatterns = ['failure', 'cancel', 'error', 'declined'];

    // Extract order_id and other relevant parameters
    String? orderId;
    String? errorMessage;

    if (widget.paymentType == null) {
      try {
        final uri = Uri.parse(url);
        // Handle both order_id[0] and order_id formats
        orderId = uri.queryParameters['order_id[0]'] ??
            uri.queryParameters['order_id'] ??
            uri.queryParameters['orderid']; // Some gateways use different formats

        if (orderId != null) {
          log('Extracted order_id: $orderId from URL: $url');
        }

        // Check for error codes in URL parameters
        final status = uri.queryParameters['status'];
        final error = uri.queryParameters['error'];
        if (error != null) {
          errorMessage = error;
        }
      } catch (e) {
        log('Error parsing URL for order_id: $e');
        errorMessage = 'URL parsing error: $e';
      }
    }

    // Check for success patterns
    for (final String pattern in successPatterns) {
      if (lowerUrl.contains(pattern)) {
        log('Payment successful - found pattern: $pattern in URL: $url');
        _handlePaymentResult(
          widget.paymentType == null ? PaymentResult(isSuccess: true, orderId: orderId) : true,
        );
        return;
      }
    }

    // Check for failure patterns
    for (final String pattern in failurePatterns) {
      if (lowerUrl.contains(pattern)) {
        log('Payment failed - found pattern: $pattern in URL: $url');
        _handlePaymentResult(
          widget.paymentType == null
              ? PaymentResult(
                  isSuccess: false,
                  orderId: orderId,
                  errorMessage: errorMessage ?? 'Payment failed',
                )
              : false,
        );
        return;
      }
    }

    // Additional success checks
    if (_checkAdditionalSuccessConditions(lowerUrl)) {
      log('Payment successful - additional success conditions met for URL: $url');
      _handlePaymentResult(
        widget.paymentType == null ? PaymentResult(isSuccess: true, orderId: orderId) : true,
      );
      return;
    }

    // Check for specific failure status codes
    if (_checkFailureConditions(lowerUrl)) {
      log('Payment failed - failure conditions detected in URL: $url');
      _handlePaymentResult(
        widget.paymentType == null
            ? PaymentResult(
                isSuccess: false,
                orderId: orderId,
                errorMessage: errorMessage ?? 'Payment declined',
              )
            : false,
      );
      return;
    }
  }

  List<String> _getSuccessPatterns() {
    switch (widget.paymentType) {
      case 'subscription':
        return ['subsuccess', 'sub_success', 'success'];
      case 'gift_card':
        return ['giftcardsuccess', 'giftcard_success', 'success'];
      default:
        return ['success'];
    }
  }

  bool _checkAdditionalSuccessConditions(String lowerUrl) {
    // Existing success conditions
    if (lowerUrl.contains('join-us-as-seller')) return true;
    if (lowerUrl.contains('status=9') || lowerUrl.contains('status=success')) return true;

    // Telr specific success conditions
    if (lowerUrl.contains('telr') && (lowerUrl.contains('acceptance=') || lowerUrl.contains('payid='))) {
      return true;
    }

    // Add more payment gateway specific success conditions here
    // For example:
    // PayPal: if (lowerUrl.contains('paypal') && lowerUrl.contains('payment_status=completed'))
    // Stripe: if (lowerUrl.contains('stripe') && lowerUrl.contains('payment_intent_client_secret'))

    return false;
  }

  bool _checkFailureConditions(String lowerUrl) {
    // Check for specific failure status codes
    if (lowerUrl.contains('status=0') || lowerUrl.contains('status=failed') || lowerUrl.contains('status=declined')) {
      return true;
    }

    // Add more gateway-specific failure conditions
    return false;
  }

  Future<void> _clearCartAndRefreshProviders() async {
    final token = await SecurePreferencesUtil.getToken();

    // Clear cart provider
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    // Optimistic clear to update app bar badge immediately
    cartProvider.clearCartLocally();

    // Then fetch from server to be sure
    await cartProvider.fetchCartData(token ?? '', context);

    // // Simple clear of orders - let user refresh when they visit orders page
    // final orderProvider = Provider.of<OrderDataProvider>(context, listen: false);
    // orderProvider.clearOrders();
  }

  Future<void> _handlePaymentResult(result) async {
    if (_hasNavigatedBack) return; // Prevent duplicate calls
    if (!mounted || !Navigator.canPop(context)) return;

    _hasNavigatedBack = true; // Set flag to prevent multiple navigation's

    // Add a small delay to ensure WebView operations complete
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    // Handle different payment types
    if (widget.paymentType == null) {
      // Regular payment from PaymentScreen
      if (result is PaymentResult && result.isSuccess) {
        // Clear cart and refresh providers
        await _clearCartAndRefreshProviders();

        if (mounted) {
          // Navigate directly to BaseHomeScreen with orderId
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BaseHomeScreen(
                shouldNavigateToOrders: true,
                orderId: result.orderId,
              ),
            ),
            (route) => false,
          );
        }
      } else {
        // Payment failed or cancelled - go back to PaymentScreen
        if (Navigator.canPop(context)) {
          Navigator.pop(context, result);
        }
      }
    } else {
      // Gift card or subscription payment - just pop with result
      if (Navigator.canPop(context)) {
        Navigator.pop(context, result);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (_hasNavigatedBack) return false;

    // Show confirmation dialog for manual back press
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        title: Text(AppStrings.confirmPaymentCancel.tr),
        content: Text(AppStrings.paymentCancelWarning.tr),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(AppStrings.continuePayment.tr),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(AppStrings.cancelPayment.tr),
                ),
              ),
            ],
          )
        ],
      ),
    );

    if (shouldPop == true) {
      _handlePaymentResult(
        widget.paymentType == null
            ? PaymentResult(
                isSuccess: false,
                orderId: null,
                errorMessage: 'Payment cancelled by user',
              )
            : false,
      );
    }

    return false; // Always return false since we handle navigation manually
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Handle pop manually
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _onWillPop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.payment.tr),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await _onWillPop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                if (!_hasNavigatedBack) {
                  _controller.reload();
                }
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
