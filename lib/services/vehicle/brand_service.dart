import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/brand_model.dart';

class BrandService {
  final String baseUrl; // URL de tu backend

  BrandService({required this.baseUrl});

  Future<List<Brand>> getBrands() async {
    final response = await http.get(Uri.parse('$baseUrl/brands'));
    
    if (response.statusCode == 200) {
      final List<dynamic> brandsJson = json.decode(response.body);
      return brandsJson.map((json) => Brand.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load brands');
    }
  }

  Future<Brand> createBrand(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/brands'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );
    
    if (response.statusCode == 201) {
      return Brand.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create brand');
    }
  }
}
