// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'doctor_calender_time_screen.dart';
import 'doctor_consultation_completed.dart';

class DoctorSlotsDetailsScreen extends StatelessWidget {
  final String bookingDate;
  final String bookingTime;
  const DoctorSlotsDetailsScreen({
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
                  buildAppBar(() {
                    Navigator.pop(context);
                  }),
                  const Center(
                    child: Image(
                      image: AssetImage("assets/images/Group 4865.png"),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Center(
                    child: Text(
                      "Your Consultation will be with",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "GothamMedium",
                          color: gTextColor,
                          fontSize: 12.sp),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Center(
                    child: Text(
                      "Dr.Anita H,Dr.Anita J",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Gotham-Black",
                          color: gTextColor,
                          fontSize: 12.sp),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage(
                              "assets/images/noun-chat-5153452.png"),
                          height: 2.h,
                        ),
                        SizedBox(width: 2.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DoctorCalenderTimeScreen()),
                            );
                          },
                          child: Text(
                            'Chat Support',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontFamily: "GothamMedium",
                              color: gTextColor,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
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
                            color: gsecondaryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 13.w),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Your Slot has been Booked @ ',
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 12.sp,
                                            fontFamily: "GothamBook",
                                            color: gWhiteColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: bookingTime.toString(),
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 13.sp,
                                            fontFamily: "GothamMedium",
                                            color: gWhiteColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " on the ",
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 12.sp,
                                            fontFamily: "GothamBook",
                                            color: gWhiteColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: bookingDate.toString(),
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 13.sp,
                                            fontFamily: "GothamMedium",
                                            color: gWhiteColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ", Has Been Confirmed",
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 12.sp,
                                            fontFamily: "GothamBook",
                                            color: gWhiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DoctorConsultationCompleted(
                                          bookingDate: bookingDate,
                                          bookingTime: bookingTime,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.h, horizontal: 25.w),
                                    decoration: BoxDecoration(
                                      color: gWhiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: gMainColor, width: 1),
                                    ),
                                    child: Text(
                                      'Join',
                                      style: TextStyle(
                                        fontFamily: "GothamMedium",
                                        color: gMainColor,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const DoctorCalenderTimeScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Reschedule',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontFamily: "GothamMedium",
                                      color: gWhiteColor,
                                      fontSize: 12.sp,
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
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: gWhiteColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(8, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image(
                                  image: const AssetImage(
                                      "assets/images/Group 3776.png"),
                                  height: 8.h,
                                ),
                                SizedBox(width: 5.w),
                                Expanded(
                                  child: Text(
                                    "My Evaluation",
                                    style: TextStyle(
                                        fontFamily: "GothamMedium",
                                        color: gTextColor,
                                        fontSize: 12.sp),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: gMainColor,
                                    size: 2.h,
                                  ),
                                )
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
