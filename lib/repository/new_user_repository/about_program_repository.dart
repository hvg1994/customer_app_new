import 'package:gwc_customer/model/new_user_model/about_program_model/about_program_model.dart';

import '../api_service.dart';

class AboutProgramRepository{
  ApiClient apiClient;

  AboutProgramRepository({required this.apiClient}) : assert(apiClient != null);

  Future serverAboutProgramRepo() async{
    return await apiClient.
    serverGetAboutProgramDetails();
  }

}