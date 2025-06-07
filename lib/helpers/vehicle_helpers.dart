import 'package:flutter/material.dart';
import '../models/brand_model.dart';
import '../models/model_model.dart';
import '../services/vehicle/brand_service.dart';
import '../services/vehicle/model_service.dart';

class VehicleHelpers {

  // Carga las marcas disponibles desde el servicio
  static Future<List<Brand>> loadBrands(BuildContext context, BrandService brandService) async {
    try {
      return await brandService.getBrands();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar marcas: $e')),
      );
      return [];
    }
  }

// Carga los modelos disponibles para una marca específica
  static Future<List<VehicleModel>> loadModels(
      BuildContext context, ModelService modelService, String brandId) async {
    try {
      return await modelService.getModels(brandId: brandId);
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar modelos: $e')),
      );
      return [];
    }
  }

// Muestra un SnackBar de error
  static Future<void> showErrorSnackBar(BuildContext context, String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
