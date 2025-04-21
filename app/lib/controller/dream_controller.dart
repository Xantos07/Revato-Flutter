import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dream.dart';

class DreamController {
  final String baseUrl = "http://localhost:8000/api/dreams";

  Future<bool> createDream(Dream dream) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(dream.toJson()),
    );

    return response.statusCode == 201;
  }
}
