import 'dart:io';

class AuthorizedSignatoryInfoPostData {
  String? ownerDisplayName;
  String? ownerPhoneNumber;
  String? ownerPhoneCode;
  String? ownerCountry;
  String? ownerRegion;
  String? ownerEIDNumber;
  String? ownerEIDExpiry;
  File? ownerEIDFile;
  String? ownerEIDFileName;
  String? ownerEIDServerFilePath;
  File? passportFile;
  String? passportFileName;
  String? passportServerFilePath;
  File? poamoaFile;
  String? poamoaFileName;
  String? poamoaServerPath;

  // Convert object to Map<String, dynamic>
  Map<String, dynamic> toMap() => {
        'owner_display_name': ownerDisplayName,
        'owner_phone_number': ownerPhoneNumber,
        'owner_phone_code': ownerPhoneCode,
        'owner_country': ownerCountry,
        'owner_region': ownerRegion,
        'owner_eid_number': ownerEIDNumber,
        'owner_eid_expiry': ownerEIDExpiry,
      };

  // Convert object to List<MapEntry<String, String>>
  List<MapEntry<String, String>> toMapEntries() => {
        'owner_display_name': ownerDisplayName ?? '',
        'owner_phone_number': ownerPhoneNumber ?? '',
        'owner_phone_code': '+971',
        'owner_country': ownerCountry ?? '',
        'owner_region': ownerRegion ?? '',
        'owner_eid_number': ownerEIDNumber ?? '',
        'owner_eid_expiry': ownerEIDExpiry ?? '',
      }
          .entries
          .map((entry) => MapEntry(entry.key, entry.value.toString()))
          .toList();

  // Override toString() method
  @override
  String toString() => '''
AuthorizedSignatoryInfoPostData(
  ownerDisplayName: $ownerDisplayName,
  ownerPhoneNumber: $ownerPhoneNumber,
  ownerPhoneCode: $ownerPhoneCode,
  ownerCountry: $ownerCountry,
  ownerRegion: $ownerRegion,
  ownerEIDNumber: $ownerEIDNumber,
  ownerEIDExpiry: $ownerEIDExpiry,
  ownerEIDFile: $ownerEIDFile,
  ownerEIDName: $ownerEIDFileName,
  passportFile: $passportFile,
  passportName: $passportFileName,
  poamoaFile: $poamoaFile,
  poamoaName: $poamoaFileName,
)
''';
}
