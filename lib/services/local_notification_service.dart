import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:rxdart/rxdart.dart';

class LocalNotificationService {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static void initialize() {
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(),
    );
    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        print('payload: $payload');
        onNotifications.add(payload);
        // Get.to(() => const NotificationsList());
        // print("onSelectNotification");
        // if (id!.isNotEmpty) {
        //   print("Router Value1234 $id");

        //   // Navigator.of(context).push(
        //   //   MaterialPageRoute(
        //   //     builder: (context) => const NotificationsList(),
        //   //   ),
        //   // );
        // }
      },
    );

  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          AppConfig.notification_channelId,
          AppConfig.notification_channelName,
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
          color: gMainColor.withOpacity(0.4),
          colorized: true
          //   sound: RawResourceAndroidNotificationSound('yourmp3files.mp3'),
        ),
        iOS: IOSNotificationDetails(
          //  sound: 'azan1.mp3',
          presentSound: true,
        ),
        macOS: MacOSNotificationDetails(
          presentSound: true,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['_id'],
      ).then((value) {
        print("notify:}");
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  void showQBNotification(RemoteMessage message) {
    print("Notification Message: ${message.toMap()}");
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'channel_id', 'some_title', description: 'some_description',
        importance: Importance.high);

    // message recieved: {senderId: null, category: null, collapseKey: event38739295,
    // contentAvailable: false, data: {msg: hello sjsnjlasjnas,
    // fcm: abc, message: This is Notification Test Message},
    // from: 728114586270, messageId: 0:1672989796313608%021842b3f9fd7ecd,
    // messageType: null, mutableContent: false, notification: null,
    // sentTime: 1672989796282, threadId: null, ttl: 86400}

    //Notification Message: {
    // senderId: null, category: null,
    // collapseKey: event38755058, contentAvailable: false,
    // data: {message: {"title":"You have New Message","message":"ghghghgh","type":"chat"}},
    // from: 223001521272, messageId: 0:1673589826135148%021842b3f9fd7ecd,
    // messageType: null,
    // mutableContent: false,
    // notification: null, sentTime: 1673589826107, threadId: null, ttl: 86400}

    AndroidNotificationDetails details = AndroidNotificationDetails(
        channel.id, channel.name, channelDescription:  channel.description,
        icon: "@mipmap/ic_launcher");

    if(message.data != null ||message.data.isNotEmpty){
      int id = message.hashCode;
      String title = "New Chat Message";
      String body = message.data["message"];

      Map payload = jsonDecode(body);
      String textMsg = payload["message"];
      payload["type"] = "chat";
      String senderId = payload['senderId'].toString();


      if(senderId != "82272762"){
        _notificationsPlugin.show(id, title, textMsg,
            NotificationDetails(android: details),
            payload: message.data.toString()
        );
      }
    }
  }

}
