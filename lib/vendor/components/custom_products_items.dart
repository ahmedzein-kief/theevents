import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

/// Custom class for product item
class VendorProductView extends StatelessWidget {
  const VendorProductView({
    super.key,
    required this.id,
    required this.productName,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.imageUrl,
    this.backgroundColor = Colors.white, // default background color
    this.headingColor = Colors.grey, // default heading color
  });

  final String id;
  final String productName;
  final String amount;
  final String status;
  final String createdAt;
  final Color backgroundColor;
  final Color headingColor;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Container(
              height: 50,
              width: screenWidth,
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(id),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        imageUrl, // Add the image URL
                        height: 30, // Define the height
                        width: 30, // Define the width
                        fit: BoxFit.cover,
                      ),
                      // Icon(Icons.add),
                      Text(productName),
                    ],
                  ),
                  Text(amount),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.green,
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                    child: Text(status),
                  ),
                  Text(createdAt),
                ],
              ),
            ),
            Container(color: Colors.grey, height: 1, width: screenWidth),
          ],
        ),
      ),
    );
  }
}

/// Custom heading widget
class ProductListHeader extends StatelessWidget {
  const ProductListHeader({
    super.key,
    this.headingColor = Colors.grey, // default heading color
  });

  final Color headingColor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: Container(
        height: 50,
        width: screenWidth,
        color: headingColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(VendorAppStrings.id.tr),
            Text(VendorAppStrings.product.tr),
            Text(VendorAppStrings.amountHeader.tr),
            Text(VendorAppStrings.status.tr),
            Text(VendorAppStrings.createdAt.tr),
          ],
        ),
      ),
    );
  }
}
