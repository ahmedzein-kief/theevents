import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle joinSeller() {
  return GoogleFonts.inter(textStyle: const TextStyle(overflow: TextOverflow.ellipsis), fontSize: 20, fontWeight: FontWeight.w600);
}

TextStyle vendorDescription() {
  return const TextStyle(
    fontSize: 12,
    overflow: TextOverflow.visible,
    fontFamily: "FontSf",
    fontWeight: FontWeight.w300,
  );
}

TextStyle vendorDescriptionAgreement() {
  return GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w300);
}

TextStyle signHere() {
  return GoogleFonts.inter(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold);
}

TextStyle agreementAccept() {
  return GoogleFonts.inter(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold);
}

TextStyle headingFields() {
  return GoogleFonts.inter(textStyle: const TextStyle(overflow: TextOverflow.ellipsis), fontSize: 15, fontWeight: FontWeight.w500);
}

TextStyle loginHeading() {
  return GoogleFonts.inter(textStyle: const TextStyle(overflow: TextOverflow.ellipsis), fontSize: 18, fontWeight: FontWeight.w600);
}

TextStyle VendorAuth() {
  return GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500);
}

TextStyle vendorBusinessInfo() {
  return GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500);
}

TextStyle paymentHeading() {
  return GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600);
}

TextStyle congratulations() {
  return GoogleFonts.inter(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold);
}

TextStyle paymentDesc() {
  return GoogleFonts.inter(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      fontWeight: FontWeight.w400);
}

TextStyle vendorPayment() {
  return GoogleFonts.inter(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Colors.green,
      fontWeight: FontWeight.bold);
}

TextStyle vendorName(context) {
  return TextStyle(
    fontSize: 20,
    overflow: TextOverflow.visible,
    fontFamily: "FontSf",
    color: Theme.of(context).colorScheme.onPrimary,
    fontWeight: FontWeight.w300,
  );
}

TextStyle vendorButtonText(context) {
  return TextStyle(
    fontSize: 16,
    overflow: TextOverflow.visible,
    fontFamily: "FontSf",
    color: AppColors.lightCoral,
    fontWeight: FontWeight.w300,
  );
}

TextStyle vendorJoinDate(context) {
  return GoogleFonts.inter(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w400);
}

TextStyle vendorDrawer(context) {
  return GoogleFonts.montserrat(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w700);
}

TextStyle vendorDashBoard(context) {
  return GoogleFonts.montserrat(
      fontSize: 12,
      textStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
      ),
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w400);
}

TextStyle vendorDashBoardPrices(context) {
  return GoogleFonts.montserrat(
      fontSize: 17,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w700);
}

TextStyle vendorNewProduct(context) {
  return GoogleFonts.inter(
      fontSize: 13,
      textStyle: const TextStyle(
        overflow: TextOverflow.ellipsis,
      ),
      color: Colors.green,
      fontWeight: FontWeight.w400);
}

TextStyle vendorNoProduct(context) {
  return GoogleFonts.inter(
      fontSize: 13,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Colors.blue,
      fontWeight: FontWeight.w400);
}

TextStyle vendorNewProducts(context) {
  return GoogleFonts.inter(
      fontSize: 13,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Colors.red,
      fontWeight: FontWeight.w400);
}

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

TextStyle vendorProductsNone(context) {
  return GoogleFonts.inter(
      fontSize: 15,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Colors.blue,
      fontWeight: FontWeight.w600);
}

TextStyle vendorDate(context) {
  return GoogleFonts.montserrat(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: AppColors.peachyPink,
      fontWeight: FontWeight.w400);
}

TextStyle vendorSell(context) {
  return GoogleFonts.inter(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: Theme.of(context).colorScheme.onPrimary,
      fontWeight: FontWeight.w600);
}

TextStyle views(context) {
  return GoogleFonts.inter(
      fontSize: 14,
      textStyle: const TextStyle(
        overflow: TextOverflow.visible,
      ),
      color: VendorColors.views,
      fontWeight: FontWeight.w600);
}

TextStyle subtitleTextStyle(context) {
  return TextStyle(
    fontSize: 12,
    color: Colors.grey,
    fontWeight: FontWeight.w400,
    height: 2,
  );
}

class VendorColors {
  static const Color vendorDashboard = Color(0xFFFCF9EF);
  static const Color peachColor = Color(0xFFF9ECE5);
  static const Color pastelGreenColor = Color(0xFFF0F5E7);
  static const Color pastelPinkColor = Color(0xFFFFEEFF);
  static const Color productHeading = Color(0xFFECE6F0);
  static const Color views = Color(0xFF2200CC);
  static const Color vendorAppBackground = Color(0xFFF0F2F5); // Manually adjusted to be lighter
  static const Color editColor = Color(0xFFFCBA03); // Manually adjusted to be lighter
}
