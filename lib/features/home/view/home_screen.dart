import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/auth/services/auth_service.dart';
import '../viewmodel/home_viewmodel.dart';
import '../../../app/routes.dart';
import '../../../core/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(AuthService())..initialize(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          final email = viewModel.userEmail;

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('LeyvaCarsMóvil'),
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
            drawer: AppDrawer(currentRoute: Routes.home),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "¡Bienvenido a LeyvaCarsMóvil!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Usuario: ${viewModel.getDisplayEmail(email)}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                  const Card(
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.menu,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Desliza desde la izquierda o toca el menú\npara ver todas las opciones disponibles',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ),
          );
        },
      ),
    );
  }
}