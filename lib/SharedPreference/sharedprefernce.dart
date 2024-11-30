

// ignore_for_file: non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedUserPreferences {
  static late SharedPreferences _preferences;
  static const _keyUser = "username";
  static const _keyU = "CatList"; 
  static const _keyEmail = "email";
  static const _keyMobile = "mobile";
  static const _keyadd = "add";
  static const _keyGender = "gender";
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

 
  static Future setCatList(List<String> data) async =>
      await _preferences.setStringList(_keyU, data);

  static List<String>? getCatList() => _preferences.getStringList(_keyU);

  static Future setUsername(String username) async =>
      await _preferences.setString(_keyUser, username);
  static String? getUsername() => _preferences.getString(_keyUser);


  static Future setEmail(String email) async =>
      await _preferences.setString(_keyEmail, email);
  static String? getEmail() => _preferences.getString(_keyEmail);

  static Future setMobile(String mobile) async =>
      await _preferences.setString(_keyMobile, mobile);
  static String? getMobile() => _preferences.getString(_keyMobile);

  static Future setAddress(String Address) async =>
      await _preferences.setString(_keyadd, Address);
  static String? getAddress() => _preferences.getString(_keyadd);

 
  static Future setGender(String Gender) async =>
      await _preferences.setString(_keyGender, Gender);
  static String? getGender() => _preferences.getString(_keyGender);

  
  static Future logout() async {
    await _preferences.clear();

  
  }
}
