import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/login_model/resend_otp_model.dart';
import 'package:gwc_customer/repository/login_otp_repository.dart';
import 'package:gwc_customer/screens/evalution_form/evaluation_form_screen.dart';
import 'package:gwc_customer/screens/help_screens/help_screen.dart';
import 'package:gwc_customer/screens/profile_screens/call_support_method.dart';
import 'package:gwc_customer/screens/user_registration/resend_otp_screen.dart';
import 'package:gwc_customer/services/login_otp_service.dart';
import 'package:gwc_customer/services/quick_blox_service/quick_blox_service.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/unfocus_widget.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:gwc_customer/widgets/will_pop_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:gwc_customer/repository/api_service.dart';
import '../../model/evaluation_from_models/get_evaluation_model/child_get_evaluation_data_model.dart';
import '../../model/evaluation_from_models/get_evaluation_model/get_evaluationdata_model.dart';
import '../../model/login_model/login_otp_model.dart';
import '../../model/profile_model/user_profile/user_profile_model.dart';
import '../../repository/evaluation_form_repository/evanluation_form_repo.dart';
import '../../repository/profile_repository/get_user_profile_repo.dart';
import '../../services/evaluation_fome_service/evaluation_form_service.dart';
import '../../services/profile_screen_service/user_profile_service.dart';
import '../dashboard_screen.dart';
import 'new_user/choose_your_problem_screen.dart';
import 'package:gwc_customer/widgets/dart_extensions.dart';
import 'package:pinput/pinput.dart';

enum EvaluationStatus { evaluation_done, no_evaluation }

class ExistingUser extends StatefulWidget {
  const ExistingUser({Key? key}) : super(key: key);

  @override
  State<ExistingUser> createState() => _ExistingUserState();
}

class _ExistingUserState extends State<ExistingUser> {
  final formKey = GlobalKey<FormState>();
  final mobileFormKey = GlobalKey<FormState>();
  late FocusNode _phoneFocus;

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final focusNode = FocusNode();

  late bool otpVisibility;

  String countryCode = '+91';

  bool otpSent = false;
  bool showOpenBottomSheetProgress = false;
  bool showLoginProgress = false;

  String otpMessage = "Sending OTP";

  late Future getOtpFuture, loginFuture;

  late LoginWithOtpService _loginWithOtpService;

  final SharedPreferences _pref = AppConfig().preferences!;

  Timer? _timer;
  int _resendTimer = 0;
  bool isSheetOpen = false;
  late Function bottomsheetSetState;

  bool enableResendOtp = false;

  void startTimer() {
    _resendTimer = 60;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
       if(isSheetOpen){
         if (_resendTimer == 0) {
           bottomsheetSetState(() {
             timer.cancel();
             enableResendOtp = true;
           });
         } else {
           bottomsheetSetState(() {
             _resendTimer--;
           });
         }
       }
       else{
         _resendTimer--;
       }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loginWithOtpService = LoginWithOtpService(repository: repository);
    otpVisibility = false;
    _phoneFocus = FocusNode();

    phoneController.addListener(() {
      setState(() {});
    });
    otpController.addListener(() {
      setState(() {});
    });
    _phoneFocus.addListener(() {
      if (!_phoneFocus.hasFocus) {
        mobileFormKey.currentState!.validate();
      }
      // print("!_phoneFocus.hasFocus: ${_phoneFocus.hasFocus}");
      //
      // if(isPhone(phoneController.text) && !_phoneFocus.hasFocus){
      //   getOtp(phoneController.text);
      // }
      // print(_phoneFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
    _phoneFocus.removeListener(() {});
    phoneController.dispose();
    otpController.dispose();
    otpController.removeListener(() {});
  }

  bottomSheetHeight() {
    if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
      return 70.h;
    } else {
      return 50.h;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      child: UnfocusWidget(
        child: Scaffold(
            body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 50.h,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    // image: DecorationImage(
                    //     image: AssetImage("assets/images/Mask Group 2.png"),
                    //     fit: BoxFit.fill),
                    ),
                child: Center(
                  child: Image(
                    fit: BoxFit.fill,
                    height: 15.h,
                    width: 80.w,
                    image: const AssetImage(
                      "assets/images/Gut welness logo.png",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              buildForms(),
            ],
          ),
        )),
      ),
    );
  }

