import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'https://petra-unintuitable-contingently.ngrok-free.dev';

  // Headers para ngrok
  static Map<String, String> get ngrokHeaders {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };
  }

  static Uri buildUri(String path) {
    return Uri.parse(baseUrl).replace(path: path);
  }

  static String? token;

  //CARGAR TOKEN AL INICIAR LA APLICACIÓN
  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    
  }
  

  /// REGISTER con más logging
  static Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    
    
    try {
      final uri = buildUri('/auth/register');
      final response = await http.post(
        uri,
        headers: ngrokHeaders,
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        token = data['token'];
       
        return true;
      } else {
        
        return false;
      }
    } catch (e) {
      
      return false;
    }
  }

  /// OBTENER TOKEN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  
  
}