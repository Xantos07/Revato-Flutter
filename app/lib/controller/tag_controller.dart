import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/tag_model.dart';
import 'config.dart';

class TagController {
  final String baseUrl = "$API_BASE_URL/api/tags";
  final storage = const FlutterSecureStorage();

  Future<List<TagModel>> fetchUserTags() async {
    String? token = await storage.read(key: 'jwt');

    final url = Uri.parse(baseUrl);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Debug prints
    print("📡 GET Tags");
    print("URL: $url");
    print("Headers: $headers");

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TagModel.fromJson(json)).toList();
    } else {
      print("❌ Erreur ${response.statusCode} : ${response.body}");
      throw Exception('Erreur lors du chargement des tags');
    }
  }
}
