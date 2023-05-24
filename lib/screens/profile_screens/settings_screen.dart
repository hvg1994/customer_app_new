import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/profile_model/logout_model.dart';
import 'package:gwc_customer/screens/appointment_screens/consultation_screens/upload_files.dart';
import 'package:gwc_customer/screens/chat_support/message_screen.dart';
import 'package:gwc_customer/screens/evalution_form/personal_details_screen.dart';
import 'package:gwc_customer/screens/help_screens/help_screen.dart';
import 'package:gwc_customer/screens/notification_screen.dart';
import 'package:gwc_customer/screens/prepratory%20plan/prepratory_plan_screen.dart';
import 'package:gwc_customer/screens/profile_screens/call_support_method.dart';
import 'package:gwc_customer/screens/profile_screens/faq_screens/faq_screen.dart';
import 'package:gwc_customer/screens/profile_screens/reward/reward_screen.dart';
import 'package:gwc_customer/screens/profile_screens/terms_conditions_screen.dart';
import 'package:gwc_customer/screens/profile_screens/user_details_tap.dart';
import 'package:gwc_customer/screens/user_registration/existing_user.dart';
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
import '../../services/chat_service/chat_service.dart';
import '../../services/login_otp_service.dart';
import '../../splash_screen.dart';
import '../../utils/app_config.dart';
import '../../widgets/widgets.dart';
import '../evalution_form/evaluation_form_screen.dart';
import '../gut_list_screens/new_stages_data.dart';
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
        backgroundColor: gBackgroundColor,
        body: Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildAppBar(() => null,
                  isBackEnable: false,
                  showNotificationIcon: true,
                  notificationOnTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationScreen()));
                  },
                  showHelpIcon: true,
                  helpOnTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HelpScreen()));
                  }),
              SizedBox(
                height: 4.h,
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: gWhiteColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2.5,
                    color: gsecondaryColor,
                  ),
                ),
                child: CircleAvatar(
                  radius: 7.h,
                  backgroundImage: NetworkImage(
                      "${_pref.getString(AppConfig.User_Profile)}"),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "${_pref.getString(AppConfig.User_Name)}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: eUser().mainHeadingFont,
                    color: eUser().mainHeadingColor,
                    fontSize: eUser().mainHeadingFontSize),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "${_pref.getString(AppConfig.User_Number)}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: eUser().userTextFieldHintFont,
                    color: gHintTextColor,
                    fontSize: eUser().userTextFieldFontSize),
              ),
              // Container(
              //   height: 10.h,
              //   width: double.maxFinite,
              //   child: Image(
              //     image: AssetImage("assets/images/profile_curve.png"),
              //     fit: BoxFit.fill,
              //   ),
              // ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 5.h),
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: const BoxDecoration(
                    color: gWhiteColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: kLineColor,
                        offset: Offset(2, 3),
                        blurRadius: 5,
                      )
                    ],
                    // border: Border.all(
                    //   width: 1,
                    //   color: kLineColor,
                    // ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              profileTile(
                                  "assets/images/Group 2753.png", "My Profile",
                                      () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const MyProfileDetails(),
                                      ),
                                    );
                                  }),

                              profileTile("assets/images/Group 2747.png", "FAQ",
                                      () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const FaqScreen(),
                                      ),
                                    );
                                  }),

                              profileTile("assets/images/Group 2748.png",
                                  "Terms & Conditions", () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const TermsConditionsScreen(),
                                      ),
                                    );
                                  }),
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
                              // Visibility(
                              //     visible: kDebugMode,
                              //     child: profileTile(
                              //         "assets/images/Group 2748.png", "Eval form",
                              //         () {
                              //       Navigator.of(context).push(
                              //         MaterialPageRoute(
                              //           builder: (context) =>
                              //               const EvaluationFormScreen(),
                              //         ),
                              //       );
                              //     })),

                              profileTile(
                                  "assets/images/coins.png", "My Rewards", () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const RewardScreen(),
                                  ),
                                );
                              }),
                              Visibility(
                                  visible: kDebugMode,
                                  child: profileTile(
                                      "assets/images/Group 2748.png", "Eval form",
                                          () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            const EvaluationFormScreen(),
                                          ),
                                        );
                                      })),

                              profileTile("assets/images/noun-chat-5153452.png",
                                  "Chat Support", () async {
                                    final uId =
                                    _pref!.getString(AppConfig.KALEYRA_USER_ID);
                                    final res = await getAccessToken(uId!);

                                    if (res.runtimeType != ErrorModel) {
                                      final accessToken = _pref.getString(
                                          AppConfig.KALEYRA_ACCESS_TOKEN);

                                      final chatSuccessId = _pref.getString(
                                          AppConfig.KALEYRA_CHAT_SUCCESS_ID);
                                      // chat
                                      openKaleyraChat(
                                          uId, chatSuccessId!, accessToken!);
                                    }
                                    else {
                                      final result = res as ErrorModel;
                                      print(
                                          "get Access Token error: ${result.message}");
                                      AppConfig().showSnackbar(
                                          context, result.message ?? '',
                                          isError: true, bottomPadding: 70);
                                    }
                                    // getChatGroupId();
                                  }),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => AppConfig().showSheet(
                            context, logoutWidget(),
                            bottomSheetHeight: 45.h),
                        child: Container(
                          margin:  EdgeInsets.symmetric(horizontal: 30.w),
                          padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 3.w),
                          decoration: BoxDecoration(
                            color: gWhiteColor,
                            borderRadius:  BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: kLineColor,
                                offset: Offset(2, 3),
                                blurRadius: 5,
                              )
                            ],
                            // border: Border.all(
                            //   width: 1,
                            //   color: kLineColor,
                            // ),
                          ),
                          child: Row(
                            children: [
                              Image(
                                image: const AssetImage(
                                  "assets/images/Group 2744.png",
                                ),
                                height: 4.h,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                "Logout",
                                style: TextStyle(
                                  color: kTextColor,
                                  fontFamily: kFontBook,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  profileTile(String image, String title, func) {
    return InkWell(
      onTap: func,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            padding: const EdgeInsets.all(5),
            // decoration: BoxDecoration(
            //   // color: gBlackColor.withOpacity(0.05),
            //   borderRadius: BorderRadius.circular(5),
            // ),
            child: Image(
              image: AssetImage(image),
              height: 4.h,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: kTextColor,
                fontFamily: kFontBook,
                fontSize: 11.sp,
              ),
            ),
          ),
          GestureDetector(
            onTap: func,
            child: Icon(
              Icons.arrow_forward_ios,
              color: gBlackColor,
              size: 1.8.h,
            ),
          ),
        ],
      ),
    );
  }

  final LoginOtpRepository repository = LoginOtpRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void logOut() async {
    logoutProgressState(() {
      showLogoutProgress = true;
    });
    final res = await LoginWithOtpService(repository: repository).logoutService();

    if (res.runtimeType == LogoutModel) {
      clearAllUserDetails();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ExistingUser(),
      ));
    }
    else {
      ErrorModel model = res as ErrorModel;
      Get.snackbar("", model.message!,
        colorText: gWhiteColor,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: gsecondaryColor.withOpacity(0.55),
      );
    }

    logoutProgressState(() {
      showLogoutProgress = true;
    });
  }

  clearAllUserDetails(){
    _pref.setBool(AppConfig.isLogin, false);
    _pref.remove(AppConfig().BEARER_TOKEN);

    _pref.remove(
        AppConfig.User_Name);
    _pref.remove(AppConfig.USER_ID);
    _pref.remove(AppConfig.QB_USERNAME);
    _pref.remove(AppConfig.QB_CURRENT_USERID);
    _pref.remove(AppConfig.KALEYRA_USER_ID);
    _pref.remove(AppConfig.User_Name);
    _pref.remove(AppConfig.User_Profile);
    _pref.remove(AppConfig.User_Number);

    updateStageData();
  }


  final MessageRepository chatRepository = MessageRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  bool showLogoutProgress = false;

  var logoutProgressState;

  logoutWidget() {
    return StatefulBuilder(
        builder: (_, setstate){
          logoutProgressState = setstate;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "We will miss you.",
                  style: TextStyle(
                      fontSize: bottomSheetHeadingFontSize,
                      fontFamily: bottomSheetHeadingFontFamily,
                      height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  color: kLineColor,
                  thickness: 1.2,
                ),
              ),
              Center(
                child: Text(
                  'Do you really want to logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: gTextColor,
                    fontSize: bottomSheetSubHeadingXFontSize,
                    fontFamily: bottomSheetSubHeadingMediumFont,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              (showLogoutProgress)
                  ? Center(child: buildCircularIndicator())
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => logOut(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                          color: gsecondaryColor,
                          border: Border.all(color: kLineColor, width: 0.5),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "YES",
                        style: TextStyle(
                          fontFamily: kFontMedium,
                          color: gWhiteColor,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                          color: gWhiteColor,
                          border: Border.all(color: kLineColor, width: 0.5),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "NO",
                        style: TextStyle(
                          fontFamily: kFontMedium,
                          color: gsecondaryColor,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h)
            ],
          );
        }
    );
  }
}
