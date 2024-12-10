import 'dart:convert';

class AlertModel {
  bool status;
  String message;
  List<Result> result;

  AlertModel({
    required this.status,
    required this.message,
    required this.result,
  });

  factory AlertModel.fromRawJson(String str) => AlertModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
    status: json["status"],
    message: json["message"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class Result {
  int parameterId;
  int upazilaId;
  int adm3Pcode;
  int adm2Pcode;
  String district;
  String name;
  DateTime forecastDate;
  DateTime stepStart;
  DateTime stepEnd;
  double valMin;
  double valAvg;
  double valMax;

  Result({
    required this.parameterId,
    required this.upazilaId,
    required this.adm3Pcode,
    required this.adm2Pcode,
    required this.district,
    required this.name,
    required this.forecastDate,
    required this.stepStart,
    required this.stepEnd,
    required this.valMin,
    required this.valAvg,
    required this.valMax,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    parameterId: json["parameter_id"],
    upazilaId: json["upazila_id"],
    adm3Pcode: json["adm3_pcode"],
    adm2Pcode: json["adm2_pcode"],
    district: json["district"],
    name: json["name"],
    forecastDate: DateTime.parse(json["forecast_date"]),
    stepStart: DateTime.parse(json["step_start"]),
    stepEnd: DateTime.parse(json["step_end"]),
    valMin: json["val_min"]?.toDouble(),
    valAvg: json["val_avg"]?.toDouble(),
    valMax: json["val_max"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "parameter_id": parameterId,
    "upazila_id": upazilaId,
    "adm3_pcode": adm3Pcode,
    "adm2_pcode": adm2Pcode,
    "district": district,
    "name": name,
    "forecast_date": "${forecastDate.year.toString().padLeft(4, '0')}-${forecastDate.month.toString().padLeft(2, '0')}-${forecastDate.day.toString().padLeft(2, '0')}",
    "step_start": stepStart.toIso8601String(),
    "step_end": stepEnd.toIso8601String(),
    "val_min": valMin,
    "val_avg": valAvg,
    "val_max": valMax,
  };
}
