import 'package:gwc_customer/repository/api_service.dart';

class PrepratoryRepository{
  ApiClient apiClient;

  PrepratoryRepository({required this.apiClient}) : assert(apiClient != null);

  Future getPrepratoryMealRepo() async{
    return await apiClient.getPrepraoryMealsApi();
  }
  Future getTransitionMealRepo() async{
    return await apiClient.getTransitionMealsApi();
  }

  Future sendPrepratoryMealTrackDetailsRepo(Map trackDetails) async{
    return await apiClient.sendPrepratoryMealTrackDetailsApi(trackDetails);
  }
}