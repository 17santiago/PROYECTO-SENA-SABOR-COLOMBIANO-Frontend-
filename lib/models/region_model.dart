import 'package:frontend_recetas/services/api_services.dart';

class Region {
  final String nombre;
  final String imagen;

  Region({required this.nombre, required this.imagen});

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      nombre: (json['region'] ?? json['region_name'] ?? '') as String,
      imagen: json['image_url'] != null
          ? '${ApiService.baseUrl}/uploads/${json['image_url']}'
          : (json['regionImage'] ?? ''),
    );
  }
}