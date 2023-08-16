import 'package:flutter/material.dart';
import 'package:gwc_customer/model/program_model/proceed_model/send_proceed_program_model.dart';
import 'package:gwc_customer/repository/prepratory_repository/prep_repository.dart';
import 'package:http/http.dart';

class PrepratoryMealService extends ChangeNotifier{
  final PrepratoryRepository repository;

  PrepratoryMealService({required this.repository}) : assert(repository != null);

  Future getPrepratoryMealService() async{
    return await repository.getPrepratoryMealRepo();
  }
  Future getTransitionMealService() async{
    return await repository.getTransitionMealRepo();
  }

  Future sendPrepratoryMealTrackDetailsService(Map trackDetails) async{
    return await repository.sendPrepratoryMealTrackDetailsRepo(trackDetails);
  }

  Future getPrepratoryMealTrackDetailsService() async{
    return await repository.getPrepratoryMealTrackDetailsRepo();
  }

  Future proceedDayMealDetailsService(ProceedProgramDayModel day, List<MultipartFile> file,List<MultipartFile> mandatoryFile) async{
    return await repository.proceedDayMealDetailsRepo(day, file,mandatoryFile);
  }

}