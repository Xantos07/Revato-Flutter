import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'config.dart';
class AuthController {
  final storage = const FlutterSecureStorage();
  final String apiUrl = '$API_BASE_URL/api/login';

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        await storage.write(key: 'jwt', value: token);
        print("✅ Token sauvegardé");
        return true;
      } else {
        print("❌ Erreur login: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Exception login: $e");
      return false;
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt');
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt');
  }
}
