import 'package:flutter/material.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:sizer/sizer.dart';

import '../../../repository/api_service.dart';
import '../../../repository/dashboard_repo/gut_repository/dashboard_repository.dart';
import '../../../services/dashboard_service/gut_service/dashboard_data_service.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'medical_report_details.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

class MedicalReportScreen extends StatelessWidget {
  final String isMrRead;
  final String pdfLink;
  MedicalReportScreen({Key? key, required this.pdfLink, this.isMrRead = "1"}) : super(key: key);
  late GutDataService _gutDataService;

  submitIsMrRead() async{
    _gutDataService = GutDataService(repository: repository);
    await _gutDataService.submitIsMrReadService();
  }
  @override
  Widget build(BuildContext context) {
    if(isMrRead == "0"){
      submitIsMrRead();
    }

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
                  "MEDICAL REPORT",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.5,
                      fontFamily: kFontMedium,
                      color: gTextColor,
                      fontSize: 12.sp
                  ),
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

  final GutDataRepository repository = GutDataRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

}
