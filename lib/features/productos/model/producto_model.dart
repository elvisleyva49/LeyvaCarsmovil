class ProductoModel {
  final String? id;
  final String nombre;
  final String? marca;
  final String? modelo;
  final int? stock;
  final int? anioInicio;
  final int? anioFin;
  final String? imagenUrl;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;

  ProductoModel({
    this.id,
    required this.nombre,
    this.marca,
    this.modelo,
    this.stock,
    this.anioInicio,
    this.anioFin,
    this.imagenUrl,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now(),
        fechaActualizacion = fechaActualizacion ?? DateTime.now();

  // Convertir a Map para Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'marca': marca,
      'modelo': modelo,
      'stock': stock,
      'anioInicio': anioInicio,
      'anioFin': anioFin,
      'imagenUrl': imagenUrl,
      'fechaCreacion': fechaCreacion.millisecondsSinceEpoch,
      'fechaActualizacion': fechaActualizacion.millisecondsSinceEpoch,
    };
  }

  // Crear desde Map de Firebase
  factory ProductoModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ProductoModel(
      id: id,
      nombre: data['nombre'] ?? '',
      marca: data['marca'],
      modelo: data['modelo'],
      stock: data['stock'],
      anioInicio: data['anioInicio'],
      anioFin: data['anioFin'],
      imagenUrl: data['imagenUrl'],
      fechaCreacion: DateTime.fromMillisecondsSinceEpoch(
        data['fechaCreacion'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      fechaActualizacion: DateTime.fromMillisecondsSinceEpoch(
        data['fechaActualizacion'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  // Crear copia con cambios
  ProductoModel copyWith({
    String? id,
    String? nombre,
    String? marca,
    String? modelo,
    int? stock,
    int? anioInicio,
    int? anioFin,
    String? imagenUrl,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return ProductoModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      stock: stock ?? this.stock,
      anioInicio: anioInicio ?? this.anioInicio,
      anioFin: anioFin ?? this.anioFin,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  String toString() {
    return 'ProductoModel{id: $id, nombre: $nombre, marca: $marca, modelo: $modelo, stock: $stock, anioInicio: $anioInicio, anioFin: $anioFin}';
  }
}