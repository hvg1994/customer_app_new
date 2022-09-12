import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:gwc_customer/model/new_user_model/about_program_model/about_program_model.dart';
import 'package:http/http.dart' as http;
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

  Future<ChooseProblemModel> serverGetProblemList() async {
    final String path = getProblemListUrl;

    print('serverGetProblemList Response header: $path');
    dynamic result;

    try{
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {"Content-Type": "application/json"},
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
      else if (json['status'] != 200) {
        result = ErrorModel.fromJson(json);
      }
      else{
        result = ChooseProblemModel.fromJson(json);
      }
    }
    catch(e){
      result = ErrorModel(status: "0", message: e.toString());
    }
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
    dynamic result;


    try{
      final response = await httpClient.post(
        Uri.parse(path),
        body: bodyParam,
      );

      print('serverRegisterUser Response header: $path');
      print('serverRegisterUser Response status: ${response.statusCode}');
      print('serverRegisterUser Response body: ${response.body}');

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
        headers: {"Content-Type": "application/json"},
      ).timeout(const Duration(seconds: 45));

      print('serverGetAboutProgramDetails Response header: $path');
      print('serverGetAboutProgramDetails Response status: ${response.statusCode}');
      print('serverGetAboutProgramDetails Response body: ${response.body}');


      final json = jsonDecode(response.body);
      print('serverGetAboutProgramDetails result: $json');
      if (response.statusCode != 200 || json['status'] != '200') {
        result = ErrorModel.fromJson(json);
      }
      else{
        result = ChooseProblemModel.fromJson(json);
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
        headers: {
          "Authorization": "Bearer ${AppConfig().shipRocketToken}",
          "Content-Type": "application/json"
        },
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


}
