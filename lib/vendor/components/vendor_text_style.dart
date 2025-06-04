import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle joinSeller() => GoogleFonts.inter(
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
    fontSize: 20,
    fontWeight: FontWeight.w600);

TextStyle vendorDescription() => const TextStyle(
      fontSize: 12,
      overflow: TextOverflow.visible,
      fontFamily: 'FontSf',
      fontWeight: FontWeight.w300,
    );

TextStyle vendorDescriptionAgreement() =>
    GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w300);

TextStyle signHere() => GoogleFonts.inter(
    fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold);

TextStyle agreementAccept() => GoogleFonts.inter(
    fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold);

TextStyle headingFields() => GoogleFonts.inter(
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
    fontSize: 15,
    fontWeight: FontWeight.w500);

TextStyle loginHeading() => GoogleFonts.inter(
    textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
    fontSize: 18,
    fontWeight: FontWeight.w600);

TextStyle VendorAuth() =>
    GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500);

TextStyle vendorBusinessInfo() =>
    GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500);

TextStyle paymentHeading() =>
    GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600);

TextStyle congratulations() => GoogleFonts.inter(
    fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold);

TextStyle paymentDesc() => GoogleFonts.inter(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      fontWeight: FontWeight.w400,
    );

TextStyle vendorPayment() => GoogleFonts.inter(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Colors.green,
      fontWeight: FontWeight.bold,
    );

TextStyle vendorName(context) => TextStyle(
      fontSize: 20,
      overflow: TextOverflow.visible,
      fontFamily: 'FontSf',
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w300,
    );

TextStyle vendorButtonText(context) => const TextStyle(
      fontSize: 16,
      overflow: TextOverflow.visible,
      fontFamily: 'FontSf',
      color: AppColors.lightCoral,
      fontWeight: FontWeight.w300,
    );

TextStyle vendorJoinDate(context) => GoogleFonts.inter(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w400,
    );

TextStyle vendorDrawer(context) => GoogleFonts.montserrat(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w700,
    );

TextStyle vendorDashBoard(context) => GoogleFonts.montserrat(
      fontSize: 12,
      textStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
      ),
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w400,
    );

TextStyle vendorDashBoardPrices(context) => GoogleFonts.montserrat(
      fontSize: 17,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w700,
    );

TextStyle vendorNewProduct(context) => GoogleFonts.inter(
      fontSize: 13,
      textStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
      ),
      color: Colors.green,
      fontWeight: FontWeight.w400,
    );

TextStyle vendorNoProduct(context) => GoogleFonts.inter(
      fontSize: 13,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Colors.blue,
      fontWeight: FontWeight.w400,
    );

TextStyle vendorNewProducts(context) => GoogleFonts.inter(
      fontSize: 13,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Colors.red,
      fontWeight: FontWeight.w400,
    );

// TextStyle vendorCxProducts(context) {
//   return GoogleFonts.inter(
//       fontSize: 10,
//       textStyle: const TextStyle(
//         overflow: TextOverflow.visible,
//       ),
//       color: Colors.green,
//       fontWeight: FontWeight.w600);
// }

// TextStyle vendorEvents(context) {
//   return GoogleFonts.inter(
//       fontSize: 15,
//       textStyle: const TextStyle(
//         overflow: TextOverflow.visible,
//       ),
//       color: Colors.green,
//       fontWeight: FontWeight.w600);
// }

TextStyle vendorProductsNone(context) => GoogleFonts.inter(
      fontSize: 15,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Colors.blue,
      fontWeight: FontWeight.w600,
    );

TextStyle vendorDate(context) => GoogleFonts.montserrat(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: AppColors.peachyPink,
      fontWeight: FontWeight.w400,
    );

TextStyle vendorSell(context) => GoogleFonts.inter(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w600,
    );

TextStyle views(context) => GoogleFonts.inter(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: VendorColors.views,
      fontWeight: FontWeight.w600,
    );

TextStyle subtitleTextStyle(context) => const TextStyle(
      fontSize: 12,
      color: Colors.grey,
      fontWeight: FontWeight.w400,
      height: 2,
    );

class VendorColors {
  static const Color vendorDashboard = Color(0xFFFCF9EF);
  static const Color peachColor = Color(0xFFF9ECE5);
  static const Color pastelGreenColor = Color(0xFFF0F5E7);
  static const Color pastelPinkColor = Color(0xFFFFEEFF);
  static const Color productHeading = Color(0xFFECE6F0);
  static const Color views = Color(0xFF2200CC);
  static const Color vendorAppBackground =
      Color(0xFFF0F2F5); // Manually adjusted to be lighter
  static const Color editColor =
      Color(0xFFFCBA03); // Manually adjusted to be lighter
}
