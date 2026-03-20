import 'dart:convert';
import 'package:frontend_recetas/models/region_model.dart';
import 'package:frontend_recetas/services/api_services.dart';
import 'package:http/http.dart' as http;

class RegionService {
  Future<List<Region>> fetchRegiones() async {
    final uri = ApiService.buildUri('/region');
    final response = await http.get(
      uri,
      headers: ApiService.ngrokHeaders,
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Region.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las regiones');
    }
  }
}