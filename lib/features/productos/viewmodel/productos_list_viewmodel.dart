import 'package:flutter/foundation.dart';
import '../model/producto_model.dart';
import '../services/producto_service.dart';

class ProductosListViewModel extends ChangeNotifier {
  final ProductoService _productoService;

  ProductosListViewModel(this._productoService);

  // Estado
  List<ProductoModel> _productos = [];
  List<ProductoModel> _productosFiltrados = [];
  bool _loading = false;
  String _errorMessage = '';
  String _searchQuery = '';

  // Getters
  List<ProductoModel> get productos => _productosFiltrados;
  bool get loading => _loading;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get hasProducts => _productos.isNotEmpty;

  // Cargar productos
  Future<void> cargarProductos() async {
    try {
      _loading = true;
      _errorMessage = '';
      notifyListeners();

      _productos = await _productoService.obtenerProductos();
      _aplicarFiltro();

      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _errorMessage = e.toString();
      notifyListeners();
      debugPrint('Error al cargar productos: $e');
    }
  }

  // Buscar productos
  void buscarProductos(String query) {
    _searchQuery = query.trim();
    _aplicarFiltro();
    notifyListeners();
  }

  // Aplicar filtro de búsqueda
  void _aplicarFiltro() {
    if (_searchQuery.isEmpty) {
      _productosFiltrados = List.from(_productos);
    } else {
      final queryLower = _searchQuery.toLowerCase();
      _productosFiltrados = _productos
          .where((producto) {
            // Buscar en nombre (obligatorio)
            bool matchNombre = producto.nombre.toLowerCase().contains(queryLower);
            
            // Buscar en marca (opcional)
            bool matchMarca = producto.marca?.toLowerCase().contains(queryLower) ?? false;
            
            // Buscar en modelo (opcional)
            bool matchModelo = producto.modelo?.toLowerCase().contains(queryLower) ?? false;
            
            // Buscar en combinación marca + modelo
            String marcaModelo = '${producto.marca ?? ''} ${producto.modelo ?? ''}'.toLowerCase().trim();
            bool matchMarcaModelo = marcaModelo.contains(queryLower);
            
            return matchNombre || matchMarca || matchModelo || matchMarcaModelo;
          })
          .toList();
    }
  }

  // Limpiar error
  void limpiarError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Limpiar búsqueda
  void limpiarBusqueda() {
    _searchQuery = '';
    _aplicarFiltro();
    notifyListeners();
  }

  // Refrescar lista
  Future<void> refrescar() async {
    await cargarProductos();
  }
}