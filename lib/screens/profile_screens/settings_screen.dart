import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gwc_customer/screens/evalution_form/personal_details_screen.dart';
import 'package:gwc_customer/screens/profile_screens/faq_screen.dart';
import 'package:gwc_customer/screens/profile_screens/terms_conditions_screen.dart';
import 'package:gwc_customer/screens/user_registration/existing_user.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../splash_screen.dart';
import '../../utils/app_config.dart';
import '../../widgets/widgets.dart';
import '../evalution_form/evaluation_form_screen.dart';
import 'my_profile_details.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SharedPreferences _pref = AppConfig().preferences!;
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
                    "assets/images/Group 2748.png", "My Report", () {
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
                profileTile("assets/images/Group 2744.png", "Logout", () {
                  _pref.setBool(AppConfig.isLogin, false);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ExistingUser(),
                    ));
                      // (route) => route.
                  // );
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
}
