import 'child_about_program.dart';

class AboutProgramModel {
  String? status;
  String? errorCode;
  String? key;
  ChildAboutProgramModel? data;

  AboutProgramModel({this.status, this.errorCode, this.key, this.data});

  AboutProgramModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'].toString();
    key = json['key'];
    data = json['data'] != null ? new ChildAboutProgramModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status.toString();
    data['errorCode'] = this.errorCode.toString();
    data['key'] = this.key;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}




