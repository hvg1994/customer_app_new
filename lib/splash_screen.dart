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
import 'package:flutter/material.dart';
import 'package:gwc_customer/repository/enquiry_status_repository.dart';
import 'package:gwc_customer/repository/enquiry_status_repository.dart';
import 'package:gwc_customer/screens/evalution_form/evaluation_form_screen.dart';
import 'package:gwc_customer/screens/user_registration/existing_user.dart';
import 'package:gwc_customer/screens/user_registration/new_user/sit_back_screen.dart';
import 'package:gwc_customer/services/enquiry_status_service.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:gwc_customer/widgets/background_widget.dart';
import 'package:gwc_customer/widgets/dart_extensions.dart';
import 'package:gwc_customer/widgets/open_alert_box.dart';
import 'package:gwc_customer/widgets/will_pop_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/enquiry_status_model.dart';
import 'model/error_model.dart';
import 'repository/api_service.dart';
import 'package:http/http.dart' as http;

import 'screens/dashboard_screen.dart';

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
    deviceId = _pref.getString(AppConfig().deviceId);
    getEnquiryStatus(deviceId!);
    super.initState();
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
          errorMsg = model.message ?? 'Unauthenticated';
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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if(isError){
        showAlert();
        _timer!.cancel();
      }
    });
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
              (enquiryStatus!.isEven) ? SitBackScreen() : !isLogin ? ExistingUser() : (evalStatus!.contains("no_evaluation")) ? EvaluationFormScreen() : DashboardScreen()
            ],
          ),
        ],
      ),
    );
  }

  splashImage() {
    return const BackgroundWidget(
      assetName: 'assets/images/Group 2657.png',
      child: Center(
        child: Image(
          image: AssetImage("assets/images/Gut welness logo green.png"),
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
          getEnquiryStatus(deviceId!);
          Navigator.pop(context);
        }
    );
  }
}
