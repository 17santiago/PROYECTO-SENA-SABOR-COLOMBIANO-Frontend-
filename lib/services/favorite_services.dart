import 'dart:convert';

import 'package:frontend_recetas/services/api_services.dart';
import 'package:http/http.dart' as http;

class FavoriteServices {

  //FAVORITOS

  /// Obtener todas las recetas favoritas del usuario
  static Future<List<dynamic>> getFavorites() async {
    final token =
        await ApiService.getToken(); // o directamente getToken() si estás dentro de la clase
    

    if (token == null) throw Exception('Usuario no autenticado');

    final uri = ApiService.buildUri('/favorites/fav');
    

    final response = await http.get(
      uri,
      headers: {...ApiService.ngrokHeaders, 'Authorization': 'Bearer $token'},
    );

    

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      
      throw Exception('Error al obtener favoritos: ${response.statusCode}');
    }
  }

  /// Agregar una receta a favoritos
  static Future<void> addFavorite(int recipeId) async {
  final token = await ApiService.getToken();
  if (token == null) throw Exception('Usuario no autenticado');

  final response = await http.post(
    ApiService.buildUri('/favorites'),
    headers: {
      ...ApiService.ngrokHeaders,                // 👈 ¡OBLIGATORIO!
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({'recipe_id': recipeId}),
  );

  if (response.statusCode == 200) {
    return;
  }

  // Si el backend responde con error de duplicado (400 o 409)
  if (response.statusCode == 400 || response.statusCode == 409) {
    // Puede venir como JSON o HTML envuelto por ngrok
    final body = response.body;
    if (body.contains('unique_user_recipe') || body.contains('duplicada')) {
      
      return; 
    }
  }

  throw Exception('Error al agregar favorito: ${response.statusCode}');
 }

  /// Eliminar una receta de favoritos
  static Future<void> removeFavorite(int recipeId) async {
  final token = await ApiService.getToken();
  if (token == null) throw Exception('Usuario no autenticado');

  final uri = ApiService.buildUri('/favorites/$recipeId');
  

  final response = await http.delete(
    uri,
    headers: {
      ...ApiService.ngrokHeaders,         
      'Authorization': 'Bearer $token',
    },
  );

  

  if (response.statusCode != 200) {
    throw Exception('Error al eliminar favorito: ${response.statusCode} - ${response.body}');
  }
}
}
