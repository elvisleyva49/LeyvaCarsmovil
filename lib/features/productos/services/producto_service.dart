import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/producto_model.dart';

class ProductoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'productos';
  static const String _imgbbApiKey = '79fefe21668969aa8a446cab366bc81a';
  static const String _imgbbApiUrl = 'https://api.imgbb.com/1/upload';

  // Subir imagen a ImgBB
  Future<String?> subirImagenImgBB(File imageFile) async {
    try {
      // Convertir imagen a base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Preparar el request
      var request = http.MultipartRequest('POST', Uri.parse(_imgbbApiUrl));
      request.fields['key'] = _imgbbApiKey;
      request.fields['image'] = base64Image;

      // Enviar request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          return jsonData['data']['url'];
        } else {
          throw Exception('Error al subir la imagen: ${jsonData['error']['message']}');
        }
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al subir imagen: $e');
    }
  }

  // Crear producto
  Future<String> crearProducto(ProductoModel producto) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(producto.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear producto: $e');
    }
  }

  // Obtener todos los productos
  Future<List<ProductoModel>> obtenerProductos() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('fechaActualizacion', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ProductoModel.fromFirestore(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener productos: $e');
    }
  }

  // Buscar productos por texto (se maneja en el ViewModel con filtrado local)
  Future<List<ProductoModel>> buscarProductos(String query) async {
    // Para búsquedas, obtenemos todos los productos y filtramos localmente
    // Esto mantiene el orden por fechaActualizacion y permite búsqueda en múltiples campos
    return await obtenerProductos();
  }

  // Actualizar producto
  Future<void> actualizarProducto(String id, ProductoModel producto) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .update(producto.copyWith(
            fechaActualizacion: DateTime.now(),
          ).toFirestore());
    } catch (e) {
      throw Exception('Error al actualizar producto: $e');
    }
  }

  // Eliminar producto
  Future<void> eliminarProducto(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar producto: $e');
    }
  }

  // Stream de productos en tiempo real
  Stream<List<ProductoModel>> productosStream() {
    return _firestore
        .collection(_collection)
        .orderBy('fechaActualizacion', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductoModel.fromFirestore(doc.id, doc.data()))
            .toList());
  }
}