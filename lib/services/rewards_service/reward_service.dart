import 'package:gwc_customer/repository/rewards_repository/reward_repository.dart';

class RewardService{
  final RewardRepository repository;

  RewardService({required this.repository}) : assert(repository != null);

  Future getRewardService() async{
    return await repository.getRewardRepo();
  }

  Future getRewardStagesService() async{
    return await repository.getRewardStagesRepo();
  }
}