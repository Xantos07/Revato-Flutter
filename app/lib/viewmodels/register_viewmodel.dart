import '../../controller/register_controller.dart';

class RegisterViewModel {
  final AuthService _authService = AuthService();

  Future<bool> register(String email, String password) async {
    return await _authService.register(email.trim(), password);
  }

  bool isEmailValid(String pass) =>
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(pass);

  bool isLengthValid(String pass) => pass.length >= 15;

  bool hasLowercase(String pass) =>
      RegExp(r'[a-z].*[a-z]').hasMatch(pass);

  bool hasUppercase(String pass) =>
      RegExp(r'[A-Z].*[A-Z]').hasMatch(pass);

  bool hasDigits(String pass) =>
      RegExp(r'\d.*\d').hasMatch(pass);

  bool hasSpecialChars(String pass) =>
      RegExp(r'[!@#\$%\^&*(),.?":{}|<>].*[!@#\$%\^&*(),.?":{}|<>]')
          .hasMatch(pass);
}
