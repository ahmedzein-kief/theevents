import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_strings.dart';
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
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(true)
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      );

    // Configure WebView settings for better compatibility
    _controller.runJavaScript('''
    // Disable WebGL to prevent context limit errors
    HTMLCanvasElement.prototype.getContext = (function(originalGetContext) {
      return function(contextType, contextAttributes) {
        if (contextType === 'webgl' || contextType === 'webgl2' || contextType === 'experimental-webgl') {
          return null;
        }
        return originalGetContext.call(this, contextType, contextAttributes);
      };
    })(HTMLCanvasElement.prototype.getContext);
  ''').catchError((e) => log('WebGL disable error: $e'));

    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          if (mounted) {
            setState(() => _isLoading = true);
          }
          _checkPaymentResult(url);
        },
        onPageFinished: (String url) {
          if (mounted) {
            setState(() => _isLoading = false);
          }
          _checkPaymentResult(url);

          // Simplified CSS injection
          _controller.runJavaScript('''
          (function() {
            try {
              var meta = document.createElement('meta');
              meta.name = 'viewport';
              meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0';
              document.head.appendChild(meta);
              
              var style = document.createElement('style');
              style.textContent = 'body { -webkit-text-size-adjust: 100%; }';
              document.head.appendChild(style);
            } catch(e) {
              console.log('CSS injection error:', e);
            }
          })();
        ''').catchError((e) => log('JS injection error: $e'));
        },
        onProgress: (int progress) {},
        onWebResourceError: (WebResourceError error) {
          // Only handle critical errors

          if (error.errorType == WebResourceErrorType.hostLookup || error.errorType == WebResourceErrorType.timeout) {
            if (!_hasNavigatedBack && mounted) {
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
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          _checkPaymentResult(request.url);
          return NavigationDecision.navigate;
        },
        onHttpAuthRequest: (HttpAuthRequest request) {
          // Let WebView handle auth normally
        },
      ),
    );

    // Load URL
    _controller.loadRequest(Uri.parse(widget.checkoutUrl)).catchError((error) {
      if (mounted && !_hasNavigatedBack) {
        _handlePaymentResult(
          widget.paymentType == null
              ? PaymentResult(
                  isSuccess: false,
                  orderId: null,
                  errorMessage: 'Failed to load payment page',
                )
              : false,
        );
      }
    });
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

        if (orderId != null) {}

        // Check for error codes in URL parameters
        final error = uri.queryParameters['error'];
        if (error != null) {
          errorMessage = error;
        }
      } catch (e) {
        errorMessage = 'URL parsing error: $e';
      }
    }

    // Check for success patterns
    for (final String pattern in successPatterns) {
      if (lowerUrl.contains(pattern)) {
        _handlePaymentResult(
          widget.paymentType == null ? PaymentResult(isSuccess: true, orderId: orderId) : true,
        );
        return;
      }
    }

    // Check for failure patterns
    for (final String pattern in failurePatterns) {
      if (lowerUrl.contains(pattern)) {
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
      _handlePaymentResult(
        widget.paymentType == null ? PaymentResult(isSuccess: true, orderId: orderId) : true,
      );
      return;
    }

    // Check for specific failure status codes
    if (_checkFailureConditions(lowerUrl)) {
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
      case 'wallet':
        return ['wallettopupSuccess', 'success'];
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

    return false;
  }

  bool _checkFailureConditions(String lowerUrl) {
    // Check for specific failure status codes
    if (lowerUrl.contains('status=0') || lowerUrl.contains('status=failed') || lowerUrl.contains('status=declined')) {
      return true;
    }

    return false;
  }

  Future<void> _clearCartAndRefreshProviders() async {
    try {
      // Clear cart provider
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      // Optimistic clear to update app bar badge immediately
      cartProvider.clearCartLocally();

      // Then fetch from server to be sure
      await cartProvider.fetchCartData();
    } catch (error) {
      debugPrint(error.toString());
    }
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
        // Payment failed or cancelled - go back with result
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context, result);
        }
      }
    } else {
      // Gift card or subscription payment - just pop with result
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context, result);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (_hasNavigatedBack) return false;

    // Show confirmation dialog for manual back press
    final shouldPop = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.sentiment_very_dissatisfied,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.paymentCancelWarning.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black54,
                        backgroundColor: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        AppStrings.no.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        AppStrings.yes.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
                if (!_hasNavigatedBack && mounted) {
                  _controller.reload();
                }
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hasNavigatedBack = true; // Prevent any pending callbacks
    super.dispose();
  }
}
