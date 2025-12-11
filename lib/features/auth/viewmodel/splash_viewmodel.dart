import '../../../core/services/secure_storage_service.dart';
import '../services/auth_service.dart';

class SplashViewModel {
  final AuthService authService;
  final SecureStorageService storage;

  SplashViewModel(this.authService, this.storage);

  Future<bool> isUserLogged() async {
    // Firebase ya mantiene sesión automáticamente
    final user = authService.currentUser;

    if (user != null) return true;

    // Por si quieres usar storage en el futuro
    return false;
  }
}
