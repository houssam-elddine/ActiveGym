import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'config.dart';

class ApiService {
  static String? token;

  static Map<String, String> headers() {
    return {
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  static Future<http.Response> get(String url) {
    return http.get(
      Uri.parse(Config.baseUrl + url),
      headers: headers(),
    );
  }

  static Future<http.Response> post(String url, Map data) {
    return http.post(
      Uri.parse(Config.baseUrl + url),
      headers: {
        ...headers(),
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> put(String url, Map data) {
    return http.put(
      Uri.parse(Config.baseUrl + url),
      headers: {
        ...headers(),
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );
  }

  static Future<void> delete(String url) async {
    await http.delete(
      Uri.parse(Config.baseUrl + url),
      headers: headers(),
    );
  }

  static Future<http.Response> multipart(
    String url,
    Map<String, String> fields,
    File? image, {
    bool isUpdate = false,
  }) async {
    var request = http.MultipartRequest(
      isUpdate ? 'PUT' : 'POST',
      Uri.parse(Config.baseUrl + url),
    );

    request.headers.addAll(headers());
    request.fields.addAll(fields);

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('img', image.path),
      );
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception('Erreur: ${response.statusCode} ${response.body}');
    }
  }
}
