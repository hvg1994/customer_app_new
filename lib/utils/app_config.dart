import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../model/ship_track_model/ship_track_activity_model.dart';
import '../widgets/constants.dart';
import 'package:get/get.dart';

class AppConfig{
  static AppConfig? instance;
  factory AppConfig() => instance ??= AppConfig._();
  AppConfig._();

  final String BASE_URL = "https://gwc.disol.in";

  // final String BASE_URL = "https://gutandhealth.com";

  final String shipRocket_AWB_URL = 'https://apiv2.shiprocket.in/v1/external';
  final String UUID = 'uuid';

  final String BEARER_TOKEN = "Bearer";

  // ****** QuickBlox Credentials ****************

  // static const String QB_APP_ID = "98585";
  // static const String QB_AUTH_KEY = "aPtW8zaYg-Qmhf9";
  // static const String QB_AUTH_SECRET = "MDvw-kpzNRGVLt4";
  // static const String QB_ACCOUNT_KEY = "1s1UERbtsu13uQFYVF9Y";
  static const String QB_APP_ID = "99437";
  static const String QB_AUTH_KEY = "zhVfP2jWfvrhe2r";
  static const String QB_AUTH_SECRET = "WhzcEcT3tau5Mfj";
  static const String QB_ACCOUNT_KEY = "dj8Pc_dxe2u4K8x9CzRj";
  static const String QB_DEFAULT_PASSWORD = "GWC@2022";

  static const String GROUP_ID = 'groupId';
  static const String QB_CURRENT_USERID = 'curr_userId';
  static const String GET_QB_SESSION = 'qb_session';
  static const String IS_QB_LOGIN = 'is_qb_login';


  static const String QB_USERNAME = 'qb_username';


  // ************** END **************************


  final String shipRocketBearer = "ShipToken";
  final String shipRocketEmail = "bhogesh@fembuddy.com";
  final String shipRocketPassword = "adithya7224";


  final String trackerVideoUrl = "tracker_meal_video";
  final String receipeVideoUrl = "reciepe_meal_video";

  /// to getlocal dashboard data which used in notification screen
  static const String LOCAL_DASHBOARD_DATA = "local_dashboard_data";


  static const String isFirstTime = "isFirstTime";

  static const String isLogin = "login";
  static const String EVAL_STATUS = 'eval_status';
  static const String last_login = "last_login";
  static const String FCM_TOKEN = "fcm_token";
  static const String SHIPPING_ADDRESS = "ship_address";
  static const String User_Name = "userName";
  static const String USER_ID = "userId";
  static const String User_Profile ="userProfile";
  static const String User_Number = "userNumber";
  /// this is for making direct voice call to success team
  static const String KALEYRA_SUCCESS_ID = "kaleyra_success_id";
  static const String KALEYRA_ACCESS_TOKEN = "kaleyra_access_token";
  static const String KALEYRA_USER_ID = 'kaleyra_uid';

  static const String KALEYRA_CHAT_SUCCESS_ID = 'kaleyra_chat_success_id';




  static const String countryCode = "COUNTRY_CODE";
  static const String countryName = "COUNTRY_NAME";

  // *** firebase ***
  static const String notification_channelId = 'high_importance_channel';
  static const String notification_channelName = 'pushnotificationappchannel';




  /// this is for showing text in meal plan screen proceed to day text
  static const String STORE_LENGTH = 'ChildProgramDayModel_Length';

  final String deviceId = "deviceId";
  final String registerOTP = "R_OTP";
  String bearerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiM2Q4ZTI5ZWUzODUyMGExNDI1ODJlMTg1ZjcwMDc3MDJjNjcwMTJjYWI4NDM5NDE5MmM0OGMwNWQ2MzY5YjgwZDJlN2JkYTUzOThmNjZlNzYiLCJpYXQiOjE2NjMzMDk2NDYuNDQxNDU5LCJuYmYiOjE2NjMzMDk2NDYuNDQxNDYyLCJleHAiOjE2OTQ4NDU2NDYuNDM4NjkxLCJzdWIiOiI1NCIsInNjb3BlcyI6W119.z902_OuP_C5c8kAUlMcVmoWaxV_efjpxQIC78Pfh2KciFOazqbX5O2xN8Bld_NurPn4u1_p_mzYcbGCFOrwnIYPtIWtOzeq7TqfZ1g64peCdGij6dntuWFR2aFEAuxUxQ4ZdOW1iNazSkmhKPQq7NBTTii3cbfJaZh8suMDApW8uC7imh2a55vFVAvykfwkC-Nnb4UlbhiunoVKXeyIkUPBlUzlt-CvrYBjOTgbd-UTVCEX2hbTCnSHatLuPFv1CpeZkCnb4SGJZgeqbE8AsBl9snTvMQ_lXSwhMla-AJjQS0oCWYJJrxe_n3tj8MvFLo9HGQORMmXYrUMFMjEX9kQCFb6I_gmwvU5yvCYNjgNuZCO99dLX-HBAFiXopScnYhpSlUu2EQbC5d5OT7nrYuGK0Vq8FTFNTQJ1rYS3jKOMERUilxnAqHoakHCOVGqdSCZ8zb5DWn_dYxpFD4bfSaU_GZbXXtuv9pRmoEP_XZygkJJNp_85N2f0g_nV3uEQ6-Xsx-7IFs0MA6KNFRyT0N6cH1y-JGRc_2PTkSpVTvVWh2oDkmCdf1hfheLAA1ZWMB3Y6ck-kDYa4MN7YyOJbEUFW7AIrSUWfLVmQNZhz88ZDw5N8RaOQ0FQP6tvBjaRT_Uj2kyyGzYHFdMUeYsnmzdRhDzji_KU87jF82XIMPCA";
  late String bearer = '';

