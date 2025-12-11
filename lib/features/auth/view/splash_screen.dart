import 'package:flutter/material.dart';
import '../../../core/services/secure_storage_service.dart';
import '../services/auth_service.dart';
import '../viewmodel/splash_viewmodel.dart';
import '../../../app/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final viewModel =
      SplashViewModel(AuthService(), SecureStorageService());

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  void checkSession() async {
    await Future.delayed(const Duration(seconds: 1));

    final logged = await viewModel.isUserLogged();

    if (logged) {
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
