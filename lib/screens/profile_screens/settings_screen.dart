import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/profile_model/logout_model.dart';
import 'package:gwc_customer/screens/appointment_screens/consultation_screens/upload_files.dart';
import 'package:gwc_customer/screens/chat_support/message_screen.dart';
import 'package:gwc_customer/screens/evalution_form/personal_details_screen.dart';
import 'package:gwc_customer/screens/notification_screen.dart';
import 'package:gwc_customer/screens/profile_screens/call_support_method.dart';
import 'package:gwc_customer/screens/profile_screens/faq_screens/faq_screen.dart';
import 'package:gwc_customer/screens/profile_screens/faq_screens/faq_screen_old.dart';
import 'package:gwc_customer/screens/profile_screens/reward/reward_screen.dart';
import 'package:gwc_customer/screens/profile_screens/terms_conditions_screen.dart';
import 'package:gwc_customer/screens/profile_screens/user_details_tap.dart';
import 'package:gwc_customer/screens/user_registration/existing_user.dart';
import 'package:gwc_customer/services/quick_blox_service/quick_blox_service.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/open_alert_box.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../model/message_model/get_chat_groupid_model.dart';
import '../../repository/api_service.dart';
import '../../repository/chat_repository/message_repo.dart';
import '../../repository/login_otp_repository.dart';
import '../../repository/quick_blox_repository/quick_blox_repository.dart';
import '../../services/chat_service/chat_service.dart';
import '../../services/login_otp_service.dart';
import '../../splash_screen.dart';
import '../../utils/app_config.dart';
import '../../widgets/widgets.dart';
import '../evalution_form/evaluation_form_screen.dart';
import 'feedback_rating_screen.dart';
import 'my_profile_details.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SharedPreferences _pref = AppConfig().preferences!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(() => null, isBackEnable: false,
                    showNotificationIcon: true,
                    notificationOnTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationScreen()));
                    }
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Settings",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: eUser().mainHeadingFont,
                      color: eUser().mainHeadingColor,
                      fontSize: eUser().mainHeadingFontSize
                  ),
                ),
                profileTile("assets/images/Group 2753.png", "My Profile", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UserDetailsTap(),
                    ),
                  );
                }),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                profileTile("assets/images/Group 2747.png", "FAQ", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FaqScreen(),
                    ),
                  );
                }),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                profileTile(
                    "assets/images/Group 2748.png", "Terms & Conditions", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TermsConditionsScreen(),
                    ),
                  );
                }),
                // Container(
                //   height: 1,
                //   color: Colors.grey,
                // ),
                // profileTile(
                //     "assets/images/feedback.png", "Feedback", () {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => const FeedbackRatingScreen(),
                //     ),
                //   );
                // }),
                // Container(
                //   height: 1,
                //   color: Colors.grey,
                // ),
                // profileTile(
                //     "assets/images/Group 2748.png", "My Report", () {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => UploadFiles(isFromSettings: false,),
                //     ),
                //   );
                // }),
                // Container(
                //   height: 1,
                //   color: Colors.grey,
                // ),
                // profileTile(
                //     "assets/images/Group 2748.png", "My Evaluation Report", () {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => const PersonalDetailsScreen(showData: true,),
                //     ),
                //   );
                // }),
                // Visibility(
                //   // visible: kDebugMode,
                //   child: Container(
                //     height: 1,
                //     color: Colors.grey,
                //   ),
                // ),
                Visibility(
                  // visible: kDebugMode,
                    child:profileTile(
                        "assets/images/Group 2748.png", "Eval form", () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EvaluationFormScreen(),
                        ),
                      );
                    })
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                profileTile(
                    "assets/images/noun-chat-5153452.png", "My Rewards", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RewardScreen(),
                    ),
                  );
                }),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                profileTile(
                    "assets/images/noun-chat-5153452.png", "Chat Support", () {
                  getChatGroupId();
                }),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                profileTile("assets/images/Group 2744.png", "Logout", () {
                  openAlertBox(
                    context: context,
                    titleNeeded: false,
                    content: "Are you sure to Logout?",
                    positiveButton: (){
                      logOut();
                    },
                    positiveButtonName: "Logout",
                    negativeButton: (){
                      Navigator.pop(context);
                    },
                    negativeButtonName: "Cancel"
                  );


                  // _pref.setBool(AppConfig.isLogin, false);
                  // _pref.remove(AppConfig().BEARER_TOKEN);
                  // Navigator.of(context).pushReplacement(
                  //     MaterialPageRoute(
                  //       builder: (context) => const ExistingUser(),
                  //     ));
                }),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  profileTile(String image, String title, func) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
      child: InkWell(
        onTap: func,
        child: Row(
          children: [
            Image(
              image: AssetImage(image),
              height: 4.h,
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              title,
              style: TextStyle(
                color: kTextColor,
                fontFamily: 'GothamBook',
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final LoginOtpRepository repository = LoginOtpRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void logOut() async{
    final _qbService = Provider.of<QuickBloxService>(context, listen: false);
    print( await _qbService.getSession());
    _qbService.logout();

    final res = await LoginWithOtpService(repository: repository).logoutService();

    if(res.runtimeType == LogoutModel){
      _pref.setBool(AppConfig.isLogin, false);
      _pref.remove(AppConfig().BEARER_TOKEN);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ExistingUser(),
          ));
    }
    else{
      ErrorModel model = res as ErrorModel;
      AppConfig().showSnackbar(context, model.message!, isError:  true);
    }
  }

  final MessageRepository chatRepository = MessageRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  getChatGroupId() async{
    print(_pref.getInt(AppConfig.GET_QB_SESSION));
    print(_pref.getBool(AppConfig.IS_QB_LOGIN));

    print(_pref.getInt(AppConfig.GET_QB_SESSION) == null || _pref.getBool(AppConfig.IS_QB_LOGIN) == null || _pref.getBool(AppConfig.IS_QB_LOGIN) == false);
    final _qbService = Provider.of<QuickBloxService>(context, listen:  false);
    print(await _qbService.getSession());
    if(_pref.getInt(AppConfig.GET_QB_SESSION) == null || await _qbService.getSession() == true || _pref.getBool(AppConfig.IS_QB_LOGIN) == null || _pref.getBool(AppConfig.IS_QB_LOGIN) == false){
      _qbService.login(_pref.getString(AppConfig.QB_USERNAME)!);
    }
    else{
      if(await _qbService.isConnected() == false){
        _qbService.connect(_pref.getInt(AppConfig.QB_CURRENT_USERID)!);
      }
    }
    final res = await ChatService(repository: chatRepository).getChatGroupIdService();

    if(res.runtimeType == GetChatGroupIdModel){
      GetChatGroupIdModel model = res as GetChatGroupIdModel;
      // QuickBloxRepository().init(AppConfig.QB_APP_ID, AppConfig.QB_AUTH_KEY, AppConfig.QB_AUTH_SECRET, AppConfig.QB_ACCOUNT_KEY);
      _pref.setString(AppConfig.GROUP_ID, model.group ?? '');
      print('model.group: ${model.group}');
      Navigator.push(context, MaterialPageRoute(builder: (c)=> MessageScreen(isGroupId: true,)));
    }
    else{
      ErrorModel model = res as ErrorModel;
      AppConfig().showSnackbar(context, model.message.toString(), isError: true);
    }

  }

}
