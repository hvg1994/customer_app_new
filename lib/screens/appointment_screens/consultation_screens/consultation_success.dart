import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class ConsultationSuccess extends StatelessWidget {
  final bool isPostProgramSuccess;
  const ConsultationSuccess({Key? key, this.isPostProgramSuccess = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage("assets/images/consultation_completed.png"),
                    height: 40.h,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    !isPostProgramSuccess
                        ? "You Have Successfully Completed Your Consultation"
                        : "Post Program Consultation Done.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.5,
                        fontFamily: kFontBold,
                        color: gPrimaryColor,
                        fontSize: 12.sp
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    !isPostProgramSuccess
                        ? "Your Medical Report is getting ready and will be uploaded within 24 hours"
                        : "Gut Maintenance Guide and Meal Plans will be Uploaded soon.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1.5,
                        fontFamily: kFontMedium,
                        color: gPrimaryColor,
                        fontSize: 10.sp
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
