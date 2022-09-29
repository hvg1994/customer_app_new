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
  final String shipRocket_AWB_URL = 'https://apiv2.shiprocket.in/v1/external';
  final String UUID = 'uuid';

  final String BEARER_TOKEN = "Bearer";

  final String shipRocketBearer = "ShipToken";
  final String shipRocketEmail = "bhogesh@fembuddy.com";
  final String shipRocketPassword = "adithya7224";



  static const String isLogin = "login";
  static const String EVAL_STATUS = 'eval_status';
  static const String last_login = "last_login";


  /// this is for showing text in meal plan screen proceed to day text
  static const String STORE_LENGTH = 'ChildProgramDayModel_Length';

  final String deviceId = "deviceId";
  final String registerOTP = "R_OTP";
  String bearerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiM2Q4ZTI5ZWUzODUyMGExNDI1ODJlMTg1ZjcwMDc3MDJjNjcwMTJjYWI4NDM5NDE5MmM0OGMwNWQ2MzY5YjgwZDJlN2JkYTUzOThmNjZlNzYiLCJpYXQiOjE2NjMzMDk2NDYuNDQxNDU5LCJuYmYiOjE2NjMzMDk2NDYuNDQxNDYyLCJleHAiOjE2OTQ4NDU2NDYuNDM4NjkxLCJzdWIiOiI1NCIsInNjb3BlcyI6W119.z902_OuP_C5c8kAUlMcVmoWaxV_efjpxQIC78Pfh2KciFOazqbX5O2xN8Bld_NurPn4u1_p_mzYcbGCFOrwnIYPtIWtOzeq7TqfZ1g64peCdGij6dntuWFR2aFEAuxUxQ4ZdOW1iNazSkmhKPQq7NBTTii3cbfJaZh8suMDApW8uC7imh2a55vFVAvykfwkC-Nnb4UlbhiunoVKXeyIkUPBlUzlt-CvrYBjOTgbd-UTVCEX2hbTCnSHatLuPFv1CpeZkCnb4SGJZgeqbE8AsBl9snTvMQ_lXSwhMla-AJjQS0oCWYJJrxe_n3tj8MvFLo9HGQORMmXYrUMFMjEX9kQCFb6I_gmwvU5yvCYNjgNuZCO99dLX-HBAFiXopScnYhpSlUu2EQbC5d5OT7nrYuGK0Vq8FTFNTQJ1rYS3jKOMERUilxnAqHoakHCOVGqdSCZ8zb5DWn_dYxpFD4bfSaU_GZbXXtuv9pRmoEP_XZygkJJNp_85N2f0g_nV3uEQ6-Xsx-7IFs0MA6KNFRyT0N6cH1y-JGRc_2PTkSpVTvVWh2oDkmCdf1hfheLAA1ZWMB3Y6ck-kDYa4MN7YyOJbEUFW7AIrSUWfLVmQNZhz88ZDw5N8RaOQ0FQP6tvBjaRT_Uj2kyyGzYHFdMUeYsnmzdRhDzji_KU87jF82XIMPCA";
  late String bearer = '';

  static String slotErrorText = "Slots Not Available Please select different day";
  static String networkErrorText = "Network Error! Please Retry..";

  static const String isSmallMode = "isShrunk";

  String emptyStringMsg = 'Please mention atleast 2 characters';


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

  String shipRocketToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjI5NTcyMzEsImlzcyI6Imh0dHBzOi8vYXBpdjIuc2hpcHJvY2tldC5pbi92MS9leHRlcm5hbC9hdXRoL2xvZ2luIiwiaWF0IjoxNjYzODQ2ODM2LCJleHAiOjE2NjQ3MTA4MzYsIm5iZiI6MTY2Mzg0NjgzNiwianRpIjoidVJHclM0dk83cm9IbllhNiJ9.meifEzRi4u4sAVceDvY-Pyy71TO0K3kYGxnrwtiAQNE';
}