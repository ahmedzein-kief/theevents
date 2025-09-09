import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_strings.dart';

class PaymentViewScreen extends StatefulWidget {
  const PaymentViewScreen({
    super.key,
    required this.checkoutUrl,
    this.paymentType, // Add payment type parameter
  });

  final String checkoutUrl;
  final String? paymentType; // 'subscription' or null for regular payments

  @override
  State<PaymentViewScreen> createState() => PaymentViewState();
}

class PaymentViewState extends State<PaymentViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      // Enable zoom controls and gestures
      ..enableZoom(true)
      // Set user agent to mobile
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

          // Check for payment result based on URL
          _checkPaymentResult(url);
        },
        onPageFinished: (String url) {
          setState(() {
            _isLoading = false;
          });

          // Check again on page finish in case we missed it
          _checkPaymentResult(url);

          // Inject CSS to make the page mobile-responsive
          _controller.runJavaScript('''
            (function() {
              // Add viewport meta tag if it doesn't exist
              var viewport = document.querySelector("meta[name=viewport]");
              if (!viewport) {
                var meta = document.createElement('meta');
                meta.name = 'viewport';
                meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes';
                document.getElementsByTagName('head')[0].appendChild(meta);
              }
              
              // Add responsive CSS
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
          // You can add a progress indicator here if needed
        },
        onWebResourceError: (WebResourceError error) {
          log('WebView error: ${error.description}');
        },
        onNavigationRequest: (NavigationRequest request) {
          log('onNavigationRequest request.url ${request.url}');

          // Check for payment result
          _checkPaymentResult(request.url);

          // Allow navigation to continue
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  void _checkPaymentResult(String url) {
    // Convert URL to lowercase for case-insensitive checking
    final lowerUrl = url.toLowerCase();

    // Determine success patterns based on payment type
    List<String> successPatterns = [];
    final List<String> failurePatterns = ['failure', 'cancel', 'error'];

    if (widget.paymentType == 'subscription') {
      // For subscription payments, look for subSuccess
      successPatterns = ['subsuccess', 'sub_success', 'success'];
    } else if (widget.paymentType == 'gift_card') {
      // For gift card payments, look for giftCardSuccess
      successPatterns = ['giftcardsuccess', 'giftcard_success', 'success'];
    } else {
      // For regular payments, look for success
      successPatterns = ['success'];
    }

    // Check for success patterns
    for (final String pattern in successPatterns) {
      if (lowerUrl.contains(pattern)) {
        log('Payment successful - found pattern: $pattern in URL: $url');
        _handlePaymentResult(true);
        return;
      }
    }

    // Check for failure patterns
    for (final String pattern in failurePatterns) {
      if (lowerUrl.contains(pattern)) {
        log('Payment failed - found pattern: $pattern in URL: $url');
        _handlePaymentResult(false);
        return;
      }
    }

    // Additional check for specific redirect URLs
    // Check if redirecting to join-us-as-seller (which typically indicates success)
    if (lowerUrl.contains('join-us-as-seller')) {
      log('Payment successful - redirecting to join-us-as-seller');
      _handlePaymentResult(true);
      return;
    }

    // Check for payment gateway success status parameters
    if (lowerUrl.contains('status=9') || lowerUrl.contains('status=success')) {
      log('Payment successful - status indicates success');
      _handlePaymentResult(true);
      return;
    }

    // Check for specific telr success patterns
    if (lowerUrl.contains('telr') && (lowerUrl.contains('acceptance=') || lowerUrl.contains('payid='))) {
      log('Payment successful - Telr success parameters detected');
      _handlePaymentResult(true);
      return;
    }
  }

  Future<void> _handlePaymentResult(bool isSuccess) async {
    // Small delay to allow backend to finalize cart clearing
    await Future.delayed(const Duration(seconds: 2));

    // Ensure we only pop once
    if (mounted && Navigator.canPop(context)) {
      log('Handling payment result: ${isSuccess ? "SUCCESS" : "FAILURE"}');
      Navigator.pop(context, isSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.payment.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle manual back press as cancelled payment
            Navigator.pop(context, false);
          },
        ),
        actions: [
          // Add refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          // If user uses system back button, treat as cancelled
          if (didPop && result == null) {
            Navigator.pop(context, false);
          }
        },
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
