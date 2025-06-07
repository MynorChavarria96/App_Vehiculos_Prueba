import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/brand_model.dart';
import '../models/model_model.dart';
import '../models/vehicle_model.dart';
import '../services/vehicle/brand_service.dart';
import '../services/vehicle/model_service.dart';
import '../widgets/add_brand_dialog.dart';
import '../widgets/add_model_dialog.dart';

class AddVehicleScreenHelpers {
  static Future<void> loadInitialData({
    required BuildContext context,
    required Vehicle? vehicle,
    required TextEditingController nameCtrl,
    required TextEditingController plateCtrl,
    required TextEditingController colorCtrl,
    required TextEditingController yearCtrl,
    required BrandService brandService,
    required ModelService modelService,
    required Function(List<Brand>) onBrandsLoaded,
    required Function(List<VehicleModel>, VehicleModel, Brand) onModelAndBrandLoaded,
  }) async {
    try {
      // Primero cargamos todas las marcas
      final brands = await brandService.getBrands();
      onBrandsLoaded(brands);

      if (vehicle != null) {
        // Establecer valores del formulario
        nameCtrl.text = vehicle.name;
        plateCtrl.text = vehicle.plate;
        colorCtrl.text = vehicle.color;
        yearCtrl.text = vehicle.year.toString();

        try {
          // Cargar modelos específicos de la marca
          final models = await modelService.getModels();
          final model = models.firstWhere(
            (m) => m.id == vehicle.modelId,
            orElse: () => throw Exception('Modelo no encontrado'),
          );

          // Encontrar la marca correspondiente
          final brand = brands.firstWhere(
            (b) => b.id == model.brandId,
            orElse: () => throw Exception('Marca no encontrada'),
          );

          // Actualizar el estado con los valores encontrados
          onModelAndBrandLoaded(models, model, brand);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al cargar modelo o marca: $e')),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos iniciales: $e')),
        );
      }
    }
  }

  static Future<File?> pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      return picked != null ? File(picked.path) : null;
    } catch (e) {
      debugPrint('Error al seleccionar imagen: $e');
      return null;
    }
  }

  static Future<Brand?> addNewBrand({
    required BuildContext context,
    required BrandService brandService,
  }) async {
    return showDialog<Brand>(
      context: context,
      builder: (context) => AddBrandDialog(brandService: brandService),
    );
  }

  static Future<VehicleModel?> addNewModel({
    required BuildContext context,
    required ModelService modelService,
    required Brand selectedBrand,
  }) async {
    return showDialog<VehicleModel>(
      context: context,
      builder: (context) => AddModelDialog(
        modelService: modelService,
        brand: selectedBrand,
      ),
    );
  }
}
