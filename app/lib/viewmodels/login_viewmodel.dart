import '../controller/authentification_controller.dart';

class LoginViewModel {
  final AuthController _authService = AuthController();

  Future<bool> login(String email, String password) async {
    return await _authService.login(email.trim(), password);
  }
}
