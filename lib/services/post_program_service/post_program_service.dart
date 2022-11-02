import 'package:flutter/material.dart';
import 'package:gwc_customer/repository/program_repository/program_repository.dart';

import '../../model/program_model/proceed_model/send_proceed_program_model.dart';
import '../../repository/post_program_repo/post_program_repository.dart';

class PostProgramService extends ChangeNotifier{
  final PostProgramRepository repository;

  PostProgramService({required this.repository}) : assert(repository != null);

  Future startPostProgramService() async{
    return await repository.startPostProgramRepo();
  }
  Future getBreakfastService(String day) async{
    return await repository.getBreakfastRepo(day);
  }
  Future getLunchService(String day) async{
    return await repository.getLunchRepo(day);
  }
  Future getDinnerService(String day) async{
    return await repository.getDinnerRepo(day);
  }
  Future submitPostProgramMealTrackingService(String mealType, int selectedType, int? dayNumber) async{
    return await repository.submitPostProgramMealTrackingRepo(mealType, selectedType, dayNumber);
  }
  Future getProtocolDayDetailsService({String? dayNumber}) async{
    return await repository.getProtocolDayDetailsRepo(dayNumber: dayNumber);
  }

}