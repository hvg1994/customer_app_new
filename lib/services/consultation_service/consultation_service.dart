
import 'package:flutter/cupertino.dart';

import '../../repository/consultation_repository/get_slots_list_repository.dart';

class ConsultationService extends ChangeNotifier{
  final ConsultationRepository repository;

  ConsultationService({required this.repository}) : assert(repository != null);

  Future getAppointmentSlotListService(String selectedDate, {String? appointmentId}) async{
    return await repository.getAppointmentSlotListRepo(selectedDate, appointmentId: appointmentId);
  }

  Future bookAppointmentService(String date, String slotTime, {String? appointmentId, bool isPostprogram = false}) async{
    return await repository.bookAppointmentSlotListRepo(date, slotTime, appointmentId: appointmentId, isPostprogram: isPostprogram);
  }

}