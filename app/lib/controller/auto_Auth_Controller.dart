import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class AutoAuthController {
  final _storage = FlutterSecureStorage();
  final String baseUrl = "$API_BASE_URL/api/me";

  Future<bool> isTokenValid() async {
    final token = await _storage.read(key: 'jwt');
    if (token == null) return false;

    try {
      final url = Uri.parse(baseUrl);
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
