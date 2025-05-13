import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) => _storage.write(key: 'jwt', value: token);
  Future<String?> readToken() => _storage.read(key: 'jwt');
  Future<void> deleteToken() => _storage.delete(key: 'jwt');
}
