import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/secure_storage_service.dart';
import '../services/auth_service.dart';
import '../viewmodel/register_viewmodel.dart';
import '../../../app/routes.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(AuthService(), SecureStorageService()),
      child: _RegisterBody(),
    );
  }
}

class _RegisterBody extends StatelessWidget {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final pass2Ctrl = TextEditingController();

  _RegisterBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Crear cuenta")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña"),
            ),
            TextField(
              controller: pass2Ctrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Repetir contraseña"),
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
                      if (passCtrl.text.trim() != pass2Ctrl.text.trim()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Las contraseñas no coinciden")),
                        );
                        return;
                      }

                      final ok = await vm.register(
                        emailCtrl.text.trim(),
                        passCtrl.text.trim(),
                      );

                      if (ok) {
                        Navigator.pushReplacementNamed(context, Routes.home);
                      }
                    },
                    child: const Text("Registrarme"),
                  ),

            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, Routes.login);
              },
              child: const Text("Ya tengo cuenta"),
            ),
          ],
        ),
      ),
    );
  }
}
