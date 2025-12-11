import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../features/auth/services/auth_service.dart';

class HomeViewModel extends ChangeNotifier {
  final AuthService _authService;
  
  HomeViewModel(this._authService);

  // Estado
  User? _currentUser;
  bool _loading = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get loading => _loading;
  String get userEmail => _currentUser?.email ?? 'usuario@example.com';

  // Inicializar datos del usuario
  void initialize() {
    _currentUser = _authService.currentUser;
    notifyListeners();
  }

  // Obtener iniciales del email
  String getInitials(String email) {
    if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return 'U';
  }

  // Formatear email para display
  String getDisplayEmail(String email) {
    if (email.length > 25) {
      return '${email.substring(0, 22)}...';
    }
    return email;
  }

  // Cerrar sesión
  Future<bool> signOut() async {
    try {
      _loading = true;
      notifyListeners();

      await _authService.logout();
      
      _currentUser = null;
      _loading = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      debugPrint('Error al cerrar sesión: $e');
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}