import 'package:flutter/material.dart';
import 'package:gwc_customer/repository/program_repository/program_repository.dart';

class ProgramService extends ChangeNotifier{
  final ProgramRepository repository;

  ProgramService({required this.repository}) : assert(repository != null);

  /// need to pass day like 1,2,3......
  Future getMealPlanDetailsService(String day) async{
    return await repository.getMealPlanDetailsRepo(day);
  }
}