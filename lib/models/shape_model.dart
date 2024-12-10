class ShapeModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String type;
  final Map<String, dynamic>? additionalProperties;

  ShapeModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.additionalProperties,
  });

  factory ShapeModel.fromJson(Map<String, dynamic> json) {
    return ShapeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unnamed Location',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      type: json['type'] ?? 'unknown',
      additionalProperties: json['properties'] is Map ? json['properties'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'type': type,
    'properties': additionalProperties,
  };

  @override
  String toString() {
    return 'ShapeModel(id: $id, name: $name, lat: $latitude, lon: $longitude)';
  }
}