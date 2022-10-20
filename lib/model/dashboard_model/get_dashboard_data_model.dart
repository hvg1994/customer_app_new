import 'package:gwc_customer/model/dashboard_model/gut_model/gut_data_model.dart';
import 'package:gwc_customer/model/dashboard_model/shipping_approved/ship_approved_model.dart';
import 'package:gwc_customer/model/program_model/proceed_model/get_proceed_model.dart';

import 'get_appointment/get_appointment_after_appointed.dart';
import 'get_program_model.dart';

class GetDashboardDataModel {
  String? status;
  String? errorCode;
  String? key;
  GetAppointmentDetailsModel? app_consulation;
  GutDataModel? normal_consultation;
  ShippingApprovedModel? approved_shipping;
  GutDataModel? normal_shipping;
  GetProgramModel? data_program;
  GutDataModel? normal_program;
  GutDataModel? normal_postprogram;

  GetDashboardDataModel(
      {this.status,
        this.errorCode,
        this.key,
        this.app_consulation,
        this.approved_shipping,
        this.normal_program,
        this.data_program,
        this.normal_postprogram,
        // this.postprogram
      });

  GetDashboardDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'].toString();
    key = json['key'];
    print(json['Consulation']['value'].runtimeType);
    print(json['Shipping']['value'].runtimeType);
    print(json['Program']['value'].runtimeType);


    if(json['Consulation'] != null){
      if(json['Consulation']['value'].runtimeType == String){
        normal_consultation = GutDataModel.fromJson(json['Consulation']);
      }
      else{
        app_consulation = GetAppointmentDetailsModel.fromJson(json['Consulation']);
      }
    }
    if(json['Shipping'] != null){
      if(json['Shipping']['value'].runtimeType == String){
        normal_shipping = GutDataModel.fromJson(json['Shipping']);
      }
      else{
        approved_shipping = ShippingApprovedModel.fromJson(json['Shipping']);
      }
    }
    if(json['Program'] != null){
      if(json['Program']['value'].runtimeType == String){
        normal_program = GutDataModel.fromJson(json['Program']);
      }
      else{
        data_program = GetProgramModel.fromJson(json['Program']);
      }
    }
    normal_postprogram = json['Postprogram'] != null
        ? GutDataModel.fromJson(json['Postprogram'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    if (this.app_consulation != null) {
      data['Consulation'] = this.app_consulation!.toJson();
    }
    if (this.approved_shipping != null) {
      data['Shipping'] = this.approved_shipping!.toJson();
    }
    if (this.data_program != null) {
      data['Program'] = this.data_program!.toJson();
    }
    if (this.normal_postprogram != null) {
      data['Postprogram'] = this.normal_postprogram!.toJson();
    }
    return data;
  }
}
