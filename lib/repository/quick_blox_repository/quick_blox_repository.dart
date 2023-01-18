import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gwc_customer/services/local_notification_service.dart';
import 'package:quickblox_sdk/models/qb_settings.dart';
import 'package:quickblox_sdk/push/constants.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class QuickBloxRepository {
  Future<void> init(String appId, String authKey, String authSecret, String accountKey,
      {String? apiEndpoint, String? chatEndpoint}) async {
    print("appId: $appId");
    print("auth: $authKey");
    print("secret: $authSecret");
    print("key: $accountKey");

    await QB.settings.init(appId, authKey, authSecret, accountKey,
        apiEndpoint: apiEndpoint, chatEndpoint: chatEndpoint).then((value) {
          print("QB init done");
    }).onError((error, stackTrace) {
      print("QB Init error${error}");
    });
  }

  Future<QBSettings?> get() async {
    return await QB.settings.get();
  }

  Future<void> enableCarbons() async {
    await QB.settings.enableCarbons();
  }

  Future<void> disableCarbons() async {
    await QB.settings.disableCarbons();
  }

  Future<void> initStreamManagement(bool autoReconnect, int messageTimeout) async {
    await QB.settings.initStreamManagement(messageTimeout, autoReconnect: autoReconnect);
  }

  Future<void> enableXMPPLogging() async {
    await QB.settings.enableXMPPLogging();
  }

  Future<void> enableLogging() async {
    await QB.settings.enableLogging();
  }

  Future<void> enableAutoReconnect(bool enable) async {
    await QB.settings.enableAutoReconnect(enable);
  }

  void initSubscription(String fcmToken) async {
    print("QB initSubscription to fcm- ${fcmToken}");
    if(fcmToken.isNotEmpty){
      // String fcm = "dC7s062gQFK-rp3_NzA-OK:APA91bHCQAQSpbPHdOGK4Qmm57TrRDAg28KU2pAYPelj-ER8VWsWr8W6gDbiD4CusBshnDY2atZntwhV5s8BvYkvUtga5L3tUf9Pa3yDLV2m4WPxOL3Hs25EFH5NHHsJnxmiLJIRLHbt";
      QB.subscriptions.create(fcmToken, QBPushChannelNames.GCM).then((value) => print("push created")).onError((error, stackTrace) => print("push error: ${error}"));
      try {
        FirebaseMessaging.onMessage.listen((message) {
          print("message recieved: ${message.toMap()}");
          LocalNotificationService().showQBNotification(message);
          // LocalNotificationService.createanddisplaynotification(message);

        });
      } on PlatformException catch (e) {
        //some error occurred
        print("qb subscribe error: ${e.message}");
      }
    }
    else{
      if (kDebugMode) {
        print("fcm Token is empty");
      }}
  }

}
