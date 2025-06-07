import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/model_model.dart';

class ModelService {
  final String baseUrl; // URL de tu backend

  ModelService({required this.baseUrl});

  Future<List<VehicleModel>> getModels({String? brandId}) async {
    final url = brandId != null 
        ? '$baseUrl/models?brandId=$brandId'
        : '$baseUrl/models';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final List<dynamic> modelsJson = json.decode(response.body);
      return modelsJson.map((json) => VehicleModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load models');
    }
  }

  Future<VehicleModel> createModel({
    required String name,
    required String brandId,
    required String brandName,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/models'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'brandId': brandId,
        'brandName': brandName,
      }),
    );
    
    if (response.statusCode == 201) {
      return VehicleModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create model');
    }
  }
}
