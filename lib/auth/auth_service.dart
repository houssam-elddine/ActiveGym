import 'dart:convert';
import '../core/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<String?> login(String email, String password) async {
    final res = await ApiService.post('/login', {
      "email": email,
      "password": password,
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final token = data['token'];
      ApiService.token = token;

      // 🔹 حفظ التوكن في SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('role', data['user']['role']);

      return data['user']['role']; 
    }
    return null;
  }

  // استرجاع الـ token عند بدء التطبيق
  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    ApiService.token = token;
  }

  static Future<bool> registerClient(
    String name,
    String email,
    String password,
  ) async {
    final res = await ApiService.post('/register', {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": password,
    });

    return res.statusCode == 201;
  }

  // تسجيل خروج
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    ApiService.token = null;
  }
}
