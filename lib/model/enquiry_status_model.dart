class EnquiryStatusModel {
  String? status;
  int? errorCode;
  String? errorMsg;
  int? enquiryStatus;

  EnquiryStatusModel(
      {this.status, this.errorCode, this.errorMsg, this.enquiryStatus});

  EnquiryStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    enquiryStatus = json['enquiry_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    data['enquiry_status'] = this.enquiryStatus;
    return data;
  }
}