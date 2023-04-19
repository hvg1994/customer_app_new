class GutDataModel {
  String? data;
  String? value;
  RejectedCaseClass? rejectedCase;
  String? isProgramFeedbackSubmitted;

  GutDataModel({this.data, this.value, this.rejectedCase, this.isProgramFeedbackSubmitted});

  GutDataModel.fromJson(Map<String, dynamic> json) {
    print("json['value'].runtimeType: ${json['value'].runtimeType}");
    data = json['data'];
    value = (json['value'].runtimeType == String) ? json['value'] ??'' : '';
    isProgramFeedbackSubmitted = json['is_program_feedback_submitted'].toString() ?? '';
    rejectedCase = (json['value'].runtimeType != String) ? RejectedCaseClass.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['value'] = this.value;
    data['is_program_feedback_submitted'] = this.value;
    return data;
  }
}

class RejectedCaseClass{
  String? reason;
  String? mr;
  RejectedCaseClass({this.reason, this.mr});

  RejectedCaseClass.fromJson(Map<String, dynamic> json) {
    reason = json['rejected_reason'];
    mr = json['mr_report'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rejected_reason'] = this.reason;
    data['mr_report'] = this.mr;
    return data;
  }
}