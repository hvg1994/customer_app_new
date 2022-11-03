import '../api_service.dart';

class ReportRepository{
  ApiClient apiClient;

  ReportRepository({required this.apiClient}) : assert(apiClient != null);

  Future uploadReportListRepo(List reportList) async{
    return await apiClient.uploadReportApi(reportList);
  }

  Future getUploadedReportListListRepo() async{
    return await apiClient.getUploadedReportListListApi();
  }

  Future doctorRequestedReportListRepo() async{
    return await apiClient.doctorRequestedReportListApi();
  }

  Future submitDoctorRequestedReportRepo(String reportId, dynamic multipartFile) async{
    return await apiClient.submitDoctorRequestedReportApi(reportId, multipartFile);
  }

}