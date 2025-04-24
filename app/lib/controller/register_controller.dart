import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class AuthService {
  Future<bool> register(String email, String password) async {
    final storage = const FlutterSecureStorage();

    final response = await http.post(
      Uri.parse('$API_BASE_URL/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("✅ Utilisateur créé !");
      final token = jsonDecode(response.body)['token'];
      await storage.write(key: 'jwt', value: token);
      print("✅ Token sauvegardé");
      return true;
    } else {
      print("❌ Erreur d'inscription : ${response.body}");
      return false;
    }
  }
}
