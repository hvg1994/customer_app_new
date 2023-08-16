import 'package:gwc_customer/model/program_model/proceed_model/send_proceed_program_model.dart';
import 'package:gwc_customer/repository/api_service.dart';
import 'package:http/http.dart';

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

  Future getPrepratoryMealTrackDetailsRepo() async{
    return await apiClient.getPrepratoryMealTrackDetailsApi();
  }

  Future proceedDayMealDetailsRepo(ProceedProgramDayModel model, List<MultipartFile> file,List<MultipartFile> mandatoryFile) async{
    return await apiClient.proceedTransitionDayProgramList(model, file,mandatoryFile);
  }
}