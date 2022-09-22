import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'personal_details_screen.dart';

class EvaluationFormScreen extends StatefulWidget {
  const EvaluationFormScreen({Key? key}) : super(key: key);

  @override
  State<EvaluationFormScreen> createState() => _EvaluationFormScreenState();
}

class _EvaluationFormScreenState extends State<EvaluationFormScreen> {
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
                  child: CommonButton.submitButton(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PersonalDetailsScreen(),
                      ),
                    );
                  }, "Next"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final String oldText1 = "1) Determine If This Program Can Heal You & Therefore Determine If We Can Proceed With Your Case Or Not.";
  final String oldText2 = "2) If Accepted What Sort Of Customization is Required To Heal Your Condition(s) Please Fill This To The Best Of Your Knowledge As This is Critical. Time To Fill 10-15Mins";
  final String oldText3 = "Your Doctors Might Personally Get In Touch With You If More Information Is Needed.";

  final String newText1 = "Preliminarily Evaluate Your Condition & Determine What Sort Of Customization Is Required";
  final String newText2 = "To Heal Your Condition(s) & To Ship Your Customized Ready To Cook Kit.";
  final String newText3 = "Please Fill This To The Best Of Your KnowledgeAs This Is Critical. Time To Fill 3-4Mins";
}
