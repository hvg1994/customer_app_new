/*
In main.dart we are storing DeviceId to local storage

AppConfig() will be Singleton class so than we can use this as local storage
*/

import 'dart:io';

// import 'package:catcher/catcher.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:device_preview/device_preview.dart' hide DeviceType;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:gwc_customer/repository/in_memory_cache.dart';
import 'package:gwc_customer/services/local_notification_service.dart';
import 'package:gwc_customer/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'repository/api_service.dart';
import 'repository/enquiry_status_repository.dart';
import 'services/analytics_service.dart';
import 'services/consultation_service/consultation_service.dart';
import 'services/vlc_service/check_state.dart';
import 'utils/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'utils/http_override.dart';


cacheManager(){
  // CatcherOptions debugOptions =
  // CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
  //
  // /// Release configuration. Same as above, but once user accepts dialog, user will be prompted to send email with crash to support.
  // CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
  //   EmailManualHandler(["support@email.com"])
  // ]);
  //
  // /// STEP 2. Pass your root widget (MyApp) along with Catcher configuration:
  // Catcher(rootWidget: MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AssetsAudioPlayer.addNotificationOpenAction((notification) {
    //custom action
    return true; //true : handled, does not notify others listeners
    //false : enable others listeners to handle it
  });

  HttpOverrides.global = new MyHttpOverrides();
  AppConfig().preferences = await SharedPreferences.getInstance();
  // cacheManager();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.black26),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  //***** firebase notification ******
  await Firebase.initializeApp().then((value) {
    print("firebase initialized");
  }).onError((error, stackTrace) {
    print("firebase initialize error: ${error}");
  });


  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //
  LocalNotificationService.initialize();

  // *****  end *************
  runApp(const MyApp());


}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  // await Firebase.initializeApp();

  print("message bg: ${message.data.toString()}");

  if (message.notification != null) {
    print(message.notification!.title);
    print(message.notification!.body);
    print("message.data bg ${message.data}");
    //message.data11 {notification_type: shopping, tag_id: ,
    // body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}
    // W/dy.gwc_custome(31771): Reducing the number of considered missed Gc histogram windows from 150 to 100
    // I/flutter (31771): message recieved: {senderId: null, category: null, collapseKey: com.fembuddy.gwc_customer, contentAvailable: false, data: {notification_type: shopping, tag_id: , body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}, from: 223001521272, messageId: 0:1677744200702793%021842b3021842b3, messageType: null, mutableContent: false, notification: {title: Shopping List, titleLocArgs: [], titleLocKey: null, body: Your shopping list has been uploaded. Enjoy!, bodyLocArgs: [], bodyLocKey: null, android: {channelId: null, clickAction: null, color: null, count: null, imageUrl: null, link: null, priority: 0, smallIcon: null, sound: default, ticker: null, tag: null, visibility: 0}, apple: null, web: null}, sentTime: 1677744200683, threadId: null, ttl: 2419200}
    // I/flutter (31771): Notification Message: {senderId: null, category: null, collapseKey: com.fembuddy.gwc_customer, contentAvailable: false, data: {notification_type: shopping, tag_id: , body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}, from: 223001521272, messageId: 0:1677744200702793%021842b3021842b3, messageType: null, mutableContent: false, notification: {title: Shopping List, titleLocArgs: [], titleLocKey: null, body: Your shopping list has been uploaded. Enjoy!, bodyLocArgs: [], bodyLocKey: null, android: {channelId: null, clickAction: null, color: null, count: null, imageUrl: null, link: null, priority: 0, smallIcon: null, sound: default, ticker: null, tag: null, visibility: 0}, apple: null, web: null}, sentTime: 1677744200683, threadId: null, ttl: 2419200}

    LocalNotificationService.createanddisplaynotification(message);
  }
  else{
    LocalNotificationService().showQBNotification(message);
  }
}

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   HttpOverrides.global = new MyHttpOverrides();
//   AppConfig().preferences = await SharedPreferences.getInstance();
//
//   // CatcherOptions debugOptions =
//   // CatcherOptions(DialogReportMode(), [ConsoleHandler()]);
//   //
//   // /// Release configuration. Same as above, but once user accepts dialog, user will be prompted to send email with crash to support.
//   // CatcherOptions releaseOptions = CatcherOptions(DialogReportMode(), [
//   //   EmailManualHandler(["support@email.com"])
//   // ]);
//   //
//   // /// STEP 2. Pass your root widget (MyApp) along with Catcher configuration:
//   // Catcher(rootWidget: MyApp(), debugConfig: debugOptions, releaseConfig: releaseOptions);
//
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(statusBarColor: Colors.black26),
//   );
//   await SystemChrome.setPreferredOrientations(
//     [DeviceOrientation.portraitUp],
//   );
//   //***** firebase notification ******
//   await Firebase.initializeApp();
//
//   // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//   //   alert: true,
//   //   badge: true,
//   //   sound: true,
//   // );
//   //
//   // await FirebaseMessaging.instance.getToken();
//   //
//   // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   // final fcmToken = await FirebaseMessaging.instance.getToken();
//
//   // LocalNotificationService.initialize();
//
//
//   // print("fcmToken: $fcmToken");
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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storeLastLogin();
  }


  @override
  Widget build(BuildContext context) {

    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return  MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CheckState()),
          ChangeNotifierProvider(create: (_)=> ConsultationService())
        ],
        child: GetMaterialApp(
            supportedLocales: [
              const Locale("en"), /// THIS IS FOR COUNTRY CODE PICKER
            ],
            // localizationsDelegates: [
            //   CountryLocalizations.delegate, /// THIS IS FOR COUNTRY CODE PICKER
            // ],
            debugShowCheckedModeBanner: false,
            builder: (BuildContext context, Widget? child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
              child: child ?? const SizedBox.shrink(),
            ),
            navigatorObservers: [
              AnalyticsService().getAnalyticsObserver(),
            ],
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
      print(date);
      DateTime prev = DateTime.fromMillisecondsSinceEpoch(date);
      print(prev);
      print('difference time: ${calculateDifference(prev)}');
      if(calculateDifference(prev) == -7){
        final inMemoryCache = InMemoryCache();
        inMemoryCache.cache.clear();
        _pref!.setBool(AppConfig.isLogin, false);
      }
    }
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  }
}
