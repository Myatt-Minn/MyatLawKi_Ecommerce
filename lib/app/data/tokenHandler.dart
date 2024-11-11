import 'package:shared_preferences/shared_preferences.dart';

class Tokenhandler {
  static const String _tokenKey = 'auth_token';

  // Save the token to SharedPreferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Retrieve the token from SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Clear the token from SharedPreferences
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
