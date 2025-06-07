import 'dart:io';
import '../models/vehicle_model.dart';
import '../services/storage/storage_service.dart';
import '../services/vehicle/api_service.dart';

class VehicleController {
  final StorageService storageService;
  final ApiService apiService;

  VehicleController({
    required this.storageService,
    required this.apiService,
  });

// Metodo para Guardar o actualizar un vehículo
  Future<void> submitVehicle({
    required Vehicle? existingVehicle,
    required String name,
    required String plate,
    required String color,
    required String yearText,
    required String? selectedModelId,
    required File? imageFile,
    required String? existingImageUrl,
  }) async {
    String? imageUrl = existingImageUrl;
    if (imageFile != null) {
      imageUrl = await storageService.uploadVehicleImage(imageFile);
    }
    final vehicle = Vehicle(
      id: existingVehicle?.id,
      name: name,
      plate: plate,
      color: color,
      year: int.parse(yearText),
      modelId: selectedModelId!,
      imageUrl: imageUrl,
    );
    if (existingVehicle == null) {
      await apiService.addVehicle(vehicle);
    } else {
      await apiService.updateVehicle(vehicle);
    }
  }
}
