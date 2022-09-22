import 'child_appintment_details.dart';

class GetAppointmentDetailsModel {
  int? status;
  int? errorCode;
  String? key;
  String? data;
  ChildAppointmentDetails? value;

  GetAppointmentDetailsModel(
      {this.status, this.errorCode, this.key, this.data, this.value});

  GetAppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    data = json['data'];
    value = json['value'] != null ? new ChildAppointmentDetails.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    data['data'] = this.data;
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    return data;
  }
}



