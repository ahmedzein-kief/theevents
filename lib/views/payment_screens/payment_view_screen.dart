import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_strings.dart';

class PaymentViewScreen extends StatefulWidget {
  const PaymentViewScreen({super.key, required this.checkoutUrl});

  final String checkoutUrl;

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
          'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',)
      ..loadRequest(Uri.parse(widget.checkoutUrl));

    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          log('onPageStarted url $url');
          setState(() {
            _isLoading = true;
          });

          // Check for success or failure URL
          if (url.contains('success')) {
            Navigator.pop(context, true); // Pop with success result
          } else if (url.contains('failure')) {
            Navigator.pop(context, false); // Pop with failure result
          }
        },
        onPageFinished: (String url) {
          setState(() {
            _isLoading = false;
          });

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

          // Optionally block certain URLs
          if (request.url.contains('block-this-url')) {
            return NavigationDecision.prevent;
          }

          if (request.url.contains('success')) {
            Navigator.pop(context, true); // Pop with success result
          }
          if (request.url.toLowerCase().contains('failure') ||
              request.url.toLowerCase().contains('cancel')) {
            Navigator.pop(context, false); // Pop with failure result
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.payment.tr),
        actions: [
          // Add refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
