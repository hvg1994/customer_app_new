import '../api_service.dart';

class ProgramRepository{
  ApiClient apiClient;

  ProgramRepository({required this.apiClient}) : assert(apiClient != null);

  /// need to pass day like 1,2,3......
  Future getMealPlanDetailsRepo(String day) async{
    return await apiClient.getMealPlanDetailsApi(day);
  }
}