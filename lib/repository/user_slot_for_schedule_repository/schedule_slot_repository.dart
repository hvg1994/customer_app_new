import 'package:gwc_customer/repository/api_service.dart';

class ScheduleSlotsRepository{
  ApiClient apiClient;

  ScheduleSlotsRepository({required this.apiClient}) : assert(apiClient != null);

  Future getSlotsDaysForScheduleRepo() async{
    return await apiClient.getSlotsDaysForScheduleApi();
  }

  Future getFollowUpSlotsScheduleRepo(String selectedDate) async{
    return await apiClient.getFollowUpSlotsApi(selectedDate);
  }
  Future submitSlotSelectedRepo(String selectedDate, String startTime, String endTime) async {
    return await apiClient.submitSlotSelectedApi(selectedDate, startTime, endTime);
  }

  }