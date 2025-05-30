import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import '../../styles/custom_text_styles.dart';

class CustomProfileText extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color? iconColor;
  final Function() onTap;

  CustomProfileText({required this.title, required this.imagePath, this.iconColor = Colors.grey, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(imagePath, width: 21, height: 21, color: Theme.of(context).colorScheme.onPrimary),
                    const SizedBox(width: 16),
                    Text(title, style: profileItems(context)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
