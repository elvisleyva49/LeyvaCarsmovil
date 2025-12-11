import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/producto_service.dart';
import '../viewmodel/productos_list_viewmodel.dart';
import '../../../app/routes.dart';
import '../../../core/widgets/app_drawer.dart';

class ProductosListScreen extends StatelessWidget {
  const ProductosListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductosListViewModel(ProductoService())..cargarProductos(),
      child: const _ProductosListBody(),
    );
  }
}

class _ProductosListBody extends StatefulWidget {
  const _ProductosListBody();

  @override
  State<_ProductosListBody> createState() => _ProductosListBodyState();
}

class _ProductosListBodyState extends State<_ProductosListBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Productos'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: AppDrawer(currentRoute: Routes.productos),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, Routes.agregarProducto);
          },
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Agregar Producto'),
        ),
        body: Consumer<ProductosListViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                // Buscador
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: viewModel.buscarProductos,
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre, marca o modelo...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: viewModel.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                viewModel.limpiarBusqueda();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ),

                // Indicador de resultados de búsqueda
                if (viewModel.searchQuery.isNotEmpty && !viewModel.loading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '${viewModel.productos.length} resultado(s) para "${viewModel.searchQuery}"',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                // Lista de productos
                Expanded(
                  child: _buildProductosList(viewModel),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductosList(ProductosListViewModel viewModel) {
    if (viewModel.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar productos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                viewModel.errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: viewModel.refrescar,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (!viewModel.hasProducts) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay productos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega tu primer producto tocando el botón \"+\"',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    if (viewModel.productos.isEmpty && viewModel.searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron productos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta con otros términos de búsqueda',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.refrescar,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: viewModel.productos.length,
        itemBuilder: (context, index) {
          final producto = viewModel.productos[index];
          return _ProductoCard(producto: producto);
        },
      ),
    );
  }
}

class _ProductoCard extends StatelessWidget {
  final dynamic producto;

  const _ProductoCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: producto.imagenUrl != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        producto.imagenUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholderImage(),
                      ),
                    )
                  : _buildPlaceholderImage(),
            ),
          ),

          // Información del producto
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (producto.marca != null || producto.modelo != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${producto.marca ?? ''} ${producto.modelo ?? ''}'.trim(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const Spacer(),
                  // Información inferior en fila
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Stock
                      if (producto.stock != null)
                        Flexible(
                          child: Text(
                            'Stock: ${producto.stock}',
                            style: TextStyle(
                              color: producto.stock! > 0 ? Colors.green : Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      
                      // Años
                      if (producto.anioInicio != null || producto.anioFin != null)
                        Flexible(
                          child: Text(
                            _formatearAnios(producto.anioInicio, producto.anioFin),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 9,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Icon(
      Icons.inventory_2,
      size: 48,
      color: Colors.grey.shade400,
    );
  }

  String _formatearAnios(int? inicio, int? fin) {
    if (inicio != null && fin != null) {
      return '$inicio - $fin';
    } else if (inicio != null) {
      return 'Desde $inicio';
    } else if (fin != null) {
      return 'Hasta $fin';
    }
    return '';
  }
}