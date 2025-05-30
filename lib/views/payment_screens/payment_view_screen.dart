import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentViewScreen extends StatefulWidget {
  final String checkoutUrl;

  const PaymentViewScreen({Key? key, required this.checkoutUrl}) : super(key: key);

  @override
  State<PaymentViewScreen> createState() => PaymentViewState();
}

class PaymentViewState extends State<PaymentViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.checkoutUrl));

    _controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {
          // Check for success or failure URL
          if (url.contains('success')) {
            Navigator.pop(context, true); // Pop with success result
          } else if (url.contains('failure')) {
            Navigator.pop(context, false); // Pop with failure result
          }
        },
        onPageFinished: (String url) {
        },
        onProgress: (int progress) {
        },
        onWebResourceError: (WebResourceError error) {
        },
        onNavigationRequest: (NavigationRequest request) {
          // Optionally block certain URLs
          if (request.url.contains('block-this-url')) {
            return NavigationDecision.prevent;
          }

          if (request.url.contains('success')) {
            Navigator.pop(context, true); // Pop with success result
          }
          if (request.url.toLowerCase().contains('failure') || request.url.toLowerCase().contains('cancel')) {
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
        title: const Text("Payment"),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
