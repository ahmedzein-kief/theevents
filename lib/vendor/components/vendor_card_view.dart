import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionText;
  final String createText;
  final VoidCallback? onTap;
  final Color containerColor;

  // Added parameters for text styles and icon
  final TextStyle actionTextHere;
  final IconData iconData;
  final Color iconColor;

  const VendorCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.actionTextHere,
    required this.containerColor,
    required this.createText,
    this.actionText = 'here',
    this.onTap,
    this.iconData = Icons.check, // Default icon
    this.iconColor = Colors.white, // Default icon color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border(
              left: BorderSide(color: Colors.blue, width: 3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: containerColor,
                      ),
                      child: Icon(iconData, size: 16, color: iconColor),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        softWrap: true,
                        style: GoogleFonts.inter(fontSize: 15, textStyle: const TextStyle(overflow: TextOverflow.ellipsis), color: Colors.green, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox.square(dimension: 15),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    subtitle,
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        textStyle: const TextStyle(
                          overflow: TextOverflow.visible,
                        ),
                        color: Colors.green,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  color: Colors.grey.withOpacity(0.2),
                  height: 1,
                  width: screenWidth,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: createText,
                              style: vendorNewProduct(context),
                            ),
                            TextSpan(
                              text: actionText,
                              style: vendorNewProducts(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
