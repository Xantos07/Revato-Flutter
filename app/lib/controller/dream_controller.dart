import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/dream.dart';
import 'config.dart';

class DreamController {
  final String baseUrl = "${API_BASE_URL}/api/dreams";

  final storage = FlutterSecureStorage();

  Future<bool> createDream(Dream dream) async {
    String? token = await storage.read(key: 'jwt');

    // On prépare tout ce qu'on va envoyer
    final url = Uri.parse(baseUrl);
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    final body = jsonEncode(dream.toJson());

    // Ajoute les prints pour voir ce qui est envoyé
    print("URL: $url");
    print("Headers: $headers");
    print("Body: $body");

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    return response.statusCode == 201;
  }

// GET: récupérer toutes les rêves
  Future<List<Dream>> getDreams() async {
    String? token = await storage.read(key: 'jwt');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.get(
      Uri.parse('$API_BASE_URL/api/dreams'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Dream.fromJson(json)).toList();
    } else {
      throw Exception('Erreur: ${response.statusCode}');
    }
  }
}


