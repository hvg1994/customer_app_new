import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'personal_details_screen.dart';

class EvaluationFormScreen extends StatefulWidget {
  final bool isFromSplashScreen;
  const EvaluationFormScreen({Key? key, this.isFromSplashScreen = false}) : super(key: key);

  @override
  State<EvaluationFormScreen> createState() => _EvaluationFormScreenState();
}

class _EvaluationFormScreenState extends State<EvaluationFormScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
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
                  buildAppBar((widget.isFromSplashScreen) ? (){} : () {
                    Navigator.pop(context);
                  },
                  isBackEnable: false),
                  const Center(
                    child: Image(
                      image: AssetImage("assets/images/Evalutation.png"),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Gut Wellness Club Evaluation Form",
                    style: TextStyle(
                        fontFamily: "PoppinsBold",
                        color: kTextColor,
                        fontSize: 12.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Hello There,",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "PoppinsBold",
                        color: gMainColor,
                        fontSize: 11.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Welcome To The 1st Step Of Your Gut Wellness Journey.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "PoppinsRegular",
                        color: kTextColor,
                        fontSize: 10.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "This Form Will Be Evaluated By Your Senior Doctors To",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "PoppinsRegular",
                        color: kTextColor,
                        fontSize: 10.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    newText1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "PoppinsRegular",
                        color: kTextColor,
                        fontSize: 10.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    newText2,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "PoppinsRegular",
                        color: kTextColor,
                        fontSize: 10.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    newText3,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "PoppinsRegular",
                        color: kTextColor,
                        fontSize: 10.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "This Form Will Be Confidential & Only Visible To Your Doctors & Few Executives Responsible For Supporting Your Doctors.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "PoppinsRegular",
                        color: kTextColor,
                        fontSize: 10.sp),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Center(
                    child: GestureDetector(
                      // onTap: (showLoginProgress) ? null : () {
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PersonalDetailsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 50.w,
                        height: 5.h,
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: eUser().buttonColor,
                          borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                          border: Border.all(
                              color: eUser().buttonBorderColor,
                              width: eUser().buttonBorderWidth
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'NEXT',
                            style: TextStyle(
                              fontFamily: eUser().buttonTextFont,
                              color: eUser().buttonTextColor,
                              fontSize: eUser().buttonTextSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Center(
                  //   child: CommonButton.submitButton(() {
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (context) => const PersonalDetailsScreen(),
                  //       ),
                  //     );
                  //   }, "NEXT"),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<bool> _onWillPop() async {
    // ignore: avoid_print
    print('back pressed eval');
    return (widget.isFromSplashScreen) ? await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0.sp))),
          contentPadding: EdgeInsets.only(top: 1.h),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            decoration: BoxDecoration(
                color: gWhiteColor, borderRadius: BorderRadius.circular(8)),
            width: 50.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Are you sure?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "GothamRoundedBold_21016",
                      color: gPrimaryColor,
                      fontSize: 13.sp),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  height: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                Text(
                  'Do you want to exit an App?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "GothamMedium",
                      color: gsecondaryColor,
                      fontSize: 11.sp),
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                            color: gMainColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "NO",
                          style: TextStyle(
                            fontFamily: "GothamRoundedBold_21016",
                            color: gPrimaryColor,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    GestureDetector(
                      onTap: () => SystemNavigator.pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                            color: gPrimaryColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "YES",
                          style: TextStyle(
                            fontFamily: "GothamRoundedBold_21016",
                            color: gMainColor,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 1.h)
              ],
            ),
          ),
        )) ??
        false : true;
  }


  final String oldText1 = "1) Determine If This Program Can Heal You & Therefore Determine If We Can Proceed With Your Case Or Not.";
  final String oldText2 = "2) If Accepted What Sort Of Customization is Required To Heal Your Condition(s) Please Fill This To The Best Of Your Knowledge As This is Critical. Time To Fill 10-15Mins";
  final String oldText3 = "Your Doctors Might Personally Get In Touch With You If More Information Is Needed.";

  final String newText1 = "Preliminarily Evaluate Your Condition & Determine What Sort Of Customization Is Required";
  final String newText2 = "To Heal Your Condition(s) & To Ship Your Customized Ready To Cook Kit.";
  final String newText3 = "Please Fill This To The Best Of Your KnowledgeAs This Is Critical. Time To Fill 3-4Mins";
}
