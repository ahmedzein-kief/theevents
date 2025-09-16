import 'package:event_app/views/product_detail_screens/product_image_screen.dart';
import 'package:event_app/views/product_detail_screens/product_information_screen.dart';
import 'package:flutter/material.dart';

// Separate widget for Product Header (Images and Info)
class ProductHeaderSection extends StatelessWidget {
  final String? selectedImageUrl;
  final double screenWidth;
  final dynamic record;
  final dynamic images;
  final String productPrice;
  final String offPercentage;
  final Function(String?) onImageUpdate;

  const ProductHeaderSection({
    super.key,
    required this.selectedImageUrl,
    required this.screenWidth,
    required this.record,
    required this.images,
    required this.productPrice,
    required this.offPercentage,
    required this.onImageUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductImageScreen(
          selectedImageUrl: selectedImageUrl,
          screenWidth: screenWidth,
          onImageUpdate: onImageUpdate,
          record: record,
          images: images,
        ),
        ProductInformationScreen(
          productPrice: productPrice,
          selectedImageUrl: selectedImageUrl,
          screenWidth: screenWidth,
          onImageUpdate: onImageUpdate,
          record: record,
          images: images,
          offPercentage: offPercentage,
        ),
      ],
    );
  }
}
