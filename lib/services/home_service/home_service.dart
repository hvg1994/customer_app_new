import 'package:flutter/cupertino.dart';
import 'package:gwc_customer/repository/home_repo/home_repository.dart';

class HomeService extends ChangeNotifier{
  final HomeRepository repository;

  HomeService({required this.repository}) : assert(repository != null);

  Future getHomeDetailsService() async{
    return await repository.getHomeDetailsRepo();
  }
}