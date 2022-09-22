import 'package:flutter/cupertino.dart';

import '../../model/profile_model/terms_condition_model.dart';
import '../../repository/profile_repository/terms_condition_repo.dart';

class TermsConditionService extends ChangeNotifier{
  final TermsConditionRepository repository;

  TermsConditionService({required this.repository}) : assert(repository != null);

  Future<TermsConditionModel> getData() async{
    return await repository.getTermsCondition();
  }
}