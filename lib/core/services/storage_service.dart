import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'auth_user';

  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Token Management
  Future<void> saveToken(String token) async {
    await _prefs.setString(_keyToken, token);
  }

  String? getToken() {
    return _prefs.getString(_keyToken);
  }

  bool get isLoggedIn {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  // User Data Management
  Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs.setString(_keyUser, jsonEncode(user));
  }

  Map<String, dynamic>? getUser() {
    final userJson = _prefs.getString(_keyUser);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        return jsonDecode(userJson) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // Financial Profile / Questionnaire Status
  bool get isFinancialProfileCompleted {
    final user = getUser();
    if (user != null) {
      return user['isFinancialProfileCompleted'] == true;
    }
    return false;
  }

  Future<void> setFinancialProfileCompleted(bool value) async {
    final user = getUser() ?? {};
    user['isFinancialProfileCompleted'] = value;
    await saveUser(user);
  }

  // Premium Status
  bool get isPremium {
    final user = getUser();
    if (user != null) {
      return user['isPremium'] == true;
    }
    return false;
  }

  // User Currency Management
  String getUserCurrency() {
    final user = getUser();
    if (user != null && user['currency'] != null && user['currency'].toString().isNotEmpty) {
      return user['currency'].toString();
    }
    return 'KR';
  }

  // Clear Session (Logout)
  Future<void> clearAuth() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyUser);
  }
}
