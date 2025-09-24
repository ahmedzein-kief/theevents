import 'package:flutter/material.dart';

import 'fund_expiry_header.dart';
import 'fund_expiry_list.dart';

class FundExpiryContent extends StatelessWidget {
  const FundExpiryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FundExpiryHeader(),
          SizedBox(height: 24),
          Expanded(child: FundExpiryList()),
        ],
      ),
    );
  }
}
