import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/login_model/resend_otp_model.dart';
import 'package:gwc_customer/repository/login_otp_repository.dart';
import 'package:gwc_customer/screens/evalution_form/evaluation_form_screen.dart';
import 'package:gwc_customer/services/login_otp_service.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/unfocus_widget.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:gwc_customer/repository/api_service.dart';
import '../../model/login_model/login_otp_model.dart';
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
    _phoneFocus.removeListener(() { });
    phoneController.dispose();
    otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: UnfocusWidget(
        child: Column(
          children: [
            Container(
              height: 40.h,
              width: double.maxFinite,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/Mask Group 2.png"),
                    fit: BoxFit.fill),
              ),
              child: Center(
                child: Image(
                  height: 15.h,
                  image: const AssetImage("assets/images/Gut welness logo.png"),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            buildForms(),
          ],
        ),
      ),
    ));
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
                    fontSize: 11.sp,
                    fontFamily: "GothamMedium",
                    color: gMainColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1.5,
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
                  fontFamily: "GothamMedium",
                  color: gPrimaryColor,
                  fontSize: 10.sp),
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
                    autovalidateMode:
                    AutovalidateMode.onUserInteraction,
                    key: mobileFormKey,
                    child: TextFormField(
                      cursorColor: gPrimaryColor,
                      textAlignVertical: TextAlignVertical.center,
                      controller: phoneController,
                      style: TextStyle(
                          fontFamily: "GothamBook", color: gMainColor, fontSize: 11.sp),
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
                         }
                      },
                      focusNode: _phoneFocus,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 2),
                        suffixIcon: !isPhone(phoneController.value.text)
                            ? phoneController.text.isEmpty
                            ? SizedBox()
                            : InkWell(
                          onTap: () {
                            phoneController.clear();
                          },
                          child: const Icon(
                              Icons.cancel_outlined,
                            color: gMainColor,
                          ),
                        )
                            : GestureDetector(
                          onTap:(otpMessage.toLowerCase().contains('otp sent')) ? null : (){
                            if(isPhone(phoneController.text) && _phoneFocus.hasFocus){
                              getOtp(phoneController.text);
                            }
                          },
                              child: Icon(
                                (otpMessage.toLowerCase().contains('otp sent')) ? Icons.check_circle_outline : Icons.keyboard_arrow_right,
                                color: gMainColor,
                                size: 22,
                              ),
                            ),
                        hintText: "MobileNumber",
                        hintStyle: TextStyle(
                          fontFamily: "GothamBook",
                          color: gMainColor,
                          fontSize: 9.sp,
                        ),
                      ),
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
                    fontSize: 8.5.sp),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              "Enter your OTP",
              style: TextStyle(
                  fontFamily: "GothamMedium",
                  color: gPrimaryColor,
                  fontSize: 10.sp),
            ),
            SizedBox(height: 1.h),
            Form(
              autovalidateMode: AutovalidateMode.disabled,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.number,
                cursorColor: gPrimaryColor,
                controller: otpController,
                obscureText: !otpVisibility,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                    fontFamily: "GothamBook",
                    color: gPrimaryColor,
                    fontSize: 11.sp),
                decoration: InputDecoration(
                  isDense: true,
                  // fillColor: MainTheme.fillColor,
                  contentPadding: EdgeInsets.symmetric(horizontal: 2),
                  // prefixIcon: const Icon(
                  //   Icons.lock_outline_sharp,
                  //   color: gPrimaryColor,
                  // ),
                  hintText: "OTP",
                  hintStyle: TextStyle(
                    fontFamily: "GothamBook",
                    color: gMainColor,
                    fontSize: 9.sp,
                  ),
                  suffixIcon: InkWell(
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
            SizedBox(height: 3.h),
            GestureDetector(
              onTap: (){
                if(phoneController.text.isEmpty){
                  AppConfig().showSnackbar(context, "Please Enter Mobile Number", isError: true);
                }
                else if(isPhone(phoneController.text)){
                  getOtp(phoneController.text);
                }
              },
              child: Text(
                "Resend OTP",
                textAlign: TextAlign.center,
                style: TextStyle(
                    decorationThickness: 3,
                    decoration: TextDecoration.underline,
                    fontFamily: "GothamBook",
                    color: gsecondaryColor,
                    fontSize: 11.sp),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: (showLoginProgress) ? null : () {
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
                        ? gMainColor
                        : gPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: gMainColor, width: 1),
                  ),
                  child: (showLoginProgress)
                      ? buildThreeBounceIndicator(color: gMainColor)
                      : Center(
                        child: Text(
                    'LOGIN',
                    style: TextStyle(
                        fontFamily: "GothamRoundedBold_21016",
                        color: (phoneController.text.isEmpty || otpController.text.isEmpty)
                            ? gPrimaryColor
                            : gMainColor,
                        fontSize: 10.sp,
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
                  "Lorem lpsum is simply dummy text of the printing and typesetting idustry",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.5,
                      fontFamily: "GothamBook",
                      color: gMainColor,
                      fontSize: 9.sp),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChooseYourProblemScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: gPrimaryColor, width: 1),
                  ),
                  child: Text(
                    'New User',
                    style: TextStyle(
                      fontFamily: "GothamRoundedBold_21016",
                      color: gMainColor,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
            ),
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
        });
      });
    }
    else{
      setState(() {
        otpSent = false;
      });
      ErrorModel response = result as ErrorModel;
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
  }

  void storeBearerToken(String token) async {
    _pref.setBool(AppConfig.isLogin, true);
    _pref.setInt(AppConfig.last_login, DateTime.now().millisecondsSinceEpoch);
    await _pref.setString(AppConfig().BEARER_TOKEN, token);
  }
}
