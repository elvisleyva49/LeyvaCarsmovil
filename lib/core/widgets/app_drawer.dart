import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/services/auth_service.dart';
import '../../app/routes.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.currentRoute,
  });

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      final authService = AuthService();
      await authService.logout();
      
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
    }
  }

  String _getDisplayEmail(String email) {
    // Ahora retornamos el email completo y dejamos que el Text widget
    // se encargue del overflow automático basado en el ancho disponible
    return email;
  }

  String _getInitials(String email) {
    if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'usuario@example.com';

    return Drawer(
      width: 250,
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
                        _getInitials(email),
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
                            _getDisplayEmail(email),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
                _DrawerItem(
                  icon: Icons.home,
                  title: 'Inicio',
                  isSelected: currentRoute == Routes.home,
                  onTap: () {
                    Navigator.pop(context);
                    if (currentRoute != Routes.home) {
                      Navigator.pushReplacementNamed(context, Routes.home);
                    }
                  },
                ),
                _DrawerItem(
                  icon: Icons.inventory_2,
                  title: 'Productos',
                  isSelected: currentRoute == Routes.productos,
                  onTap: () {
                    Navigator.pop(context);
                    if (currentRoute != Routes.productos) {
                      Navigator.pushReplacementNamed(context, Routes.productos);
                    }
                  },
                ),
                _DrawerItem(
                  icon: Icons.directions_car,
                  title: 'Mis Vehículos',
                  isSelected: false, // TODO: Cuando se implemente
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navegar a pantalla de vehículos
                  },
                ),
                _DrawerItem(
                  icon: Icons.build,
                  title: 'Servicios',
                  isSelected: false, // TODO: Cuando se implemente
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navegar a pantalla de servicios
                  },
                ),
                _DrawerItem(
                  icon: Icons.history,
                  title: 'Historial',
                  isSelected: false, // TODO: Cuando se implemente
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navegar a pantalla de historial
                  },
                ),
                _DrawerItem(
                  icon: Icons.person,
                  title: 'Perfil',
                  isSelected: false, // TODO: Cuando se implemente
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navegar a pantalla de perfil
                  },
                ),
                _DrawerItem(
                  icon: Icons.settings,
                  title: 'Configuración',
                  isSelected: false, // TODO: Cuando se implemente
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
            child: _DrawerItem(
              icon: Icons.exit_to_app,
              title: 'Cerrar Sesión',
              isSelected: false,
              isLogout: true,
              onTap: () {
                Navigator.pop(context);
                _handleSignOut(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isLogout;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isSelected,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout 
            ? Colors.red.shade300 
            : isSelected 
                ? Colors.blue.shade300 
                : Colors.white,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout 
              ? Colors.red.shade300 
              : isSelected 
                  ? Colors.blue.shade300 
                  : Colors.white,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.grey.shade800,
      splashColor: Colors.grey.shade700,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      tileColor: isSelected ? Colors.grey.shade800.withOpacity(0.5) : null,
    );
  }
}