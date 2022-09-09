import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/ship_track_model/ship_track_activity_model.dart';
import '../widgets/constants.dart';

class AppConfig{
  static AppConfig? _instance;
  factory AppConfig() => _instance ??= AppConfig._();
  AppConfig._();

  final String BASE_URL = "https://gwc.disol.in";
  final String shipRocket_AWB_URL = 'https://apiv2.shiprocket.in/v1/external/courier/track/awb';
  final String UUID = 'uuid';

  final String BEARER_TOKEN = "Bearer";

  final String deviceId = "deviceId";
  final String registerOTP = "R_OTP";
  final String tokenUser = 'token';
  String bearerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMzlkMTg0Yjk0NTE3MDE2YWE4YzBhZmIzNmEzYjU5NWQ5ZDE4NmIwN2RjNmJmZjhlMzA2NDNkZjYxNzIxNDQ0N2M1M2ZkYjI3ZjAzMzJiMjUiLCJpYXQiOjE2NTkwNzM5NDguMjI1NDY3LCJuYmYiOjE2NTkwNzM5NDguMjI1NDY5LCJleHAiOjE2OTA2MDk5NDguMjIzNTkyLCJzdWIiOiIzMiIsInNjb3BlcyI6W119.AFBwNxPiZbviR4iKlLCl5GiuoOVyChEOGIkDNKqd8OqzNTKZYo12NnwgNVhsVclIGkgkwb3N0a_rG_bWmUihu3UMfOEzo8TWdtrgJlBZauI5qX2C6eTLyCvC70jgj22X4R6vE5m7ef2gncyAZJWnmEoTU4PhQt4XSS6Lb24xDKkJ4hNeDxO49hrMSjh5Gusjq9rPU17QJa0-jTCDwS63ZUYXjicw2j48sEz6k0MnF5WaV0m7Lqp0-uf7Z4SlieBxjStCAz9gCCSDfoJvnptEWWbOpPq_GW7EvI-1qNwThjvIuUnb77BCIQdyOsYDUurrS8gI5AueIlD_hX4sSPWU3BECUi6senj1cjTDbX_L4prnz6J8tz2LNB9f8vAM1F6Nwlm_ibbdN3c3NYXQUyjSz2erXHdFPQQbJF5x8Ck9aD96eVPI0ByZk-syNV5GApUmVA_aSROnSVnjr39nm1sPfS5EPjnjjDnzfDJTB-haE2Fw_DQir7yMyovhN4bywjojlggeRUVWqgeG8HPeza49z3ErPSObXPbgxBEbnQ0RPiZFWCKIoZN8A9qZ5rVnA4KXVDiLH8yLjdHdT2kBJawcTPO_Fu8yXYyNPBFoGEIDdLFfp_3Bsv28ms8LBN8VHx4CR9_EQyIqGBZkrMlDxs-ydusujeV6MUReSK7z8a0-FTw";
  late String bearer = '';

  static String slotErrorText = "Slots Not Available Please select different day";
  static String networkErrorText = "Network Error! Please Retry..";

  static const String isSmallMode = "isShrunk";

  final String program_days = "no_of_days";

  static String appointmentId = "appoint_id";
  static String doctorId = "doctor_id";

  //---Razorpay secret keys -----------------
  static const KEY_ID = "rzp_test_mGdJGjZKpJswFa";
  static const SECRET_KEY = "A9AgMVJOVRe1199AiprO0n7u";
  // ------------------END ------------

  SharedPreferences? preferences;
  Future<String?> getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId;
  }

  showSnackbar(BuildContext context, String message,{Duration? duration, bool? isError}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:(isError == null || isError == false) ? gPrimaryColor : Colors.redAccent,
        content: Text(message),
        duration: duration ?? Duration(seconds: 2),
      ),
    );
  }
  fixedSnackbar(BuildContext context, String message,String btnName, onPress, {Duration? duration, bool? isError}){
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor:(isError == null || isError == false) ? gPrimaryColor : Colors.redAccent,
        content: Text(message),
        actions: [
          TextButton(
              onPressed: onPress,
              child: Text(btnName)
          )
        ],
      ),
    );
  }


  // List<ShipmentTrackActivities> trackingList = [
  //   ...trackJson.map((e) => ShipmentTrackActivities.fromJson(e))
  // ];

  String shipRocketToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjI5NTcyMzEsImlzcyI6Imh0dHBzOi8vYXBpdjIuc2hpcHJvY2tldC5pbi92MS9leHRlcm5hbC9hdXRoL2xvZ2luIiwiaWF0IjoxNjYyNDQxMTQxLCJleHAiOjE2NjMzMDUxNDEsIm5iZiI6MTY2MjQ0MTE0MSwianRpIjoicG84WVZ2NWJUNzZuUjNGaSJ9.3GmwDELJn7WhhmKCP5L5dWCOYbVrR8fI6-3VAEecAUs';
}