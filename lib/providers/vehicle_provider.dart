import 'package:flutter/foundation.dart';
import '../models/vehicle_model.dart';
import '../services/vehicle/api_service.dart';

//Provider para manejar el estado de los vehículos
class VehicleProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Vehicle> _vehicles = [];
  String? _error;

  List<Vehicle> get vehicles => _vehicles;
  String? get error => _error;

// Cargar vehículos al iniciar la aplicación
  Future<void> loadVehicles() async {
    _error = null;
    try {
      _vehicles = await _apiService.fetchVehicles();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

//Eliminar vehículo
  Future<void> deleteVehicle(String id) async {
    _error = null;
    try {
      await _apiService.deleteVehicle(id);
// Actualizar la lista local inmediatamente
      _vehicles.removeWhere((vehicle) => vehicle.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

// Agregar un nuevo vehículo
  Future<void> addVehicle(Vehicle vehicle) async {
    _error = null;
    try {
      await _apiService.addVehicle(vehicle);
      _vehicles.add(vehicle);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
