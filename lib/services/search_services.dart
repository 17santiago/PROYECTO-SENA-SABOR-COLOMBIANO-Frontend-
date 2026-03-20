import 'dart:convert';
import 'package:frontend_recetas/models/recipe_model.dart';
import 'package:frontend_recetas/services/api_services.dart';
import 'package:http/http.dart' as http;

//Bsuqeuda de recetas por nombre o ingredientes o region

class SearchServices {
  Future<List<Recipe>> searchRecipes(String query) async {
    if (query.isEmpty) return [];

    final uri = ApiService.buildUri(
      '/search/search',
    ).replace(queryParameters: {'q': query});
    final response = await http.get(uri, headers: ApiService.ngrokHeaders);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Recipe.fromJson(e)).toList();
    } else {
      throw Exception('Error al buscar recetas');
    }
  }
}
