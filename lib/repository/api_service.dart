import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:gwc_customer/model/dashboard_model/get_appointment/get_appointment_after_appointed.dart';
import 'package:gwc_customer/model/dashboard_model/get_dashboard_data_model.dart';
import 'package:gwc_customer/model/dashboard_model/gut_model/gut_data_model.dart';
import 'package:gwc_customer/model/enquiry_status_model.dart';
import 'package:gwc_customer/model/evaluation_from_models/get_evaluation_model/get_evaluationdata_model.dart';
import 'package:gwc_customer/model/login_model/login_otp_model.dart';
import 'package:gwc_customer/model/login_model/resend_otp_model.dart';
import 'package:gwc_customer/model/message_model/get_chat_groupid_model.dart';
import 'package:gwc_customer/model/new_user_model/about_program_model/about_program_model.dart';
import 'package:gwc_customer/model/notification_model/NotificationModel.dart';
import 'package:gwc_customer/model/post_program_model/breakfast/protocol_breakfast_get.dart';
import 'package:gwc_customer/model/post_program_model/post_program_base_model.dart';
import 'package:gwc_customer/model/post_program_model/protocol_guide_day_score.dart';
import 'package:gwc_customer/model/profile_model/feedback_model.dart';
import 'package:gwc_customer/model/profile_model/logout_model.dart';
import 'package:gwc_customer/model/profile_model/user_profile/update_user_model.dart';
import 'package:gwc_customer/model/program_model/proceed_model/get_proceed_model.dart';
import 'package:gwc_customer/model/program_model/proceed_model/send_proceed_program_model.dart';
import 'package:gwc_customer/model/program_model/program_days_model/program_day_model.dart';
import 'package:gwc_customer/model/program_model/start_post_program_model.dart';
import 'package:gwc_customer/model/program_model/start_program_on_swipe_model.dart';
import 'package:gwc_customer/model/rewards_model/reward_point_model.dart';
import 'package:gwc_customer/model/rewards_model/reward_point_stages.dart';
import 'package:gwc_customer/model/ship_track_model/shiprocket_auth_model/shiprocket_auth_model.dart';
import 'package:gwc_customer/model/ship_track_model/shopping_model/get_shopping_model.dart';
import 'package:gwc_customer/model/ship_track_model/sipping_approve_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../model/consultation_model/appointment_booking/appointment_book_model.dart';
import '../model/consultation_model/appointment_slot_model.dart';
import '../model/dashboard_model/report_upload_model/report_list_model.dart';
import '../model/dashboard_model/report_upload_model/report_upload_model.dart';
import '../model/dashboard_model/shipping_approved/ship_approved_model.dart';
import '../model/error_model.dart';
import '../model/evaluation_from_models/get_country_details_model.dart';
import '../model/faq_model/faq_list_model.dart';
import '../model/new_user_model/choose_your_problem/choose_your_problem_model.dart';
import '../model/new_user_model/choose_your_problem/submit_problem_response.dart';
import '../model/new_user_model/register/register_model.dart';
import '../model/profile_model/terms_condition_model.dart';
import '../model/profile_model/user_profile/user_profile_model.dart';
import '../model/program_model/meal_plan_details_model/meal_plan_details_model.dart';
import '../model/ship_track_model/shipping_track_model.dart';
import '../utils/api_urls.dart';
import '../utils/app_config.dart';
import 'package:gwc_customer/model/home_model/home_model.dart';

class ApiClient {
  ApiClient({
    required this.httpClient,
  }) : assert(httpClient != null);

  final http.Client httpClient;

  final _prefs = AppConfig().preferences;

