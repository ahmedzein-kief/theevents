import 'dart:io';

class BusinessOwnerInfoPostData {
  String? companyDisplayName;
  String? phoneNumber;
  String? phoneCode;
  String? country;
  String? region;
  String? eidNumber;
  String? eidExpiry;
  File? eidFile;
  String? eidFileName;
  String? eidServerFilePath;
  File? passportFile;
  String? passportFileName;
  String? passportServerFilePath;

  // Convert object to Map<String, dynamic>
  Map<String, dynamic> toMap(bool isOwner) => {
        'meta_type': 'signatory-information',
        'company_display_name': companyDisplayName,
        'phone_number': phoneNumber,
        'phone_code': phoneCode,
        'country': country,
        'region': region,
        'eid_number': eidNumber,
        'eid_expiry': eidExpiry,
        'user_information_type': isOwner ? 'owner' : 'authorized_signatory',
      };

  // Convert object to List<MapEntry<String, String>>
  List<MapEntry<String, String>> toMapEntries(bool isOwner) => {
        'meta_type': 'signatory-information',
        'company_display_name': companyDisplayName ?? '',
        'phone_number': phoneNumber ?? '',
        'phone_code': phoneCode ?? '+971',
        'country': country ?? '',
        'region': region ?? '',
        'eid_number': eidNumber ?? '',
        'eid_expiry': eidExpiry ?? '',
        'user_information_type': isOwner ? 'owner' : 'authorized_signatory',
      }
          .entries
          .map((entry) => MapEntry(entry.key, entry.value.toString()))
          .toList();

  // Override toString() method
  @override
  String toString() => '''
BusinessOwnerInfoPostData(
  companyDisplayName: $companyDisplayName,
  phoneNumber: $phoneNumber,
  phoneCode: $phoneCode,
  country: $country,
  region: $region,
  eidNumber: $eidNumber,
  eidExpiry: $eidExpiry,
  eidFile: ${eidFile?.path},
  eidName: $eidFileName,
  passport: ${passportFile?.path},
  passportName: $passportFileName,
)
''';
}
