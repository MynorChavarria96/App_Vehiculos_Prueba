// Modelo de datos para representar una marca de vehículo.
class Brand {
  final String id;
  final String name;

  Brand({
    required this.id,
    required this.name,
  });

// Factory constructor para crear una Marca desde un JSON.
  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json['id'].toString(),
        name: json['name'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