  String getHeaderToken() {
    if (_prefs != null) {
      final token = _prefs!.getString(AppConfig().BEARER_TOKEN);
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

  Future serverGetProblemList() async {
    final String path = getProblemListUrl;

    print('serverGetProblemList Response header: $path');
    dynamic result;

    try {
      final response = await httpClient
          .get(
            Uri.parse(path),
            headers: header,
          )
          .timeout(const Duration(seconds: 45));

      print('serverGetProblemList Response header: $path');
      print('serverGetProblemList Response status: ${response.statusCode}');
      print('serverGetProblemList Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('serverGetProblemList result: $json');

      if (response.statusCode != 200) {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      } else {
        if (json['status'] != 200) {
          result = ErrorModel.fromJson(json);
        } else {
          result = ChooseProblemModel.fromJson(json);
        }
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future submitProblemList(List problemList, String deviceId) async {
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
      required String deviceId,
      required String fcmToken}) async {
    final String path = registerUserUrl;

    Map bodyParam = {
      'name': name,
      'age': age.toString(),
      'gender': gender,
      'email': email,
      'phone': phone,
      'country_code': countryCode,
      "device_id": deviceId,
      "device_token": fcmToken
    };

    print(bodyParam);
    dynamic result;

    try {
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
      } else {
        print('submitProblemList result: $json');
        if (json['status'].toString() == '201') {
          result = RegisterResponse.fromJson(json);
        } else {
          result = ErrorModel.fromJson(json);
        }
      }
    } catch (e) {
      print("catch error: $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future serverGetAboutProgramDetails() async {
    final String path = getAboutProgramUrl;

    print('serverGetAboutProgramDetails Response header: $path');

    dynamic result;

    try {
      final response = await httpClient
          .get(
            Uri.parse(path),
            headers: header,
          )
          .timeout(const Duration(seconds: 45));

      print('serverGetAboutProgramDetails Response header: $path');
      print(
          'serverGetAboutProgramDetails Response status: ${response.statusCode}');
      print('serverGetAboutProgramDetails Response body: ${response.body}');

      final json = jsonDecode(response.body);
      print('serverGetAboutProgramDetails result: $json');

      if (response.statusCode != 200) {
        print("error: $json");
        result = ErrorModel.fromJson(json);
      } else if (json['status'].toString().contains("200")) {
        result = AboutProgramModel.fromJson(json);
      } else {
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  Future getShippingTokenApi(String email, String password) async {
    final path = shippingApiLoginUrl;

    Map bodyParam = {"email": email, "password": password};

    dynamic result;

    try {
      final response = await httpClient
          .post(Uri.parse(path), body: bodyParam)
          .timeout(Duration(seconds: 45));

      if (response.statusCode != 200) {
        result = ErrorModel.fromJson(jsonDecode(response.body));
      } else {
        result = ShipRocketTokenModel.fromJson(jsonDecode(response.body));
        storeShipRocketToken(result);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future serverShippingTrackerApi(String awbNumber) async {
    print(awbNumber);
    final String path = '$shippingApiUrl/$awbNumber';
    dynamic result;

    String shipToken = _prefs?.getString(AppConfig().shipRocketBearer) ?? '';

    Map<String, String> shipRocketHeader = {
      "Authorization": "Bearer $shipToken",
      "Content-Type": "application/json"
    };

    print('shiptoken: $shipToken');
    try {
      final response = await httpClient
          .get(
            Uri.parse(path),
            headers: shipRocketHeader,
          )
          .timeout(const Duration(seconds: 45));

      print('serverShippingTrackerApi Response header: $path');
      print('serverShippingTrackerApi Response status: ${response.statusCode}');
      print('serverShippingTrackerApi Response body: ${response.body}');

      if (response.statusCode != 200) {
        final res = jsonDecode(response.body);
        result = ErrorModel.fromJson(res);
      } else {
        final res = jsonDecode(response.body);
        result = ShippingTrackModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  serverLoginWithOtpApi(String phone, String otp) async {
    var path = loginWithOtpUrl;

    dynamic result;

    Map bodyParam = {'phone': phone, 'otp': otp};

    try {
      final response = await httpClient
          .post(Uri.parse(path), body: bodyParam)
          .timeout(Duration(seconds: 45));

      print('serverLoginWithOtpApi Response header: $path');
      print('serverLoginWithOtpApi Response status: ${response.statusCode}');
      print('serverLoginWithOtpApi Response body: ${response.body}');
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (res['status'] == 200) {
          result = loginOtpFromJson(response.body);
        } else {
          result = ErrorModel.fromJson(res);
        }
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  serverLogoutApi() async {
    var path = logOutUrl;

    dynamic result;

    try {
      final response = await httpClient.post(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(Duration(seconds: 45));

      print('serverLogoutApi Response header: $path');
      print('serverLogoutApi Response status: ${response.statusCode}');
      print('serverLogoutApi Response body: ${response.body}');
      final res = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (res['status'] == 200) {
          result = LogoutModel.fromJson(res);
        } else {
          result = ErrorModel.fromJson(res);
        }
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  serverGetOtpApi(String phone) async {
    String path = getOtpUrl;

    dynamic result;

    Map bodyParam = {'phone': phone};

    try {
      final response = await httpClient
          .post(Uri.parse(path), body: bodyParam)
          .timeout(Duration(seconds: 45));

      print('serverGetOtpApi Response header: $path');
      print('serverGetOtpApi Response status: ${response.statusCode}');
      print('serverGetOtpApi Response body: ${response.body}');

      final res = jsonDecode(response.body);

      if (response.statusCode != 200) {
        result = ErrorModel.fromJson(res);
      } else {
        if (res['status'] == 200) {
          result = getOtpFromJson(response.body);
        } else {
          result = ErrorModel.fromJson(res);
        }
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  /// date should be 2022-04-15 format
  Future getAppointmentSlotListApi(String selectedDate,
      {String? appointmentId}) async {
    final path = getAppointmentSlotsListUrl + selectedDate;
    var startTime = DateTime.now().millisecondsSinceEpoch;

    var result;
    print("appointmentId: $appointmentId");

    Map<String, dynamic> param = {'appointment_id': appointmentId};
    Map<String, String> header = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      if (appointmentId == null) {
        print("First Slot");
      } else {
        print("Existing Slot");
      }

      final response = (appointmentId != null)
          ? await httpClient
              .post(Uri.parse(path), headers: header, body: param)
              .timeout(const Duration(seconds: 45))
          : await httpClient
              .get(
                Uri.parse(path),
                headers: header,
              )
              .timeout(const Duration(seconds: 45));

      print("getAppointmentSlotListApi response path:" + path);

      print("getAppointmentSlotListApi response code:" +
          response.statusCode.toString());
      print("getAppointmentSlotListApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
      print("response Time:" + (totalTime / 1000).round().toString());

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'] == 200) {
        result = SlotModel.fromJson(res);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future bookAppointmentApi(String date, String slotTime,
      {String? appointmentId, bool isPostprogram = false}) async {
    final path = bookAppointmentUrl;

    print("is from postprogram==> ${isPostprogram}");

    var startTime = DateTime.now().millisecondsSinceEpoch;

    Map param = {'booking_date': date, 'slot': slotTime};
    if(isPostprogram == true) {
      param.putIfAbsent("status", () => 'post_program');
    }
    if (appointmentId != null) {
      param.putIfAbsent('appointment_id', () => appointmentId);
    }
    var result;

    try {
      if (appointmentId == null) {
        print("Normal Appointment");
      } else {
        print("Reschedule Appointment");
      }
      print("param: ${param}");
      final response = await httpClient.post(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
        body: param,
      );
      print(
          "bookAppointmentApi response code:" + response.statusCode.toString());
      print("bookAppointmentApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
      print("response Time:" + (totalTime / 1000).round().toString());

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        result = AppointmentBookingModel.fromJson(res);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error: ${e}");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future enquiryStatusApi(String deviceId) async {
    final path = enquiryStatusUrl;

    Map<String, String> param = {
      'device_id': deviceId,
    };

    final startTime = DateTime.now().millisecondsSinceEpoch;

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
      request.persistentConnection = false;

      // reportList.forEach((element) async {
      //   request.files.add(await http.MultipartFile.fromPath('files[]', element));
      // });

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 45));

      print("enquiryStatusApi response code:" + response.statusCode.toString());
      print("enquiryStatusApi response body:" + response.body);

      print("getAppointmentSlotListApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;

      print("response: $totalTime");

      final res = jsonDecode(response.body);

      print('${res['status'].runtimeType} ${res['status']}');

      if (response.statusCode != 200) {
        result = ErrorModel.fromJson(res);
      } else if (res['status'].toString() == '200') {
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

  Future submitEvaluationFormApi(Map form, List medicalReports) async {
    final path = submitEvaluationFormUrl;

    var result;
    var startTime = DateTime.now().millisecondsSinceEpoch;

    print(getHeaderToken());

    Map<String, String> m2 = Map.from(form);
    print(m2);
    // print("form: $form");
    try {
      var request = http.MultipartRequest('POST', Uri.parse(path));
      var headers = {
        // "Authorization": "Bearer ${AppConfig().bearerToken}",
        "Authorization": getHeaderToken(),
      };
      medicalReports.forEach((element) async {
        request.files.add(
            await http.MultipartFile.fromPath('medical_report[]', element));
      });
      request.headers.addAll(headers);
      request.fields.addAll(m2);
      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 50));

      print("submitEvaluationFormApi response code:" + path);
      print("submitEvaluationFormApi response code:" +
          response.statusCode.toString());
      print("submitEvaluationFormApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
      print("response Time:" + (totalTime / 1000).round().toString());

      print(
          "start: $startTime end: ${DateTime.now().millisecondsSinceEpoch}  total: $totalTime");

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        result = ReportUploadModel.fromJson(res);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error: ${e}");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  jsonToFormData(http.MultipartRequest request, Map<String, dynamic> data) {
    for (var key in data.keys) {
      request.fields[key] = data[key].toString();
    }
    return request;
  }

  Future serverGetEvaluationDetails() async {
    final String path = getEvaluationDataUrl;

    dynamic result;

    var headers = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      final response = await httpClient
          .get(
            Uri.parse(path),
            headers: headers,
          )
          .timeout(const Duration(seconds: 45));

      print('serverGetEvaluationDetails Response header: $path');
      print(
          'serverGetEvaluationDetails Response status: ${response.statusCode}');
      print('serverGetEvaluationDetails Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('serverGetEvaluationDetails result: $json');

      if (response.statusCode != 200) {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      } else {
        if (json['status'].toString() != '200') {
          result = ErrorModel.fromJson(json);
        } else {
          result = GetEvaluationDataModel.fromJson(json);
        }
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future serverGetGutData() async {
    final String path = getDashboardDataUrl;

    dynamic result;

    var headers = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      final response = await httpClient
          .get(
            Uri.parse(path),
            headers: headers,
          )
          .timeout(const Duration(seconds: 45));

      print('serverGetDashboardData Response header: $path');
      print('serverGetDashboardData Response status: ${response.statusCode}');
      print('serverGetDashboardData Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('serverGetDashboardData result: $json');

      if (response.statusCode != 200) {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      } else {
        if (json['status'].toString() != '200') {
          result = ErrorModel.fromJson(json);
        } else {
          result = GetDashboardDataModel.fromJson(json);
        }
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future getUserProfileApi() async {
    final path = getUserProfileUrl;
    var result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print(
          "getUserProfileApi response code:" + response.statusCode.toString());
      print("getUserProfileApi response body:" + response.body);

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        result = UserProfileModel.fromJson(jsonDecode(response.body));
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("getUserProfileApi catch error");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future updateUserProfileApi(Map user) async {
    final path = updateUserProfileUrl;
    print(user);
    var result;
    try {
      final response = await httpClient
          .post(Uri.parse(path),
              headers: {
                // "Authorization": "Bearer ${AppConfig().bearerToken}",
                "Authorization": getHeaderToken(),
              },
              body: user)
          .timeout(const Duration(seconds: 45));

      print("updateUserProfileApi response code:" +
          response.statusCode.toString());
      print("updateUserProfileApi response body:" + response.body);

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        result = UpdateUserModel.fromJson(jsonDecode(response.body));
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("updateUserProfileApi catch error $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future serverGetTermsAndCondition() async {
    final String path = termsConditionUrl;

    final response = await httpClient.get(
      Uri.parse(path),
      headers: {"Content-Type": "application/json"},
    ).timeout(const Duration(seconds: 45));
    if (kDebugMode) {
      print('serverGetTermsAndCondition Response header: $path');
      print(
          'serverGetTermsAndCondition Response status: ${response.statusCode}');
      print('serverGetTermsAndCondition Response body: ${response.body}');
    }
    dynamic result;
    if (response.statusCode == 401) {
      final json = jsonDecode(response.body);
      print('serverGetTermsAndCondition error: $json');
      result = ErrorModel.fromJson(json);
    } else if (response.statusCode != 200) {
      throw Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    print('serverGetTermsAndCondition result: $json');
    result = TermsConditionModel.fromJson(json);
    return result;
  }

  Future uploadReportApi(List reportList) async {
    final path = uploadReportUrl;

    var result;
    var startTime = DateTime.now().millisecondsSinceEpoch;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(path));
      var headers = {
        // "Authorization": "Bearer ${AppConfig().bearerToken}",
        "Authorization": getHeaderToken(),
      };

      request.files.addAll(reportList as List<http.MultipartFile>);

      // reportList.forEach((element) async {
      //   request.files.add(await http.MultipartFile.fromPath('files[]', element));
      // });
      request.headers.addAll(headers);

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 50));

      print("uploadReportApi response code:" + path);
      print("uploadReportApi response code:" + response.statusCode.toString());
      print("uploadReportApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
      print(
          "start: $startTime end: ${DateTime.now().millisecondsSinceEpoch}  total: $totalTime");

      print("response Time:" + (totalTime / 1000).round().toString());

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        result = ReportUploadModel.fromJson(res);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error: ${e}");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future getUploadedReportListListApi() async {
    final path = getUserReportListUrl;
    var result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print("getUploadedReportListApi response code:" +
          response.statusCode.toString());
      print("getUploadedReportListApi response body:" + response.body);

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        result = GetReportListModel.fromJson(jsonDecode(response.body));
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future getProgramDayListApi() async {
    final path = getMealProgramDayListUrl;
    var result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print("getProgramDayListApi response code:" +
          response.statusCode.toString());
      print("getProgramDayListApi response body:" + response.body);

      if (response.statusCode != 200) {
        print('status not equal called');
        final res = jsonDecode(response.body);
        result = ErrorModel.fromJson(res);
      } else {
        final res = jsonDecode(response.body);
        print('${res['status'].runtimeType} ${res['status']}');
        if (res['status'].toString() == '200') {
          result = ProgramDayModel.fromJson(jsonDecode(response.body));
        } else {
          result = ErrorModel.fromJson(res);
        }
      }
    } catch (e) {
      print("catch error::> $e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  /// need to pass day 1,2,3,4.......... like this
  Future getMealPlanDetailsApi(String day) async {
    final path = '$getMealPlanDataUrl/$day';
    var result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print("getMealPlanDetailsApi response code:" +
          response.statusCode.toString());
      print("getMealPlanDetailsApi response body:" + response.body);

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');

      if (res['status'].toString() == '200') {
        result = MealPlanDetailsModel.fromJson(jsonDecode(response.body));
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error$e");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future proceedDayProgramList(ProceedProgramDayModel model) async {
    var url = submitDayPlanDetailsUrl;

    dynamic result;

    Map staticData =
    {
    'patient_meal_tracking[]':[{"user_meal_item_id":1658,"day":2,"status":"followed"},{"user_meal_item_id":1500,"day":2,"status":"followed"},{"user_meal_item_id":1501,"day":2,"status":"unfollowed"},{"user_meal_item_id":1502,"day":2,"status":"followed"},{"user_meal_item_id":1503,"day":2,"status":"followed"},
      {"user_meal_item_id":1504,"day":2,"status":"followed"},{"user_meal_item_id":1505,"day":2,"status":"unfollowed"},
      {"user_meal_item_id":1506,"day":2,"status":"followed"},
      {"user_meal_item_id":1659,"day":2,"status":"unfollowed"},
      {"user_meal_item_id":1507,"day":2,"status":"followed"},
      {"user_meal_item_id":1508,"day":2,"status":"followed"}],
    'user_program_status_tracking':1,
    'day':2,
    'did_u_miss':'no',
    'withdrawal_symptoms[]': ['Aches, pain, and soreness', 'Nausea'],
    'detoxification[]': ['Lightness in the Chest / Abdomen', 'Odour free burps'],
    'have_any_other_worries':'No',
    'eat_something_other':'no',
    'completed_calm_move_modules':'Yes',
    'had_a_medical_exam_medications':'No'
  };

    print("proceedDayProgramList path: $url");

    print(Map.from(model.toJson()));
    Map<String, String> m = Map.unmodifiable(model.toJson());

    // print(
    //     "model: ${json.encode(model.toJson()) == jsonEncode(model.toJson())}");

    try {
      final response = await httpClient.post(
        Uri.parse(url),
        headers: {
          // "Content-Type": "application/json",
          "Authorization": getHeaderToken(),
        },
        body: m,
        // body: staticData
      );

      print('proceedDayProgramList Response status: ${response.statusCode}');
      print('proceedDayProgramList Response body: ${response.body}');

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('proceedDayProgramList result: $json');
        result = GetProceedModel.fromJson(json);
      } else {
        print('proceedDayProgramList error: ${response.reasonPhrase}');
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future shoppingDetailsListApi() async {
    final String path = shoppingListApiUrl;
    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print('shoppingDetailsListApi Response header: $path');
      print('shoppingDetailsListApi Response status: ${response.statusCode}');
      print('shoppingDetailsListApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['status'] == 200) {
          result = GetShoppingListModel.fromJson(res);
        } else {
          result = ErrorModel.fromJson(jsonDecode(response.body));
        }
      } else {
        print('proceedDayProgramList error: ${response.reasonPhrase}');
        result = ErrorModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  Future shippingApproveApi(String approveStatus) async {
    final String path = shoppingApproveApiUrl;
    dynamic result;

    Map bodyParam = {'status': approveStatus};

    try {
      final response = await httpClient
          .post(Uri.parse(path),
              headers: {
                // "Authorization": "Bearer ${AppConfig().bearerToken}",
                "Authorization": getHeaderToken(),
              },
              body: bodyParam)
          .timeout(const Duration(seconds: 45));

      print('shippingApproveApi Response header: $path');
      print('shippingApproveApi Response status: ${response.statusCode}');
      print('shippingApproveApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['status'] == 200) {
          result = ShippingApproveModel.fromJson(res);
        } else {
          result = ErrorModel.fromJson(jsonDecode(response.body));
        }
      } else {
        print('shippingApproveApi error: ${response.reasonPhrase}');
        result = ErrorModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }
  //https://api.worldpostallocations.com/?postalcode=570008&countrycode=IN

  getCountryDetails(String pincode, String countryCode) async {
    final String url = "http://www.postalpincode.in/api/pincode/";
    final String path = url + pincode;
    // final String url = "https://api.worldpostallocations.com/";
    // final String path = url + "?postalcode=$pincode&countrycode=$countryCode";
    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print('getCountryDetails Response header: $path');
      print('getCountryDetails Response status: ${response.statusCode}');
      print('getCountryDetails Response body: ${response.body}');

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['Status'].toString().toLowerCase() == "success") {
          result = GetCountryDetailsModel.fromJson(res);
        } else {
          result = ErrorModel(status: "0", message: "No Data");
        }
      } else {
        print('getCountryDetails error: ${response.reasonPhrase}');
        result = ErrorModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  Future submitUserFeedbackDetails(Map feedback, List<MultipartFile> files) async {
    final String path = submitFeedbackUrl;

    dynamic result;

    Map bodyParam = feedback;

    print(bodyParam);
    print(files);
    var headers = {
      // "Authorization": "Bearer ${AppConfig().bearerToken}",
      "Authorization": getHeaderToken(),
    };
    try {
      var request = http.MultipartRequest('POST', Uri.parse(path));

      request.headers.addAll(headers);
      request.fields.addAll(Map.from(bodyParam));

      if(files.isNotEmpty){
        request.files.addAll(files);
      }
      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 50));

      print('submitUserFeedbackDetails Response header: $path');
      print(
          'submitUserFeedbackDetails Response status: ${response.statusCode}');
      print('submitUserFeedbackDetails Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('submitUserFeedbackDetails result: $json');

      if (response.statusCode != 200) {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      } else {
        if (json['status'].toString() != '200') {
          result = ErrorModel.fromJson(json);
        } else {
          result = FeedbackModel.fromJson(json);
        }
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future serverGetCallSupportDetails() async {
    final String path = getCallSupportUrl;

    print('serverGetCallSupportDetails Response header: $path');

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print('serverGetCallSupportDetails Response header: $path');
      print(
          'serverGetCallSupportDetails Response status: ${response.statusCode}');
      print('serverGetCallSupportDetails Response body: ${response.body}');

      final json = jsonDecode(response.body);
      print('serverGetCallSupportDetails result: $json');
      print(json['status'].toString().contains("200"));
      if (response.statusCode != 200) {
        print("error: $json");
        result = ErrorModel.fromJson(json);
      } else if (json['status'].toString().contains("200")) {
        result = AboutProgramModel.fromJson(json);
      } else {
        result = ErrorModel.fromJson(json);
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  /// need to send 1 to startProgram
  Future startProgramOnSwipeApi(String startProgram) async {
    final path = startProgramOnSwipeUrl;

    Map<String, String> param = {
      'start_program': startProgram,
      'date': DateTime.now().toString()
    };

    final startTime = DateTime.now().millisecondsSinceEpoch;

    var result;

    try {
      print("param: $param");

      // final response = await httpClient.post(
      //   Uri.parse(path),
      //   body: param,
      // ).timeout(Duration(seconds: 45));

      var request = http.MultipartRequest('POST', Uri.parse(path));
      var headers = {
        "Authorization": getHeaderToken(),
      };
      request.headers.addAll(headers);

      request.fields.addAll(param);
      request.persistentConnection = false;

      // reportList.forEach((element) async {
      //   request.files.add(await http.MultipartFile.fromPath('files[]', element));
      // });

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 45));

      print("enquiryStatusApi response code:" + response.statusCode.toString());
      print("enquiryStatusApi response body:" + response.body);

      print("getAppointmentSlotListApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;

      print("response: $totalTime");

      final res = jsonDecode(response.body);

      print('${res['status'].runtimeType} ${res['status']}');

      if (response.statusCode != 200) {
        result = ErrorModel.fromJson(res);
      } else if (res['status'].toString() == '200') {
        result = StartProgramOnSwipeModel.fromJson(res);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error: ${e}");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  getChatGroupId() async {
    String path = chatGroupIdUrl;

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(path),
        headers: {
          // "Authorization": "Bearer ${AppConfig().bearerToken}",
          "Authorization": getHeaderToken(),
        },
      ).timeout(const Duration(seconds: 45));

      print('getChatGroupId Response header: $path');
      print('getChatGroupId Response status: ${response.statusCode}');
      print('getChatGroupId Response body: ${response.body}');

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['status'].toString() == '200') {
          result = GetChatGroupIdModel.fromJson(res);
        } else {
          result = ErrorModel(
              status: res['status'].toString(), message: res.toString());
        }
      } else {
        print('getChatGroupId error: ${response.reasonPhrase}');
        result = ErrorModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }

    return result;
  }

  Future startPostProgram() async {
    var url = startPostProgramUrl;

    dynamic result;

    try {
      final response = await httpClient.post(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('startPostProgram Response status: ${response.statusCode}');
      print('startPostProgram Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('startPostProgram result: $json');
        result = StartPostProgramModel.fromJson(json);
      } else {
        print('startPostProgram error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future submitPostProgramMealTrackingApi(
      String mealType, int selectedType, int? dayNumber) async {
    print("submit :");
    var url = submitPostProgramMealTrackingUrl;

    dynamic result;

    Map bodyParam = {
      'type': mealType.toString(),
      'follow_id': selectedType.toString(),
      'day': dayNumber.toString()
    };

    print('body: $bodyParam');
   // print("token: ${getHeaderToken()}");

    try {
      final response = await httpClient.post(Uri.parse(url),
          headers: {
            "Authorization": getHeaderToken(),
          },
          body: bodyParam
      );

      print(
          'submitPostProgramMealTrackingApi Response status: ${response.statusCode}');
      print('submitPostProgramMealTrackingApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('submitPostProgramMealTrackingApi result: $json');
        result = PostProgramBaseModel.fromJson(json);
      } else {
        print(
            'submitPostProgramMealTrackingApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  /// selectedType ==> breakfast/lunch/dinner
  Future getBreakfastOnclickApi(String day) async {
    var url = '$getBreakfastOnclickUrl/$day';

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('getBreakfastOnclickApi Response status: ${response.statusCode}');
      print('getBreakfastOnclickApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getBreakfastOnclickApi result: $json');
        result = GetProtocolBreakfastModel.fromJson(json);
      } else {
        print('getBreakfastOnclickApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getLunchOnclickApi(String day) async {
    var url = '$getLunchOnclickUrl/$day';

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('getLunchOnclickApi Response status: ${response.statusCode}');
      print('getLunchOnclickApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getLunchOnclickApi result: $json');
        result = GetProtocolBreakfastModel.fromJson(json);
      } else {
        print('getLunchOnclickApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getDinnerOnclickApi(String day) async {
    var url = '$getDinnerOnclickUrl/$day';

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('getDinnerOnclickApi Response status: ${response.statusCode}');
      print('getDinnerOnclickApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getDinnerOnclickApi result: $json');
        result = GetProtocolBreakfastModel.fromJson(json);
      } else {
        print('getDinnerOnclickApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getProtocolDayDetailsApi({String? dayNumber}) async {
    var url;
    if (dayNumber != null) {
      url = '$getProtocolDayDetailsUrl/$dayNumber';
    } else {
      url = getProtocolDayDetailsUrl;
    }

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('getProtocolDayDetailsApi Response status: ${response.statusCode}');
      print('getProtocolDayDetailsApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getProtocolDayDetailsApi result: $json');
        result = ProtocolGuideDayScoreModel.fromJson(json);
      } else {
        print('getProtocolDayDetailsApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future submitDoctorRequestedReportApi(String reportId, dynamic multipartFile) async {
    final path = submitDoctorRequestedReportUrl;

    var result;
    var startTime = DateTime.now().millisecondsSinceEpoch;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(path));
      var headers = {
        "Authorization": getHeaderToken(),
      };
      request.headers.addAll(headers);

      request.fields.addAll({
        'report_id': reportId
      });
      request.files.add(multipartFile);

      request.persistentConnection = false;


      // reportList.forEach((element) async {
      //   request.files.add(await http.MultipartFile.fromPath('files[]', element));
      // });

      var response = await http.Response.fromStream(await request.send())
          .timeout(Duration(seconds: 45));

      print("uploadReportApi response code:" + path);
      print("uploadReportApi response code:" + response.statusCode.toString());
      print("uploadReportApi response body:" + response.body);
      var totalTime = DateTime.now().millisecondsSinceEpoch - startTime;
      print(
          "start: $startTime end: ${DateTime.now().millisecondsSinceEpoch}  total: $totalTime");

      print("response Time:" + (totalTime / 1000).round().toString());

      final res = jsonDecode(response.body);
      print('${res['status'].runtimeType} ${res['status']}');
      if (res['status'].toString() == '200') {
        result = ReportUploadModel.fromJson(res);
      } else {
        result = ErrorModel.fromJson(res);
      }
    } catch (e) {
      print("catch error: ${e}");
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  Future doctorRequestedReportListApi() async {
    final String path = doctorRequestedReportListUrl;

    print('doctorRequestedReportListApi Response header: $path');
    dynamic result;

    try {
      final response = await httpClient
          .get(
        Uri.parse(path),
        headers: {
          "Authorization": getHeaderToken(),
        },
      )
          .timeout(const Duration(seconds: 45));

      print('doctorRequestedReportListApi Response header: $path');
      print('doctorRequestedReportListApi Response status: ${response.statusCode}');
      print('doctorRequestedReportListApi Response body: ${response.body}');
      final json = jsonDecode(response.body);

      print('doctorRequestedReportListApi result: $json');

      if (response.statusCode != 200) {
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      } else {
        if (json['status'] != 200) {
          result = ErrorModel.fromJson(json);
        } else {
          result = GetReportListModel.fromJson(json);
        }
      }
    } catch (e) {
      result = ErrorModel(status: "0", message: e.toString());
    }
    return result;
  }

  getNotificationListApi() async{
    String url = notificationListUrl;
    print(url);

    dynamic result;
    try{
      final response = await httpClient.get(Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      ).timeout(Duration(seconds: 45));

      print('getNotificationListApi Response status: ${response.statusCode}');
      print('getNotificationListApi Response body: ${response.body}');

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);

        if(json['status'].toString() == '200'){
          result = NotificationModel.fromJsonMap(json);
        }
        else{
          result = ErrorModel.fromJson(json);
        }
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getRewardPointsApi() async {
    var url = rewardPointsUrl;

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('getRewardPointsApi Response status: ${response.statusCode}');
      print('getRewardPointsApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getRewardPointsApi result: $json');
        result = RewardPointModel.fromJson(json);
      } else {
        print('getRewardPointsApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getRewardPointsStagesApi() async {
    var url = rewardPointsStagesUrl;

    dynamic result;

    try {
      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      print('getRewardPointsStagesApi Response status: ${response.statusCode}');
      print('getRewardPointsStagesApi Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('getRewardPointsStagesApi result: $json');
        result = RewardPointsStagesModel.fromJson(json);
      } else {
        print('getRewardPointsStagesApi error: ${response.reasonPhrase}');
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    } catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }

  Future getFaqListApi() async{
    String url= faqListUrl;
    dynamic result;

    try{
      final response = await httpClient.get(Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      );

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        print('getFaqListApi result: $json');


        if(json['status'].toString() == '200'){
          result = FaqListModel.fromJson(json);
        }
        else {
          print('getFaqListApi error: $json');
          result = ErrorModel.fromJson(json);
        }
      }
      else{
        result = ErrorModel(status: response.statusCode.toString(), message: response.body);
      }
    }
    catch(e){
      throw Exception(e);
    }
    return result;
  }

  Future getHomeDetailsApi() async{
    String url = getHomeDetailsUrl;
    dynamic result;

    try{
      final response = await httpClient.get(Uri.parse(url),
        headers: {
          "Authorization": getHeaderToken(),
        },
      ).timeout(Duration(seconds: 50));

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);

        if(json['status'].toString() == '200'){
          result = HomeScreenModel.fromJson(json);
        }
        else{
          result = ErrorModel.fromJson(json);
        }
      }
      else{
        result = ErrorModel(
            status: response.statusCode.toString(), message: response.body);
      }
    }
    catch (e) {
      print(e);
      result = ErrorModel(status: "", message: e.toString());
    }
    return result;
  }



  void storeShipRocketToken(ShipRocketTokenModel result) {
    _prefs!.setString(AppConfig().shipRocketBearer, result.token ?? '');
  }
}
