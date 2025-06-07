import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/vehicle_model.dart';
import '../../config/api_config.dart';

class ApiService {
  final String _baseUrl = ApiConfig.baseUrl;

  // Obtener
  Future<List<Vehicle>> fetchVehicles() async {
    final uri = Uri.parse('$_baseUrl/vehicles');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((json) => Vehicle.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al cargar vehículos: ${response.statusCode}');
    }
  }

  // Eliminar
  Future<void> deleteVehicle(String id) async {
    final uri = Uri.parse('$_baseUrl/vehicles/$id');
    final response = await http.delete(uri);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar vehículo: ${response.statusCode}');
    }
  }

  // Agregar
  Future<void> addVehicle(Vehicle vehiculo) async {
    final uri = Uri.parse('$_baseUrl/vehicles');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehiculo.toJson()),
    );    if (response.statusCode != 201 && response.statusCode != 200) {
      print('Response body: ${response.body}');
      throw Exception('Error al agregar vehículo: ${response.statusCode}\nDetalle: ${response.body}');
    }
  }

  // Editar
  Future<void> updateVehicle(Vehicle vehiculo) async {
    if (vehiculo.id == null) {
      throw Exception('ID de vehículo no proporcionado');
    }
    final uri = Uri.parse('$_baseUrl/vehicles/${vehiculo.id}');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehiculo.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar vehículo: ${response.statusCode}');
    }
  }
}
