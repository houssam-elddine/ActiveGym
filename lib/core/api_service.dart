import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class ApiService {
  static String? token;

  static Future<http.Response> get(String endpoint) {
    return http.get(
      Uri.parse("${Config.baseUrl}$endpoint"),
      headers: _headers(),
    );
  }

  static Future<http.Response> post(String endpoint, Map data) {
    return http.post(
      Uri.parse("${Config.baseUrl}$endpoint"),
      headers: _headers(),
      body: jsonEncode(data),
    );
  }

  static Map<String, String> _headers() {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }
}
