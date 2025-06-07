import 'dart:io';
import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../models/brand_model.dart';
import '../models/model_model.dart';
import '../services/storage/storage_service.dart';
import '../services/vehicle/api_service.dart';
import '../services/vehicle/brand_service.dart';
import '../services/vehicle/model_service.dart';
import '../config/api_config.dart';
import '../widgets/vehicle/vehicle_image_picker.dart';
import '../widgets/vehicle/vehicle_form_fields.dart';
import '../widgets/vehicle/vehicle_brand_model_selector.dart';
import '../controllers/vehicle_controller.dart';
import '../helpers/vehicle_helpers.dart';
import '../helpers/add_vehicle_screen_helpers.dart';

/// Pantalla para agregar o editar un vehículo.
class AddVehicleScreen extends StatefulWidget {
  final Vehicle? vehicle; // Vehículo a editar (o null para crear uno nuevo)
  final bool readOnly; // Modo solo lectura
  final StorageService _storageService = StorageService();
  final BrandService _brandService = BrandService(baseUrl: ApiConfig.baseUrl);
  final ModelService _modelService = ModelService(baseUrl: ApiConfig.baseUrl);

  AddVehicleScreen({
    super.key,
    this.vehicle,
    this.readOnly = false,
  });

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto para el formulario
  final _nameCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();

  final ApiService _apiService = ApiService();
  late final VehicleController _vehicleController;
  bool _isLoading = false; // Estado de carga mientras se guarda

  File? _imageFile; // Imagen seleccionada localmente
  String? _imageUrl; // URL de la imagen ya cargada en firebase Storage 

  List<Brand> _brands = []; 
  List<VehicleModel> _models = []; 
  Brand? _selectedBrand; 
  VehicleModel? _selectedModel; 

  @override
  void initState() {
    super.initState();

    // Inicializar el controlador del vehículo 
    _vehicleController = VehicleController(
      storageService: widget._storageService,
      apiService: _apiService,
    );

    // Cargar datos iniciales 
    _loadInitialData();
  }
  /// Carga inicial de datos de la pantalla
  Future<void> _loadInitialData() async {
    if (widget.vehicle != null) {
      setState(() {
        _imageUrl = widget.vehicle?.imageUrl;
      });
    }

    await AddVehicleScreenHelpers.loadInitialData(
      context: context,
      vehicle: widget.vehicle,
      nameCtrl: _nameCtrl,
      plateCtrl: _plateCtrl,
      colorCtrl: _colorCtrl,
      yearCtrl: _yearCtrl,
      brandService: widget._brandService,
      modelService: widget._modelService,
      onBrandsLoaded: (brands) {
        setState(() => _brands = brands);
      },
      onModelAndBrandLoaded: (models, model, brand) {
        setState(() {
          _models = models;
          _selectedModel = model;
          _brands = _brands;
          _selectedBrand = brand;
        });
      },
    );
  }

  /// Selecciona una imagen desde la galería y la asigna a [_imageFile]
  Future<void> _pickImage() async {
    final pickedFile = await AddVehicleScreenHelpers.pickImage();
    if (pickedFile != null) {
      setState(() => _imageFile = pickedFile);
    }
  }

  /// Abre el diálogo para agregar una nueva marca
  Future<void> _addNewBrand() async {
    final brand = await AddVehicleScreenHelpers.addNewBrand(
      context: context,
      brandService: widget._brandService,
    );
    if (brand != null) {
      setState(() {
        _brands.add(brand);
        _selectedBrand = brand;
        _models.clear();
        _selectedModel = null;
      });
    }
  }

  /// Abre el diálogo para agregar un nuevo modelo
  Future<void> _addNewModel() async {
    if (_selectedBrand == null) {
      VehicleHelpers.showErrorSnackBar(context, 'Primero seleccione una marca');
      return;
    }
    final model = await AddVehicleScreenHelpers.addNewModel(
      context: context,
      modelService: widget._modelService,
      selectedBrand: _selectedBrand!,
    );
    if (model != null) {
      setState(() {
        _models.add(model);
        _selectedModel = model;
      });
    }
  }

  /// Envía el formulario para crear o actualizar el vehículo
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _vehicleController.submitVehicle(
        existingVehicle: widget.vehicle,
        name: _nameCtrl.text.trim(),
        plate: _plateCtrl.text.trim(),
        color: _colorCtrl.text.trim(),
        yearText: _yearCtrl.text.trim(),
        selectedModelId: _selectedModel?.id,
        imageFile: _imageFile,
        existingImageUrl: _imageUrl,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      VehicleHelpers.showErrorSnackBar(context, 'Error al guardar: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    // Liberar recursos de los controladores
    _nameCtrl.dispose();
    _plateCtrl.dispose();
    _colorCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.vehicle != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.readOnly
              ? 'Detalle Vehículo'
              : isEdit
                  ? 'Editar Vehículo'
                  : 'Agregar Vehículo',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Widget para mostrar la imagen del vehículo
                VehicleImagePicker(
                  imageFile: _imageFile,
                  imageUrl: _imageUrl,
                  readOnly: widget.readOnly,
                  onPickImage: _pickImage,
                ),
                const SizedBox(height: 16),

                // Campos de texto del formulario
                VehicleFormFields(
                  nameCtrl: _nameCtrl,
                  plateCtrl: _plateCtrl,
                  colorCtrl: _colorCtrl,
                  yearCtrl: _yearCtrl,
                  readOnly: widget.readOnly,
                ),
                const SizedBox(height: 16),

                // Dropdowns para seleccionar marca y modelo
                VehicleBrandModelSelector(
                  brands: _brands,
                  models: _models,
                  selectedBrand: _selectedBrand,
                  selectedModel: _selectedModel,
                  readOnly: widget.readOnly,
                  onBrandChanged: (v) async {
                    setState(() {
                      _selectedBrand = v;
                      _selectedModel = null;
                      _models = [];
                    });
                    if (v != null) {
                      final models = await VehicleHelpers.loadModels(
                        context,
                        widget._modelService,
                        v.id,
                      );
                      if (!mounted) return;
                      setState(() => _models = models);
                    }
                  },
                  onModelChanged: (v) {
                    setState(() => _selectedModel = v);
                  },
                  onAddBrand: _addNewBrand,
                  onAddModel: _addNewModel,
                ),
                const SizedBox(height: 24),

                // Botón para guardar el vehículo (solo si no es readOnly)
                if (!widget.readOnly)
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEdit ? 'Actualizar' : 'Guardar'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
