class ChildReportListModel {
  String? id;
  String? doctorId;
  String? patientId;
  String? appointmentId;
  String? report;
  String? reportType;
  String? createdAt;
  String? updatedAt;

  ChildReportListModel(
      {this.id,
        this.doctorId,
        this.patientId,
        this.appointmentId,
        this.report,
        this.reportType,
        this.createdAt,
        this.updatedAt});

  ChildReportListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    doctorId = json['doctor_id'].toString();
    patientId = json['patient_id'];
    appointmentId = json['appointment_id'].toString();
    report = json['report'];
    reportType = json['report_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor_id'] = this.doctorId;
    data['patient_id'] = this.patientId;
    data['appointment_id'] = this.appointmentId;
    data['report'] = this.report;
    data['report_type'] = this.reportType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}