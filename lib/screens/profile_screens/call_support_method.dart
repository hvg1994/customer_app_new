import 'package:gwc_customer/services/profile_screen_service/terms_condition_service.dart';

import '../../repository/api_service.dart';
import '../../repository/profile_repository/terms_condition_repo.dart';
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