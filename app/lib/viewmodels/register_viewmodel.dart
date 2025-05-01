// lib/viewmodels/register_viewmodel.dart
import '../../controller/register_controller.dart';

class RegisterViewModel {
  final AuthService _authService = AuthService();

  Future<bool> register(String email, String password) async {
    return await _authService.register(email.trim(), password);
  }
}
