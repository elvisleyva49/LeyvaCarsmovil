import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../model/producto_model.dart';
import '../services/producto_service.dart';

class AgregarProductoViewModel extends ChangeNotifier {
  final ProductoService _productoService;
  final ImagePicker _imagePicker = ImagePicker();

  AgregarProductoViewModel(this._productoService);

  // Estado
  bool _loading = false;
  String _errorMessage = '';
  File? _imagenSeleccionada;
  String? _imagenUrl;

  // Getters
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  File? get imagenSeleccionada => _imagenSeleccionada;
  String? get imagenUrl => _imagenUrl;
  bool get tieneImagen => _imagenSeleccionada != null || _imagenUrl != null;

  // Seleccionar imagen de la cámara
  Future<void> tomarFoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        _imagenSeleccionada = File(image.path);
        _imagenUrl = null; // Limpiar URL anterior
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error al tomar foto: $e';
      notifyListeners();
    }
  }

  // Seleccionar imagen de la galería
  Future<void> seleccionarImagen() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        _imagenSeleccionada = File(image.path);
        _imagenUrl = null; // Limpiar URL anterior
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error al seleccionar imagen: $e';
      notifyListeners();
    }
  }

  // Mostrar opciones de imagen
  void mostrarOpcionesImagen() {
    // Este método será llamado desde la vista para mostrar el BottomSheet
  }

  // Remover imagen seleccionada
  void removerImagen() {
    _imagenSeleccionada = null;
    _imagenUrl = null;
    notifyListeners();
  }

  // Crear producto
  Future<bool> crearProducto({
    required String nombre,
    String? marca,
    String? modelo,
    int? stock,
    int? anioInicio,
    int? anioFin,
  }) async {
    try {
      _loading = true;
      _errorMessage = '';
      notifyListeners();

      // Validaciones básicas
      if (nombre.trim().isEmpty) {
        throw Exception('El nombre es obligatorio');
      }

      if (anioInicio != null && anioFin != null && anioInicio > anioFin) {
        throw Exception('El año de inicio no puede ser mayor al año final');
      }

      String? imageUrl;

      // Subir imagen si hay una seleccionada
      if (_imagenSeleccionada != null) {
        imageUrl = await _productoService.subirImagenImgBB(_imagenSeleccionada!);
      }

      // Crear el producto
      final producto = ProductoModel(
        nombre: nombre.trim(),
        marca: marca?.trim(),
        modelo: modelo?.trim(),
        stock: stock,
        anioInicio: anioInicio,
        anioFin: anioFin,
        imagenUrl: imageUrl,
      );

      await _productoService.crearProducto(producto);

      _loading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _loading = false;
      _errorMessage = e.toString();
      notifyListeners();
      debugPrint('Error al crear producto: $e');
      return false;
    }
  }

  // Limpiar formulario
  void limpiarFormulario() {
    _imagenSeleccionada = null;
    _imagenUrl = null;
    _errorMessage = '';
    notifyListeners();
  }

  // Limpiar error
  void limpiarError() {
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}