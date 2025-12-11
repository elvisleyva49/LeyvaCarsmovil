import 'package:flutter/material.dart';
import '../features/auth/view/login_screen.dart';
import '../features/auth/view/splash_screen.dart';
import '../features/auth/view/register_screen.dart';
import '../features/home/view/home_screen.dart';

class Routes {
  static const splash = "/splash";
  static const login = "/login";
  static const register = "/register";
  static const home = "/home";

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      splash: (_) => const SplashScreen(),
      login: (_) => const LoginScreen(),
      register: (_) => const RegisterScreen(),
      home: (_) => const HomeScreen(),
    };
  }
}
