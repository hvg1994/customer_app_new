import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../model/profile_model/terms_condition_model.dart';
import '../../repository/profile_repository/settings_repo.dart';

class SettingsService extends ChangeNotifier{
  final SettingsRepository repository;

  SettingsService({required this.repository}) : assert(repository != null);

  Future<TermsConditionModel> getData() async{
    return await repository.getTermsCondition();
  }

  /// click to call method
  Future getCallSupportService() async{
    return await repository.getCallSupportRepo();
  }

  Future getFaqListService() async{
    return await repository.getFaqListRepo();
  }


  /// voice call methods****************

  Future callToSupportTeam(String name, String successTeamId, String accessToken) async{
    final String channelName = "callNative";


    var channel = MethodChannel(channelName);
    print("callToSupportTeam");

    Map m = {
      'user_id': name,
      'access_token': accessToken,
      'success_id': successTeamId
    };

    print("m: $m");

    try{
      listenForCall();
      var result = await channel.invokeMethod("call_support", m).whenComplete(() {
        // _showProgress = false;
        // notifyListeners();
      });
      print("Provider callToSupportTeam" + result.toString());
      // final users = result['users'];
      // print("users: ${users.runtimeType}");
      notifyListeners();

    } on PlatformException catch(e){
      print("Provider callToSupportTeam error" + e.message.toString());
      // _errorMsg = e.message.toString();
      // _isGetHomeListSuccess = false;
      notifyListeners();
    }
    // return _isGetHomeListSuccess;
  }

  Future getAccessToken(String kaleyraUID) async{
    return await repository.getAccessTokenRepo(kaleyraUID);
  }

  listenForCall()
  {
    String eventChannelName = "callNative1";

    print("Listen call");
    var channel1 = EventChannel(eventChannelName);

    //same key is used in the native code also
    try {
      print('called');
      var result;
      final result1 = channel1.receiveBroadcastStream('eventChannel');
      print("eventchannel: ${result1.asBroadcastStream().listen((event) {
        // ("type","onNetworkStatusChanged");
        print("event==>: $event");
        // if(event['type'].toString().contains(Constants.onNetworkChange)){
        //   _deviceNetworkStatus = event['status'];
        // }
        // if(event['type'].toString().contains(Constants.onStatusChange)){
        //   _deviceStatus = event['status'].toString().contains("false") ? false : true;
        // }
      })}");
      print("result1: $result1");
      notifyListeners();
      return result1;
    }
    on PlatformException catch (e) {
      print('error: $e');
      notifyListeners();
      // Unable to open the browser print(e);
    }
  }

// *************************************



}