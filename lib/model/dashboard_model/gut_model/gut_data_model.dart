class GutDataModel {
  int? status;
  int? errorCode;
  String? key;
  String? data;
  String? value;

  GutDataModel({this.status, this.errorCode, this.key, this.data, this.value});

  GutDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    data = json['data'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    data['data'] = this.data;
    data['value'] = this.value;
    return data;
  }
}