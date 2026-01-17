import 'dart:convert';
import '../core/api_service.dart';

class AuthService {
  static Future<bool> login(String email, String password) async {
    final res = await ApiService.post('/login', {
      "email": email,
      "password": password,
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      ApiService.token = data['token'];
      return data['user']['role'] == 'admin';
    }
    return false;
  }
}
