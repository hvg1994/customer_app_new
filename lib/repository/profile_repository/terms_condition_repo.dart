import '../../model/profile_model/terms_condition_model.dart';
import '../api_service.dart';

class TermsConditionRepository{
  ApiClient apiClient;

  TermsConditionRepository({required this.apiClient}) : assert(apiClient != null);

  Future<TermsConditionModel> getTermsCondition() async{
    return await apiClient.serverGetTermsAndCondition();
  }
}