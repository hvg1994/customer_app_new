import 'package:flutter/material.dart';
import 'package:gwc_customer/screens/user_registration/existing_user.dart';
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAppBar(() {},
                  isBackEnable: false
                  ),
                  SizedBox(height: 2.h),
                  const Image(
                    image: AssetImage("assets/images/Mask Group 2172.png"),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Sit Back And Relax..!!",
                    style: TextStyle(
                        fontFamily: "GothamRoundedBook_21018",
                        color: gTextColor,
                        fontSize: 14.sp),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "Our Success Team Will Contact \nYou Soon ..!!",
                    style: TextStyle(
                        height: 1.5,
                        fontFamily: "GothamRoundedBold_21016",
                        color: gTextColor,
                        fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            // Center(child: Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextButton(
            //     child: Text("Submit New Query",
            //       style: TextStyle(
            //         fontFamily: "GothamBook",
            //         color: gTextColor,
            //         fontSize: 11.5.sp,
            //       ),
            //     ),
            //     onPressed: (){
            //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => ExistingUser()), (route) => route.isFirst);
            //     },
            //   ),
            // ))
          ],
        ),
      ),
    );
  }
}
