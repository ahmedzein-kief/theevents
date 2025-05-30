import 'dart:io';

class ContractAgreementPostData {
  bool? agreementAgree;
  File? companyStampFile;
  String? signImage;
  String? companyStampFileName;
  String? companyStampFileServerPath;

  // Convert object to List<MapEntry<String, String>>
  List<MapEntry<String, String>> toMapEntries() {
    return {
      "meta_type": "contract-agreement",
      "agreement_agree": agreementAgree.toString(),
      "sign_image": signImage?.toString(),
    }.entries.map((entry) => MapEntry(entry.key, entry.value ?? "")).toList();
  }

  @override
  String toString() {
    return '''
Contract Agreement:
  Agreement Agree: $agreementAgree
  Company Stamp File: ${companyStampFile?.path}
  Sign Image: ${signImage}
  ''';
  }
}
