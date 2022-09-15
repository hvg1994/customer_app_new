import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'medical_report_details.dart';

class MedicalReportScreen extends StatelessWidget {
  const MedicalReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 5.h),
          child: Column(
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              Expanded(
                child: buildDetails(),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MedicalReportDetails(),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: gPrimaryColor,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
                    child: Text(
                      'View',
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

  buildDetails() {
    return Column(
      children: [
        SizedBox(height: 2.h),
       const  Image(
          image:  AssetImage("assets/images/Group 3828.png"),
        ),
        SizedBox(height: 4.h),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            "Your Consultation is done Successfully, Now you can view your MEDICAL REPORT",
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.5,
                fontFamily: "GothamMedium",
                color: gTextColor,
                fontSize: 13.sp),
          ),
        ),
      ],
    );
  }
}
