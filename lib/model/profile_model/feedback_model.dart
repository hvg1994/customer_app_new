class EnquiryStatusModel {
  String? status;
  String? errorCode;
  String? errorMsg;

  EnquiryStatusModel(
      {this.status, this.errorCode, this.errorMsg});

  EnquiryStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'].toString();
    errorMsg = json['errorMsg'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}