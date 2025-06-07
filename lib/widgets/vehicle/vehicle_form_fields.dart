import 'package:flutter/material.dart';

class VehicleFormFields extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController plateCtrl;
  final TextEditingController colorCtrl;
  final TextEditingController yearCtrl;
  final bool readOnly;

  const VehicleFormFields({
    super.key,
    required this.nameCtrl,
    required this.plateCtrl,
    required this.colorCtrl,
    required this.yearCtrl,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          enabled: !readOnly,
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Nombre'),
          validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
        ),
        TextFormField(
          enabled: !readOnly,
          controller: plateCtrl,
          decoration: const InputDecoration(labelText: 'Placa'),
          validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
        ),
        TextFormField(
          enabled: !readOnly,
          controller: colorCtrl,
          decoration: const InputDecoration(labelText: 'Color'),
          validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
        ),
        TextFormField(
          enabled: !readOnly,
          controller: yearCtrl,
          decoration: const InputDecoration(labelText: 'Año'),
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Requerido';
            final year = int.tryParse(v);
            if (year == null || year < 1900 || year > DateTime.now().year + 1) {
              return 'Año inválido';
            }
            return null;
          },
        ),
      ],
    );
  }
}
