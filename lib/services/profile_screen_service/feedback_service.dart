import 'package:flutter/cupertino.dart';

import '../../repository/profile_repository/feedback_repo.dart';

class FeedbackService extends ChangeNotifier{
  final FeedbackRepository repository;

  FeedbackService({required this.repository}) : assert(repository != null);

  Future submitFeedbackService(Map feedback) async{
    return await repository.submitFeedbackRepo(feedback);
  }
}