import 'package:event_app/models/dashboard/information_icons_models/gift_card_models/gift_card_models.dart';
import 'package:flutter/material.dart';

class GiftCardHeader extends StatelessWidget {
  double screenHeight;
  double screenWidth;
  final Data? data;
  final String? giftCard;

  GiftCardHeader({
    required this.screenHeight,
    required this.screenWidth,
    this.data,
    this.giftCard,
  });

  @override
  Widget build(BuildContext context) {
    var coverImage;

    if (data == null) {
      coverImage = "";
    } else {
      coverImage = data?.coverImage;
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            height: screenHeight * 0.15,
            width: screenWidth,
            fit: BoxFit.cover,
            coverImage,
          ),
        ),
        Text(giftCard ?? '')
      ],
    );
  }
}
