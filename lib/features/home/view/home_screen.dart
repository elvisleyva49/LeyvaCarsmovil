import 'package:flutter/material.dart';
import '../../../features/auth/services/auth_service.dart';
import '../../../app/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      final authService = AuthService();
      await authService.logout();
      
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Bienvenido, estás logueado."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: const Text("Cerrar sesión"),
            ),
          ],
        ),
      ),
    );
  }
}