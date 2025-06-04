import 'dart:io';

class CompanyInfoPostData {
  String? companyName;
  String? companyType;
  String? companyEmail;
  String? companyPhoneNumber;
  String? tradingLicenseNumber;
  String? tradingLicenseExpiryDate;
  String? mobileNumber;
  String? companyCountry;
  String? companyAddress;
  String? companyRegion;
  String? addressType;
  File? companyLogoFile;
  String? companyLogoFileName;
  String? companyLogoFileServerPath;
  File? utlFile;
  String? utlFileName;
  String? utlFileServerPath;
  File? nocPoaFile;
  String? nocPoaFileName;
  String? nocPoaFileServerPath;
  File? vatFile;
  String? vatFileName;
  String? vatFileServerPath;

  // Convert object to Map<String, dynamic>
  Map<String, dynamic> toMap(bool isOwner) => {
        'meta_type': 'company-information',
        'company_name': companyName,
        'company_type': companyType,
        'company_email': companyEmail,
        'company_phone_code': '971',
        'company_phone_number': companyPhoneNumber,
        'trading_license_number': tradingLicenseNumber,
        'company_address': companyAddress,
        'address_type': addressType,
        'mobile_number': mobileNumber,
        'region': companyRegion,
        'company_country': companyCountry,
        'trading_license_expiry': tradingLicenseExpiryDate,
      };

  // Convert object to List<MapEntry<String, String>>
  List<MapEntry<String, String>> toMapEntries() => {
        'meta_type': 'company-information',
        'company_name': companyName,
        'company_type': companyType?.toLowerCase(),
        'company_email': companyEmail,
        'company_phone_code': '971',
        'company_phone_number': companyPhoneNumber,
        'trading_license_number': tradingLicenseNumber,
        'company_address': companyAddress,
        'address_type': addressType?.toLowerCase(),
        'mobile_number': mobileNumber,
        'company_region': companyRegion,
        'company_country': companyCountry,
        'trading_license_expiry': tradingLicenseExpiryDate,
      }
          .entries
          .map((entry) => MapEntry(entry.key, entry.value.toString()))
          .toList();

  @override
  String toString() => '''
Company Information:
  Company Name: $companyName
  Company Type: $companyType
  Company Email: $companyEmail
  Company Phone Number: $companyPhoneNumber
  Trading License Number: $tradingLicenseNumber
  Trading License Expiry Date: $tradingLicenseExpiryDate
  Mobile Number: $mobileNumber
  Company Country: $companyCountry
  Company Address: $companyAddress
  Company Region: $companyRegion
  Address Type: $addressType
  Company Logo: ${companyLogoFile?.path}
  Company Logo Name: $companyLogoFileName
  Utility Bill File: ${utlFile?.path}
  Utility Bill File Name: $utlFileName
  NOC/POA File: ${nocPoaFile?.path}
  NOC/POA File Name: $nocPoaFileName
  VAT File: ${vatFile?.path}
  VAT File Name: $vatFileName
  ''';
}
