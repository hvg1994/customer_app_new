import 'package:flutter/cupertino.dart';

import '../../repository/consultation_repository/get_report_repository.dart';

class ReportService extends ChangeNotifier{
  final ReportRepository repository;

  ReportService({required this.repository}) : assert(repository != null);

  Future uploadReportListService(List reportList) async{
    return await repository.uploadReportListRepo(reportList);
  }

  Future getUploadedReportListListService() async{
    return await repository.getUploadedReportListListRepo();
  }
}