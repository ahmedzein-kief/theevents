import 'dart:convert';

MetaDataResponse metaDataResponseFromJson(String str) => MetaDataResponse.fromJson(json.decode(str));

String metaDataResponseToJson(MetaDataResponse data) => json.encode(data.toJson());

class MetaDataResponse {
  MetaDataResponse({
    required this.data,
    required this.error,
    required this.message,
  });

  factory MetaDataResponse.fromJson(Map<dynamic, dynamic> json) => MetaDataResponse(
        data: json['data'] is List
            ? {}
            : Map.from(json['data']).map((k, v) => MapEntry<String, String?>(k, v?.toString())),
        error: json['error'],
        message: json['message'],
      );

  Map<String, String?> data; // Changed to allow nullable String values
  bool error;
  String? message;

  Map<dynamic, dynamic> toJson() => {
        'data': Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v)),
        'error': error,
        'message': message,
      };
}

// Alternative approach: Create a proper model class with specific fields
class MetaData {
  MetaData({
    required this.step,
    required this.companyDisplayName,
    required this.phoneCode,
    required this.phoneNumber,
    required this.country,
    required this.region,
    required this.eidNumber,
    required this.eidExpiry,
    required this.userInformationType,
    required this.eidFileName,
    required this.eidFilePath,
    required this.passportFileName,
    required this.passportFilePath,
    required this.companyName,
    required this.companyType,
    required this.companyEmail,
    required this.companyPhoneCode,
    required this.companyPhoneNumber,
    required this.tradingLicenseNumber,
    required this.companyAddress,
    required this.mobileNumber,
    required this.tradingLicenseExpiry,
    required this.companyCountry,
    required this.companyRegion,
    required this.addressType,
    required this.companyLogoName,
    required this.companyLogoPath,
    required this.tdlFileName,
    required this.tdlFilePath,
    required this.nocFileName,
    required this.nocFilePath,
    required this.vatFileName,
    required this.vatFilePath,
    required this.bankName,
    required this.ibanNumber,
    required this.accountName,
    required this.accountNumber,
    required this.bankLetterFileName,
    required this.bankLetterFilePath,
    required this.agreementAgree,
    required this.signImage,
    required this.companyStampFileName,
    required this.companyStampFilePath,
    this.countryName,
    this.regionName,
    this.companyCountryName,
    this.companyRegionName,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
        step: json['step'],
        companyDisplayName: json['company_display_name'],
        phoneCode: json['phone_code'],
        phoneNumber: json['phone_number'],
        country: json['country'],
        region: json['region'],
        eidNumber: json['eid_number'],
        eidExpiry: json['eid_expiry'],
        userInformationType: json['user_information_type'],
        eidFileName: json['eid_file_name'],
        eidFilePath: json['eid_file_path'],
        passportFileName: json['passport_file_name'],
        passportFilePath: json['passport_file_path'],
        companyName: json['company_name'],
        companyType: json['company_type'],
        companyEmail: json['company_email'],
        companyPhoneCode: json['company_phone_code'],
        companyPhoneNumber: json['company_phone_number'],
        tradingLicenseNumber: json['trading_license_number'],
        companyAddress: json['company_address'],
        mobileNumber: json['mobile_number'],
        tradingLicenseExpiry: json['trading_license_expiry'],
        companyCountry: json['company_country'],
        companyRegion: json['company_region'],
        addressType: json['address_type'],
        companyLogoName: json['company_logo_name'],
        companyLogoPath: json['company_logo_path'],
        tdlFileName: json['tdl_file_name'],
        tdlFilePath: json['tdl_file_path'],
        nocFileName: json['noc_file_name'],
        nocFilePath: json['noc_file_path'],
        vatFileName: json['vat_file_name'],
        vatFilePath: json['vat_file_path'],
        bankName: json['bank_name'],
        ibanNumber: json['iban_number'],
        accountName: json['account_name'],
        accountNumber: json['account_number'],
        bankLetterFileName: json['bank_letter_file_name'],
        bankLetterFilePath: json['bank_letter_file_path'],
        agreementAgree: json['agreement_agree'],
        signImage: json['sign_image'],
        companyStampFileName: json['company_stamp_file_name'],
        companyStampFilePath: json['company_stamp_file_path'],
        countryName: json['country_name'],
        regionName: json['region_name'],
        companyCountryName: json['company_country_name'],
        companyRegionName: json['company_region_name'],
      );

  final String step;
  final String companyDisplayName;
  final String phoneCode;
  final String phoneNumber;
  final String country;
  final String region;
  final String eidNumber;
  final String eidExpiry;
  final String userInformationType;
  final String eidFileName;
  final String eidFilePath;
  final String passportFileName;
  final String passportFilePath;
  final String companyName;
  final String companyType;
  final String companyEmail;
  final String companyPhoneCode;
  final String companyPhoneNumber;
  final String tradingLicenseNumber;
  final String companyAddress;
  final String mobileNumber;
  final String tradingLicenseExpiry;
  final String companyCountry;
  final String companyRegion;
  final String addressType;
  final String companyLogoName;
  final String companyLogoPath;
  final String tdlFileName;
  final String tdlFilePath;
  final String nocFileName;
  final String nocFilePath;
  final String vatFileName;
  final String vatFilePath;
  final String bankName;
  final String ibanNumber;
  final String accountName;
  final String accountNumber;
  final String bankLetterFileName;
  final String bankLetterFilePath;
  final String agreementAgree;
  final String signImage;
  final String companyStampFileName;
  final String companyStampFilePath;
  final String? countryName; // These can be null
  final String? regionName; // These can be null
  final String? companyCountryName; // These can be null
  final String? companyRegionName; // These can be null

  Map<String, dynamic> toJson() => {
        'step': step,
        'company_display_name': companyDisplayName,
        'phone_code': phoneCode,
        'phone_number': phoneNumber,
        'country': country,
        'region': region,
        'eid_number': eidNumber,
        'eid_expiry': eidExpiry,
        'user_information_type': userInformationType,
        'eid_file_name': eidFileName,
        'eid_file_path': eidFilePath,
        'passport_file_name': passportFileName,
        'passport_file_path': passportFilePath,
        'company_name': companyName,
        'company_type': companyType,
        'company_email': companyEmail,
        'company_phone_code': companyPhoneCode,
        'company_phone_number': companyPhoneNumber,
        'trading_license_number': tradingLicenseNumber,
        'company_address': companyAddress,
        'mobile_number': mobileNumber,
        'trading_license_expiry': tradingLicenseExpiry,
        'company_country': companyCountry,
        'company_region': companyRegion,
        'address_type': addressType,
        'company_logo_name': companyLogoName,
        'company_logo_path': companyLogoPath,
        'tdl_file_name': tdlFileName,
        'tdl_file_path': tdlFilePath,
        'noc_file_name': nocFileName,
        'noc_file_path': nocFilePath,
        'vat_file_name': vatFileName,
        'vat_file_path': vatFilePath,
        'bank_name': bankName,
        'iban_number': ibanNumber,
        'account_name': accountName,
        'account_number': accountNumber,
        'bank_letter_file_name': bankLetterFileName,
        'bank_letter_file_path': bankLetterFilePath,
        'agreement_agree': agreementAgree,
        'sign_image': signImage,
        'company_stamp_file_name': companyStampFileName,
        'company_stamp_file_path': companyStampFilePath,
        'country_name': countryName,
        'region_name': regionName,
        'company_country_name': companyCountryName,
        'company_region_name': companyRegionName,
      };
}

// Updated response class to use the proper MetaData model
class MetaDataResponseV2 {
  MetaDataResponseV2({
    required this.data,
    required this.error,
    required this.message,
  });

  factory MetaDataResponseV2.fromJson(Map<String, dynamic> json) => MetaDataResponseV2(
        data: MetaData.fromJson(json['data']),
        error: json['error'],
        message: json['message'],
      );

  final MetaData data;
  final bool error;
  final String? message;

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
        'error': error,
        'message': message,
      };
}
