import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/profile_model/logout_model.dart';
import 'package:gwc_customer/screens/appointment_screens/consultation_screens/upload_files.dart';
import 'package:gwc_customer/screens/chat_support/message_screen.dart';
import 'package:gwc_customer/screens/evalution_form/personal_details_screen.dart';
import 'package:gwc_customer/screens/profile_screens/call_support_method.dart';
import 'package:gwc_customer/screens/profile_screens/faq_screen.dart';
import 'package:gwc_customer/screens/profile_screens/terms_conditions_screen.dart';
import 'package:gwc_customer/screens/user_registration/existing_user.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../repository/api_service.dart';
import '../../repository/login_otp_repository.dart';
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
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(() {
                  Navigator.pop(context);
                }),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Settings",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'GothamRoundedBold_21016',
                      color: gPrimaryColor,
                      fontSize: 12.sp),
                ),
                profileTile("assets/images/Group 2753.png", "My Profile", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyProfileDetails(),
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
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                profileTile(
                    "assets/images/feedback.png", "Feedback", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FeedbackRatingScreen(),
                    ),
                  );
                }),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                profileTile(
                    "assets/images/Group 2748.png", "My Report", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UploadFiles(),
                    ),
                  );
                }),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                profileTile(
                    "assets/images/Group 2748.png", "My Evaluation Report", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PersonalDetailsScreen(showData: true,),
                    ),
                  );
                }),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                profileTile(
                    "assets/images/Group 2748.png", "Eval form", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EvaluationFormScreen(),
                    ),
                  );
                }),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                profileTile(
                    "assets/images/call.png", "Customer Support", () {
                  callSupport();
                }),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                profileTile(
                    "assets/images/noun-chat-5153452.png", "Chat Support", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MessageScreen(),
                    ),
                  );
                }),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                profileTile("assets/images/Group 2744.png", "Logout", () {
                  logOut();

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

}
