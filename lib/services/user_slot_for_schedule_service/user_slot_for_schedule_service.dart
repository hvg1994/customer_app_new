import 'package:gwc_customer/repository/user_slot_for_schedule_repository/schedule_slot_repository.dart';

class GetUserScheduleSlotsForService{
  final ScheduleSlotsRepository repository;

  GetUserScheduleSlotsForService({required this.repository}) : assert(repository != null);

  Future getShoppingDetailsListService() async{
    return await repository.getSlotsDaysForScheduleRepo();
  }

  Future getFollowUpSlotsScheduleService(String selectedDate) async{
    return await repository.getFollowUpSlotsScheduleRepo(selectedDate);
  }

  Future submitSlotSelectedService(String selectedDate, String startTime, String endTime) async{
    print("start: $startTime");
    return await repository.submitSlotSelectedRepo(selectedDate, startTime, endTime);
  }


}