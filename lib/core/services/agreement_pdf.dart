import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../provider/vendor/vendor_sign_up_provider.dart';

Future<void> generateAgreementPdf(Map<String, dynamic> vendorData) async {
  try {
    // 1. Load the existing PDF template from assets
    final templateBytes =
        await rootBundle.load('assets/corrected_agreement1.pdf');
    final Uint8List templateData = templateBytes.buffer.asUint8List();

    // 2. Load the PDF document
    final PdfDocument document = PdfDocument(inputBytes: templateData);

    // 3. Get the form from the PDF
    final PdfForm form = document.form;

    // 4. Fill the form fields (adjust field names according to your PDF)
    if (form.fields.count > 0) {
      // Fill form fields by name
      _fillFormField(
          form, 'company_name', vendorData['company_display_name'] ?? '',);
      _fillFormField(form, 'company_type', vendorData['company_type'] ?? '');
      _fillFormField(form, 'company_email', vendorData['company_email'] ?? '');

      // Add more fields as needed based on your PDF form field names
      // You can inspect field names using:
    } else {
      // If no form fields, add text annotations or create overlay
      _addTextOverlay(document, vendorData);
    }

    // 5. Save the document
    final List<int> bytes = await document.save();
    document.dispose();

    // 6. Save to file
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/Vendor_Agreement.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    log('File saved at: $filePath');

    // 7. Open file
    await OpenFile.open(filePath);
  } catch (e) {
    log('Error generating PDF: $e');
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
    log('Field $fieldName not found or error filling: $e');
  }
}

void _addTextOverlay(PdfDocument document, Map<String, dynamic> vendorData) {
  // If there are no form fields, add text as overlay
  final PdfPage page = document.pages[0];
  final PdfGraphics graphics = page.graphics;

  // Set fonts
  final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);

  // Section 1: VENDOR / CUSTOMER DETAILS
  // Company Name (as per TLN)
  graphics.drawString(
    vendorData['company_name'] ?? '',
    font,
    bounds: const Rect.fromLTWH(119, 209, 300, 15),
  );

  // Company Type
  graphics.drawString(
    vendorData['company_type'] ?? '',
    font,
    bounds: const Rect.fromLTWH(115, 247, 200, 15),
  );

  // Email (to register on system)
  graphics.drawString(
    vendorData['company_email'] ?? '',
    font,
    bounds: const Rect.fromLTWH(75, 272, 300, 15),
  );

  // Company TLN (Trade License Number)
  graphics.drawString(
    vendorData['trading_license_number'] ?? '',
    font,
    bounds: const Rect.fromLTWH(395, 209, 200, 15),
  );

  // Company Mobile Number
  String mobileNumber = '';
  if (vendorData['company_phone_code'] != null &&
      vendorData['company_phone_number'] != null) {
    mobileNumber =
        '+${vendorData['company_phone_code']} ${vendorData['company_phone_number']}';
  }
  graphics.drawString(
    mobileNumber,
    font,
    bounds: const Rect.fromLTWH(429, 247, 200, 15),
  );

  // Trade License Expiry Date
  graphics.drawString(
    vendorData['trading_license_expiry'] ?? '',
    font,
    bounds: const Rect.fromLTWH(446, 272, 200, 15),
  );

  // Section 2: CONTACT INFORMATION
  // Name
  graphics.drawString(
    vendorData['company_display_name'] ?? '',
    font,
    // Align with left column similar to Section 1
    bounds: const Rect.fromLTWH(78, 369, 250, 15),
  );

  // Telephone Number
  String phoneNumber = '';
  if (vendorData['phone_code'] != null && vendorData['phone_number'] != null) {
    phoneNumber = '${vendorData['phone_code']} ${vendorData['phone_number']}';
  }
  graphics.drawString(
    phoneNumber,
    font,
    // Right column to mirror mobile number position in Section 1
    bounds: const Rect.fromLTWH(140, 394, 200, 15),
  );

  // Business Address
  graphics.drawString(
    vendorData['company_address'] ?? '',
    font,
    // Left column, next row
    bounds: const Rect.fromLTWH(131, 420, 300, 15),
  );

  // Country
  graphics.drawString(
    vendorData['company_country'] ?? '',
    font,
    // Right column, aligned with Business Address row
    bounds: const Rect.fromLTWH(88, 445, 200, 15),
  );

  // Region
  graphics.drawString(
    vendorData['company_region'] ?? '',
    font,
    // Right column, next row
    bounds: const Rect.fromLTWH(88, 471, 200, 15),
  );

  // Emirates ID #
  graphics.drawString(
    vendorData['eid_number'] ?? '',
    font,
    // Right column, next row
    bounds: const Rect.fromLTWH(115, 496, 200, 15),
  );

  //////////////////////////////

  graphics.drawString(
    vendorData['company_display_name'] ?? '',
    font,
    // Align with left column similar to Section 1
    bounds: const Rect.fromLTWH(425, 369, 250, 15),
  );

  graphics.drawString(
    phoneNumber,
    font,
    // Right column to mirror mobile number position in Section 1
    bounds: const Rect.fromLTWH(425, 394, 200, 15),
  );

  // Business Address
  graphics.drawString(
    vendorData['company_address'] ?? '',
    font,
    // Left column, next row
    bounds: const Rect.fromLTWH(425, 420, 300, 15),
  );

  // Country
  graphics.drawString(
    vendorData['company_country'] ?? '',
    font,
    // Right column, aligned with Business Address row
    bounds: const Rect.fromLTWH(425, 445, 200, 15),
  );

  // Region
  graphics.drawString(
    vendorData['company_region'] ?? '',
    font,
    // Right column, next row
    bounds: const Rect.fromLTWH(425, 471, 200, 15),
  );

  // Emirates ID #
  graphics.drawString(
    vendorData['eid_number'] ?? '',
    font,
    // Right column, next row
    bounds: const Rect.fromLTWH(425, 496, 200, 15),
  );

  // Section 3: BANK INFORMATION
  // Bank Name
  graphics.drawString(
    vendorData['bank_name'] ?? '',
    font,
    bounds: const Rect.fromLTWH(135, 577, 200, 15),
  );

  // IBAN Number
  graphics.drawString(
    vendorData['iban_number'] ?? '',
    font,
    bounds: const Rect.fromLTWH(135, 602, 300, 15),
  );

  // Account Name
  graphics.drawString(
    vendorData['account_name'] ?? '',
    font,
    bounds: const Rect.fromLTWH(135, 627, 200, 15),
  );

  // Account Number
  graphics.drawString(
    vendorData['account_number'] ?? '',
    font,
    bounds: const Rect.fromLTWH(135, 653, 200, 15),
  );

  log('Text overlay added to first page');
}

Future<void> previewAgreementAndGeneratePdf(BuildContext context) async {
  final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
  final response = await provider.previewAgreement(context);

  // Extract the data from the response structure
  Map<String, dynamic> vendorData = {};
  if (response != null && response['data'] != null) {
    vendorData = response['data'];
  } else if (response != null) {
    vendorData = response;
  }

  await generateAgreementPdf(vendorData);
}
