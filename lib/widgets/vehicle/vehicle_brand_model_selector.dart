import 'package:app_vehiculos/models/brand_model.dart';
import 'package:app_vehiculos/models/model_model.dart';
import 'package:flutter/material.dart';

class VehicleBrandModelSelector extends StatelessWidget {
  final List<Brand> brands;
  final List<VehicleModel> models;
  final Brand? selectedBrand;
  final VehicleModel? selectedModel;
  final bool readOnly;
  final Function(Brand?) onBrandChanged;
  final Function(VehicleModel?) onModelChanged;
  final VoidCallback onAddBrand;
  final VoidCallback onAddModel;

  const VehicleBrandModelSelector({
    super.key,
    required this.brands,
    required this.models,
    required this.selectedBrand,
    required this.selectedModel,
    required this.readOnly,
    required this.onBrandChanged,
    required this.onModelChanged,
    required this.onAddBrand,
    required this.onAddModel,
  });

  Brand? _findMatchingBrand() {
    if (selectedBrand == null || selectedBrand?.id == null || brands.isEmpty) {
      return null;
    }
    try {
      return brands.firstWhere((b) => b.id == selectedBrand?.id);
    } catch (_) {
      return brands.isNotEmpty ? brands.first : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<Brand>(
                value: _findMatchingBrand(),
                onChanged: readOnly ? null : onBrandChanged,
                items: brands.map((b) => DropdownMenuItem(
                  value: b,
                  child: Text(b.name),
                )).toList(),
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (v) => v == null ? 'Requerido' : null,
              ),
            ),
            if (!readOnly)
              IconButton(
                onPressed: onAddBrand,
                icon: const Icon(Icons.add),
                tooltip: 'Agregar Nueva Marca',
              ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<VehicleModel>(
                value: selectedModel != null && models.contains(selectedModel) 
                  ? selectedModel 
                  : null,
                onChanged: readOnly ? null : onModelChanged,
                items: models.map((m) => DropdownMenuItem(
                  value: m,
                  child: Text(m.name),
                )).toList(),
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (v) => v == null ? 'Requerido' : null,
              ),
            ),
            if (!readOnly)
              IconButton(
                onPressed: onAddModel,
                icon: const Icon(Icons.add),
                tooltip: 'Agregar Nuevo Modelo',
              ),
          ],
        ),
      ],
    );
  }
}
