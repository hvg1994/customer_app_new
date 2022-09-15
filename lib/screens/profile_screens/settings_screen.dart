import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gwc_customer/screens/profile_screens/faq_screen.dart';
import 'package:gwc_customer/screens/profile_screens/terms_conditions_screen.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:sizer/sizer.dart';

import '../../splash_screen.dart';
import '../../widgets/widgets.dart';
import 'my_profile_details.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding:
                EdgeInsets.only(left: 4.w, right: 4.w, top: 3.h, bottom: 5.h),
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
                      fontFamily: "GothamBold",
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
                profileTile("assets/images/Group 2744.png", "Logout", () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ),
                  );
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
              height: 5.h,
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              title,
              style: TextStyle(
                color: kTextColor,
                fontFamily: 'GothamBook',
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
