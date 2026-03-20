

import 'package:frontend_recetas/services/api_services.dart';

class Recipe {
  final int id;
  final String name;
  final String ingredients;
  final String steps;
  final String regionImage;
  final String galery;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients, 
    required this.regionImage,
    required this.steps,
    required this.galery,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    
    return Recipe(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['recipe'] ?? 'Sin nombre',
      ingredients: json['ingredients'] ?? 'Sin ingredientes',
      steps: json['steps'] ?? 'Sin pasos',     
      regionImage: json['region_image'] != null
          ? '${ApiService.baseUrl}/uploads/${json['region_image']}'

          : (json['regionImage'] ?? ''),

      galery: json['galery'] != null
          ? '${ApiService.baseUrl}/uploads/recipes/${json['galery']}'

          : (json['galery'] ?? '')
    );
  }
}
