class AlertModel {
  final int id;
  final String alertName;
  final double valMin;

  AlertModel({required this.id, required this.alertName, required this.valMin});

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'],
      alertName: json['alert_name'],
      valMin: json['val_min'],
    );
  }
}
