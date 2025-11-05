import 'dart:io';
import 'dart:typed_data';

import 'package:event_app/core/constants/app_assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../models/vendor_models/response_models/subscription_package_response.dart';
import '../../provider/vendor/vendor_sign_up_provider.dart';

Future<void> generateAgreementPdf(
  Map<String, dynamic> vendorData,
  SubscriptionPackageResponse? subscriptionResponse,
) async {
  try {
    // 1. Load the existing PDF template from assets
    final templateBytes = await rootBundle.load(AppAssets.vendorAgreementPdf);
    final Uint8List templateData = templateBytes.buffer.asUint8List();

    // 2. Load the PDF document
    final PdfDocument document = PdfDocument(inputBytes: templateData);

    // 3. Get the form from the PDF
    final PdfForm form = document.form;

    // 4. Fill the form fields (adjust field names according to your PDF)
    if (form.fields.count > 0) {
      // Fill form fields by name
      _fillFormField(
        form,
        'company_name',
        vendorData['company_display_name'] ?? '',
      );
      _fillFormField(form, 'company_type', vendorData['company_type'] ?? '');
      _fillFormField(form, 'company_email', vendorData['company_email'] ?? '');

      // Add more fields as needed based on your PDF form field names
    } else {
      // If no form fields, add text annotations or create overlay
      await _addTextOverlay(document, vendorData, subscriptionResponse);
    }

    // 5. Save the document
    final List<int> bytes = await document.save();
    document.dispose();

    // 6. Save to file
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/Vendor_Agreement.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    // 7. Open file
    await OpenFile.open(filePath);
  } catch (e) {
    rethrow;
  }
}

