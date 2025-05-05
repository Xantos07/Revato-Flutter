import 'package:app/controller/auto_Auth_Controller.dart';
import '../controller/auto_Auth_Controller.dart';

class SplashViewModel {
  final AutoAuthController _authRepository;

  SplashViewModel(this._authRepository);

  Future<bool> isAuthenticated() async {
    return await _authRepository.isTokenValid();
  }
}
