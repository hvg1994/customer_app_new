import 'child_get_shopping_model.dart';

class GetShoppingListModel {
  int? status;
  int? errorCode;
  Map<String, List<ChildGetShoppingModel>>? data;

  GetShoppingListModel({
    this.status,
    this.errorCode,
    this.data,
  });

  factory GetShoppingListModel.fromJson(Map<String, dynamic> json) => GetShoppingListModel(
    status: json["status"],
    errorCode: json["errorCode"],
    data: Map.from(json["data"]).map((k, v) => MapEntry<String, List<ChildGetShoppingModel>>(k, List<ChildGetShoppingModel>.from(v.map((x) => ChildGetShoppingModel.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errorCode": errorCode,
    "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
  };
}
