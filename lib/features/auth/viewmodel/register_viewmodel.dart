import 'package:flutter/material.dart';
import '../../../core/services/secure_storage_service.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService authService;
  final SecureStorageService storage;

  bool loading = false;
  String? errorMessage;

  RegisterViewModel(this.authService, this.storage);

  Future<bool> register(String email, String password) async {
    try {
      loading = true;
      errorMessage = null;
      notifyListeners();

      final user = await authService.register(email, password);

      if (user != null) {
        // Guardamos login automático tras registrarse
        await storage.setLoggedIn(true);
        return true;
      }

      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