  buildForms() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Existing User',
                  style: TextStyle(
                      fontFamily: eUser().mainHeadingFont,
                      fontSize: eUser().mainHeadingFontSize,
                      color: eUser().mainHeadingColor),
                ),
                Expanded(
                  child: Container(
                    height: 1.0,
                    color: kLineColor,
                    margin: EdgeInsets.symmetric(
                      horizontal: 1.5.w,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              "Mobile Number",
              style: TextStyle(
                  fontFamily: eUser().userFieldLabelFont,
                  fontSize: eUser().userFieldLabelFontSize,
                  color: eUser().userFieldLabelColor),
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: false,
                  child: CountryCodePicker(
                    // flagDecoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(7),
                    // ),
                    showDropDownButton: false,
                    showFlagDialog: true,
                    hideMainText: false,
                    showFlagMain: false,
                    showCountryOnly: true,
                    textStyle: TextStyle(
                        fontFamily: "GothamBook",
                        color: gMainColor,
                        fontSize: 11.sp),
                    padding: EdgeInsets.zero,
                    favorite: ['+91', 'IN'],
                    initialSelection: countryCode,
                    onChanged: (val) {
                      print(val.code);
                      setState(() {
                        countryCode = val.dialCode.toString();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Form(
                    autovalidateMode: AutovalidateMode.disabled,
                    key: mobileFormKey,
                    child: TextFormField(
                      cursorColor: gPrimaryColor,
                      textAlignVertical: TextAlignVertical.center,
                      maxLength: 10,
                      controller: phoneController,
                      style: TextStyle(
                          fontFamily: eUser().userTextFieldFont,
                          fontSize: eUser().userTextFieldFontSize,
                          color: eUser().userTextFieldColor),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Mobile Number';
                        } else if (!isPhone(value)) {
                          return 'Please enter valid Mobile Number';
                        } else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (value) {
                        print("isPhone(value): ${isPhone(value)}");
                        print("!_phoneFocus.hasFocus: ${_phoneFocus.hasFocus}");
                        if (isPhone(value) && _phoneFocus.hasFocus) {
                          // getOtp(value);
                          _phoneFocus.unfocus();
                        }
                      },
                      focusNode: _phoneFocus,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: eUser().focusedBorderColor,
                                width: eUser().focusedBorderWidth)
                            // borderRadius: BorderRadius.circular(25.0),
                            ),
                        enabledBorder: (phoneController.text.isEmpty)
                            ? null
                            : UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: eUser().focusedBorderColor,
                                    width: eUser().focusedBorderWidth)),
                        isDense: true,
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(horizontal: 2),
                        suffixIcon: (phoneController.text.length != 10 &&
                                phoneController.text.length > 0)
                            ? InkWell(
                                onTap: () {
                                  phoneController.clear();
                                },
                                child: const Icon(
                                  Icons.cancel_outlined,
                                  color: gMainColor,
                                ),
                              )
                            : (phoneController.text.length == 10)
                                ? Icon(
                                    Icons.check_circle_outline,
                                    color: gPrimaryColor,
                                    size: 2.h,
                                  )
                                : const SizedBox(),
                        // (phoneController.text.length == 10 &&
                        //             isPhone(phoneController.text))
                        //         ? GestureDetector(
                        //             onTap: (otpMessage
                        //                     .toLowerCase()
                        //                     .contains('otp sent'))
                        //                 ? null
                        //                 : () {
                        //                     if (isPhone(phoneController.text) &&
                        //                         _phoneFocus.hasFocus) {
                        //                       getOtp(phoneController.text);
                        //                     }
                        //                   },
                        //             child: Row(
                        //               mainAxisSize: MainAxisSize.min,
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.center,
                        //               children: [
                        //                 Visibility(
                        //                   visible: !(otpMessage
                        //                       .toLowerCase()
                        //                       .contains('otp sent')),
                        //                   child: Text(
                        //                     'Get OTP',
                        //                     textAlign: TextAlign.center,
                        //                     style: TextStyle(
                        //                       fontFamily:
                        //                           eUser().fieldSuffixTextFont,
                        //                       color:
                        //                           eUser().fieldSuffixTextColor,
                        //                       fontSize: eUser()
                        //                           .fieldSuffixTextFontSize,
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 Icon(
                        //                   (otpMessage
                        //                           .toLowerCase()
                        //                           .contains('otp sent'))
                        //                       ? Icons.check_circle_outline
                        //                       : Icons.keyboard_arrow_right,
                        //                   color: gPrimaryColor,
                        //                   size: 22,
                        //                 ),
                        //               ],
                        //             ),
                        //             // child: Icon(
                        //             //   (otpMessage.toLowerCase().contains('otp sent')) ? Icons.check_circle_outline : Icons.keyboard_arrow_right,
                        //             //   color: gPrimaryColor,
                        //             //   size: 22,
                        //             // ),
                        //           )
                        //         : SizedBox(),
                        hintText: "Mobile Number",
                        hintStyle: TextStyle(
                          fontFamily: eUser().userTextFieldHintFont,
                          color: eUser().userTextFieldHintColor,
                          fontSize: eUser().userTextFieldHintFontSize,
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Center(
              child: GestureDetector(
                // onTap: (showLoginProgress) ? null : () {
                onTap: () {
                  if(showOpenBottomSheetProgress){

                  }
                  else{
                    if (mobileFormKey.currentState!.validate()) {
                      if (isPhone(phoneController.text)) {
                        print("ifff");
                        setState(() {
                          showOpenBottomSheetProgress = true;
                        });
                        getOtp(phoneController.text);
                      }
                    }
                    else {
                      AppConfig().showSnackbar(
                          context, 'Enter your Mobile Number',
                          isError: true);
                    }
                  }
                      },
                child: Container(
                  width: 40.w,
                  height: 5.h,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: (phoneController.text.isEmpty ||
                            otpController.text.isEmpty)
                        ? eUser().buttonColor
                        : eUser().buttonColor,
                    borderRadius:
                        BorderRadius.circular(eUser().buttonBorderRadius),
                    // border: Border.all(
                    //     color: eUser().buttonBorderColor,
                    //     width: eUser().buttonBorderWidth
                    // ),
                  ),
                  child: (showOpenBottomSheetProgress)
                      ? buildThreeBounceIndicator(
                          color: eUser().threeBounceIndicatorColor)
                      : Center(
                          child: Text(
                            'GET OTP',
                            style: TextStyle(
                              fontFamily: eUser().buttonTextFont,
                              color: (phoneController.text.isEmpty ||
                                      otpController.text.isEmpty)
                                  ? eUser().buttonTextColor
                                  : eUser().buttonTextColor,
                              fontSize: eUser().buttonTextSize,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Center(
                child: Text(
                  "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    fontFamily: eUser().loginDummyTextFont,
                    color: eUser().loginDummyTextColor,
                    fontSize: eUser().loginDummyTextFontSize,
                  ),
                ),
              ),
            ),
            // Center(
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(
            //           builder: (context) => const ChooseYourProblemScreen(),
            //         ),
            //       );
            //     },
            //     child: Container(
            //       margin: EdgeInsets.symmetric(vertical: 4.h),
            //       padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(30),
            //         border: Border.all(color: gsecondaryColor, width: 1.5),
            //       ),
            //       child: Text(
            //         'New User',
            //         style: TextStyle(
            //           fontFamily: "GothamRoundedBold_21016",
            //           color: Colors.black87.withOpacity(0.7),
            //           fontSize: 10.sp,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),,
            SizedBox(height: 8.h),
            Center(
              child: RichText(
                  text: TextSpan(
                      text: "Don't have an Account? ",
                      style: TextStyle(
                        height: 1.5,
                        fontFamily: eUser().anAccountTextFont,
                        color: eUser().anAccountTextColor,
                        fontSize: eUser().anAccountTextFontSize,
                      ),
                      children: [
                    TextSpan(
                        text: 'Signup',
                        style: TextStyle(
                          height: 1.5,
                          fontFamily: eUser().loginSignupTextFont,
                          color: eUser().loginSignupTextColor,
                          fontSize: eUser().loginSignupTextFontSize,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChooseYourProblemScreen(),
                              ),
                            );
                          })
                  ])),
            )
          ],
        ),
      ),
    );
  }

  buildGetOTP(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 50,
      textStyle: TextStyle(
        fontFamily: eUser().anAccountTextFont,
        color: eUser().loginDummyTextColor,
        fontSize: eUser().loginSignupTextFontSize,
      ),
      decoration: BoxDecoration(
        color: gGreyColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
      ),
    );
    startTimer();
    return AppConfig().showSheet(context,
        StatefulBuilder(
            builder: (_, setstate){
              bottomsheetSetState = setstate;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text("SECURE WITH PIN OR\nVERIFY YOUR PHONE NUMBER",
                      style: TextStyle(
                          fontSize: bottomSheetHeadingFontSize,
                          fontFamily: bottomSheetHeadingFontFamily,
                          height: 1.4
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: kLineColor,
                      thickness: 1.2,
                    ),
                  ),
                  // Visibility(
                  //     visible: otpSent, child: SizedBox(height: 1.h)),
                  // Visibility(
                  //   visible: otpSent,
                  //   child: Text(
                  //     otpMessage,
                  //     style: TextStyle(
                  //         fontFamily: kFontMedium,
                  //         color: gPrimaryColor,
                  //         fontSize: 8.5.sp),
                  //   ),
                  // ),
                  SizedBox(height: 5.h),
                  Center(
                    child: Pinput(
                      controller: otpController,
                      length: 6,
                      focusNode: focusNode,
                      androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsUserConsentApi,
                      listenForMultipleSmsOnAndroid: true,
                      defaultPinTheme: defaultPinTheme,
                      validator: (value) {
                        return value == otpController.text
                            ? null
                            : 'Pin is incorrect';
                      },
                      // onClipboardFound: (value) {
                      //   debugPrint('onClipboardFound: $value');
                      //   pinController.setText(value);
                      // },
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        debugPrint('onCompleted: $pin');
                      },
                      onChanged: (value) {
                        debugPrint('onChanged: $value');
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 22,
                            height: 1,
                            color: eUser().loginDummyTextColor,
                          ),
                        ],
                      ),
                      // focusedPinTheme: defaultPinTheme.copyWith(
                      //   decoration: defaultPinTheme.decoration!.copyWith(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: gPrimaryColor),
                      //   ),
                      // ),
                      // submittedPinTheme: defaultPinTheme.copyWith(
                      //   decoration: defaultPinTheme.decoration!.copyWith(
                      //     color: gGreyColor,
                      //     borderRadius: BorderRadius.circular(19),
                      //     border: Border.all(color: gPrimaryColor),
                      //   ),
                      // ),
                      // errorPinTheme: defaultPinTheme.copyBorderWith(
                      //   border: Border.all(color: Colors.redAccent),
                      // ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Visibility(
                    visible: _resendTimer != 0,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.timelapse_rounded,
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(_resendTimer.toString(),
                                style: TextStyle(
                                  fontFamily: eUser().resendOtpFont,
                                  color: eUser().resendOtpFontColor,
                                  fontSize: eUser().resendOtpFontSize,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: Text(
                      "Didn't receive an OTP?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decorationThickness: 3,
                        // decoration: TextDecoration.underline,
                        fontFamily: eUser().userTextFieldHintFont,
                        color: (_resendTimer != 0 || !enableResendOtp)
                            ? eUser().userTextFieldHintColor
                            : eUser().resendOtpFontColor,
                        fontSize: eUser().userTextFieldFontSize,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: GestureDetector(
                      onTap: (_resendTimer != 0 || !enableResendOtp)
                          ? null
                          : () {
                        getOtp(phoneController.text);
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => ResendOtpScreen()));
                      },
                      child: Text(
                        "Resend OTP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decorationThickness: 3,
                          decoration: TextDecoration.underline,
                          fontFamily: eUser().userFieldLabelFont,
                          color: (_resendTimer != 0 || !enableResendOtp)
                              ? eUser().userTextFieldHintColor
                              : eUser().resendOtpFontColor,
                          fontSize: eUser().userTextFieldFontSize,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Center(
                    child: GestureDetector(
              // onTap: (showLoginProgress) ? null : () {
                      onTap: () {
                        final fcmToken = _pref.getString(AppConfig.FCM_TOKEN);

                        if (mobileFormKey.currentState!.validate() &&
                            phoneController.text.isNotEmpty &&
                            otpController.text.isNotEmpty) {
                          login(phoneController.text, otpController.text, fcmToken!);
                        }
                      },
                      child: Container(
                        width: 60.w,
                        height: 5.h,
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: (phoneController.text.isEmpty ||
                              otpController.text.isEmpty)
                              ? eUser().buttonColor
                              : eUser().buttonColor,
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(
                          //     color: eUser().buttonBorderColor,
                          //     width: eUser().buttonBorderWidth
                          // ),
                        ),
                        child: (showLoginProgress)
                            ? buildThreeBounceIndicator(
                            color: eUser().threeBounceIndicatorColor)
                            : Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              fontFamily: eUser().buttonTextFont,
                              color: (phoneController
                                  .text.isEmpty ||
                                  otpController.text.isEmpty)
                                  ? eUser().buttonTextColor
                                  : eUser().buttonTextColor,
                              fontSize: eUser().buttonTextSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
        )
        , bottomSheetHeight: 65.h, sheetForLogin: true);
  }


  // buildGetOTP(BuildContext context) {
  //   final defaultPinTheme = PinTheme(
  //     width: 45,
  //     height: 50,
  //     textStyle: TextStyle(
  //       fontFamily: eUser().anAccountTextFont,
  //       color: eUser().loginDummyTextColor,
  //       fontSize: eUser().loginSignupTextFontSize,
  //     ),
  //     decoration: BoxDecoration(
  //       color: gGreyColor.withOpacity(0.3),
  //       borderRadius: BorderRadius.circular(5),
  //     ),
  //   );
  //   return showModalBottomSheet(
  //     isScrollControlled: false,
  //     isDismissible: false,
  //     enableDrag: false,
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(30),
  //       ),
  //     ),
  //     builder: (BuildContext context) => StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return SizedBox(
  //             height: bottomSheetHeight(),
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   SizedBox(height: 1.h),
  //                   Center(
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Expanded(
  //                           child: Center(
  //                             child: Text(
  //                               'Enter your OTP',
  //                               style: TextStyle(
  //                                   fontFamily: eUser().mainHeadingFont,
  //                                   fontSize: eUser().mainHeadingFontSize,
  //                                   color: eUser().mainHeadingColor),
  //                             ),
  //                           ),
  //                         ),
  //                         GestureDetector(
  //                           onTap: () {
  //                             Navigator.pop(context);
  //                           },
  //                           child: Container(
  //                             padding: const EdgeInsets.all(1),
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(30),
  //                               border: Border.all(
  //                                   color: eUser().mainHeadingColor, width: 1),
  //                             ),
  //                             child: Icon(
  //                               Icons.clear,
  //                               color: eUser().mainHeadingColor,
  //                               size: 1.6.h,
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(width: 5)
  //                       ],
  //                     ),
  //                   ),
  //                   Container(
  //                     margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
  //                     height: 1,
  //                     color: eUser().mainHeadingColor.withOpacity(0.3),
  //                   ),
  //                   Expanded(
  //                     child: SingleChildScrollView(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Visibility(
  //                               visible: otpSent, child: SizedBox(height: 1.h)),
  //                           Visibility(
  //                             visible: otpSent,
  //                             child: Text(
  //                               otpMessage,
  //                               style: TextStyle(
  //                                   fontFamily: "GothamMedium",
  //                                   color: gPrimaryColor,
  //                                   fontSize: 8.5.sp),
  //                             ),
  //                           ),
  //                           SizedBox(height: 5.h),
  //                           Center(
  //                             child: Pinput(
  //                               controller: otpController,
  //                               length: 6,
  //                               focusNode: focusNode,
  //                               androidSmsAutofillMethod:
  //                               AndroidSmsAutofillMethod.smsUserConsentApi,
  //                               listenForMultipleSmsOnAndroid: true,
  //                               defaultPinTheme: defaultPinTheme,
  //                               validator: (value) {
  //                                 return value == otpController.text
  //                                     ? null
  //                                     : 'Pin is incorrect';
  //                               },
  //                               // onClipboardFound: (value) {
  //                               //   debugPrint('onClipboardFound: $value');
  //                               //   pinController.setText(value);
  //                               // },
  //                               hapticFeedbackType: HapticFeedbackType.lightImpact,
  //                               onCompleted: (pin) {
  //                                 debugPrint('onCompleted: $pin');
  //                               },
  //                               onChanged: (value) {
  //                                 debugPrint('onChanged: $value');
  //                               },
  //                               cursor: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.end,
  //                                 children: [
  //                                   Container(
  //                                     margin: const EdgeInsets.only(bottom: 9),
  //                                     width: 22,
  //                                     height: 1,
  //                                     color: eUser().loginDummyTextColor,
  //                                   ),
  //                                 ],
  //                               ),
  //                               // focusedPinTheme: defaultPinTheme.copyWith(
  //                               //   decoration: defaultPinTheme.decoration!.copyWith(
  //                               //     borderRadius: BorderRadius.circular(8),
  //                               //     border: Border.all(color: gPrimaryColor),
  //                               //   ),
  //                               // ),
  //                               // submittedPinTheme: defaultPinTheme.copyWith(
  //                               //   decoration: defaultPinTheme.decoration!.copyWith(
  //                               //     color: gGreyColor,
  //                               //     borderRadius: BorderRadius.circular(19),
  //                               //     border: Border.all(color: gPrimaryColor),
  //                               //   ),
  //                               // ),
  //                               // errorPinTheme: defaultPinTheme.copyBorderWith(
  //                               //   border: Border.all(color: Colors.redAccent),
  //                               // ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 3.h),
  //                           Visibility(
  //                             visible: _resendTimer != 0,
  //                             child: Row(
  //                               mainAxisSize: MainAxisSize.min,
  //                               children: [
  //                                 const Icon(
  //                                   Icons.timelapse_rounded,
  //                                   size: 12,
  //                                 ),
  //                                 SizedBox(width: 1.w),
  //                                 Text(_resendTimer.toString(),
  //                                     style: TextStyle(
  //                                       fontFamily: eUser().resendOtpFont,
  //                                       color: eUser().resendOtpFontColor,
  //                                       fontSize: eUser().resendOtpFontSize,
  //                                     )),
  //                               ],
  //                             ),
  //                           ),
  //                           SizedBox(height: 3.h),
  //                           Center(
  //                             child: Text(
  //                               "Didn't receive an OTP?",
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 decorationThickness: 3,
  //                                 // decoration: TextDecoration.underline,
  //                                 fontFamily: eUser().resendOtpFont,
  //                                 color: (_resendTimer != 0 || !enableResendOtp)
  //                                     ? eUser().userTextFieldHintColor
  //                                     : eUser().resendOtpFontColor,
  //                                 fontSize: eUser().userTextFieldFontSize,
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 2.h),
  //                           Center(
  //                             child: GestureDetector(
  //                               onTap: (_resendTimer != 0 || !enableResendOtp)
  //                                   ? null
  //                                   : () {
  //                                 getOtp(phoneController.text);
  //                                 // Navigator.push(context, MaterialPageRoute(builder: (_) => ResendOtpScreen()));
  //                               },
  //                               child: Text(
  //                                 "Resend OTP",
  //                                 textAlign: TextAlign.center,
  //                                 style: TextStyle(
  //                                   decorationThickness: 3,
  //                                   decoration: TextDecoration.underline,
  //                                   fontFamily: eUser().userFieldLabelFont,
  //                                   color: (_resendTimer != 0 || !enableResendOtp)
  //                                       ? eUser().userTextFieldHintColor
  //                                       : eUser().resendOtpFontColor,
  //                                   fontSize: eUser().userTextFieldFontSize,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 3.h),
  //                           Center(
  //                             child: GestureDetector(
  //                               // onTap: (showLoginProgress) ? null : () {
  //                               onTap: () {
  //                                 if (mobileFormKey.currentState!.validate() &&
  //                                     phoneController.text.isNotEmpty &&
  //                                     otpController.text.isNotEmpty) {
  //                                   login(phoneController.text, otpController.text);
  //                                 }
  //                               },
  //                               child: Container(
  //                                 width: 60.w,
  //                                 height: 5.h,
  //                                 margin: EdgeInsets.symmetric(vertical: 4.h),
  //                                 padding: EdgeInsets.symmetric(
  //                                     vertical: 1.h, horizontal: 10.w),
  //                                 decoration: BoxDecoration(
  //                                   color: (phoneController.text.isEmpty ||
  //                                       otpController.text.isEmpty)
  //                                       ? eUser().buttonColor
  //                                       : eUser().buttonColor,
  //                                   borderRadius: BorderRadius.circular(10),
  //                                   // border: Border.all(
  //                                   //     color: eUser().buttonBorderColor,
  //                                   //     width: eUser().buttonBorderWidth
  //                                   // ),
  //                                 ),
  //                                 child: (showLoginProgress)
  //                                     ? buildThreeBounceIndicator(
  //                                     color: eUser().threeBounceIndicatorColor)
  //                                     : Center(
  //                                   child: Text(
  //                                     'LOGIN',
  //                                     style: TextStyle(
  //                                       fontFamily: eUser().buttonTextFont,
  //                                       color: (phoneController
  //                                           .text.isEmpty ||
  //                                           otpController.text.isEmpty)
  //                                           ? eUser().buttonTextColor
  //                                           : eUser().buttonTextColor,
  //                                       fontSize: eUser().buttonTextSize,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }


  final LoginOtpRepository repository = LoginOtpRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  bool isPhone(String input) =>
      RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(input);

  void getOtp(String phoneNumber) async {
    setState(() {
      otpSent = true;
    });
    print("get otp");
    final result = await _loginWithOtpService.getOtpService(phoneNumber);

    if (result.runtimeType == GetOtpResponse) {
      GetOtpResponse model = result as GetOtpResponse;
      setState(() {
        isSheetOpen = true;
        otpMessage = "OTP Sent";
          showOpenBottomSheetProgress = false;
        if (kDebugMode) otpController.text = result.otp!;
      });
      buildGetOTP(context);
      Future.delayed(Duration(seconds: 2)).whenComplete(() {
        setState(() {
          otpSent = false;
          // if (kDebugMode) _resendTimer = 0;
        });
      });
      // if (kDebugMode) _timer!.cancel();
    } else {
      setState(() {
        otpSent = false;
        showOpenBottomSheetProgress = false;
      });
      ErrorModel response = result as ErrorModel;
      if(_timer != null) _timer!.cancel();
      _resendTimer = 0;
      AppConfig().showSnackbar(context, response.message!, isError: true);
    }
  }

  login(String phone, String otp, String fcm) async {
    bottomsheetSetState(() {
      showLoginProgress = true;
    });
    print("---------Login---------");
    final result = await _loginWithOtpService.loginWithOtpService(phone, otp, fcm);

    if (result.runtimeType == LoginOtpModel) {
      LoginOtpModel model = result as LoginOtpModel;
      bottomsheetSetState(() {
        showLoginProgress = false;
      });
      print("model.userEvaluationStatus: ${model.userEvaluationStatus}");

      _pref.setString(AppConfig.EVAL_STATUS, model.userEvaluationStatus!);
      storeBearerToken(model.accessToken ?? '');
      _pref.setString(AppConfig.KALEYRA_USER_ID, model.kaleyraUserId ?? '');
      _pref.setString(AppConfig.KALEYRA_SUCCESS_ID, model.kaleyraSuccessId ?? '');
      _pref.setString(AppConfig.KALEYRA_CHAT_SUCCESS_ID, model.associatedSuccessMemberKaleyraId ?? '');

      storeUserProfile();

      _loginWithOtpService.getAccessToken(model.kaleyraUserId!);
      _pref.setString(AppConfig.QB_USERNAME, model.loginUsername ?? '');
      _pref.setString(AppConfig.QB_CURRENT_USERID, model.chatId ?? '');
      final _qbService = Provider.of<QuickBloxService>(context, listen:  false);
      _qbService.login("${model.loginUsername}");

      if (model.userEvaluationStatus!.contains("no_evaluation") ||
          model.userEvaluationStatus!.contains("pending")) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const EvaluationFormScreen(),
          ),
        );
      } else {
        bool? firstTime = _pref.getBool(AppConfig.isFirstTime);

        if (firstTime == null) {
          _pref.setBool(AppConfig.isFirstTime, false);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HelpScreen(
                isFromLogin: true,
              ),
            ),
          );
        }
        else {
          _pref.setBool(AppConfig.isFirstTime, false);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
          );
        }
      }
      final shipAddress =
          await EvaluationFormService(repository: evalrepository)
              .getEvaluationDataService();
      if (shipAddress.runtimeType == GetEvaluationDataModel) {
        GetEvaluationDataModel model = shipAddress as GetEvaluationDataModel;
        ChildGetEvaluationDataModel? model1 = model.data;
        final address1 = model1?.patient?.user?.address ?? '';
        final address2 = model1?.patient?.address2 ?? '';
        _pref.setString(AppConfig.SHIPPING_ADDRESS, address1 + address2);
      }

    } else {
      bottomsheetSetState(() {
        showLoginProgress = false;
      });
      _pref.setBool(AppConfig.isLogin, false);

      ErrorModel response = result as ErrorModel;
      AppConfig().showSnackbar(context, response.message!, isError: true);
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const DashboardScreen(),
      //   ),
      // );
    }

  }

  void storeBearerToken(String token) async {
    _pref.setBool(AppConfig.isLogin, true);
    _pref.setInt(AppConfig.last_login, DateTime.now().millisecondsSinceEpoch);
    await _pref.setString(AppConfig().BEARER_TOKEN, token);
  }

  final EvaluationFormRepository evalrepository = EvaluationFormRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final UserProfileRepository userRepository = UserProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void storeUserProfile() async {
    final profile = await UserProfileService(repository: userRepository)
        .getUserProfileService();
    if (profile.runtimeType == UserProfileModel) {
      UserProfileModel model1 = profile as UserProfileModel;
      print("model1.datqbUserIda!.: ${model1.data!.qbUserId}");

      _pref.setString(
          AppConfig.User_Name, model1.data?.name ?? model1.data?.fname ?? '');
      _pref.setInt(AppConfig.USER_ID, model1.data?.id ?? -1);
      _pref.setString(AppConfig.QB_USERNAME, model1.data!.qbUsername!);
      _pref.setString(AppConfig.QB_CURRENT_USERID, model1.data!.qbUserId ?? '');
      _pref.setString(AppConfig.KALEYRA_USER_ID, model1.data!.kaleyraUID ?? '');
      print("pref id: ${_pref.getInt(AppConfig.USER_ID)}");
      print("model1. after: ${_pref.getString(AppConfig.QB_CURRENT_USERID)}");
    }
  }

}
