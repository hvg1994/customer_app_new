import 'child_user.dart';

class RegisterResponse {
  User? user;
  String? accessToken;
  String? otp;

  RegisterResponse({this.user, this.accessToken, this.otp});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['access_token'] = this.accessToken;
    data['otp'] = this.otp;
    return data;
  }
}

