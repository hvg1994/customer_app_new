import '../api_service.dart';

class EvaluationFormRepository{
  ApiClient apiClient;

  EvaluationFormRepository({required this.apiClient}) : assert(apiClient != null);

  Future submitEvaluationFormRepo(Map form, List medicalReports) async{
    return await apiClient.submitEvaluationFormApi(form, medicalReports);
  }

  Future getEvaluationDataRepo() async{
    return await apiClient.serverGetEvaluationDetails();
  }
}