/*
1. check for the enquiry status api
2. if status: 0 sitback screen
3. else status: 1 => than we need to check for is already login or not
 if not login need to show existing user screen else
4. Need to check for evaluation status(EVAL_STATUS) which will be stored when user login
if already login we will get from local storage else its null
5. if eval status is there than we are showing dashboard screen else evaluation screen

API's used in this screen:
1. EnquiryStatus API
 */

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gwc_customer/repository/enquiry_status_repository.dart';
import 'package:gwc_customer/repository/enquiry_status_repository.dart';
import 'package:gwc_customer/screens/evalution_form/evaluation_form_screen.dart';
import 'package:gwc_customer/screens/profile_screens/call_support_method.dart';
import 'package:gwc_customer/screens/user_registration/existing_user.dart';
import 'package:gwc_customer/screens/user_registration/new_user/sit_back_screen.dart';
import 'package:gwc_customer/services/enquiry_status_service.dart';
import 'package:gwc_customer/services/local_notification_service.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:gwc_customer/widgets/background_widget.dart';
import 'package:gwc_customer/widgets/dart_extensions.dart';
import 'package:gwc_customer/widgets/notification_class.dart';
import 'package:gwc_customer/widgets/open_alert_box.dart';
import 'package:gwc_customer/widgets/will_pop_widget.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'model/enquiry_status_model.dart';
import 'model/error_model.dart';
import 'repository/api_service.dart';
import 'package:http/http.dart' as http;

