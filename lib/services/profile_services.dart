import 'dart:convert';
import 'dart:io';

import 'package:frontend_recetas/services/api_services.dart';
import 'package:http/http.dart' as http;

class ProfileServices {
  //OBTENER PERFIL DE USUARIO
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await ApiService.getToken();

    final response = await http.get(
      ApiService.buildUri('/users/profile'),
      headers: {...ApiService.ngrokHeaders, 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  //Agregar foto de perfil
  static Future<Map<String, dynamic>> uploadProfilePhoto(File imageFile) async {
    final token = await ApiService.getToken();

    var request = http.MultipartRequest(
      'POST',
      ApiService.buildUri('/users/profile/photo'),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      ...ApiService.ngrokHeaders,
    });

    // Obtener la extensión del archivo
    final extension = imageFile.path.split('.').last.toLowerCase();
    String mimeType;

    // Determinar el MIME type basado en la extensión
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        mimeType = 'image/jpeg';
        break;
      case 'png':
        mimeType = 'image/png';
        break;
      case 'gif':
        mimeType = 'image/gif';
        break;
      default:
        mimeType = 'image/jpeg'; // default
    }

    // Crear el MultipartFile con el Content-Type específico
    var multipartFile = await http.MultipartFile.fromPath(
      'photo',
      imageFile.path,
      contentType: http.MediaType.parse(mimeType),
    );

    request.files.add(multipartFile);

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
          'photo': data['photo'],
        };
      } else {
        throw Exception('Error subiendo foto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Eliminar foto de perfil
  static Future<Map<String, dynamic>> deleteProfilePhoto() async {
    final token = await ApiService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('No hay token de autenticación');
    }

    try {
      final response = await http.delete(
        ApiService.buildUri('/users/profile/photo'),
        headers: {
          ...ApiService.ngrokHeaders,
        'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'message': data['message']};
      } else {
        // Intentar parsear el error
        try {
          final errorData = jsonDecode(response.body);
          throw Exception(
            errorData['message'] ??
                'Error eliminando foto (${response.statusCode})',
          );
        } catch (_) {
          throw Exception('Error ${response.statusCode}: ${response.body}');
        }
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
