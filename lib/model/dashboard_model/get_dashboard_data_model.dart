import 'package:gwc_customer/model/dashboard_model/gut_model/gut_data_model.dart';
import 'package:gwc_customer/model/dashboard_model/shipping_approved/ship_approved_model.dart';

import 'get_appointment/get_appointment_after_appointed.dart';

class GetDashboardDataModel {
  int? status;
  int? errorCode;
  String? key;
  GetAppointmentDetailsModel? app_consulation;
  GutDataModel? normal_consultation;
  ShippingApprovedModel? approved_shipping;
  GutDataModel? normal_shipping;
  GutDataModel? program;
  GutDataModel? postprogram;

  GetDashboardDataModel(
      {this.status,
        this.errorCode,
        this.key,
        this.app_consulation,
        this.approved_shipping,
        this.program,
        this.postprogram});

  GetDashboardDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    print(json['Consulation']['value'].runtimeType);
    print(json['Shipping']['value'].runtimeType);

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
    // consulation =
    //     ? new GetAppointmentDetailsModel.fromJson(json['Consulation'])
    //     : null;
    // shipping = json['Shipping'] != null
    //     ? new ShippingApprovedModel.fromJson(json['Shipping'])
    //     : null;
    program = json['Program'] != null ? new GutDataModel.fromJson(json['Program']) : null;
    postprogram = json['Postprogram'] != null
        ? new GutDataModel.fromJson(json['Postprogram'])
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
    if (this.app_consulation != null) {
      data['Shipping'] = this.approved_shipping!.toJson();
    }
    if (this.program != null) {
      data['Program'] = this.program!.toJson();
    }
    if (this.postprogram != null) {
      data['Postprogram'] = this.postprogram!.toJson();
    }
    return data;
  }
}
