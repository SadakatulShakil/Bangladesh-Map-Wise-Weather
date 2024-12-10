class ForecastModel {
  final int id;
  final DateTime date;
  final double temperature;
  final double minTemperature;
  final double maxTemperature;
  final String description;
  final double humidity;
  final double windSpeed;
  final String windDirection;

  ForecastModel({
    required this.id,
    required this.date,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      id: json['id'] ?? 0,
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      minTemperature: (json['min_temperature'] ?? 0.0).toDouble(),
      maxTemperature: (json['max_temperature'] ?? 0.0).toDouble(),
      description: json['description'] ?? 'No description',
      humidity: (json['humidity'] ?? 0.0).toDouble(),
      windSpeed: (json['wind_speed'] ?? 0.0).toDouble(),
      windDirection: json['wind_direction'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'temperature': temperature,
    'min_temperature': minTemperature,
    'max_temperature': maxTemperature,
    'description': description,
    'humidity': humidity,
    'wind_speed': windSpeed,
    'wind_direction': windDirection,
  };

  @override
  String toString() {
    return 'ForecastModel(date: $date, temp: $temperature°C, desc: $description)';
  }
}