import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/auth/services/auth_service.dart';
import '../viewmodel/home_viewmodel.dart';
import '../../../app/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleSignOut(BuildContext context, HomeViewModel viewModel) async {
    final success = await viewModel.signOut();
    if (success && context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

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
            drawer: Drawer(
              backgroundColor: Colors.grey.shade900,
              child: Column(
                children: [
                  // Header del Drawer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade700,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            // Avatar con inicial
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue.shade600,
                              child: Text(
                                viewModel.getInitials(email),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Información del usuario
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    viewModel.getDisplayEmail(email),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Usuario',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Contenido del menú
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildDrawerItem(
                          icon: Icons.home,
                          title: 'Inicio',
                          onTap: () => Navigator.pop(context),
                        ),
                        _buildDrawerItem(
                          icon: Icons.directions_car,
                          title: 'Mis Vehículos',
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navegar a pantalla de vehículos
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.build,
                          title: 'Servicios',
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navegar a pantalla de servicios
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.history,
                          title: 'Historial',
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navegar a pantalla de historial
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.person,
                          title: 'Perfil',
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navegar a pantalla de perfil
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.settings,
                          title: 'Configuración',
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navegar a pantalla de configuración
                          },
                        ),
                      ],
                    ),
                  ),

                  // Botón de cerrar sesión
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade700,
                          width: 1,
                        ),
                      ),
                    ),
                    child: _buildDrawerItem(
                      icon: Icons.exit_to_app,
                      title: 'Cerrar Sesión',
                      onTap: () {
                        Navigator.pop(context);
                        _handleSignOut(context, viewModel);
                      },
                      isLogout: true,
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red.shade300 : Colors.white,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red.shade300 : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.grey.shade800,
      splashColor: Colors.grey.shade700,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}