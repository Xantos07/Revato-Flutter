import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/tag_model.dart';
import 'config.dart';

class TagController {
  final _storage = const FlutterSecureStorage();
  final _baseUrl = "$API_BASE_URL/api/tags";

  Future<List<TagModel>> fetchTagsPaginated({
    required int page,
    required int pageSize,
    String? category,
    String? search,
  }) async {
    final token = await _storage.read(key: 'jwt');
    final queryParams = {
      'page': '$page',
      'pageSize': '$pageSize',
      if (category != null) 'category': category,
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print('📦 Payload reçu : ${response.body}');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);


      final List<dynamic> tagsJson = decoded['tags'];

      return tagsJson.map((e) => TagModel.fromJson(e)).toList();
    } else {
      throw Exception('Erreur de chargement paginé des tags');
    }
  }

}
