import 'dart:io';

class BankDetailsPostData {
  String? bankName;
  String? ibanNumber;
  String? accountName;
  String? accountNumber;
  File? bankLetterFile;
  String? bankLetterFileName;
  String? bankLetterFileServerPath;

  // Convert object to Map<String, dynamic>
  Map<String, dynamic> toMap() => {
        'meta_type': 'bank-details',
        'bank_name': bankName,
        'iban_number': ibanNumber,
        'account_name': accountName,
        'account_number': accountNumber,
      };

  // Convert object to List<MapEntry<String, String>>
  List<MapEntry<String, String>> toMapEntries() => {
        'meta_type': 'bank-details',
        'bank_name': bankName,
        'iban_number': ibanNumber,
        'account_name': accountName,
        'account_number': accountNumber,
      }.entries.map((entry) => MapEntry(entry.key, entry.value ?? '')).toList();

  @override
  String toString() => '''
Bank Details:
  Bank Name: $bankName
  IBAN Number: $ibanNumber
  Account Name: $accountName
  Account Number: $accountNumber
  Bank Letter File: ${bankLetterFile?.path}
  Bank Letter File Name: $bankLetterFileName
  ''';
}
