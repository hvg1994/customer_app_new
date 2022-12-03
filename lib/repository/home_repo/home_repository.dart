import 'package:gwc_customer/repository/api_service.dart';

class HomeRepository{
  ApiClient apiClient;

  HomeRepository({required this.apiClient}) : assert(apiClient != null);

  Future getHomeDetailsRepo() async{
    return await apiClient.getHomeDetailsApi();
  }
}