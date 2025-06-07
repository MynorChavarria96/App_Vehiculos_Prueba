//Modelo de datos para representar un modelo de vehículo.
class VehicleModel {
  final String id;
  final String name;
  final String brandId;
  final String brandName;

  VehicleModel({
    required this.id,
    required this.name,
    required this.brandId,
    required this.brandName,
  });

// Factory constructor para crear un Modelo desde un JSON.
  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json['id'].toString(),
        name: json['name'] as String,
        brandId: json['brandId'] as String,
        brandName: json['brandName'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'brandId': brandId,
        'brandName': brandName,
      };
}
