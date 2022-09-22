import 'child_report_list_model.dart';

class GetReportListModel {
  String? status;
  int? errorCode;
  String? key;
  List<ChildReportListModel>? data;

  GetReportListModel({this.status, this.errorCode, this.key, this.data});

  GetReportListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'];
    key = json['key'];
    if (json['data'] != null) {
      data = <ChildReportListModel>[];
      json['data'].forEach((v) {
        data!.add(new ChildReportListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

