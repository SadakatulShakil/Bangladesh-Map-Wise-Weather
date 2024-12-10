import 'dart:convert';

class ForecastModel {
  bool status;
  String message;
  List<Result> result;

  ForecastModel({
    required this.status,
    required this.message,
    required this.result,
  });

  factory ForecastModel.fromRawJson(String str) => ForecastModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForecastModel.fromJson(Map<String, dynamic> json) => ForecastModel(
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
  DateTime stepStart;
  DateTime stepEnd;
  String date;
  String weekday;
  String rfUnit;
  String tempUnit;
  String rhUnit;
  String windspdUnit;
  String winddirUnit;
  String cldcvrUnit;
  String windgustUnit;
  String icon;
  String type;
  Cldcvr rf;
  Cldcvr temp;
  Cldcvr rh;
  Cldcvr windspd;
  Cldcvr winddir;
  Cldcvr cldcvr;
  Cldcvr windgust;

  Result({
    required this.stepStart,
    required this.stepEnd,
    required this.date,
    required this.weekday,
    required this.rfUnit,
    required this.tempUnit,
    required this.rhUnit,
    required this.windspdUnit,
    required this.winddirUnit,
    required this.cldcvrUnit,
    required this.windgustUnit,
    required this.icon,
    required this.type,
    required this.rf,
    required this.temp,
    required this.rh,
    required this.windspd,
    required this.winddir,
    required this.cldcvr,
    required this.windgust,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    stepStart: DateTime.parse(json["step_start"]),
    stepEnd: DateTime.parse(json["step_end"]),
    date: json["date"],
    weekday: json["weekday"],
    rfUnit: json["rf_unit"],
    tempUnit: json["temp_unit"],
    rhUnit: json["rh_unit"],
    windspdUnit: json["windspd_unit"],
    winddirUnit: json["winddir_unit"],
    cldcvrUnit: json["cldcvr_unit"],
    windgustUnit: json["windgust_unit"],
    icon: json["icon"],
    type: json["type"],
    rf: Cldcvr.fromJson(json["rf"]),
    temp: Cldcvr.fromJson(json["temp"]),
    rh: Cldcvr.fromJson(json["rh"]),
    windspd: Cldcvr.fromJson(json["windspd"]),
    winddir: Cldcvr.fromJson(json["winddir"]),
    cldcvr: Cldcvr.fromJson(json["cldcvr"]),
    windgust: Cldcvr.fromJson(json["windgust"]),
  );

  Map<String, dynamic> toJson() => {
    "step_start": "${stepStart.year.toString().padLeft(4, '0')}-${stepStart.month.toString().padLeft(2, '0')}-${stepStart.day.toString().padLeft(2, '0')}",
    "step_end": "${stepEnd.year.toString().padLeft(4, '0')}-${stepEnd.month.toString().padLeft(2, '0')}-${stepEnd.day.toString().padLeft(2, '0')}",
    "date": date,
    "weekday": weekday,
    "rf_unit": rfUnit,
    "temp_unit": tempUnit,
    "rh_unit": rhUnit,
    "windspd_unit": windspdUnit,
    "winddir_unit": winddirUnit,
    "cldcvr_unit": cldcvrUnit,
    "windgust_unit": windgustUnit,
    "icon": icon,
    "type": type,
    "rf": rf.toJson(),
    "temp": temp.toJson(),
    "rh": rh.toJson(),
    "windspd": windspd.toJson(),
    "winddir": winddir.toJson(),
    "cldcvr": cldcvr.toJson(),
    "windgust": windgust.toJson(),
  };
}

class Cldcvr {
  double valMin;
  double valAvg;
  double valMax;

  Cldcvr({
    required this.valMin,
    required this.valAvg,
    required this.valMax,
  });

  factory Cldcvr.fromRawJson(String str) => Cldcvr.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cldcvr.fromJson(Map<String, dynamic> json) => Cldcvr(
    valMin: json["val_min"]?.toDouble(),
    valAvg: json["val_avg"]?.toDouble(),
    valMax: json["val_max"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "val_min": valMin,
    "val_avg": valAvg,
    "val_max": valMax,
  };
}
