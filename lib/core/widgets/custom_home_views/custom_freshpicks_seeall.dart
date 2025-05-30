import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';

class ImageTextView extends StatelessWidget {
  final String imageUrl;
  final String text;
  final VoidCallback onTap;
  final TextStyle textStyle;

  const ImageTextView({
    Key? key,
    required this.imageUrl,
    required this.text,
    required this.onTap,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(color: AppColors.freshItemsBack),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
        Text(text, softWrap: true, maxLines: 1, textAlign: TextAlign.center, style: textStyle),
      ],
    );
  }
}