  static String slotErrorText = "Slots Not Available Please select different day";
  static String networkErrorText = "Network Error! Please Retry..";
  static String oopsMessage = "OOps ! Something went wrong.";

  static String numberNotFound = "Mobile Number not found";

  static const String isSmallMode = "isShrunk";

  String emptyStringMsg = 'Please mention atleast 2 characters';


  final String program_days = "no_of_days";


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

  showSnackbar(BuildContext context, String message,{int? duration, bool? isError, SnackBarAction? action, double? bottomPadding}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:(isError == null || isError == false) ? gPrimaryColor : gsecondaryColor.withOpacity(0.55),
        content: Text(message),
        margin: (bottomPadding != null) ? EdgeInsets.only(bottom: bottomPadding) : null,
        duration: Duration(seconds: duration ?? 3),
        action: action,
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

  showSheet(BuildContext context, Widget widget,
      {bool sheetForLogin = false,double? bottomSheetHeight,
        String? circleIcon, Color? topColor, bool isSheetCloseNeeded = false,
        VoidCallback? sheetCloseOnTap, bool isDismissible = false}){
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: isDismissible,
        enableDrag: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return (sheetForLogin)
              ? AnimatedPadding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          duration: const Duration(milliseconds: 100),
            child: commonBottomSheetView(context, widget,
              bottomSheetHeight: bottomSheetHeight, circleIcon: circleIcon, topColor: topColor, sheetForLogin: true),
          )
              : commonBottomSheetView(context, widget,
            bottomSheetHeight: bottomSheetHeight, circleIcon: circleIcon, topColor: topColor, isSheetCloseNeeded: isSheetCloseNeeded,sheetCloseOnTap: sheetCloseOnTap
          );
        }
    );
  }

  commonBottomSheetView(BuildContext context, Widget widget,
      {bool sheetForLogin = false,double? bottomSheetHeight,
        String? circleIcon, Color? topColor,
        bool isSheetCloseNeeded = false, VoidCallback? sheetCloseOnTap}){
    return Container(
      decoration: const BoxDecoration(
        color: gBackgroundColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22)
        ),
      ),
      padding: (sheetForLogin) ? null : EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      height: bottomSheetHeight ?? 50.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Container(
                height: 15.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: topColor ?? kBottomSheetHeadYellow,
                ),
                child: Center(
                  child: Image.asset(bsHeadStarsIcon,
                    alignment: Alignment.topRight,
                    fit: BoxFit.scaleDown,
                    width: 30.w,
                    height: 10.h,
                  ),
                ),
              ),
              SizedBox(
                height: 7.h,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: widget,
                ),
              )

            ],
          ),
          Positioned(
              top: 8.h,
              left: 5,
              right: 5,
              child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(blurRadius: 5, color: gHintTextColor.withOpacity(0.8))
                    ],
                  ),
                  child: CircleAvatar(
                    maxRadius: 40.sp,
                    backgroundColor: kBottomSheetHeadCircleColor,
                    child: Image.asset(circleIcon ?? bsHeadBellIcon,
                      fit: BoxFit.scaleDown,
                      width: 45,
                      height: 45,
                    ),
                  )
              )
          ),
          Visibility(
            visible: isSheetCloseNeeded,
            child: Positioned(
              top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: sheetCloseOnTap ?? (){},
                    child: Icon(Icons.cancel_outlined, color: gsecondaryColor,size: 28,))),
          )
        ],
      ),
    );
  }

  // List<ShipmentTrackActivities> trackingList = [
  //   ...trackJson.map((e) => ShipmentTrackActivities.fromJson(e))
  // ];

  /// dummy token
  String shipRocketToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjI5NTcyMzEsImlzcyI6Imh0dHBzOi8vYXBpdjIuc2hpcHJvY2tldC5pbi92MS9leHRlcm5hbC9hdXRoL2xvZ2luIiwiaWF0IjoxNjYzODQ2ODM2LCJleHAiOjE2NjQ3MTA4MzYsIm5iZiI6MTY2Mzg0NjgzNiwianRpIjoidVJHclM0dk83cm9IbllhNiJ9.meifEzRi4u4sAVceDvY-Pyy71TO0K3kYGxnrwtiAQNE';
}