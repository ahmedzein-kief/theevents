import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../styles/custom_text_styles.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem(
      {super.key,
      required this.imagePath,
      required this.title,
      this.textWidth,
      this.onTap,
      this.routeName,
      this.arguments,
      this.width,
      this.height});
  final String imagePath;
  final String title;
  final VoidCallback? onTap;
  final String? routeName; // Add routeName as a parameter
  final Map<String, dynamic>? arguments; // Add arguments (optional)
  final double? width;
  final double? textWidth;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          Navigator.pushNamed(
            context,
            routeName ?? '',
            arguments: arguments ?? {'title': title}, // Pass arguments
          );
        }
      },
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 30,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                width: width ?? 30, // Default width is 30
                height: height ?? 30, // Default height is 30
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              SizedBox(width: textWidth ?? screenHeight * 0.02),
              Text(
                title,
                style:
                    profileItems(context), // Assuming this is defined elsewhere
              ),
            ],
          ),
        ),
      ),
    );
  }
}
