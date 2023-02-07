import 'package:flutter/material.dart';
import 'package:gwc_customer/repository/prepratory_repository/prep_repository.dart';

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
}