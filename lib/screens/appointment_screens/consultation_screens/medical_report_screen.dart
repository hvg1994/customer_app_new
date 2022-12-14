import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'medical_report_details.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class MedicalReportScreen extends StatelessWidget {
  final String pdfLink;
  const MedicalReportScreen({Key? key, required this.pdfLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(pdfLink);
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
              SizedBox(height: 2.h),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  "Your Consultation is done Successfully,\nNow you can view your MEDICAL REPORT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.5,
                      fontFamily: "GothamMedium",
                      color: gTextColor,
                      fontSize: 12.sp),
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: SfPdfViewer.network(
                    this.pdfLink
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
