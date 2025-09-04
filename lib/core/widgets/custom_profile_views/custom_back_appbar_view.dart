import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BackAppBarStyle extends StatelessWidget {
  const BackAppBarStyle({
    super.key,
    this.icon, // Optional Icon
    this.text, // Optional Text
    this.goBack, // Optional function to handle back button click event
  });
  final IconData? icon;
  final String? text;
  final Function()? goBack;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02,),
          child: GestureDetector(
            onTap: goBack ??
                () => Navigator.pop(
                    context,), // Navigate back to the previous screen,
            child: Row(
              children: [
                if (icon != null)
                  Icon(icon, size: 20.0), // Customize icon size as needed
                if (icon != null) const SizedBox(width: 4),
                if (text != null)
                  Text(
                    text!,
                    style: GoogleFonts.inter(
                        fontSize: 18.0,
                        fontWeight:
                            FontWeight.w400,), // Customize text style as needed
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
