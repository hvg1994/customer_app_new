import 'dart:convert';

import 'child_breakfast.dart';

class GetProtocolBreakfastModel {
  GetProtocolBreakfastModel({
    this.status,
    this.errorCode,
    this.key,
    this.time,
    this.data,
  });

  int? status;
  int? errorCode;
  String? key;
  String? time;
  ChildBreakfast? data;

  factory GetProtocolBreakfastModel.fromJson(Map<String, dynamic> json) => GetProtocolBreakfastModel(
    status: json["status"],
    errorCode: json["errorCode"],
    key: json["key"],
    time: json["time"],
    data: ChildBreakfast.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "key": key,
    "time": time,
    "data": data?.toJson() ?? ChildBreakfast(),
  };
}


