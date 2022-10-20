
import 'child_doctor_model.dart';
import 'child_team.dart';

class AppointmentBookingModel {
  String? status;
  int? errorCode;
  String? key;
  String? data;
  String? appointmentId;
  Team? team;
  String? patientName;
  ChildDoctorModel? doctor;
  String? zoomJoinUrl;
  String? zoomId;
  String? zoomPassword;

  AppointmentBookingModel(
      {this.status,
        this.errorCode,
        this.key,
        this.data,
        this.appointmentId,
        this.team,
        this.doctor,
        this.zoomJoinUrl,
        this.zoomId,
        this.zoomPassword,
        this.patientName
      });

  AppointmentBookingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'];
    key = json['key'];
    data = json['data'];
    appointmentId = json['appointment_id'].toString();
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;
    doctor = json['doctor'] != null ? new ChildDoctorModel.fromJson(json['doctor']) : null;
    zoomJoinUrl = json['zoom_join_url'];
    zoomId = json['zoom_id'].toString();
    zoomPassword = json['zoom_password'];
    patientName = json['patient_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    data['data'] = this.data;
    data['patient_name'] = this.patientName;
    data['appointment_id'] = this.appointmentId;
    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    if (this.doctor != null) {
      data['doctor'] = this.doctor!.toJson();
    }
    data['zoom_join_url'] = this.zoomJoinUrl;
    data['zoom_id'] = this.zoomId;
    data['zoom_password'] = this.zoomPassword;
    return data;
  }
}


