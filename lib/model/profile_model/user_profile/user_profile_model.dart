import 'child_user_model.dart';

class UserProfileModel {
  String? status;
  String? errorCode;
  String? key;
  ChildUserModel? data;

  UserProfileModel({this.status, this.errorCode, this.key, this.data});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'].toString();
    key = json['key'];
    data = json['data'] != null ? ChildUserModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
