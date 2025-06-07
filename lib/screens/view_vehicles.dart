import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../services/auth/auth_service.dart';
import '../widgets/vehicle_search_bar.dart';
import '../widgets/vehicle/vehicle_list_container.dart';
import '../widgets/delete_vehicle_dialog.dart';
import 'add_vehicle.dart';

/// Pantalla principal para visualizar vehículos.
class ViewVehiclesScreen extends StatefulWidget {
  const ViewVehiclesScreen({super.key});

  @override
  State<ViewVehiclesScreen> createState() => _ViewVehiclesScreenState();
}

class _ViewVehiclesScreenState extends State<ViewVehiclesScreen> {
  final AuthService _authService = AuthService();
  bool isGridView = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Provider.of<VehicleProvider>(context, listen: false).loadVehicles();
  }

  /// Alterna entre vista de lista y cuadrícula.
  void _toggleView() {
    setState(() => isGridView = !isGridView);
  }

  /// Actualiza la búsqueda de vehículos.
  void _updateSearch(String value) {
    setState(() => _searchQuery = value.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehículos'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.grid_view : Icons.view_list),
            tooltip: 'Cambiar vista',
            onPressed: _toggleView,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async => await _authService.logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          VehicleSearchBar(onChanged: _updateSearch),
          Expanded(
            child: VehicleListContainer(
              isGridView: isGridView,
              searchQuery: _searchQuery,
              confirmDelete: (context) => showDeleteVehicleDialog(context),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) =>  AddVehicleScreen()),
          );
          Provider.of<VehicleProvider>(context, listen: false).loadVehicles();
        },
        tooltip: 'Agregar vehículo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
