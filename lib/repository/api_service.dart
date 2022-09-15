import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:gwc_customer/model/enquiry_status_model.dart';
import 'package:gwc_customer/model/login_model/login_otp_model.dart';
import 'package:gwc_customer/model/login_model/resend_otp_model.dart';
import 'package:gwc_customer/model/new_user_model/about_program_model/about_program_model.dart';
import 'package:http/http.dart' as http;
import '../model/consultation_model/appointment_booking/appointment_book_model.dart';
import '../model/consultation_model/appointment_slot_model.dart';
import '../model/error_model.dart';
import '../model/new_user_model/choose_your_problem/choose_your_problem_model.dart';
import '../model/new_user_model/choose_your_problem/submit_problem_response.dart';
import '../model/new_user_model/register/register_model.dart';
import '../model/ship_track_model/shipping_track_model.dart';
import '../utils/api_urls.dart';
import '../utils/app_config.dart';


class ApiClient {
  ApiClient({
    required this.httpClient,
  }) : assert(httpClient != null);

  final http.Client  httpClient;

final _prefs = AppConfig().preferences;

  String getHeaderToken() {
    if (_prefs != null) {
      final token = _prefs!.getString(AppConfig().tokenUser);
      // AppConfig().tokenUser
      // .substring(2, AppConstant().tokenUser.length - 1);
      return "Bearer $token";
    } else {
      return "Bearer ${AppConfig().bearer}";
    }
  }


  Map<String, String> header = {
    "Content-Type": "application/json",
    "Keep-Alive": "timeout=5, max=1"
  };

  Map<String, String> shipRocketHeader = {
    "Authorization": "Bearer ${AppConfig().shipRocketToken}",
    "Content-Type": "application/json"
  };



