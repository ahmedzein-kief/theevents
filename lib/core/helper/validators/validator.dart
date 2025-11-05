import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/network/api_endpoints/vendor_api_end_point.dart';

class Validator {
  /// ======= EMAIL VALIDATION =================================================
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'valEmailEmpty'.tr;
    }
    const String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'valEmailInvalid'.tr;
    }
    return null;
  }

  static String? emailOptional(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    const String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'valEmailInvalid'.tr;
    }
    return null;
  }

  static String? isValidUrl(String value) {
    if (value.isEmpty) {
      return 'valRequiredField'.tr; // Ensure it's not empty
    }

    final Uri? uri = Uri.tryParse(value);
    final bool isValid = uri != null && uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');

    return isValid ? null : 'valUrlInvalid'.tr;
  }

  static String? vendorEmail(String? value) {
    if (value == null || value.isEmpty) {
      return VendorAppStrings.errorEmailRequired.tr;
    }
    const String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return VendorAppStrings.errorValidEmail.tr;
    }
    return null;
  }

  /// ======= PHONE VALIDATION =================================================

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'valPhoneEmpty'.tr;
    }
    if (value.length < 9) {
      return 'valPhone9Digits'.tr;
    }
    const String pattern = r'^\d+$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'valPhoneDigitsOnly'.tr;
    }
    return null;
  }

  static String? companyMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'valCompanyMobileRequired'.tr;
    }
    if (value.length > 9 || value.length < 9) {
      return 'valCompanyMobile9Digits'.tr;
    }
    const String pattern = r'^\d+$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'valCompanyMobileDigitsOnly'.tr;
    }
    return null;
  }

  static String? companyLandline(String? value) {
    if (value == null || value.isEmpty) {
      return 'valLandlineRequired'.tr;
    }
    if (value.length > 8 || value.length < 8) {
      return 'valLandline8Digits'.tr;
    }
    const String pattern = r'^\d+$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'valLandlineDigitsOnly'.tr;
    }
    return null;
  }

  static String? businessInfoPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'valPhoneRequired'.tr;
    }
    if (value.length > 9 || value.length < 9) {
      return 'valPhone9Digits'.tr;
    }
    const String pattern = r'^\d+$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'valPhoneDigitsOnly'.tr;
    }
    return null;
  }

  static String? gender(String? value) {
    if (value == null || value.isEmpty) {
      return 'valGenderRequired'.tr;
    }
    return null;
  }

  /// ======= NAME VALIDATION =================================================

  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'valNameEmpty'.tr;
    }
    if (value.length > 25) {
      return 'valNameMax25'.tr;
    }
    return null;
  }

  static String? productName(String? value) {
    if (value == null || value.isEmpty) {
      return 'valNameEmpty'.tr;
    }
    return null;
  }

  static String? vendorName(String? value) {
    if (value == null || value.isEmpty) {
      return 'valNameRequired'.tr;
    }
    if (value.length > 25) {
      return 'valNameMax25'.tr;
    }
    return null;
  }

  static String? bankName(String? value) {
    if (value == null || value.isEmpty) {
      return 'valBankNameRequired'.tr;
    }
    return null;
  }

  static String? accountName(String? value) {
    if (value == null || value.isEmpty) {
      return 'valAccountNameRequired'.tr;
    }
    return null;
  }

  static String? accountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'valAccountNumberRequired'.tr;
    }
    return null;
  }

  static String? region(String? value) {
    if (value == null || value.isEmpty) {
      return 'valRegionRequired'.tr;
    }
    return null;
  }

  static String? country(value) {
    if (value == null || value.isEmpty) {
      return 'valCountryRequired'.tr;
    }
    return null;
  }

  static String? emiratesIdNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'valEidRequired'.tr;
    }
    if (value.length < 15 || value.length > 15) {
      return 'valEid15Digits'.tr;
    }

    return null;
  }

  static String? companyCategoryType(String? value) {
    if (value == null || value.isEmpty) {
      return 'valCompanyCategoryRequired'.tr;
    }
    return null;
  }

  static String? emiratesIdNumberDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'valEidExpiryRequired'.tr;
    }
    return null;
  }

  static String? tradingNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'valTradingNumberRequired'.tr;
    }

    if (value.length < 10 || value.length > 15) {
      return 'valTradingNumberLength'.tr;
    }
    return null;
  }

  static String? tradeLicenseNumberExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'valTradeLicenseExpiryRequired'.tr;
    }
    return null;
  }

  static String? fieldRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'valRequiredField'.tr;
    }
    return null;
  }

  static String? companyAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'valCompanyAddressRequired'.tr;
    }
    return null;
  }

  static String? companyName(String? value) {
    if (value == null || value.isEmpty) {
      return 'valCompanyNameRequired'.tr;
    }
    if (value.length > 50) {
      return 'valCompanyNameMax50'.tr;
    }
    return null;
  }

  static String? companySlug(String? value) {
    if (value == null || value.isEmpty) {
      return 'valCompanySlugRequired'.tr;
    }
    if (value.length > 22) {
      return 'valCompanySlugMax20'.tr;
    }
    return null;
  }

  /// ======= ZIP CODE VALIDATION =================================================

  static String? zipCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'valZipEmpty'.tr;
    } else if (value.length < 5) {
      return 'valZip5Digits'.tr;
    }
    const String pattern = r'^\d+$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'valZipDigitsOnly'.tr;
    }
    return null;
  }

  static String? zipCodeOptional(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (value.length < 5) {
      return 'valZip5Digits'.tr;
    }
    const String pattern = r'^\d+$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'valZipDigitsOnly'.tr;
    }
    return null;
  }

  /// ======== SIGN+UP+VALIDATION  ==============================================

  static String? signUpPasswordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'valPasswordEmpty'.tr;
    }
    if (value.length < 9) {
      return 'valPasswordMin9'.tr;
    }

    // Regex pattern for the password policy
    const String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#]).{9,}$';
    final RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'valPasswordPolicyFull'.tr;
    }

    return null; // Valid password
  }

  static String? vendorPasswordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passRequired.tr;
    }
    if (value.length < 6) {
      return 'valVendorPasswordMin9'.tr;
    }
    const String pattern = r'^(?=.*[a-z])(?=.*[A-Z]).{6,}$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'valVendorPasswordCaseReq'.tr;
    }
    return null;
  }

  ///  =================  GIFT CARD NAME =================================================================
  static String? nameGiftCard(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.nameCannotBeEmpty.tr;
    }
    if (value.length > 16) {
      return 'Name cannot be more than 16 characters';
    }
    return null;
  }

  static String? emailGiftCard(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailCannotBeEmpty.tr;
    }
    const String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  /// Field cannot be empty
  static String? fieldCannotBeEmpty(value) {
    if (value == null || value.isEmpty) {
      return 'valFieldRequiredAlt'.tr;
    }
    return null;
  }

  /// Field cannot be empty
  static String? validationPaypalID(String? value) {
    if (value == null || value.isEmpty) {
      return 'valRequiredField'.tr;
    }

    if (value.length > 120) {
      return 'valPaypalIdMax120'.tr;
    }

    // PayPal email regex validation
    final RegExp paypalEmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!paypalEmailRegex.hasMatch(value)) {
      return 'valPaypalEmailInvalid'.tr;
    }
    return null;
  }

  /// Field cannot be empty
  static String? validationBankIFSC(String? value) {
    if (value == null || value.isEmpty) {
      return 'valRequiredField'.tr;
    }

    if (value.length > 120) {
      return 'valIFSCMax120'.tr;
    }

    return null;
  }

  /// Field cannot be empty
  static String? validationAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'valRequiredField'.tr;
    }

    if (value.length > 120) {
      return 'valAccountNumberMax120'.tr;
    }

    return null;
  }

  /// coupons must be greater than or equal to 1
  static String? validateNumberOfCoupons(String? value) {
    if (value == null || value.isEmpty) {
      return 'valCouponsNumMin1'.tr;
    }
    if ((int.tryParse(value) ?? 0) < 1) {
      return 'valCouponsNumMin1'.tr; // Error message for invalid or too small value
    }
    return null;
  }

  /// coupons must be greater than or equal to 1
  static String? validateDiscountOfCoupons(String? value) {
    if (value == null || value.isEmpty) {
      return 'valDiscountMin1'.tr;
    }

    final double? discount = double.tryParse(value);

    if (discount == null || discount < 1) {
      return 'valDiscountMin1'.tr; // Error message for invalid or too small value
    }

    return null;
  }

  /// coupons must be greater than or equal to 1
  static String? validatePermalink(String? value) {
    if (value == null || value.isEmpty) {
      return 'valPermalinkRequired'.tr;
    }

    if (value.trim() == VendorApiEndpoints.vendorProductBaseUrl) {
      return 'valPermalinkUnique'.tr;
    }

    return null;
  }

  static String? validateStartAndEndDate(String? startDate, String? endDate) {
    // Skip validation if either date is empty
    if (startDate == null || startDate.isEmpty || endDate == null || endDate.isEmpty) {
      return null;
    }

    try {
      // Parse the dates
      final DateTime start = DateTime.parse(startDate);
      final DateTime end = DateTime.parse(endDate);

      // If start date is greater than end date, return an error
      if (start.isAfter(end)) {
        return 'valStartDateAfterEnd'.tr;
      }
    } catch (e) {
      return 'valInvalidDateFormat'.tr;
    }

    return null; // No error
  }

  static String formatToTwoDecimalPlaces(String value) {
    if (value.isEmpty) return '0.00'; // Default case

    final double? number = double.tryParse(value);
    return number != null ? number.toStringAsFixed(2) : value;
  }

  static String? addressValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'valAddressRequired'.tr;
    }
    if (value.length < 5) {
      return 'valAddressMin5'.tr;
    }
    if (value.length > 100) {
      return 'valAddressMax100'.tr;
    }

    return null; // Valid address
  }

  static String? cityValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'valCityRequired'.tr;
    }
    if (value.length < 2) {
      return 'valCityMin2'.tr;
    }
    if (value.length > 50) {
      return 'valCityMax50'.tr;
    }
    if (!RegExp(r'^[a-zA-Z\s-]+$').hasMatch(value)) {
      return 'valCityChars'.tr;
    }
    return null; // Valid city name
  }

  static String? ibanNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'valIbanRequired'.tr;
    }

    // Remove spaces
    final iban = value.replaceAll(' ', '');

    // Basic length check
    if (iban.length < 15 || iban.length > 34) {
      return 'valIbanLength'.tr;
    }

    // Must start with 2 letters (country code)
    if (!RegExp(r'^[A-Z]{2}[0-9A-Z]+$').hasMatch(iban)) {
      return 'valIbanFormat'.tr;
    }

    return null; // ✅ valid
  }
}