void _fillFormField(PdfForm form, String fieldName, String value) {
  try {
    // Search through fields manually
    for (int i = 0; i < form.fields.count; i++) {
      final field = form.fields[i];
      if (field.name == fieldName) {
        if (field is PdfTextBoxField) {
          field.text = value;
        }
        break;
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> _addTextOverlay(
  PdfDocument document,
  Map<String, dynamic> vendorData,
  SubscriptionPackageResponse? subscriptionResponse,
) async {
  // Load Arabic font
  final ByteData arabicFontData = await rootBundle.load(AppAssets.amiriRegular);
  final PdfTrueTypeFont arabicFont = PdfTrueTypeFont(arabicFontData.buffer.asUint8List(), 10);
  final PdfTrueTypeFont arabicBoldFont =
      PdfTrueTypeFont(arabicFontData.buffer.asUint8List(), 10, style: PdfFontStyle.bold);

  // Standard fonts for fallback (English text)
  final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);
  final PdfFont boldFont = PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

  // If there are no form fields, add text as overlay
  final PdfPage page = document.pages[0];
  final PdfGraphics graphics = page.graphics;

  // Helper function to detect if text contains Arabic characters
  bool containsArabic(String text) {
    if (text.isEmpty) return false;
    return text.runes.any((rune) => rune >= 0x0600 && rune <= 0x06FF);
  }

  // Helper function to draw text with appropriate font
  void drawText(String text, double x, double y, double width, double height, {bool isBold = false}) {
    if (text.isEmpty) return;

    final isArabic = containsArabic(text);
    final selectedFont = isArabic ? (isBold ? arabicBoldFont : arabicFont) : (isBold ? boldFont : font);

    debugPrint('Drawing text: "$text" at ($x, $y) with ${isArabic ? "Arabic" : "English"} font');

    // For Arabic text, use RTL direction
    final format = PdfStringFormat(
      lineAlignment: PdfVerticalAlignment.top,
      textDirection: isArabic ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight,
    );

    graphics.drawString(
      text,
      selectedFont,
      bounds: Rect.fromLTWH(x, y, width, height),
      format: format,
    );
  }

  /// Section 1: VENDOR / CUSTOMER DETAILS
  ///
  // Company Name (as per TLN)
  drawText(vendorData['company_name'] ?? '', 119, 209, 300, 15);

  // Company Type
  drawText(vendorData['company_type'] ?? '', 115, 247, 200, 15);

  // Email (to register on system)
  drawText(vendorData['company_email'] ?? '', 75, 272, 300, 15);

  // Company TLN (Trade License Number)
  drawText(vendorData['trading_license_number'] ?? '', 395, 209, 200, 15);

  // Company Mobile Number
  String mobileNumber = '';
  if (vendorData['company_phone_code'] != null && vendorData['company_phone_number'] != null) {
    mobileNumber = '+${vendorData['company_phone_code']} ${vendorData['company_phone_number']}';
  }
  drawText(mobileNumber, 429, 247, 200, 15);

  // Get country and region - prefer Arabic if available
  final countryName = vendorData['country_name'] ?? vendorData['company_country_name'] ?? '';
  final countryRegion = vendorData['region_name'] ?? vendorData['company_region_name'] ?? '';

  // Debug logging
  debugPrint('Country Name: $countryName');
  debugPrint('Region Name: $countryRegion');
  debugPrint('Contains Arabic (country): ${containsArabic(countryName)}');
  debugPrint('Contains Arabic (region): ${containsArabic(countryRegion)}');

  // Trade License Expiry Date
  drawText(vendorData['trading_license_expiry'] ?? '', 446, 272, 200, 15);

  /// Section 2: CONTACT INFORMATION
  ///
  // Name
  drawText(vendorData['company_display_name'] ?? '', 78, 369, 250, 15);

  // Telephone Number
  String telephoneNumber = '';
  if (vendorData['phone_code'] != null && vendorData['phone_number'] != null) {
    telephoneNumber = '${vendorData['phone_code']} ${vendorData['phone_number']}';
  }
  drawText(telephoneNumber, 140, 394, 200, 15);

  // Business Address
  drawText(vendorData['company_address'] ?? '', 131, 420, 170, 50);

  // Country (will use Arabic font automatically)
  drawText(countryName, 88, 457, 300, 20);

  // Region (will use Arabic font automatically)
  drawText(countryRegion, 88, 483, 300, 20);

  // Emirates ID #
  drawText(vendorData['eid_number'] ?? '', 115, 508, 200, 15);

  //////////////////////////////

  String designation = vendorData['user_information_type'] ?? '';
  designation = designation == 'authorized_signatory' ? 'Signatory' : designation;
  drawText(designation, 425, 369, 250, 15);

  drawText(vendorData['company_display_name'] ?? '', 425, 394, 200, 15);

  // Business Address
  drawText(telephoneNumber, 425, 420, 300, 15);

  // Country (will use Arabic font automatically)
  drawText(countryName, 425, 445, 300, 20);

  // Region (will use Arabic font automatically)
  drawText(countryRegion, 425, 471, 300, 20);

  // Emirates ID #
  drawText(vendorData['eid_number'] ?? '', 425, 496, 200, 15);

  /// Section 3: BANK INFORMATION
  ///
  // Bank Name
  drawText(vendorData['bank_name'] ?? '', 135, 577, 200, 15);

  // IBAN Number
  drawText(vendorData['iban_number'] ?? '', 135, 602, 300, 15);

  // Account Name
  drawText(vendorData['account_name'] ?? '', 135, 627, 200, 15);

  // Account Number
  drawText(vendorData['account_number'] ?? '', 135, 653, 200, 15);

  // Navigate to Page 2 for Section 4: SERVICES/PRODUCTS DESCRIPTION
  if (document.pages.count > 1 && subscriptionResponse != null) {
    final PdfPage page2 = document.pages[1];
    final PdfGraphics graphics2 = page2.graphics;

    // Helper function for page 2
    void drawText2(String text, double x, double y, double width, double height, {bool isBold = false}) {
      if (text.isEmpty) return;

      final isArabic = containsArabic(text);
      final selectedFont = isArabic ? (isBold ? arabicBoldFont : arabicFont) : (isBold ? boldFont : font);

      final format = PdfStringFormat(
        alignment: PdfTextAlignment.left,
        lineAlignment: PdfVerticalAlignment.top,
        textDirection: isArabic ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight,
      );

      graphics2.drawString(
        text,
        selectedFont,
        bounds: Rect.fromLTWH(x, y, width, height),
        format: format,
      );
    }

    /// Section 4: SERVICES/PRODUCTS DESCRIPTION
    ///
    // Get current date for START DATE
    final DateTime now = DateTime.now();
    final String startDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    // Calculate END DATE (12 months from start date)
    final DateTime endDate = DateTime(now.year + 1, now.month, now.day);
    final String endDateStr =
        '${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}/${endDate.year}';

    // START DATE
    drawText2(startDate, 150, 205, 150, 15);

    // END DATE
    drawText2(endDateStr, 390, 205, 150, 15);

    // Annual Subscription Fee
    drawText2(subscriptionResponse.data.formatedPriceWithoutVat, 390, 240, 200, 15);

    // Commission % Per Order
    final String commission = subscriptionResponse.data.commission;
    drawText2(commission.isNotEmpty ? '$commission%' : '7%', 390, 280, 150, 15);

    // Yearly Total (Excl. of VAT)
    drawText2(subscriptionResponse.data.formatedPriceWithoutVat, 390, 315, 200, 15, isBold: true);

    // VAT
    drawText2(subscriptionResponse.data.formatedVat, 390, 355, 150, 15);

    // Contract Total (Incl. of VAT)
    drawText2('${subscriptionResponse.data.formatedPriceWithVat}AED', 390, 390, 200, 15, isBold: true);

    // Contract Duration
    drawText2('${subscriptionResponse.data.subtime} Months', 390, 430, 150, 15);
  }
}

Future<void> previewAgreementAndGeneratePdf(
  BuildContext context,
  SubscriptionPackageResponse? subscriptionResponse,
) async {
  final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
  final response = await provider.previewAgreement(context);

  // Extract the data from the response structure
  Map<String, dynamic> vendorData = {};
  if (response != null && response['data'] != null) {
    vendorData = response['data'];
  } else if (response != null) {
    vendorData = response;
  }

  await generateAgreementPdf(vendorData, subscriptionResponse);
}