  Future<ChooseProblemModel> serverGetProblemList() async {
    final String path = getProblemListUrl;

    print('serverGetProblemList Response header: $path');
    dynamic result;

    try{
      final response = await httpClient.get(
        Uri.parse(path),
        headers: header,
      ).timeout(const Duration(seconds: 45));

      print('serverGetProblemList Response header: $path');
      print('serverGetProblemList Response status: ${response.statusCode}');
      print('serverGetProblemList Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('serverGetProblemList result: $json');

      if(response.statusCode != 200){
        result = ErrorModel(
            status: response.statusCode.toString(),
            message: "Unauthenticated"
        );
      }
      else{
        if(json['status'] != 200){
          result = ErrorModel.fromJson(json);
        }
        else{
          result = ChooseProblemModel.fromJson(json);
        }
      }
    }
    catch(e){
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future submitProblemList(
      List problemList, String deviceId) async {
    var url = submitProblemListUrl;

    Map param = {
      "device_id": deviceId,
    };
    problemList.forEach((element) {
      param.putIfAbsent(
          "problems[${problemList.indexWhere((ele) => ele == element)}]",
              () => element.toString());
    });

    print(jsonEncode(param));
    dynamic result;

    try {
      final response = await httpClient.post(
        Uri.parse(url),
        body: param,
      );

      print('submitProblemList Response status: ${response.statusCode}');
      print('submitProblemList Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('submitProblemList result: $json');
        result = SubmitProblemResponse.fromJson(json);
      } else {
        print('submitProblemList error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(),
            message: 'error getting quotes');
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future serverRegisterUser(
      {required String name,
        required int age,
        required String gender,
        required String email,
        required String countryCode,
        required String phone,
        required String deviceId}) async {
    final String path = registerUserUrl;

    Map bodyParam = {
      'name': name,
      'age': age.toString(),
      'gender': gender,
      'email': email,
      'phone': phone,
      'country_code': countryCode,
      "device_id": deviceId
    };

    print(bodyParam);
    dynamic result;


    try{
      final response = await httpClient.post(
        Uri.parse(path),
        body: bodyParam,
      );

      print('serverRegisterUser Response header: $path');
      print('serverRegisterUser Response status: ${response.statusCode}');
      print('serverRegisterUser Response body: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode != 200) {
        result = ErrorModel.fromJson(json);
      }else {
        print('submitProblemList result: $json');
        if(json['status'] == '201'){
          result = RegisterResponse.fromJson(json);
        }
        else{
          result = ErrorModel.fromJson(json);
        }
      }
    }
    catch(e){
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future serverGetAboutProgramDetails() async {
    final String path = getAboutProgramUrl;

    print('serverGetAboutProgramDetails Response header: $path');

    dynamic result;

    try{
      final response = await httpClient.get(
        Uri.parse(path),
        headers: header,
      ).timeout(const Duration(seconds: 45));

      print('serverGetAboutProgramDetails Response header: $path');
      print('serverGetAboutProgramDetails Response status: ${response.statusCode}');
      print('serverGetAboutProgramDetails Response body: ${response.body}');


      final json = jsonDecode(response.body);
      print('serverGetAboutProgramDetails result: $json');
      print(json['status'].toString().contains("200"));
      if (response.statusCode != 200) {
        print("error: $json");
        result = ErrorModel.fromJson(json);
      }
      else if(json['status'].toString().contains("200")){
        result = AboutProgramModel.fromJson(json);
      }
      else{
        result = ErrorModel.fromJson(json);
      }
    }
    catch(e){
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }



  Future serverShippingTrackerApi(String awbNumber) async {
    print(awbNumber);
    final String path = '$shippingApiUrl/$awbNumber';
    dynamic result;

    try{
      final response = await httpClient.get(
        Uri.parse(path),
        headers: shipRocketHeader,
      ).timeout(const Duration(seconds: 45));

      print('serverShippingTrackerApi Response header: $path');
      print('serverShippingTrackerApi Response status: ${response.statusCode}');
      print('serverShippingTrackerApi Response body: ${response.body}');

      if (response.statusCode != 200) {
        result = ErrorModel(
            status: response.statusCode.toString(),
            message: "Unauthenticated"
        );
      } else {
        final res = jsonDecode(response.body);
        result = ShippingTrackModel.fromJson(res);
      }
    }
    catch(e){
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  serverLoginWithOtpApi(String phone, String otp) async {
    var path = loginWithOtpUrl;

    dynamic result;

    Map bodyParam = {
      'phone': phone,
      'otp': otp
    };

    try{
      final response = await httpClient.post(Uri.parse(path),
        body: bodyParam
      ).timeout(Duration(seconds: 45));

      print('serverLoginWithOtpApi Response header: $path');
      print('serverLoginWithOtpApi Response status: ${response.statusCode}');
      print('serverLoginWithOtpApi Response body: ${response.body}');
      final res = jsonDecode(response.body);

      if(response.statusCode == 200){
        if(res['status'] == 200){
          result = loginOtpFromJson(response.body);
        }
        else{
          result = ErrorModel.fromJson(res);
        }
      }
      else{
        result = ErrorModel.fromJson(res);
      }
    }
    catch(e){
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  serverGetOtpApi(String phone) async {
    String path = getOtpUrl;
    
    dynamic result;

    Map bodyParam = {
      'phone': phone
    };
    
    try{
      final response = await httpClient.post(
        Uri.parse(path),
        body: bodyParam
      ).timeout(Duration(seconds: 45));

      print('serverGetOtpApi Response header: $path');
      print('serverGetOtpApi Response status: ${response.statusCode}');
      print('serverGetOtpApi Response body: ${response.body}');

      final res = jsonDecode(response.body);

      if(response.statusCode != 200){
        result = ErrorModel.fromJson(res);
      }
      else{
        if(res['status'] == 200){
          result = getOtpFromJson(response.body);
        }
        else{
          result = ErrorModel.fromJson(res);
        }
      }
    }
    catch(e){
      print(e);
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  /// date should be 2022-04-15 format
  Future getAppointmentSlotListApi(String selectedDate,
      {String? appointmentId}) async {
    final path = getAppointmentSlotsListUrl + selectedDate;
    var result;
    print("docId: $appointmentId");

    Map<String, dynamic> param = {'doctor_id': appointmentId};
    Map<String, String> header = {
      "Authorization": "Bearer ${AppConfig().bearerToken}",
      // "Authorization": getHeaderToken(),
    };
    try {
      if(appointmentId == null){
        print("First Slot");
      }
      else{
        print("Existing Slot");
      }
      final response = (appointmentId != null)
          ? await httpClient
          .post(Uri.parse(path),
          headers: header,
          body: param)
          .timeout(const Duration(seconds: 45))
          : await httpClient.get(
        Uri.parse(path),
        headers: header,
      ).timeout(const Duration(seconds: 45));

      print(
          "getAppointmentSlotListApi response path:" + path);

      print("getAppointmentSlotListApi response code:" +
          response.statusCode.toString());
      print("getAppointmentSlotListApi response body:" + response.body);

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'] == 200) {
        result = SlotModel.fromJson(res);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error $e");
      result = ErrorModel(status: "0", message: "Unauthenticated");
    }
    return result;
  }

  Future bookAppointmentApi(String date, String slotTime,
      {String? appointmentId}) async {
    final path = bookAppointmentUrl;

    Map param = {'booking_date': date, 'slot': slotTime};
    if (appointmentId != null) {
      param.putIfAbsent('appointment_id', () => appointmentId);
    }
    var result;

    try {
      if(appointmentId == null){
        print("Normal Appointment");
      }
      else{
        print("Reschedule Appointment");
      }
      print("param: $param");
      final response = await httpClient.post(
        Uri.parse(path),
        headers: {
          "Authorization": "Bearer ${AppConfig().bearerToken}",
          // "Authorization": getHeaderToken(),
        },
        body: param,
      );
      print(
          "bookAppointmentApi response code:" + response.statusCode.toString());
      print("bookAppointmentApi response body:" + response.body);

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        result = AppointmentBookingModel.fromJson(res);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error: ${e}");
      result = ErrorModel(status: "0", message: "Unauthenticated");
    }
    return result;
  }

  Future enquiryStatusApi(String deviceId) async {
    final path = enquiryStatusUrl;

    Map<String, String> param = {
      'device_id': deviceId,
    };

    var result;

    try {
      print("param: $param");

      // final response = await httpClient.post(
      //   Uri.parse(path),
      //   body: param,
      // ).timeout(Duration(seconds: 45));

      var request = http.MultipartRequest('POST', Uri.parse(path));
      var headers = {
        "Authorization": "Bearer ${AppConfig().bearerToken}",
        // "Authorization": getHeaderToken(),
      };

      request.fields.addAll(param);

      // reportList.forEach((element) async {
      //   request.files.add(await http.MultipartFile.fromPath('files[]', element));
      // });

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 45));


      print("enquiryStatusApi response code:" + response.statusCode.toString());
      print("enquiryStatusApi response body:" + response.body);

      final res = jsonDecode(response.body);

      print('${res['status'].runtimeType} ${res['status']}');

      if(response.statusCode != 200){
        result = ErrorModel.fromJson(res);
      }
      else if (res['status'].toString() == '200') {
        result = EnquiryStatusModel.fromJson(res);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error: ${e}");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }
}
