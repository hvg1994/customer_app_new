import 'package:flutter/material.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/widgets.dart';

class SitBackScreen extends StatefulWidget {
  const SitBackScreen({Key? key}) : super(key: key);

  @override
  State<SitBackScreen> createState() => _SitBackScreenState();
}

class _SitBackScreenState extends State<SitBackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(left: 4.w, top: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAppBar(() {
              Navigator.pop(context);
            }),
            SizedBox(height: 2.h),
            const Image(
              image: AssetImage("assets/images/Mask Group 2172.png"),
            ),
            SizedBox(height: 5.h),
            Text(
              "Sit Back And Relax",
              style: TextStyle(
                  fontFamily: "GothamRoundedBold_21016",
                  color: gTextColor,
                  fontSize: 12.sp),
            ),
            SizedBox(height: 1.h),
            Text(
              "Our Success Team Will Contact \nYou Soon ..!!",
              style: TextStyle(
                height: 1.5,
                  fontFamily: "GothamMedium",
                  color: gTextColor,
                  fontSize: 10.sp),
            ),
          ],
        ),
      ),
    );
  }
}
