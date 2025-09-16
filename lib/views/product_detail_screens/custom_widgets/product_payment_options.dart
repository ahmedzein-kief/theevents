import 'package:flutter/material.dart';

// Separate widget for Payment Options
class ProductPaymentOptions extends StatelessWidget {
  const ProductPaymentOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        right: 20,
        left: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Image.asset(
              'assets/tabby.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Image.asset(
              'assets/tamara.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
