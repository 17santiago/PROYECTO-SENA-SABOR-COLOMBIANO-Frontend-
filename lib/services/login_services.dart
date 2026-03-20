import 'dart:convert';
import 'package:frontend_recetas/models/login_result.dart';
import 'package:frontend_recetas/services/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginServices {
  /// Realiza el login y retorna un LoginResult detallado
  static Future<LoginResult> login(String email, String password) async {
    // Validación básica
    if (email.trim().isEmpty) {
      return LoginResult(
        success: false,
        errorType: LoginErrorType.other,
        message: 'El correo no puede estar vacío',
      );
    }
    if (password.isEmpty) {
      return LoginResult(
        success: false,
        errorType: LoginErrorType.other,
        message: 'La contraseña no puede estar vacía',
      );
    }

    try {
      final uri = ApiService.buildUri('/auth/login');
      final response = await http.post(
        uri,
        headers: ApiService.ngrokHeaders,
        body: jsonEncode({'email': email.trim(), 'password': password}),
      );

      // ✅ Éxito
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String newToken = data['token'];

        // Guardar token en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', newToken);

        // Actualizar token en memoria (ApiService.token)
        ApiService.token = newToken;

        return LoginResult(success: true, errorType: LoginErrorType.none);
      }

      // ❌ Error: intentamos extraer el mensaje del cuerpo
      String errorMsg = 'Error desconocido';
      try {
        final errorData = jsonDecode(response.body);
        errorMsg = errorData['message'] ??
                  errorData['error'] ??
                  'Error ${response.statusCode}';
      } catch (_) {
        errorMsg = 'Error ${response.statusCode}';
      }

      // 401 es el código de error de autenticación
      if (response.statusCode == 401) {
        final lowerMsg = errorMsg.toLowerCase();
        // Intenta distinguir entre email no encontrado y contraseña incorrecta
        if (lowerMsg.contains('email') ||
            lowerMsg.contains('correo') ||
            lowerMsg.contains('no existe') ||
            lowerMsg.contains('not found')) {
          return LoginResult(
            success: false,
            errorType: LoginErrorType.emailNotFound,
            message: 'El correo electrónico no está registrado',
          );
        } else if (lowerMsg.contains('contraseña') ||
                   lowerMsg.contains('password') ||
                   lowerMsg.contains('incorrect')) {
          return LoginResult(
            success: false,
            errorType: LoginErrorType.wrongPassword,
            message: 'Contraseña incorrecta',
          );
        } else {
          return LoginResult(
            success: false,
            errorType: LoginErrorType.other,
            message: errorMsg,
          );
        }
      }

      // Otros códigos de error (500, 400, etc.)
      return LoginResult(
        success: false,
        errorType: LoginErrorType.other,
        message: errorMsg,
      );
    } catch (e) {
      return LoginResult(
        success: false,
        errorType: LoginErrorType.other,
        message: 'Error de conexión: ${e.toString()}',
      );
    }
  }
}