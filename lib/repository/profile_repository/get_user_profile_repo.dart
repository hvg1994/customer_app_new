
import '../api_service.dart';

class UserProfileRepository{
  ApiClient apiClient;

  UserProfileRepository({required this.apiClient}) : assert(apiClient != null);

  Future getUserProfileRepo() async{
    return await apiClient.getUserProfileApi();
  }
}