import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/producto_service.dart';
import '../viewmodel/agregar_producto_viewmodel.dart';

class AgregarProductoScreen extends StatelessWidget {
  const AgregarProductoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AgregarProductoViewModel(ProductoService()),
      child: const _AgregarProductoBody(),
    );
  }
}

class _AgregarProductoBody extends StatefulWidget {
  const _AgregarProductoBody();

  @override
  State<_AgregarProductoBody> createState() => _AgregarProductoBodyState();
}

class _AgregarProductoBodyState extends State<_AgregarProductoBody> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _stockController = TextEditingController();
  final _anioInicioController = TextEditingController();
  final _anioFinController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _stockController.dispose();
    _anioInicioController.dispose();
    _anioFinController.dispose();
    super.dispose();
  }

  void _mostrarOpcionesImagen(AgregarProductoViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Seleccionar imagen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOption(
                    icon: Icons.camera_alt,
                    label: 'Cámara',
                    onTap: () {
                      Navigator.pop(context);
                      viewModel.tomarFoto();
                    },
                  ),
                  _buildImageOption(
                    icon: Icons.photo_library,
                    label: 'Galería',
                    onTap: () {
                      Navigator.pop(context);
                      viewModel.seleccionarImagen();
                    },
                  ),
                  if (viewModel.tieneImagen)
                    _buildImageOption(
                      icon: Icons.delete,
                      label: 'Eliminar',
                      onTap: () {
                        Navigator.pop(context);
                        viewModel.removerImagen();
                      },
                      color: Colors.red,
                    ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: (color ?? Colors.blue.shade700).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              icon,
              color: color ?? Colors.blue.shade700,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color ?? Colors.grey.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agregar Producto'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Consumer<AgregarProductoViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Sección de imagen
                    _buildImageSection(viewModel),
                    const SizedBox(height: 24),

                    // Campos del formulario
                    _buildTextField(
                      controller: _nombreController,
                      label: 'Nombre *',
                      icon: Icons.inventory_2,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'El nombre es obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _marcaController,
                      label: 'Marca',
                      icon: Icons.business,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _modeloController,
                      label: 'Modelo',
                      icon: Icons.category,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _stockController,
                      label: 'Stock',
                      icon: Icons.format_list_numbered,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isNotEmpty == true) {
                          final stock = int.tryParse(value!);
                          if (stock == null || stock < 0) {
                            return 'Ingrese un número válido';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Años de compatibilidad
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _anioInicioController,
                            label: 'Año Inicio',
                            icon: Icons.calendar_today,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isNotEmpty == true) {
                                final anio = int.tryParse(value!);
                                if (anio == null || anio < 1900 || anio > 2100) {
                                  return 'Año inválido';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _anioFinController,
                            label: 'Año Fin',
                            icon: Icons.event,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isNotEmpty == true) {
                                final anio = int.tryParse(value!);
                                if (anio == null || anio < 1900 || anio > 2100) {
                                  return 'Año inválido';
                                }
                                
                                final anioInicio = int.tryParse(_anioInicioController.text);
                                if (anioInicio != null && anio < anioInicio) {
                                  return 'Debe ser >= año inicio';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Mensaje de error
                    if (viewModel.errorMessage.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red.shade600),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                viewModel.errorMessage,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Botón guardar
                    ElevatedButton(
                      onPressed: viewModel.loading ? null : () => _guardarProducto(viewModel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: viewModel.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Guardar Producto',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageSection(AgregarProductoViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imagen del producto',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _mostrarOpcionesImagen(viewModel),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
                width: 2,
              ),
            ),
            child: viewModel.imagenSeleccionada != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      viewModel.imagenSeleccionada!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toca para agregar imagen',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Future<void> _guardarProducto(AgregarProductoViewModel viewModel) async {
    if (_formKey.currentState?.validate() ?? false) {
      viewModel.limpiarError();

      final success = await viewModel.crearProducto(
        nombre: _nombreController.text,
        marca: _marcaController.text.isNotEmpty ? _marcaController.text : null,
        modelo: _modeloController.text.isNotEmpty ? _modeloController.text : null,
        stock: _stockController.text.isNotEmpty ? int.tryParse(_stockController.text) : null,
        anioInicio: _anioInicioController.text.isNotEmpty ? int.tryParse(_anioInicioController.text) : null,
        anioFin: _anioFinController.text.isNotEmpty ? int.tryParse(_anioFinController.text) : null,
      );

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto creado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}