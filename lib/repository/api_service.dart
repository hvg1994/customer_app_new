import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
// import 'package:gut_wellness_app/model/ayurveda_model/appointment_booking/appointment_book_model.dart';
// import 'package:gut_wellness_app/model/ayurveda_model/appointment_slot_model.dart';
// import 'package:gut_wellness_app/model/error_model.dart';
// import 'package:gut_wellness_app/model/intro_model/choose_your_problem/choose_your_problem_model.dart';
// import 'package:gut_wellness_app/model/intro_model/choose_your_problem/submit_problem_response.dart';
// import 'package:gut_wellness_app/model/intro_model/document_text_model.dart';
// import 'package:gut_wellness_app/model/intro_model/get_program_details/get_program__details_model.dart';
// import 'package:gut_wellness_app/model/intro_model/given_details_model.dart';
// import 'package:gut_wellness_app/model/intro_model/payment_model.dart';
// import 'package:gut_wellness_app/model/intro_model/welcome_text_model.dart';
// import 'package:gut_wellness_app/model/profile_model/terms_condition_model.dart';
// import 'package:gut_wellness_app/model/profile_model/user_profile/user_profile_model.dart';
// import 'package:gut_wellness_app/model/register_model/register/register_model.dart';
// import 'package:gut_wellness_app/model/register_model/resend_otp_model.dart';
// import 'package:gut_wellness_app/model/register_model/validate_otp_model.dart';
// import 'package:gut_wellness_app/model/report_upload_model/report_list_model.dart';
// import 'package:gut_wellness_app/model/report_upload_model/report_upload_model.dart';
// import 'package:gut_wellness_app/model/ship_track_model/shipping_track_model.dart';
// import 'package:gut_wellness_app/utils/app_config.dart';
import 'package:http/http.dart' as http;

import '../model/error_model.dart';
import '../model/new_user_model/choose_your_problem/choose_your_problem_model.dart';
import '../model/new_user_model/choose_your_problem/submit_problem_response.dart';
import '../model/new_user_model/register/register_model.dart';
import '../model/ship_track_model/shipping_track_model.dart';
import '../utils/app_config.dart';


class ApiClient {
  ApiClient({
    required this.httpClient,
  }) : assert(httpClient != null);

  final http.Client httpClient;
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
  //
  // var welcomeTextUrl = "${AppConfig().BASE_URL}/api/list/welcome_text";
  // var postLoginUrl = "${AppConfig().BASE_URL}/login";
  // var termsConditionUrl =
  //     "${AppConfig().BASE_URL}/api/list/terms_and_conditions";
  var getProblemListUrl = "${AppConfig().BASE_URL}/api/list/problem_list";
  var submitProblemListUrl = "${AppConfig().BASE_URL}/api/form/submit_problems";
  // var getThankYouTextUrl = "${AppConfig().BASE_URL}/api/list/thank_you_text";
  // var getDocumentTextUrl = "${AppConfig().BASE_URL}/api/list/document_text";
  var registerUserUrl = "${AppConfig().BASE_URL}/api/register";
  // var sendOTPUrl = "${AppConfig().BASE_URL}/api/sendOTP";
  // var validateOTPUrl = "${AppConfig().BASE_URL}/api/validateOTP";
  // var getProgramDetailsUrl =
  //     "${AppConfig().BASE_URL}/api/getData/get_program_details";
  // var sendPaymentIdUrl = "${AppConfig().BASE_URL}/api/submitForm/payment";
  // var getAppointmentSlotsListUrl = "${AppConfig().BASE_URL}/api/getData/slots/";
  // var bookAppointmentUrl = "${AppConfig().BASE_URL}/api/getData/book";
  // var uploadReportUrl = "${AppConfig().BASE_URL}/api/submitForm/user_report";
  // var getUserReportListUrl =
  //     "${AppConfig().BASE_URL}/api/getData/user_reports_list";
  // var submitEvaluationFormUrl =
  //     "${AppConfig().BASE_URL}/api/submitForm/evaluation_form";
  // var getUserProfileUrl = "${AppConfig().BASE_URL}/api/user";
  var shippingApiUrl = AppConfig().shipRocket_AWB_URL;


  Future<ChooseProblemModel> serverGetProblemList() async {
    final String path = getProblemListUrl;
    print('serverGetProblemList Response header: $path');
    final response = await httpClient.get(
      Uri.parse(path),
      headers: {"Content-Type": "application/json"},
    ).timeout(const Duration(seconds: 45));
    print('serverGetProblemList Response header: $path');
    print('serverGetProblemList Response status: ${response.statusCode}');
    print('serverGetProblemList Response body: ${response.body}');
    dynamic result;
    if (response.statusCode != 200) {
      throw Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    print('serverGetProblemList result: $json');
    result = ChooseProblemModel.fromJson(json);
    return result;
  }

  Future submitProblemList(
      List problemList, String deviceId, String otherProblem) async {
    var url = submitProblemListUrl;

    Map param = {
      "device_id": deviceId,
    };
    problemList.forEach((element) {
      param.putIfAbsent(
          "problems[${problemList.indexWhere((ele) => ele == element)}]",
              () => element.toString());
    });

    if (otherProblem.isNotEmpty) {
      param.putIfAbsent("other_problem", () => otherProblem);
    }
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

    final response = await httpClient.post(
      Uri.parse(path),
      body: bodyParam,
    );

    print('serverRegisterUser Response header: $path');
    print('serverRegisterUser Response status: ${response.statusCode}');
    print('serverRegisterUser Response body: ${response.body}');

    dynamic result;
    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      print('submitProblemList result: $json');
      result = RegisterResponse.fromJson(json);
    } else if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      result = ErrorModel.fromJson(json);
    } else {
      print('submitProblemList error: ${response.reasonPhrase}');
      result = ErrorModel(
          status: response.statusCode.toString(),
          message: 'error getting quotes');
    }
    return result;
  }



  Future serverShippingTrackerApi(String awbNumber) async {
    print(awbNumber);
    final String path = '$shippingApiUrl/$awbNumber';

    final response = await httpClient.get(
      Uri.parse(path),
      headers: {
        "Authorization": "Bearer ${AppConfig().shipRocketToken}",
        "Content-Type": "application/json"
      },
    ).timeout(const Duration(seconds: 45));

    print('serverShippingTrackerApi Response header: $path');
    print('serverShippingTrackerApi Response status: ${response.statusCode}');
    print('serverShippingTrackerApi Response body: ${response.body}');
    dynamic result;

    if (response.statusCode != 200) {
      result = ErrorModel(
          status: response.statusCode.toString(),
          message: "Unauthenticated"
      );
    } else {
      final res = jsonDecode(response.body);
      result = ShippingTrackModel.fromJson(res);
    }
    return result;
  }
}
