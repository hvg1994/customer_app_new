import 'child_breakfast.dart';

class GetProtocolBreakfastModel {
  GetProtocolBreakfastModel({
    this.status,
    this.errorCode,
    this.key,
    this.day,
    this.time,
    this.data,
    this.history,
  });

  int? status;
  int? errorCode;
  String? key;
  String? day;
  String? time;
  Data? data;
  List<dynamic>? history;

  factory GetProtocolBreakfastModel.fromJson(Map<String, dynamic> json) => GetProtocolBreakfastModel(
    status: json["status"],
    errorCode: json["errorCode"],
    key: json["key"],
    day: json["day"],
    time: json["time"],
    data: Data.fromJson(json["data"]),
    history: List<dynamic>.from(json["history"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "key": key,
    "day": day,
    "time": time,
    "data": data?.toJson(),
    "history": List<dynamic>.from(history!.map((x) => x)),
  };
}

