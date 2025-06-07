//Modelo de datos para representar un vehículo.
class Vehicle {
  final String? id;
  final String name;
  final String plate;
  final String color;
  final int year;
  final String modelId;
  final String? modelName;
  final String? brandName;  
  final String? imageUrl;

  Vehicle({
    this.id,
    required this.name,
    required this.plate,
    required this.color,
    required this.year,
    required this.modelId,
    this.modelName, 
    this.brandName, 
    this.imageUrl,
  });
  // Factory contructor para crear un Vehículo desde un JSON.
  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json['id']?.toString(),
        name: json['name'] as String,
        plate: json['plate'] as String,
        color: json['color'] as String,
        year: json['year'] is int
            ? json['year'] as int
            : int.parse(json['year'].toString()),
        modelId: json['modelId'] as String,
        modelName: json['modelName'] as String?,
        brandName: json['brandName'] as String?,
        imageUrl: json['imageUrl'] as String?,
      );

  get brand => null;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name,
      'plate': plate,
      'color': color,
      'year': year,
      'modelId': modelId,
    };
    if (id != null) data['id'] = id;
    if (imageUrl != null) data['imageUrl'] = imageUrl;
    return data;
  }
}
