import 'package:flutter/material.dart';
import '../features/auth/view/login_screen.dart';
import '../features/auth/view/splash_screen.dart';
import '../features/auth/view/register_screen.dart';
import '../features/home/view/home_screen.dart';
import '../features/productos/view/productos_list_screen.dart';
import '../features/productos/view/agregar_producto_screen.dart';

class Routes {
  static const splash = "/splash";
  static const login = "/login";
  static const register = "/register";
  static const home = "/home";
  static const productos = "/productos";
  static const agregarProducto = "/agregar-producto";

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      splash: (_) => const SplashScreen(),
      login: (_) => const LoginScreen(),
      register: (_) => const RegisterScreen(),
      home: (_) => const HomeScreen(),
      productos: (_) => const ProductosListScreen(),
      agregarProducto: (_) => const AgregarProductoScreen(),
    };
  }
}
