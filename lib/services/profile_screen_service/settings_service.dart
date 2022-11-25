import 'package:flutter/cupertino.dart';

import '../../model/profile_model/terms_condition_model.dart';
import '../../repository/profile_repository/settings_repo.dart';

class SettingsService extends ChangeNotifier{
  final SettingsRepository repository;

  SettingsService({required this.repository}) : assert(repository != null);

  Future<TermsConditionModel> getData() async{
    return await repository.getTermsCondition();
  }

  Future getCallSupportService() async{
    return await repository.getCallSupportRepo();
  }

  Future getFaqListService() async{
    return await repository.getFaqListRepo();
  }
}