import 'package:gwc_customer/services/profile_screen_service/settings_service.dart';
import 'package:gwc_customer/utils/app_config.dart';

import '../../repository/api_service.dart';
import '../../repository/profile_repository/settings_repo.dart';
import 'package:http/http.dart' as http;


callSupport() async{
  final res = await SettingsService(repository: repository).getCallSupportService();
  print(res);
  return res;
}


final SettingsRepository repository = SettingsRepository(
  apiClient: ApiClient(
    httpClient: http.Client(),
  ),
);


supportVoiceCall(String kaleyraUID, String kaleyraSuccessID, String accessToken) async{
  final res = await SettingsService(repository: repository).callToSupportTeam(kaleyraUID, kaleyraSuccessID, accessToken);
  return res;
}