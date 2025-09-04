import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/network/api_endpoints/vendor_api_end_point.dart';

class Validator {
  /// ======= EMAIL VALIDATION =================================================
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email Cannot be empty';
    }
    const String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter a valid email address.';
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
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? isValidUrl(String value) {
    if (value.isEmpty) {
      return 'This is a required field'; // Ensure it's not empty
    }

    final Uri? uri = Uri.tryParse(value);
    final bool isValid = uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');

    return isValid ? null : 'Please enter a valid link';
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
      return 'Phone number Cannot be empty';
    }
    if (value.length < 9) {
      return 'Phone Number should be 9 digits long';
    }
    const String pattern = r'^\d+$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Phone number should contain only numbers.';
    }
    return null;
  }

  static String? companyMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company mobile number is required';
    }
    if (value.length > 9 || value.length < 9) {
      return 'Company mobile number should be 9 digits long';
    }
    const String pattern = r'^\d+$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Company mobile number should contain only numbers.';
    }
    return null;
  }

  static String? companyLandline(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number (Landline) is required';
    }
    if (value.length > 8 || value.length < 8) {
      return 'Phone number (Landline) should be 8 digits long';
    }
    const String pattern = r'^\d+$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Phone number (Landline) should contain only numbers.';
    }
    return null;
  }

  static String? businessInfoPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone is required';
    }
    if (value.length > 9 || value.length < 9) {
      return 'Phone number should be 9 digits long';
    }
    const String pattern = r'^\d+$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Phone number should contain only numbers.';
    }
    return null;
  }

  static String? gender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select gender';
    }
    return null;
  }

  /// ======= NAME VALIDATION =================================================

  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (value.length > 25) {
      return 'Name cannot be more than 25 characters';
    }
    return null;
  }

  static String? productName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  static String? vendorName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length > 25) {
      return 'Name cannot be more than 25 characters';
    }
    return null;
  }

  static String? bankName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bank name is required';
    }
    return null;
  }

  static String? ibanNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'IBAN number is required';
    }
    return null;
  }

  static String? accountName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Account name is required';
    }
    return null;
  }

  static String? accountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Account number is required';
    }
    return null;
  }

  static String? region(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select region';
    }
    return null;
  }

  static String? country(value) {
    if (value == null || value.isEmpty) {
      return 'Please select country';
    }
    return null;
  }

  static String? emiratesIdNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Emirates ID number is required';
    }
    if (value.length < 15 || value.length > 15) {
      return 'Emirates ID number must be of 15 digits long.';
    }

    return null;
  }

  static String? companyCategoryType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company category type is required';
    }
    return null;
  }

  static String? emiratesIdNumberDate(String? value) {
    if (value == null || value.isEmpty) {
      return "EID number's expiry date is required";
    }
    return null;
  }

  static String? tradingNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Trading number is required';
    }

    if (value.length < 10 || value.length > 15) {
      return 'Trading License number must be between 10 and 15 characters long.';
    }
    return null;
  }

  static String? tradeLicenseNumberExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Trade License number's expiry date is required";
    }
    return null;
  }

  static String? fieldRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? companyAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company address is required';
    }
    return null;
  }

  static String? companyName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company name is required';
    }
    if (value.length > 50) {
      return 'Company name cannot be more than 50 characters';
    }
    return null;
  }

  static String? companySlug(String? value) {
    if (value == null || value.isEmpty) {
      return 'Company slug is required';
    }
    if (value.length > 22) {
      return 'Company slug cannot be more than 20 characters';
    }
    return null;
  }

  /// ======= ZIP CODE VALIDATION =================================================

  static String? zipCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Zip code cannot be empty';
    } else if (value.length < 5) {
      return 'Zip Code must be 5 digits long.';
    }
    const String pattern = r'^\d+$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Zip Code should contain only numbers.';
    }
    return null;
  }

  static String? zipCodeOptional(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (value.length < 5) {
      return 'Zip Code must be 5 digits long.';
    }
    const String pattern = r'^\d+$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Zip Code should contain only numbers.';
    }
    return null;
  }

  /// ======== SIGN+UP+VALIDATION  ==============================================

  static String? signUpPasswordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty.';
    }
    if (value.length < 9) {
      return 'Password should be at least 9 characters long.';
    }

    // Regex pattern for the password policy
    const String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#]).{9,}$';
    final RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Password must include at least one uppercase letter, one lowercase letter, one digit, and one special character.';
    }

    return null; // Valid password
  }

  static String? vendorPasswordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password should be at least 9 characters long';
    }
    const String pattern = r'^(?=.*[a-z])(?=.*[A-Z]).{6,}$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Password must contain at least one uppercase and one lowercase letter.';
    }
    return null;
  }

  ///  =================  GIFT CARD NAME =================================================================
  static String? nameGiftCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (value.length > 16) {
      return 'Name cannot be more than 16 characters';
    }
    return null;
  }

  static String? emailGiftCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email Cannot be empty';
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
      return 'This Field cannot be empty.';
    }
    return null;
  }

  /// Field cannot be empty
  static String? validationPaypalID(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty.';
    }

    if (value.length > 120) {
      return 'PayPal ID must not be greater than 120 characters.';
    }

    // PayPal email regex validation
    final RegExp paypalEmailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!paypalEmailRegex.hasMatch(value)) {
      return 'Enter a valid PayPal email ID.';
    }
    return null;
  }

  /// Field cannot be empty
  static String? validationBankIFSC(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty.';
    }

    if (value.length > 120) {
      return 'Bank code/IFSC must not be greater than 120 characters.';
    }

    return null;
  }

  /// Field cannot be empty
  static String? validationAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty.';
    }

    if (value.length > 120) {
      return 'Account number must not be greater than 120 characters.';
    }

    return null;
  }

  /// coupons must be greater than or equal to 1
  static String? validateNumberOfCoupons(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of coupons must be greater than or equal to 1';
    }
    if ((int.tryParse(value) ?? 0) < 1) {
      return 'Number of coupons must be greater than or equal to 1'; // Error message for invalid or too small value
    }
    return null;
  }

  /// coupons must be greater than or equal to 1
  static String? validateDiscountOfCoupons(String? value) {
    if (value == null || value.isEmpty) {
      return 'Discount must be greater than or equal to 1';
    }

    final double? discount = double.tryParse(value);

    if (discount == null || discount < 1) {
      return 'Discount must be greater than or equal to 1'; // Error message for invalid or too small value
    }

    return null;
  }

  /// coupons must be greater than or equal to 1
  static String? validatePermalink(String? value) {
    if (value == null || value.isEmpty) {
      return 'Product permanent link is required.';
    }

    if (value.trim() == VendorApiEndpoints.vendorProductBaseUrl) {
      return 'Please generate unique permanent link.';
    }

    return null;
  }

  static String? validateStartAndEndDate(String? startDate, String? endDate) {
    // Skip validation if either date is empty
    if (startDate == null ||
        startDate.isEmpty ||
        endDate == null ||
        endDate.isEmpty) {
      return null;
    }

    try {
      // Parse the dates
      final DateTime start = DateTime.parse(startDate);
      final DateTime end = DateTime.parse(endDate);

      // If start date is greater than end date, return an error
      if (start.isAfter(end)) {
        return 'Start date cannot be after end date.';
      }
    } catch (e) {
      return 'Invalid date format.';
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
      return 'Address field is required.';
    }
    if (value.length < 5) {
      return 'Address must be at least 5 characters long.';
    }
    if (value.length > 100) {
      return 'Address must not exceed 100 characters.';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s,.-]+$').hasMatch(value)) {
      return 'Address contains invalid characters.';
    }
    return null; // Valid address
  }

  static String? cityValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City field is required.';
    }
    if (value.length < 2) {
      return 'City name must be at least 2 characters long.';
    }
    if (value.length > 50) {
      return 'City name must not exceed 50 characters.';
    }
    if (!RegExp(r'^[a-zA-Z\s-]+$').hasMatch(value)) {
      return 'City name can only contain letters, spaces, and hyphens.';
    }
    return null; // Valid city name
  }
}
