import 'package:gwc_customer/repository/user_slot_for_schedule_repository/schedule_slot_repository.dart';

/// this is FollowUp Call Service
class GetUserScheduleSlotsForService{
  final ScheduleSlotsRepository repository;

  GetUserScheduleSlotsForService({required this.repository}) : assert(repository != null);

  /// to get the list of slots with date
  Future getSlotsDaysForScheduleService() async{
    return await repository.getSlotsDaysForScheduleRepo();
  }

  /// to get the list of slots for selected date
  Future getFollowUpSlotsScheduleService(String selectedDate) async{
    return await repository.getFollowUpSlotsScheduleRepo(selectedDate);
  }

  Future submitSlotSelectedService(String selectedDate, String startTime, String endTime) async{
    print("start: $startTime");
    return await repository.submitSlotSelectedRepo(selectedDate, startTime, endTime);
  }


}