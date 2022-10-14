import '../../model/program_model/proceed_model/send_proceed_program_model.dart';
import '../api_service.dart';

class ProgramRepository{
  ApiClient apiClient;

  ProgramRepository({required this.apiClient}) : assert(apiClient != null);

  Future getMealProgramDaysRepo() async{
    return await apiClient.getProgramDayListApi();
  }

  /// need to pass day like 1,2,3......
  Future getMealPlanDetailsRepo(String day) async{
    return await apiClient.getMealPlanDetailsApi(day);
  }

  Future proceedDayMealDetailsRepo(ProceedProgramDayModel model) async{
    return await apiClient.proceedDayProgramList(model);
  }

  /// pass startProgram=1
  Future startProgramOnSwipeRepo(String startProgram) async{
    return await apiClient.startProgramOnSwipeApi(startProgram);
  }

}