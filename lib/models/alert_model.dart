class AlertModel {
  final int id;
  final String name;
  final double value;
  final String unit;
  final DateTime timestamp;

  AlertModel({
    required this.id,
    required this.name,
    required this.value,
    required this.unit,
    required this.timestamp,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Alert',
      value: (json['val_min'] ?? 0.0).toDouble(),
      unit: json['unit'] ?? '°C',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'val_min': value,
    'unit': unit,
    'timestamp': timestamp.toIso8601String(),
  };

  @override
  String toString() {
    return 'AlertModel(id: $id, name: $name, value: $value$unit)';
  }
}