import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/login_model/resend_otp_model.dart';
import 'package:gwc_customer/repository/login_otp_repository.dart';
import 'package:gwc_customer/screens/user_registration/existing_user.dart';
import 'package:gwc_customer/services/login_otp_service.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/unfocus_widget.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:gwc_customer/widgets/will_pop_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:gwc_customer/repository/api_service.dart';
import '../../repository/profile_repository/get_user_profile_repo.dart';
import '../../utils/app_config.dart';
import 'new_user/choose_your_problem_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';

class ResendOtpScreen extends StatefulWidget {
  const ResendOtpScreen({Key? key}) : super(key: key);

  @override
  State<ResendOtpScreen> createState() => _ResendOtpScreenState();
}

class _ResendOtpScreenState extends State<ResendOtpScreen> {
  final formKey = GlobalKey<FormState>();
  final mobileFormKey = GlobalKey<FormState>();
  late FocusNode _phoneFocus;

  TextEditingController phoneController = TextEditingController();

  bool otpSent = false;

  String countryCode = '+91';


  late Future getOtpFuture, loginFuture;

  late LoginWithOtpService _loginWithOtpService;

  final SharedPreferences _pref = AppConfig().preferences!;

  @override
  void initState() {
    super.initState();
    _loginWithOtpService = LoginWithOtpService(repository: repository);
    _phoneFocus = FocusNode();

    phoneController.addListener(() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: UnfocusWidget(
            child: Column(
              children: [
                Container(
                  height: 35.h,
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
                SizedBox(height: 5.h),
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
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Resend OTP',
                  style: TextStyle(
                    fontSize: 12.sp,
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
                      maxLength: 10,
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
                      focusNode: _phoneFocus,
                      decoration: InputDecoration(
                        isDense: true,
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                        suffixIcon: !isPhone(phoneController.value.text)
                            ? phoneController.text.isEmpty
                            ? const SizedBox()
                            : InkWell(
                          onTap: () {
                            phoneController.clear();
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            color: gMainColor,
                          ),
                        )
                            : const Icon(
                              Icons.check_circle_outline,
                              color: gMainColor,
                              size: 22,
                            ),
                        hintText: "MobileNumber",
                        hintStyle: TextStyle(
                          fontFamily: "GothamBook",
                          color: gMainColor,
                          fontSize: 9.sp,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Center(
              child: GestureDetector(
                onTap: (otpSent) ? null : () {
                  if(mobileFormKey.currentState!.validate() && phoneController.text.isNotEmpty){
                    getOtp(phoneController.text);
                  }
                },
                child: Container(
                  width: 40.w,
                  height: 5.h,
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding:
                  EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: (phoneController.text.isEmpty)
                        ? gMainColor
                        : gPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: gMainColor, width: 1),
                  ),
                  child: (otpSent)
                      ? buildThreeBounceIndicator(color: gMainColor)
                      : Center(
                    child: Text(
                      'Send OTP',
                      style: TextStyle(
                        fontFamily: "GothamRoundedBold_21016",
                        color: (phoneController.text.isEmpty)
                            ? gPrimaryColor
                            : gMainColor,
                        fontSize: 10.sp,
                      ),
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
        otpSent = false;
      });
      AppConfig().showSnackbar(context, 'Otp sent to ${phoneNumber}', duration: 3);
      Future.delayed(const Duration(seconds: 3)).whenComplete((){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => ExistingUser()), (route) => route.isFirst);
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

  final UserProfileRepository userRepository = UserProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
