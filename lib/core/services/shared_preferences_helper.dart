import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurePreferencesUtil {
  static SharedPreferences? _preferences;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm:
          KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Keys for sensitive data (stored in secure storage)
  static const String _tokenKey = 'auth_token';
  static const String _userNameKey = 'userName';
  static const String _userMailKey = 'userMail';

  // Keys for non-sensitive data (stored in regular shared preferences)
  static const String isLoggedInKey = 'isLoggedIn';
  static const String isApproved = 'is_approved';
  static const String isVerified = 'is_verified';
  static const String isVendor = 'is_vendor';
  static const String isFirstTimeKey = 'isFirstTime';
  static const String serverStep = 'serverStep';

  // Getters for backward compatibility
  static String get tokenKey => _tokenKey;
  static String get loggedInKey => isLoggedInKey;
  static String get verified => isVerified;
  static String get approved => isApproved;
  static String get vendor => isVendor;

  /// Initialize the preferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // ===============================
  // SECURE STORAGE METHODS (for sensitive data)
  // ===============================

  /// Save user name securely
  static Future<void> saveUserName(String name) async {
    await _secureStorage.write(key: _userNameKey, value: name);
  }

  /// Get user name from secure storage
  static Future<String?> getUserName() async =>
      _secureStorage.read(key: _userNameKey);

  /// Save user email securely
  static Future<void> saveUserMail(String userMail) async {
    await _secureStorage.write(key: _userMailKey, value: userMail);
  }

  /// Get user email from secure storage
  static Future<String?> getUserMail() async =>
      _secureStorage.read(key: _userMailKey);

  /// Save authentication token securely
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  /// Get authentication token from secure storage
  static Future<String?> getToken() async =>
      _secureStorage.read(key: _tokenKey);

  /// Remove authentication token
  static Future<void> removeToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  /// Remove user name
  static Future<void> removeUserName() async {
    await _secureStorage.delete(key: _userNameKey);
  }

  /// Remove user email
  static Future<void> removeUserMail() async {
    await _secureStorage.delete(key: _userMailKey);
  }

  // ===============================
  // REGULAR SHARED PREFERENCES METHODS (for non-sensitive data)
  // ===============================

  /// Save server step
  static Future<void> saveServerStep(int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(serverStep, step);
  }

  /// Get server step
  static Future<int?> getServerStep() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(serverStep);
  }

  /// Set boolean value
  static Future<void> setBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  /// Set integer value
  static Future<void> setInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  /// Get boolean value
  static bool getBool(String key) => _preferences?.getBool(key) ?? false;

  /// Set string value (for non-sensitive data only)
  static Future<void> setString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  /// Get string value (for non-sensitive data only)
  static String? getString(String key) => _preferences?.getString(key);

  /// Remove key from regular preferences
  static Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  /// Set vendor data
  static Future<void> setVendorData({
    bool approved = false,
    bool verified = false,
    int vendor = 0,
  }) async {
    await setBool(isApproved, approved);
    await setBool(isVerified, verified);
    await setInt(isVendor, vendor);
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences?.getBool(isLoggedInKey) ?? false;
  }

  /// Set login status
  static Future<void> setLoginStatus(bool status) async {
    await setBool(isLoggedInKey, status);
  }

  // ===============================
  // CLEAR ALL DATA METHODS
  // ===============================

  /// Clear all regular shared preferences
  static Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Clear all secure storage data
  static Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  /// Clear all data (both regular and secure)
  static Future<void> clearAllData() async {
    await clearSharedPreferences();
    await clearSecureStorage();
  }

  /// Logout user - clear sensitive data but keep some preferences
  static Future<void> logout() async {
    // Clear sensitive data from secure storage
    await removeToken();
    await removeUserName();
    await removeUserMail();

    // Clear login status and vendor data from regular preferences
    await setBool(isLoggedInKey, false);
    await setBool(isApproved, false);
    await setBool(isVerified, false);
    await setInt(isVendor, 0);
  }

  // ===============================
  // UTILITY METHODS
  // ===============================

  /// Check if secure storage contains a key
  static Future<bool> containsKeyInSecureStorage(String key) async =>
      _secureStorage.containsKey(key: key);

  /// Get all keys from secure storage
  static Future<Map<String, String>> getAllFromSecureStorage() async =>
      _secureStorage.readAll();
}



// import 'package:shared_preferences/shared_preferences.dart';
//
// class SharedPreferencesUtil {
//   static SharedPreferences? _preferences;
//
//   static const String isLoggedInKey = 'isLoggedIn';
//   static const String _tokenKey = 'auth_token';
//   static const String isApproved = 'is_approved';
//   static const String isVerified = 'is_verified';
//   static const String isVendor = 'is_vendor';
//   static const String isFirstTimeKey = 'isFirstTime';
//   static const String serverStep = 'serverStep';
//
//   static String get tokenKey => _tokenKey;
//
//   static String get loggedInKey => isLoggedInKey;
//
//   static String get verified => isVerified;
//
//   static String get approved => isApproved;
//
//   static String get vendor => isVendor;
//
//   static Future<void> saveUserName(String name) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userName', name);
//   }
//
//   static Future<String?> getUserName() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userName');
//   }
//
//   // Add other keys as needed
//
//   static Future<void> saveUserMail(String userMail) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userMail', userMail);
//   }
//
//   static Future<void> saveServerStep(int step) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(serverStep, step);
//   }
//
//   /// save user mail
//
//   static Future<String?> getUserMail() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userMail');
//   }
//
//   static Future<int?> getServerStep() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt(serverStep);
//   }
//
//   static Future<void> init() async {
//     _preferences = await SharedPreferences.getInstance();
//   }
//
//   static Future<void> setBool(String key, bool value) async {
//     await _preferences?.setBool(key, value);
//   }
//
//   static Future<void> setInt(String key, int value) async {
//     await _preferences?.setInt(key, value);
//   }
//
//   static bool getBool(String key) {
//     return _preferences?.getBool(key) ?? false;
//   }
//
//   static Future<void> setString(String key, String value) async {
//     await _preferences?.setString(key, value);
//   }
//
//   static String? getString(String key) {
//     return _preferences?.getString(key);
//   }
//
//   static Future<void> remove(String key) async {
//     await _preferences?.remove(key);
//   }
//
//   ///     -------------------------- SAVE THE TOKEN  --------------------------------
//
//   static Future<void> saveToken(String token) async {
//     await setString(_tokenKey, token);
//   }
//
//   static Future<String?> getToken() async {
//     return getString(_tokenKey);
//   }
//
//   static Future<void> removeToken() async {
//     await remove(_tokenKey);
//   }
//
//   static Future<void> clearSharedPreferences() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }
//
//   static Future<void> setVendorData({bool approved = false, bool verified = false, int vendor = 0}) async {
//     await setBool(isApproved, approved);
//     await setBool(isVerified, verified);
//     await setInt(isVendor, vendor);
//   }
//
//   /// ---------------------------------   SAVE LOGIN KEY --------------------------------
//
//   static Future<bool> isLoggedIn() async {
//     _preferences = await SharedPreferences.getInstance();
//     return await _preferences?.getBool(isLoggedInKey) ?? false;
//   }
// }