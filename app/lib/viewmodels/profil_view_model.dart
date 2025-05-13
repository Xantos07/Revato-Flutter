import 'package:flutter/material.dart';
import '../controller/authentification_controller.dart';
import '../models/user_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthController _authController = AuthController();

  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    _user = await _authController.fetchUser();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await _authController.logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
