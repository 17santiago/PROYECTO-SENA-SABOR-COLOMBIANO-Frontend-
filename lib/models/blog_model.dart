import 'package:frontend_recetas/services/api_services.dart';

class Blog {
  final int id;
  final String title;
  final String description;
  final String content;
  final String regionName;
  final String imageUrl;

  Blog({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.regionName,
    required this.imageUrl,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      content: json['content'] ?? 'Sin contenido',
      regionName: json['region'] ?? 'Sin región',
      imageUrl: json['image_url'] != null
          ? '${ApiService.baseUrl}/uploads/${json['image_url']}'
          : (json['regionImage'] ?? ''),
    );
  }
}
