import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashViewModel {
  final _storage = FlutterSecureStorage();

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'jwt');
    return token != null;
  }
}
