import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static SharedPreferences? _preferences;

  static const String isLoggedInKey = 'isLoggedIn';
  static const String _tokenKey = 'auth_token';
  static const String isApproved = 'is_approved';
  static const String isVerified = 'is_verified';
  static const String isVendor = 'is_vendor';
  static const String isFirstTimeKey = 'isFirstTime';
  static const String serverStep = 'serverStep';

  static String get tokenKey => _tokenKey;

  static String get loggedInKey => isLoggedInKey;

  static String get verified => isVerified;

  static String get approved => isApproved;

  static String get vendor => isVendor;

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  // Add other keys as needed

  static Future<void> saveUserMail(String userMail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userMail', userMail);
  }

  static Future<void> saveServerStep(int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(serverStep, step);
  }

  /// save user mail

  static Future<String?> getUserMail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userMail');
  }

  static Future<int?> getServerStep() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(serverStep);
  }

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  static bool getBool(String key) {
    return _preferences?.getBool(key) ?? false;
  }

  static Future<void> setString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  static String? getString(String key) {
    return _preferences?.getString(key);
  }

  static Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  ///     -------------------------- SAVE THE TOKEN  --------------------------------

  static Future<void> saveToken(String token) async {
    await setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    return getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    await remove(_tokenKey);
  }

  static Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> setVendorData({bool approved = false, bool verified = false, int vendor = 0}) async {
    await setBool(isApproved, approved);
    await setBool(isVerified, verified);
    await setInt(isVendor, vendor);
  }

  /// ---------------------------------   SAVE LOGIN KEY --------------------------------

  static Future<bool> isLoggedIn() async {
    _preferences = await SharedPreferences.getInstance();
    return await _preferences?.getBool(isLoggedInKey) ?? false;
  }
}
