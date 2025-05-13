import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class UserController{

  final String apiUrl = '$API_BASE_URL/api/me';

  Future<Map<String, dynamic>> getUser(String token) async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération des données utilisateur');
    }
  }
}