import 'screens/dashboard_screen.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'screens/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  bool isLogin = false;
  String? evalStatus;

  final _pref = AppConfig().preferences!;

  String? deviceId;

  /// by default status is 1
  /// 1 existing user screen
  /// 0 sitback screen
  int? enquiryStatus;

  bool isError = false;

  String errorMsg = '';

  @override
  void initState() {
    // checkNewVersion();
    getDeviceId();
    super.initState();
    runAllAsync();
    firebaseNotif();
    // listenMessages();
  }
  checkNewVersion(){
    final newVersion = NewVersion(
      // iOSId: 'com.google.Vespa',
      androidId: 'com.fembuddy.gwc_customer',
    );

    // You can let the plugin handle fetching the status and showing a dialog,
    // or you can fetch the status and display your own dialog, or no dialog.
    const simpleBehavior = true;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      advancedStatusCheck(newVersion);
    }
  }
  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Custom Title',
        dialogText: 'Custom Text',
      );
    }
  }

  Future getDeviceId() async{
    final _pref = AppConfig().preferences;
    if(_pref!.getString(AppConfig().deviceId) == null || _pref.getString(AppConfig().deviceId) != ""){
      await AppConfig().getDeviceId().then((id) {
        print("deviceId: $id");
        if(id != null){
          _pref!.setString(AppConfig().deviceId, id);
          getEnquiryStatus(id);
        }
      });
    }
    else{
      deviceId = _pref.getString(AppConfig().deviceId);
      getEnquiryStatus(deviceId!);
    }

    // this is for getting the state and city name
    // this was not using currently
    String? n = await FlutterSimCountryCode.simCountryCode;
    print("country: $n");
    if(n!= null) _pref!.setString(AppConfig.countryCode, n);
    // print("country_code:${n}");

  }
  late FirebaseMessaging messaging;

  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();
  firebaseNotif() async{
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      // iOS: IOSInitializationSettings(),
    );
    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onClickedNotifications
      // onSelectNotification: (payload) async {
      //   print('payload: $payload');
      //   onNotifications.add(payload);
      //   // Get.to(() => const NotificationsList());
      //   // print("onSelectNotification");
      //   // if (id!.isNotEmpty) {
      //   //   print("Router Value1234 $id");
      //
      //   //   // Navigator.of(context).push(
      //   //   //   MaterialPageRoute(
      //   //   //     builder: (context) => const NotificationsList(),
      //   //   //   ),
      //   //   // );
      //   // }
      // },
    );
    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.toMap());
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          //message.data11 {notification_type: shopping, tag_id: ,
          // body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}
          // W/dy.gwc_custome(31771): Reducing the number of considered missed Gc histogram windows from 150 to 100
          // I/flutter (31771): message recieved: {senderId: null, category: null, collapseKey: com.fembuddy.gwc_customer, contentAvailable: false, data: {notification_type: shopping, tag_id: , body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}, from: 223001521272, messageId: 0:1677744200702793%021842b3021842b3, messageType: null, mutableContent: false, notification: {title: Shopping List, titleLocArgs: [], titleLocKey: null, body: Your shopping list has been uploaded. Enjoy!, bodyLocArgs: [], bodyLocKey: null, android: {channelId: null, clickAction: null, color: null, count: null, imageUrl: null, link: null, priority: 0, smallIcon: null, sound: default, ticker: null, tag: null, visibility: 0}, apple: null, web: null}, sentTime: 1677744200683, threadId: null, ttl: 2419200}
          // I/flutter (31771): Notification Message: {senderId: null, category: null, collapseKey: com.fembuddy.gwc_customer, contentAvailable: false, data: {notification_type: shopping, tag_id: , body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}, from: 223001521272, messageId: 0:1677744200702793%021842b3021842b3, messageType: null, mutableContent: false, notification: {title: Shopping List, titleLocArgs: [], titleLocKey: null, body: Your shopping list has been uploaded. Enjoy!, bodyLocArgs: [], bodyLocKey: null, android: {channelId: null, clickAction: null, color: null, count: null, imageUrl: null, link: null, priority: 0, smallIcon: null, sound: default, ticker: null, tag: null, visibility: 0}, apple: null, web: null}, sentTime: 1677744200683, threadId: null, ttl: 2419200}

          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) async {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print(message.toMap());
          print("message.data22 ${message.data['notification_type']}");
          if(message.data != null){
            if(message.data['notification_type'] == 'new_chat'){
              final uId = _pref!.getString(AppConfig.KALEYRA_USER_ID);

              final accessToken = _pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN);

              final chatSuccessId = _pref!.getString(AppConfig.KALEYRA_CHAT_SUCCESS_ID);
              // chat
              await openKaleyraChat(uId!, chatSuccessId!, accessToken!);
            }
          }


        }
      },
    );
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  }

  runAllAsync() async{
    await Future.wait([
      getPermission(),
    // listenNotifications(),
    //   /// quickblox
    //   getSession(),
    ]);
    print("starting Application!");
  }

  Future getSession() async{
    await notificationFunction();
  }

  Future listenNotifications()async{
    LocalNotificationService.onNotifications.stream
        .listen(onClickedNotifications);}

  void onClickedNotifications(String? payload)
  {
    print("on notification click: $payload");
    if(payload != null){
      if(payload == 'new_chat'){

      }
      else{
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const NotificationScreen(),
          ),
        );
      }
    }
  }

  listenMessages(){
    print("listenMessages");
    messaging.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          if(message != null){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NotificationScreen(),
              ),
            );
          }
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
          //message.data11 {notification_type: shopping, tag_id: ,
          // body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}
          // W/dy.gwc_custome(31771): Reducing the number of considered missed Gc histogram windows from 150 to 100
          // I/flutter (31771): message recieved: {senderId: null, category: null, collapseKey: com.fembuddy.gwc_customer, contentAvailable: false, data: {notification_type: shopping, tag_id: , body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}, from: 223001521272, messageId: 0:1677744200702793%021842b3021842b3, messageType: null, mutableContent: false, notification: {title: Shopping List, titleLocArgs: [], titleLocKey: null, body: Your shopping list has been uploaded. Enjoy!, bodyLocArgs: [], bodyLocKey: null, android: {channelId: null, clickAction: null, color: null, count: null, imageUrl: null, link: null, priority: 0, smallIcon: null, sound: default, ticker: null, tag: null, visibility: 0}, apple: null, web: null}, sentTime: 1677744200683, threadId: null, ttl: 2419200}
          // I/flutter (31771): Notification Message: {senderId: null, category: null, collapseKey: com.fembuddy.gwc_customer, contentAvailable: false, data: {notification_type: shopping, tag_id: , body: Your shopping list has been uploaded. Enjoy!, title: Shopping List, user: user}, from: 223001521272, messageId: 0:1677744200702793%021842b3021842b3, messageType: null, mutableContent: false, notification: {title: Shopping List, titleLocArgs: [], titleLocKey: null, body: Your shopping list has been uploaded. Enjoy!, bodyLocArgs: [], bodyLocKey: null, android: {channelId: null, clickAction: null, color: null, count: null, imageUrl: null, link: null, priority: 0, smallIcon: null, sound: default, ticker: null, tag: null, visibility: 0}, apple: null, web: null}, sentTime: 1677744200683, threadId: null, ttl: 2419200}

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

  Future getPermission() async{
    // await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;

    String? fcmToken = await messaging.getToken();
    print("fcm: $fcmToken");
    _pref!.setString(AppConfig.FCM_TOKEN, fcmToken!);

    // QuickBloxRepository().init(AppConfig.QB_APP_ID, AppConfig.QB_AUTH_KEY, AppConfig.QB_AUTH_SECRET, AppConfig.QB_ACCOUNT_KEY);
    //
    // QuickBloxRepository().initSubscription(fcmToken);


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

  startTimer(){
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 1;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
    getScreen();
  }

  getEnquiryStatus(String deviceId) async{

    final result = await EnquiryStatusService(repository: repository).enquiryStatusService(deviceId);

    print("getEnquiryStatus: $result");
    if(result.runtimeType == EnquiryStatusModel){
      EnquiryStatusModel model = result as EnquiryStatusModel;
      if(model.errorMsg!.contains("No data found")){
        setState(() {
          // show login if new deviceId
          enquiryStatus = 1;
          isError = false;
        });
      }
      else{
        setState(() {
          enquiryStatus = model.enquiryStatus ?? 0;
          isError = false;
        });
      }
    }
    else{
      ErrorModel model = result as ErrorModel;
      print("getEnquiryStatus error from main: ${model.message}");
      setState(() {
        isError = true;
        if(model.message!.contains("Failed host lookup")){
          errorMsg = AppConfig.networkErrorText;
        }
        else{
          errorMsg = AppConfig.oopsMessage;
        }
      });
    }
    startTimer();
  }

  getScreen(){
    setState(() {
      isLogin = _pref.getBool(AppConfig.isLogin) ?? false;
      evalStatus = _pref.getString(AppConfig.EVAL_STATUS) ?? '';
    });
    print("_pref.getBool(AppConfig.isLogin): ${_pref.getBool(AppConfig.isLogin)}");
    print("isLogin: $isLogin");
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   if(isError){
    //     showAlert();
    //     _timer!.cancel();
    //   }
    // });
  }



  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            reverse: false,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: <Widget>[
              splashImage(),
              if(enquiryStatus != null)
              (enquiryStatus!.isEven) ? SitBackScreen() : !isLogin ? ExistingUser() : (evalStatus!.contains("no_evaluation") || evalStatus!.contains("pending")) ? EvaluationFormScreen(isFromSplashScreen: true,) : DashboardScreen()
            ],
          ),
        ],
      ),
    );
  }

  splashImage() {
    return BackgroundWidget(
      assetName: 'assets/images/Group 2657.png',
      child: Center(
        child: Image(
          width: 70.w,
          image: AssetImage("assets/images/Gut welness logo.png"),
        ),
        // SvgPicture.asset(
        //     "assets/images/splash_screen/Splash screen Logo.svg"),
      ),
    );
  }

  final EnquiryStatusRepository repository = EnquiryStatusRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  showAlert(){
    return openAlertBox(
        context: context,
        barrierDismissible: false,
        content: errorMsg,
        titleNeeded: false,
        isSingleButton: true,
        positiveButtonName: 'Retry',
        positiveButton: (){
          if(deviceId != null){
            getEnquiryStatus(deviceId!);
            Navigator.pop(context);
          }
          else{
            getDeviceId();
            Navigator.pop(context);
          }
        }
    );
  }
}
