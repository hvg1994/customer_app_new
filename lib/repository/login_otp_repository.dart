import '../../repository/api_service.dart';

class LoginOtpRepository{
  ApiClient apiClient;

  LoginOtpRepository({required this.apiClient}) : assert(apiClient != null);

  Future loginWithOtpRepo(String phone, String otp) async{
    return await apiClient.serverLoginWithOtpApi(phone, otp);
  }

  Future getOtpRepo(String phone) async{
    return await apiClient.serverGetOtpApi(phone);
  }
}