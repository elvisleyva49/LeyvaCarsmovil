import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/secure_storage_service.dart';
import '../services/auth_service.dart';
import '../viewmodel/login_viewmodel.dart';
import '../../../app/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(AuthService(), SecureStorageService()),
      child: _LoginBody(),
    );
  }
}

class _LoginBody extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  _LoginBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña"),
            ),

            const SizedBox(height: 20),

            if (vm.errorMessage != null)
              Text(
                vm.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 10),

            vm.loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      final ok = await vm.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );

                      if (ok) {
                        Navigator.pushReplacementNamed(
                            context, Routes.home);
                      }
                    },
                    child: const Text("Iniciar Sesión"),
                  ),
            // Agregar el botón "Crear cuenta" aquí
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.register);
              },
              child: const Text("Crear cuenta"),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
