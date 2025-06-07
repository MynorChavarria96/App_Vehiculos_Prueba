import 'package:flutter/material.dart';
import 'package:app_vehiculos/models/vehicle_model.dart';
import 'package:app_vehiculos/screens/add_vehicle.dart';

class VehicleGridItem extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VehicleGridItem({
    super.key,
    required this.vehicle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //borderRadius: BorderRadius.circular(12),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddVehicleScreen(vehicle: vehicle, readOnly: true),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.blueGrey, width: 0.5),
        ),
        elevation: 4,
        child: Column(
          children: [
            Expanded(              child: vehicle.imageUrl?.isNotEmpty == true
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        vehicle.imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.directions_car, size: 60),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${vehicle.brandName} - ${vehicle.modelName}",
                   style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                  Text(
                    vehicle.plate,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Color: ${vehicle.color} - ${vehicle.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
