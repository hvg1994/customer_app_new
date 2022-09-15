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

  static const String isLogin = "login";
  final String deviceId = "deviceId";
  final String registerOTP = "R_OTP";
  final String tokenUser = 'token';
  String bearerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYWI0M2RlY2NlMGExMTQyNmMzN2IwZGRkZTMxZGM3N2U3YjNjODVmY2JlNGJjNTk5NDMwNzhiM2JkMDkzYTQzYTI1OTA1Mzk4ZGI4NTRiNWYiLCJpYXQiOjE2NjI3MDExMjEuODYyNzgxLCJuYmYiOjE2NjI3MDExMjEuODYyNzgzLCJleHAiOjE2OTQyMzcxMjEuODYwNzI3LCJzdWIiOiI0NiIsInNjb3BlcyI6W119.G2j2u_5GPeA4qaZtydxb3PBHpePYnmqKeOIBF80es_Hm0lo3NeE0URatUjO8sdiQM-nFuxqO9sk9xiDxk3ONu1zTC23whWhNTm59iDUlxd0CIQZHgOx0blVjNnZYK10dRSkoGafk8GI9i9gYVl1no4ImIch_dBhb92VWPlIJ7ZHk2S1Mvrm5wM9WKObPK3-V1SNu3m2BGYli2DBz-9LEvF3SI3TSmLShFybH6n4xddJYzhZuz73xryQghvKBOGvg9RoXKDHPY0ofkdSzHJVJ5h44PuXDcMUOMTNFUospfmPKq31By9dA7EnKQ6Upnv8x4QhH005Xcpf4FFU1SANDTk--bj_bOgUcB2kvWirzZpQ5r3kqsL8B251Nft0lk4kv5ECqq5HDNM8fzfQL8T7fapcTzniht003XHphxHUPyfRpUELfMLRAz_clQCmCTqXfwFPAeEc74CeHIHXhS2k7pURbG1kdhfgRmI5VXc1e1OPt1RtBM6aBWLdlvlDbQOyBvVbHOVaAy2j8hhjKFT8NUOawpRNsms5kG0EtUKOl-0XXnGhzOPbGQhR1MW6DbiEilaK5m3iNOw4kIs0L594KcrSEoxabKKOiw5NyxI1SO1eYIS8629gvDi8gDM4BlYw_SEMRFBLOMOgw8rX9ok6OVIKe6NiL_8dgqWAySZtVPaM";
  late String bearer = '';

  static String slotErrorText = "Slots Not Available Please select different day";
  static String networkErrorText = "Network Error! Please Retry..";

  static const String isSmallMode = "isShrunk";

  final String program_days = "no_of_days";

  static const String consultationComplete = "IS_COMPLETED";

  static String appointmentId = "appoint_id";

  //---Razorpay secret keys -----------------
  static const KEY_ID = "rzp_test_mGdJGjZKpJswFa";
  static const SECRET_KEY = "A9AgMVJOVRe1199AiprO0n7u";
  // ------------------END ------------

  SharedPreferences? preferences;
  Future<String?> getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId;
  }

  showSnackbar(BuildContext context, String message,{int? duration, bool? isError}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:(isError == null || isError == false) ? gPrimaryColor : Colors.redAccent,
        content: Text(message),
        duration: Duration(seconds: duration ?? 2),
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