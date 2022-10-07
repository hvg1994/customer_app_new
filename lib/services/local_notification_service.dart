import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gwc_customer/utils/app_config.dart';
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
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          AppConfig.notification_channelId,
          AppConfig.notification_channelName,
          importance: Importance.high,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
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
}
