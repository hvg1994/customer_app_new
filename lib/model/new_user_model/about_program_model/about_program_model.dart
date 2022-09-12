import 'child_about_program.dart';

class AboutProgramModel {
  int? status;
  int? errorCode;
  String? key;
  ChildAboutProgramModel? data;

  AboutProgramModel({this.status, this.errorCode, this.key, this.data});

  AboutProgramModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    data = json['data'] != null ? new ChildAboutProgramModel.fromJson(json['data']) : null;
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




