import 'package:flutter/material.dart';
import '../models/brand_model.dart';
import '../services/vehicle/model_service.dart';

class AddModelDialog extends StatefulWidget {
  final ModelService modelService;
  final Brand brand;

  const AddModelDialog({
    Key? key,
    required this.modelService,
    required this.brand,
  }) : super(key: key);

  @override
  State<AddModelDialog> createState() => _AddModelDialogState();
}

class _AddModelDialogState extends State<AddModelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final model = await widget.modelService.createModel(
        name: _nameController.text.trim(),
        brandId: widget.brand.id,
        brandName: widget.brand.name,
      );
      if (!mounted) return;
      Navigator.of(context).pop(model);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear modelo: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nuevo Modelo - ${widget.brand.name}'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Nombre del Modelo'),
          validator: (value) => 
            value == null || value.isEmpty ? 'Nombre requerido' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}
