import 'dart:convert';

class LoginOtpModel {
  String? status;
  String? accessToken;
  String? tokenType;
  String? userEvaluationStatus;

  LoginOtpModel({this.status, this.accessToken, this.tokenType, this.userEvaluationStatus});

  LoginOtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    accessToken = json['access_token'].toString();
    tokenType = json['token_type'].toString();
    userEvaluationStatus = json['user_status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status.toString();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['user_status'] = this.userEvaluationStatus;
    return data;
  }
}

LoginOtpModel loginOtpFromJson(String str) => LoginOtpModel.fromJson(json.decode(str));

String loginOtpToJson(LoginOtpModel data) => json.encode(data.toJson());