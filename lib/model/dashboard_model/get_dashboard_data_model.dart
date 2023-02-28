import 'package:gwc_customer/model/dashboard_model/gut_model/gut_data_model.dart';
import 'package:gwc_customer/model/dashboard_model/shipping_approved/ship_approved_model.dart';
import 'package:gwc_customer/model/program_model/proceed_model/get_proceed_model.dart';

import 'get_appointment/get_appointment_after_appointed.dart';
import 'get_program_model.dart';

class GetDashboardDataModel {
  String? status;
  String? errorCode;
  String? key;
  // these 2 for consultation
  GetAppointmentDetailsModel? app_consulation;
  GutDataModel? normal_consultation;

  GutDataModel? prepratory_normal_program;
  // these 2 for shipping
  ShippingApprovedModel? approved_shipping;
  GutDataModel? normal_shipping;
  // these 2 for Programs
  GetProgramModel? data_program;
  GetPrePostMealModel? trans_program, prepratory_program;
  GutDataModel? normal_program;

  GutDataModel? transition_meal_program;

  // these parameters for post programs
  GutDataModel? normal_postprogram;
  GetAppointmentDetailsModel? postprogram_consultation;



  GetDashboardDataModel(
      {this.status,
        this.errorCode,
        this.key,
        this.app_consulation,
        this.prepratory_normal_program,
        this.prepratory_program,
        this.approved_shipping,
        this.normal_program,
        this.data_program,
        this.trans_program,
        this.transition_meal_program,
        this.normal_postprogram,
        // this.postprogram
      });

  GetDashboardDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString();
    errorCode = json['errorCode'].toString();
    key = json['key'];
    print(json['Consulation']['value'].runtimeType);
    print(json['Shipping']['value'].runtimeType);
    print(json['PostProgram']['value']);


    if(json['Consulation'] != null){
      if(json['Consulation']['value'].runtimeType == String){
        normal_consultation = GutDataModel.fromJson(json['Consulation']);
      }
      else{
        app_consulation = GetAppointmentDetailsModel.fromJson(json['Consulation']);
      }
    }
    if(json['PrepProgram'] != null){
      if(json['PrepProgram']['value'].runtimeType == String){
        prepratory_normal_program = GutDataModel.fromJson(json['PrepProgram']);
      }
      else{
        prepratory_program = GetPrePostMealModel.fromJson(json['PrepProgram']);
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
        print("program: ${normal_program!.toJson()}");
      }
      else{
        data_program = GetProgramModel.fromJson(json['Program']);
        print("program: ${data_program!.toJson()}");
      }
    }
    if(json['TransProgram'] != null){
      print("json['TransProgram']: ${json['TransProgram']}");
      if(json['TransProgram']['value'].runtimeType == String){
        transition_meal_program = GutDataModel.fromJson(json['TransProgram']);
      }
      else{
        trans_program = GetPrePostMealModel.fromJson(json['TransProgram']);
      }
    }

    print('json postProgram: ${json['PostProgram']['value'].runtimeType}');

    if(json['PostProgram'] != null && json['PostProgram']['data'] != null){
      if(json['PostProgram']['value'].runtimeType == String || json['PostProgram']['value'] == null){
        normal_postprogram = GutDataModel.fromJson(json['PostProgram']);
        print('json PostProgram: ${normal_postprogram!.toJson()}');
      }
      else{
        postprogram_consultation = GetAppointmentDetailsModel.fromJson(json['PostProgram']);
        // if((json['PostProgram']['value'] as Map).containsKey('zoom_join_url')){
        //   postprogram_consultation = GetAppointmentDetailsModel.fromJson(json['PostProgram']);
        //   print("postProgram:${postprogram_consultation!.toJson()}");
        // }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    if (this.app_consulation != null) {
      data['Consulation'] = this.app_consulation!.toJson();
    }
    if (this.prepratory_normal_program != null) {
      data['PrepProgram'] = this.prepratory_normal_program!.toJson();
    }
    if (this.approved_shipping != null) {
      data['Shipping'] = this.approved_shipping!.toJson();
    }
    if (this.data_program != null) {
      data['Program'] = this.data_program!.toJson();
    }
    if (this.normal_postprogram != null) {
      data['PostProgram'] = this.normal_postprogram!.toJson();
    }
    return data;
  }
}

class GetPrePostMealModel{
  String? data;
  GetPrePostMealvalue? value;

  GetPrePostMealModel({this.data, this.value});

  GetPrePostMealModel.fromJson(Map<String, dynamic> json){
    data = json['data'];
    value = (json['value'] != null ? new GetPrePostMealvalue.fromJson(json['value']) : null);
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['days'] = this.data;
    data['value'] = this.value;
    return data;
  }
}

class GetPrePostMealvalue{
  String? prep_days;
  String? trans_days;
  bool? isPrepratoryStarted;
  bool? isPrepCompleted;
  bool? isTransMealStarted;
  bool? isTransMealCompleted;
  String? currentDay;


  GetPrePostMealvalue({this.prep_days, this.trans_days,this.isPrepratoryStarted, this.isTransMealCompleted,this.isPrepCompleted, this.isTransMealStarted, this.currentDay});

  GetPrePostMealvalue.fromJson(Map<String, dynamic> json){
    print("json['days']===> ${json['days']}");
    print("json['days']===> ${json['trans_days']}");

    prep_days = json['days'];
    trans_days = json['days'];
    isPrepratoryStarted = json['is_prep_program_started'].toString().contains("0") ? false : true;
    isPrepCompleted = json['is_prep_program_completed'].toString().contains("0") ? false : true;
    isTransMealStarted = json['is_trans_program_started'].toString().contains("0") ? false : true;
    isTransMealCompleted = json['is_trans_completed'].toString().contains("0") ? false : true;

    currentDay = json['current_day'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['days'] = this.prep_days;
    data['trans_days'] = this.trans_days;
    data['is_prep_program_started'] = this.isPrepratoryStarted;
    data['is_trans_program_started'] = this.isTransMealStarted;
    data['current_day'] = this.currentDay;
    return data;
  }
}