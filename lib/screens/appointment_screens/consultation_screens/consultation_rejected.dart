import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class ConsultationRejected extends StatelessWidget {
  const ConsultationRejected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xffC10B02), Color(0xffFFA29E)],
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
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
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
                          "assets/images/noun-sad-emoji-2600928.png"),
                      height: 13.h,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Your consultation has been rejected our success Team will get back to you soon",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.5,
                          fontFamily: "GothamMedium",
                          color: gsecondaryColor,
                          fontSize: 10.sp),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Your Medical Report is getting ready and uploaded within 24 hours",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.5,
                          fontFamily: "GothamMedium",
                          color: gsecondaryColor,
                          fontSize: 8.sp),
                    ),
                    SizedBox(height: 2.h),
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
