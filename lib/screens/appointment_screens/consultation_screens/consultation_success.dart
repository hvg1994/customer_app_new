import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class ConsultationSuccess extends StatelessWidget {
  const ConsultationSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff56AB2F), Color(0xffA8E063)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 4.w,
            right: 4.w,
            top: 4.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w,vertical: 20.h),
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(2, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image(
                      image: const AssetImage(
                          "assets/images/noun-party-4210684.png"),
                      height: 15.h,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "You Have Successfully Completed Your Consultation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.5,
                          fontFamily: "GothamMedium",
                          color: gPrimaryColor,
                          fontSize: 10.sp),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Your Medical Report is getting ready and uploaded within 24 hours",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.5,
                          fontFamily: "GothamMedium",
                          color: gPrimaryColor,
                          fontSize: 8.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
