import 'dart:convert';
import 'package:frontend_recetas/models/blog_model.dart';
import 'package:frontend_recetas/services/api_services.dart';
import 'package:http/http.dart' as http;

class BlogServices {
  Future<List<Blog>> fetchBlogs() async {
    final uri = ApiService.buildUri('/blogs');
    final response = await http.get(
      uri,
      headers: ApiService.ngrokHeaders,
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Blog.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los blogs');
    }
  }
}