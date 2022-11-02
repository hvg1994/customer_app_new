import '../../model/program_model/proceed_model/send_proceed_program_model.dart';
import '../api_service.dart';

class PostProgramRepository{
  ApiClient apiClient;

  PostProgramRepository({required this.apiClient}) : assert(apiClient != null);

  Future startPostProgramRepo() async{
    return await apiClient.startPostProgram();
  }

  Future getBreakfastRepo(String day) async{
    return await apiClient.getBreakfastOnclickApi(day);
  }
  Future getLunchRepo(String day) async{
    return await apiClient.getLunchOnclickApi(day);
  }
  Future getDinnerRepo(String day) async{
    return await apiClient.getDinnerOnclickApi(day);
  }

  Future submitPostProgramMealTrackingRepo(String mealType, int selectedType, int? dayNumber) async{
    return await apiClient.submitPostProgramMealTrackingApi(mealType, selectedType, dayNumber);
  }

  Future getProtocolDayDetailsRepo({String? dayNumber}) async{
    return await apiClient.getProtocolDayDetailsApi(dayNumber: dayNumber);
  }

}