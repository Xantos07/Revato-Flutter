import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/controller/user_controller.dart';
import '../Security/secure_storage_service.dart';
import '../models/user_model.dart';
import 'config.dart';

class AuthController {
  final SecureStorageService _storage = SecureStorageService();
  final UserController _user = UserController();

  final String loginUrl = '$API_BASE_URL/api/login';
  final String registerUrl = '$API_BASE_URL/api/register';
  final String userUrl = "$API_BASE_URL/api/me";

  /// Connexion utilisateur
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        await _storage.saveToken(token);
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

  /// Inscription utilisateur
  Future<bool> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Utilisateur créé !");
        final token = jsonDecode(response.body)['token'];
        await _storage.saveToken(token);
        print("✅ Token sauvegardé");
        return true;
      } else {
        print("❌ Erreur d'inscription : ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Exception inscription: $e");
      return false;
    }
  }

  /// Lire le token
  Future<String?> getToken() async {
    return await _storage.readToken();
  }

  /// Récupérer les infos utilisateur (via UserController)
  Future<UserModel?> fetchUser() async {
    String? token = await _storage.readToken();
    if (token == null) return null;

    final userData = await _user.getUser(token);
    return UserModel.fromJson(userData);
  }

  /// Déconnexion
  Future<void> logout() async {
    await _storage.deleteToken();
  }

  /// Authentification utilisateur
  Future<bool> isTokenValid() async {
    final token = await _storage.readToken();
    if (token == null) return false;

    try {
      final url = Uri.parse(userUrl);
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('response : ' + response.body);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
