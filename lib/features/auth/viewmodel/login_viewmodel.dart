import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../../../core/services/secure_storage_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService authService;
  final SecureStorageService storage;

  bool loading = false;
  String? errorMessage;

  LoginViewModel(this.authService, this.storage);

  Future<bool> login(String email, String password) async {
    try {
      loading = true;
      notifyListeners();

      final user = await authService.login(email, password);

      if (user != null) {
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
