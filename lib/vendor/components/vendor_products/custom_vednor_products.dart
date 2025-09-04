import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:flutter/material.dart';

class VendorProductsView extends StatelessWidget {
  const VendorProductsView({
    super.key,
    required this.id,
    this.onEdit,
    this.comment,
    this.showActions = true,
    this.onDelete,
    required this.productName,
    required this.amount,
    required this.createdAt,
    required this.imageUrl,
  });
  final String id;
  final String productName;
  final String amount;
  final String createdAt;
  final String imageUrl;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;
  final String? comment;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.001,
                left: screenWidth * 0.03,
                right: screenHeight * 0.02,
                bottom: screenHeight * 0.001,),
            child: Column(
              children: [
                Container(
                  height: 45,
                  width: screenWidth,
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(id),
                      Image.asset(
                        imageUrl, // Add the image URL
                        height: 30, // Define the height
                        width: 30, // Define the width
                        fit: BoxFit.cover,
                      ),
                      Text(productName),
                      if (showActions)
                        Row(
                          children: [
                            GestureDetector(
                              onTap: onEdit,
                              child: Container(
                                  color: VendorColors.editColor,
                                  width: 30,
                                  height: 30,
                                  child: const Icon(Icons.edit,
                                      size: 20, color: Colors.white,),),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                                onTap: onDelete,
                                child: Container(
                                    color: Colors.red,
                                    width: 30,
                                    height: 30,
                                    child: const Icon(Icons.delete,
                                        size: 20, color: Colors.white,),),),
                          ],
                        )
                      else
                        Text(comment ?? ''),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(color: Colors.grey.shade200, height: 1, width: screenWidth),
        ],
      ),
    );
  }
}

// Container(color: Colors.grey,height: 1,width: screenWidth)
