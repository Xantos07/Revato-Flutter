import 'package:app/controller/authentification_controller.dart';

class SplashViewModel {
  final AuthController _authRepository;

  SplashViewModel(this._authRepository);

  Future<bool> isAuthenticated() async {
    return await _authRepository.isTokenValid();
  }
}
