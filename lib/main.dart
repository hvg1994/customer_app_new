/*
In main.dart we are storing DeviceId to local storage

AppConfig() will be Singleton class so than we can use this as local storage
*/

import 'dart:io';

import 'package:country_code_picker/country_localizations.dart';
import 'package:device_preview/device_preview.dart' hide DeviceType;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer/services/local_notification_service.dart';
import 'package:gwc_customer/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'repository/api_service.dart';
import 'repository/enquiry_status_repository.dart';
import 'services/vlc_service/check_state.dart';
import 'utils/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';

import 'utils/http_override.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
    await Firebase.initializeApp();

    print(message.data.toString());
    print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  AppConfig().preferences = await SharedPreferences.getInstance();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.black26),
  );
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  //***** firebase notification ******
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.getToken();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final fcmToken = await FirebaseMessaging.instance.getToken();

  LocalNotificationService.initialize();


  print("fcmToken: $fcmToken");

  // *****  end *************
  runApp(const MyApp());

  print("fcmToken: $fcmToken");


}


// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   AppConfig().preferences = await SharedPreferences.getInstance();
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
//   );
//   runApp(
//     DevicePreview(
//       enabled: !kReleaseMode,
//       builder: (context) => const MyApp(), // Wrap your app
//     ),
//   );
// }

final EnquiryStatusRepository repository = EnquiryStatusRepository(
  apiClient: ApiClient(
    httpClient: http.Client(),
  ),
);


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _pref = AppConfig().preferences;

  getDeviceId() async{
    final _pref = AppConfig().preferences;
    await AppConfig().getDeviceId().then((id) {
      print("deviceId: $id");
      if(id != null){
        _pref!.setString(AppConfig().deviceId, id);
      }
    });

    // this is for getting the state and city name
    // this was not using currently
    String? n = await FlutterSimCountryCode.simCountryCode;
    if(n!= null) _pref!.setString(AppConfig.countryCode, n);
    // print("country_code:${n}");

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    _pref!.setString(AppConfig.FCM_TOKEN, fcmToken!);

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceId();
    storeLastLogin();

    getPermission();
    listenMessages();
    listenNotifications();
  }
  void listenNotifications()async{
    LocalNotificationService.onNotifications.stream
      .listen(onClickedNotifications);}

  void onClickedNotifications(String? payload)
  {
    print("on notification click: $payload");
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => const NotificationsList(),
    //   ),
    // );
  }

  listenMessages(){
    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );
    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  getPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }




  @override
  Widget build(BuildContext context) {
    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return  MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CheckState())
        ],
        child: const GetMaterialApp(
            supportedLocales: [
              const Locale("en"), /// THIS IS FOR COUNTRY CODE PICKER
            ],
            localizationsDelegates: [
              CountryLocalizations.delegate, /// THIS IS FOR COUNTRY CODE PICKER
            ],
            debugShowCheckedModeBanner: false,
            home: const SplashScreen()),
      );
    });
  }

  void storeLastLogin() {
    if(_pref!.getInt(AppConfig.last_login) == null){
      _pref!.setInt(AppConfig.last_login, DateTime.now().millisecondsSinceEpoch);
    }
    else{
      int date = _pref!.getInt(AppConfig.last_login)!;
      DateTime prev = DateTime.fromMillisecondsSinceEpoch(date);
      print(prev);
      print('difference time: ${calculateDifference(prev)}');
      if(calculateDifference(prev) == -1){
        _pref!.setBool(AppConfig.isLogin, false);
      }
    }
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  }
}
