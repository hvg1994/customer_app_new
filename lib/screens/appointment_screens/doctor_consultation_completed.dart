
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import '../upload_reports_screen.dart';


class DoctorConsultationCompleted extends StatelessWidget {
  final String bookingDate;
  final String bookingTime;
  const DoctorConsultationCompleted({
    Key? key,
    required this.bookingDate,
    required this.bookingTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 2.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildAppBar(() {
                        Navigator.pop(context);
                      }),
                      Text(
                        "Ayurveda Consultation",
                        style: TextStyle(
                            fontFamily: "GothamRoundedBold_21016",
                            color: gPrimaryColor,
                            fontSize: 12.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  SizedBox(
                    height: 15.h,
                    child: const Center(
                      child: Image(
                        image: AssetImage("assets/images/Group 2523.png"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Center(
                    child: Text(
                      "Dr.Swarnalatha",
                      style: TextStyle(
                          fontFamily: "GothamRoundedBold_21016",
                          color: gPrimaryColor,
                          fontSize: 15.sp),
                    ),
                  ),
                  SizedBox(
                    height: 0.5.h,
                  ),
                  Center(
                    child: Text(
                      "Ayurveda Specialist",
                      style: TextStyle(
                          fontFamily: "GothamBook",
                          color: gsecondaryColor,
                          fontSize: 10.sp),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          top: 5.h,
                          child: Container(
                            color: kPrimaryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Your Consultation as Completed on",
                                  style: TextStyle(
                                      fontFamily: "GothamMedium",
                                      color: gWhiteColor,
                                      fontSize: 10.sp),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      bookingDate,
                                      style: TextStyle(
                                          fontFamily: "GothamRoundedBold_21016",
                                          color: gWhiteColor,
                                          fontSize: 11.sp),
                                    ),
                                    Text(
                                      " @ ",
                                      style: TextStyle(
                                          fontFamily: "GothamMedium",
                                          color: gWhiteColor,
                                          fontSize: 10.sp),
                                    ),
                                    Text(
                                      bookingTime,
                                      style: TextStyle(
                                          fontFamily: "GothamRoundedBold_21016",
                                          color: gWhiteColor,
                                          fontSize: 11.sp),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UploadReportsScreen()),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.h, horizontal: 15.w),
                                    decoration: BoxDecoration(
                                      color: gWhiteColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: gMainColor, width: 1),
                                    ),
                                    child: Text(
                                      'Report Uploaded',
                                      style: TextStyle(
                                        fontFamily: "GothamRoundedBold_21016",
                                        color: gPrimaryColor,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10.w,
                          right: 10.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: kSecondaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    "assets/images/splash_screen/Calendar.svg"),
                                SizedBox(width: 5.w),
                                Text(
                                  "Consultation Completed",
                                  style: TextStyle(
                                      fontFamily: "GothamMedium",
                                      color: gTextColor,
                                      fontSize: 10.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
