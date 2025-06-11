import 'dart:convert';
import 'package:flutter/material.dart';
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

    print('🛠️ Réponse brute : ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      print('🧩 Données décodées : $data');

      return data.map((json) => Dream.fromJson(json)).toList();
    } else {
      print('❌ Erreur HTTP : ${response.statusCode}');
      throw Exception('Erreur: ${response.statusCode}');
    }
  }


  Future<List<Dream>> getDreamsByPage(int page, int pageSize, [List<String>? tags, DateTimeRange? dateRange]) async {

    String? token = await storage.read(key: 'jwt');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final Map<String, dynamic> queryParams = {
      'page': '$page',
      'pageSize': '$pageSize',
    };

    if (tags != null && tags.isNotEmpty) {
      for (int i = 0; i < tags.length; i++) {
        queryParams['tags[$i]'] = tags[i];
      }
    }

    if (dateRange != null) {
      print('📅 startDate: ${dateRange.start.toIso8601String()}');
      print('📅 endDate: ${dateRange.end.toIso8601String()}');
      queryParams['startDate'] = dateRange.start.toIso8601String();
      queryParams['endDate'] = dateRange.end.toIso8601String();
    } else {
      print('📅 Aucune date sélectionnée');
    }


    final url = Uri.parse('$API_BASE_URL/api/dreams').replace(queryParameters: queryParams);

    print('🔎 URL: $url');

    final response = await http.get(url, headers: headers);

    print('🔎 Réponse : ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> dreamsJson = data['dreams'];
      return dreamsJson.map((json) => Dream.fromJson(json)).toList();
    } else {
      throw Exception('Erreur HTTP: ${response.statusCode}');
    }
  }



}


