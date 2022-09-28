import 'child_get_shopping_model.dart';

class GetShoppingListModel {
  int? status;
  int? errorCode;
  List<ChildGetShoppingModel>? data;

  GetShoppingListModel({this.status, this.errorCode, this.data});

  GetShoppingListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    if (json['data'] != null) {
      data = <ChildGetShoppingModel>[];
      json['data'].forEach((v) {
        data!.add(new ChildGetShoppingModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
