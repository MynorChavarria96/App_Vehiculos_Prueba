import 'package:app_vehiculos/models/vehicle_model.dart';
import 'package:app_vehiculos/providers/vehicle_provider.dart';
import 'package:app_vehiculos/screens/add_vehicle.dart';
import 'package:app_vehiculos/widgets/vehicle/vehicle_grid_item.dart';
import 'package:app_vehiculos/widgets/vehicle/vehicle_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/// Contenedor de lista o cuadrícula de vehículos filtrados.
class VehicleListContainer extends StatelessWidget {
  final bool isGridView;
  final String searchQuery;
  final Future<bool?> Function(BuildContext) confirmDelete;

  const VehicleListContainer({
    super.key,
    required this.isGridView,
    required this.searchQuery,
    required this.confirmDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleProvider>(
      builder: (context, vehicleProvider, _) {
        if (vehicleProvider.error != null) {
          return Center(child: Text('Error: ${vehicleProvider.error}'));
        }

        final vehicles = vehicleProvider.vehicles;
        if (vehicles.isEmpty) {
          return const Center(child: Text('No hay vehículos disponibles.'));
        }

        final filteredVehicles = _filterVehicles(vehicles);

        return RefreshIndicator(
          onRefresh: () => vehicleProvider.loadVehicles(),
          child: isGridView
              ? _buildGrid(filteredVehicles, vehicleProvider, context)
              : _buildList(filteredVehicles, vehicleProvider, context),
        );
      },
    );
  }

  /// Filtra los vehículos por nombre, marca o placa.
  List<Vehicle> _filterVehicles(List<Vehicle> vehicles) {
    return vehicles.where((v) {
      return v.name.toLowerCase().contains(searchQuery) ||
          (v.brandName?.toLowerCase() ?? '').contains(searchQuery) ||
          (v.modelName?.toLowerCase() ?? '').contains(searchQuery) ||
          (v.plate?.toLowerCase() ?? '').contains(searchQuery);
    }).toList();
  }

  Widget _buildGrid(List<Vehicle> vehicles, VehicleProvider vehicleProvider, BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        final v = vehicles[index];
        return VehicleGridItem(
          vehicle: v,
          onEdit: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddVehicleScreen(vehicle: v)),
            );
            vehicleProvider.loadVehicles();
          },
          onDelete: () async {
            final confirmed = await confirmDelete(context);
            if (confirmed == true) {
              await vehicleProvider.deleteVehicle(v.id!);
            }
          },
        );
      },
    );
  }

  Widget _buildList(List<Vehicle> vehicles, VehicleProvider vehicleProvider, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        final v = vehicles[index];
        return VehicleListItem(
          vehicle: v,
          onEdit: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddVehicleScreen(vehicle: v)),
            );
            vehicleProvider.loadVehicles();
          },
          onDelete: () async {
            final confirmed = await confirmDelete(context);
            if (confirmed == true) {
              await vehicleProvider.deleteVehicle(v.id!);
            }
          },
        );
      },
    );
  }
}
