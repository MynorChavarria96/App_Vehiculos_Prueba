import 'package:flutter/material.dart';

/// Muestra un diálogo de confirmación para eliminar un vehículo.
Future<bool?> showDeleteVehicleDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmar eliminación'),
      content: const Text('¿Estás seguro de que deseas eliminar este vehículo?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
}
