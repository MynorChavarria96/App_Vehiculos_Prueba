import 'package:flutter/material.dart';

class VehicleSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const VehicleSearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Buscar vehículo',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => onChanged(value.toLowerCase()),
      ),
    );
  }
}
