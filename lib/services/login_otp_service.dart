import 'package:flutter/material.dart';
import 'package:gwc_customer/repository/login_otp_repository.dart';

class LoginWithOtpService extends ChangeNotifier{
  late final LoginOtpRepository repository;

  LoginWithOtpService({required this.repository}) : assert(repository != null);

  Future loginWithOtpService(String phone, String otp, String fcm) async{
    return await repository.loginWithOtpRepo(phone, otp, fcm);
  }

  Future getOtpService(String phone) async{
    return await repository.getOtpRepo(phone);
  }

  Future logoutService() async{
    return await repository.logoutRepo();
  }

  Future getAccessToken(String kaleyraUID) async{
    return await repository.getAccessTokenRepo(kaleyraUID);
  }
}