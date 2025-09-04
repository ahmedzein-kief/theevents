import 'package:event_app/models/dashboard/information_icons_models/gift_card_models/gift_card_models.dart';
import 'package:flutter/material.dart';

class GiftCardHeader extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final Data? data;
  final String? giftCard;

  const GiftCardHeader({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    this.data,
    this.giftCard,
  });

  @override
  Widget build(BuildContext context) {
    final String coverImage = data?.coverImage ?? '';

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            coverImage,
            height: screenHeight * 0.15,
            width: screenWidth,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 40), // fallback
          ),
        ),
        Text(giftCard ?? ''),
      ],
    );
  }
}
