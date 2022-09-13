import 'package:flutter/material.dart';
import 'package:gwc_customer/user_registration/new_user/video_player.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';


class AboutTheProgram extends StatefulWidget {
  const AboutTheProgram({Key? key}) : super(key: key);

  @override
  State<AboutTheProgram> createState() => _AboutTheProgramState();
}

class _AboutTheProgramState extends State<AboutTheProgram> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 1.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About The Problem",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "GothamRoundedBold_21016",
                            color: gPrimaryColor,
                            fontSize: 11.sp),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 3.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: gPrimaryColor, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(2, 10),
                            ),
                          ],
                        ),
                        child: Text(
                          'Lorem lpsum is simply dummy text of the printing and typesetting industry. Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.',
                          style: TextStyle(
                            height: 1.7,
                            fontFamily: "GothamBook",
                            color: gTextColor,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Testimonial",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "GothamRoundedBold_21016",
                            color: gPrimaryColor,
                            fontSize: 11.sp),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      buildTestimonial(),
                      SizedBox(height: 2.h),
                      Text(
                        "Feedback",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "GothamRoundedBold_21016",
                            color: gPrimaryColor,
                            fontSize: 11.sp),
                      ),
                      SizedBox(height: 2.h),
                      buildFeedback(),
                    ],
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AboutTheProgram(),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 15.w),
                    decoration: BoxDecoration(
                      color: gPrimaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: "GothamRoundedBold_21016",
                        color: gWhiteColor,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildTestimonial() {
    return GestureDetector(
      onTap: (){ Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const VideoPlayer(),
        ),
      );},
      child: Container(
        height: 24.h,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: gPrimaryColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(2, 10),
            ),
          ],
          image: const DecorationImage(
              image: AssetImage("assets/images/Group 4865.png"),
              fit: BoxFit.fill),
        ),
        child: Center(
          child: Image(
            height: 7.h,
            image: const AssetImage("assets/images/noun-play-icon-3120990.png"),
          ),
        ),
      ),
    );
  }

  buildFeedback() {
    return  Container(
      padding: EdgeInsets.symmetric(
          vertical: 1.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: gPrimaryColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(2, 10),
          ),
        ],
      ),
      child: Text(
        'Lorem lpsum is simply dummy text of the printing and typesetting industry. Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.',
        style: TextStyle(
          height: 1.7,
          fontFamily: "GothamBook",
          color: gTextColor,
          fontSize: 9.sp,
        ),
      ),
    );
  }
}
