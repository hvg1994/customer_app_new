import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/login_model/resend_otp_model.dart';
import 'package:gwc_customer/repository/login_otp_repository.dart';
import 'package:gwc_customer/screens/evalution_form/evaluation_form_screen.dart';
import 'package:gwc_customer/screens/user_registration/resend_otp_screen.dart';
import 'package:gwc_customer/services/login_otp_service.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/unfocus_widget.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:gwc_customer/widgets/will_pop_widget.dart';
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
import '../../utils/app_config.dart';
import '../dashboard_screen.dart';
import 'new_user/choose_your_problem_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:gwc_customer/widgets/dart_extensions.dart';

enum EvaluationStatus {
  evaluation_done,
  no_evaluation
}


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
  late bool otpVisibility;

  String countryCode = '+91';

  bool otpSent = false;
  bool showLoginProgress = false;

  String otpMessage = "Sending OTP";

  late Future getOtpFuture, loginFuture;

  late LoginWithOtpService _loginWithOtpService;

  final SharedPreferences _pref = AppConfig().preferences!;

  Timer? _timer;
  int _resendTimer = 0;

  bool enableResendOtp = false;

  void startTimer() {
    _resendTimer = 60;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_resendTimer == 0) {
          setState(() {
            timer.cancel();
            enableResendOtp = true;
          });
        } else {
          setState(() {
            _resendTimer--;
          });
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
      if(!_phoneFocus.hasFocus){
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
    if(_timer != null){
      _timer!.cancel();
    }
    _phoneFocus.removeListener(() { });
    phoneController.dispose();
    otpController.dispose();
    otpController.removeListener(() { });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      child: Scaffold(
          body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: UnfocusWidget(
          child: Column(
            children: [
              Container(
                height: 30.h,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  // image: DecorationImage(
                  //     image: AssetImage("assets/images/Mask Group 2.png"),
                  //     fit: BoxFit.fill),
                ),
                child: Center(
                  child: Image(
                    fit: BoxFit.fitWidth,
                    height: 15.h,
                    width: 80.w,
                    image: const AssetImage("assets/images/Gut welness logo.png",

                    ),
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              buildForms(),
            ],
          ),
        ),
      )),
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
                      color: eUser().mainHeadingColor
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 2.0,
                    color: gMainColor,
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
                  color: eUser().userFieldLabelColor
              ),
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
                    favorite: ['+91','IN'],
                    initialSelection: countryCode,
                    onChanged: (val){
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
                          color: eUser().userTextFieldColor
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Mobile Number';
                        } else if (!isPhone(value)) {
                          return 'Please enter valid Mobile Number';
                        }
                        else {
                          return null;
                        }
                      },
                      onFieldSubmitted: (value){
                        print("isPhone(value): ${isPhone(value)}");
                        print("!_phoneFocus.hasFocus: ${_phoneFocus.hasFocus}");
                         if(isPhone(value) && _phoneFocus.hasFocus){
                           getOtp(value);
                           _phoneFocus.unfocus();
                         }
                      },
                      focusNode: _phoneFocus,
                      decoration: InputDecoration(
                        focusedBorder:UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: eUser().focusedBorderColor,
                              width: eUser().focusedBorderWidth
                          )
                          // borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: (phoneController.text.isEmpty) ? null : UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: eUser().focusedBorderColor,
                                width: eUser().focusedBorderWidth
                            )
                        ),
                        isDense: true,
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(horizontal: 2),
                        suffixIcon: (phoneController.text.length != 10 && phoneController.text.length > 0)
                        ? InkWell(
                          onTap: () {
                            phoneController.clear();
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: gMainColor,
                          ),
                        )
                            : (phoneController.text.length == 10 && isPhone(phoneController.text))
                          ? GestureDetector(
                          onTap:(otpMessage.toLowerCase().contains('otp sent')) ? null : (){
                            if(isPhone(phoneController.text) && _phoneFocus.hasFocus){
                              getOtp(phoneController.text);
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: !(otpMessage.toLowerCase().contains('otp sent')),
                                child: Text('Get OTP',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: eUser().fieldSuffixTextFont,
                                    color: eUser().fieldSuffixTextColor,
                                    fontSize: eUser().fieldSuffixTextFontSize,
                                  ),
                                ),
                              ),
                              Icon(
                                (otpMessage.toLowerCase().contains('otp sent')) ? Icons.check_circle_outline : Icons.keyboard_arrow_right,
                                color: gPrimaryColor,
                                size: 22,
                              ),
                            ],
                          ),
                          // child: Icon(
                          //   (otpMessage.toLowerCase().contains('otp sent')) ? Icons.check_circle_outline : Icons.keyboard_arrow_right,
                          //   color: gPrimaryColor,
                          //   size: 22,
                          // ),
                        )
                            : SizedBox(),
                        hintText: "MobileNumber",
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
            Visibility(
                visible: otpSent,
                child: SizedBox(height: 1.h)),
            Visibility(
              visible: otpSent,
              child: Text(
                otpMessage,
                style: TextStyle(
                    fontFamily: "GothamMedium",
                    color: gPrimaryColor,
                    fontSize: 8.5.sp
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              "Enter your OTP",
              style: TextStyle(
                  fontFamily: eUser().userFieldLabelFont,
                  fontSize: eUser().userFieldLabelFontSize,
                  color: eUser().userFieldLabelColor
              ),
            ),
            SizedBox(height: 1.h),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              child: TextFormField(
                maxLength: 6,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.number,
                cursorColor: gPrimaryColor,
                controller: otpController,
                // obscureText: !otpVisibility,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                    fontFamily: eUser().userTextFieldFont,
                    fontSize: eUser().userTextFieldFontSize,
                    color: eUser().userTextFieldColor
                ),
                decoration: InputDecoration(
                  focusedBorder:UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: eUser().focusedBorderColor,
                          width: eUser().focusedBorderWidth
                      )
                    // borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: (otpController.text.isEmpty) ? null :UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: eUser().focusedBorderColor,
                          width: eUser().focusedBorderWidth
                      )
                  ),
                  isDense: true,
                  counterText: '',
                  // fillColor: MainTheme.fillColor,
                  contentPadding: EdgeInsets.symmetric(horizontal: 2),
                  // prefixIcon: const Icon(
                  //   Icons.lock_outline_sharp,
                  //   color: gPrimaryColor,
                  // ),
                  hintText: "OTP",
                  hintStyle: TextStyle(
                    fontFamily: eUser().userTextFieldHintFont,
                    color: eUser().userTextFieldHintColor,
                    fontSize: eUser().userTextFieldHintFontSize,
                  ),
                  suffixIcon: Visibility(
                    visible: false,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          otpVisibility = !otpVisibility;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          otpVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: gPrimaryColor,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (_resendTimer != 0 || !enableResendOtp) ? null : (){
                    getOtp(phoneController.text);
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => ResendOtpScreen()));
                  },
                  child: Text(
                    "Resend OTP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decorationThickness: 3,
                        // decoration: TextDecoration.underline,
                      fontFamily: eUser().resendOtpFont,
                      color: (_resendTimer != 0 || !enableResendOtp) ? eUser().userTextFieldHintColor : eUser().resendOtpFontColor,
                      fontSize: eUser().resendOtpFontSize,
                    ),
                  ),
                ),
                Visibility(
                  visible: _resendTimer != 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timelapse_rounded,
                        size: 12,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(_resendTimer.toString(),
                        style: TextStyle(
                          fontFamily: eUser().resendOtpFont,
                          color: eUser().resendOtpFontColor,
                          fontSize: eUser().resendOtpFontSize,
                        )
                      ),
                    ],
                  ),
                )
              ],
            ),
            Center(
              child: GestureDetector(
                // onTap: (showLoginProgress) ? null : () {
                onTap: () {
                  if(mobileFormKey.currentState!.validate() && phoneController.text.isNotEmpty && otpController.text.isNotEmpty){
                    login(phoneController.text, otpController.text);
                  }
                },
                child: Container(
                  width: 40.w,
                  height: 5.h,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: (phoneController.text.isEmpty || otpController.text.isEmpty)
                        ? eUser().buttonColor
                        : eUser().buttonColor,
                    borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                    border: Border.all(
                        color: eUser().buttonBorderColor,
                        width: eUser().buttonBorderWidth
                    ),
                  ),
                  child: (showLoginProgress)
                      ? buildThreeBounceIndicator(color: eUser().threeBounceIndicatorColor)
                      : Center(
                        child: Text(
                    'LOGIN',
                    style: TextStyle(
                        fontFamily: eUser().buttonTextFont,
                        color: (phoneController.text.isEmpty || otpController.text.isEmpty)
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
            SizedBox(
              height: 8.h,
            ),
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
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ChooseYourProblemScreen(),
                            ),
                          );
                        }
                      )
                    ]
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

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
    startTimer();
    print("get otp");
    final result = await _loginWithOtpService.getOtpService(phoneNumber);

    if(result.runtimeType == GetOtpResponse){
      GetOtpResponse model = result as GetOtpResponse;
      setState(() {
        otpMessage = "OTP Sent";
        otpController.text = result.otp!;
      });
      Future.delayed(Duration(seconds: 2)).whenComplete(() {
        setState(() {
          otpSent = false;
          _resendTimer = 0;
        });
      });
      _timer!.cancel();
    }
    else{
      setState(() {
        otpSent = false;
      });
      ErrorModel response = result as ErrorModel;
      _timer!.cancel();
      _resendTimer = 0;
      AppConfig().showSnackbar(context, response.message!, isError: true);
    }
  }

  login(String phone, String otp) async{
    setState(() {
      showLoginProgress = true;
    });
    print("---------Login---------");
    final result = await _loginWithOtpService.loginWithOtpService(phone, otp);

    if(result.runtimeType == LoginOtpModel){
      LoginOtpModel model = result as LoginOtpModel;
      setState(() {
        showLoginProgress = false;
      });

      print("model.userEvaluationStatus: ${model.userEvaluationStatus}");

      _pref.setString(AppConfig.EVAL_STATUS, model.userEvaluationStatus!);
      storeBearerToken(model.accessToken ?? '');
      _pref.setString(AppConfig.KALEYRA_USER_ID, model.kaleyraUserId!);
      _pref.setString(AppConfig.KALEYRA_SUCCESS_ID, model.kaleyraSuccessId!);

      _loginWithOtpService.getAccessToken(model.kaleyraUserId!);

      if(model.userEvaluationStatus!.contains("no_evaluation") || model.userEvaluationStatus!.contains("pending"))
        {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const EvaluationFormScreen(),
            ),
          );
        }
      else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      }
      final shipAddress = await EvaluationFormService(repository: evalrepository).getEvaluationDataService();
      if(shipAddress.runtimeType == GetEvaluationDataModel){
        GetEvaluationDataModel model = shipAddress as GetEvaluationDataModel;
        ChildGetEvaluationDataModel? model1 = model.data;
        final address1 = model1?.patient?.user?.address ?? '';
        final address2 = model1?.patient?.address2 ?? '';
        _pref.setString(AppConfig.SHIPPING_ADDRESS, address1+address2);
      }
    }
    else{
      setState(() {
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

    final profile = await UserProfileService(repository: userRepository).getUserProfileService();
    if(profile.runtimeType == UserProfileModel){
      UserProfileModel model1 = profile as UserProfileModel;
      _pref.setString(AppConfig.User_Name, model1.data?.name ?? model1.data?.fname ?? '');
      _pref.setInt(AppConfig.USER_ID, model1.data?.id ?? -1);
      _pref.setString(AppConfig.QB_USERNAME, model1.data!.qbUsername!);
      _pref.setInt(AppConfig.QB_CURRENT_USERID, int.tryParse(model1.data!.qbUserId!)!);
      _pref.setString(AppConfig.KALEYRA_USER_ID, model1.data!.kaleyraUID!);
      print("pref id: ${_pref.getInt(AppConfig.USER_ID)}");
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
}
