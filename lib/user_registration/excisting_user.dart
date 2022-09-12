import 'package:flutter/material.dart';
import 'package:gwc_customer/dashboard/dashboard_screen.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:sizer/sizer.dart';

import 'new_user/choose_your_problem_screen.dart';

class ExcistingUser extends StatefulWidget {
  const ExcistingUser({Key? key}) : super(key: key);

  @override
  State<ExcistingUser> createState() => _ExcistingUserState();
}

class _ExcistingUserState extends State<ExcistingUser> {
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late bool passwordVisibility;

  @override
  void initState() {
    super.initState();
    passwordVisibility = false;
    phoneController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
                  'Excisting User',
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
            TextFormField(
              //  autovalidateMode: AutovalidateMode.onUserInteraction,
              //  maxLength: 10,
              cursorColor: kSecondaryColor,
              controller: phoneController,
              style: TextStyle(
                  fontFamily: "GothamBook", color: gMainColor, fontSize: 11.sp),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Mobile Number';
                } else if (!RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(value)) {
                  return 'Please enter your valid Mobile Number';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                // prefixIcon: const Icon(
                //   Icons.phone_android_outlined,
                //   color: gPrimaryColor,
                // ),
                suffixIcon: (!RegExp(r'^(?:[+0]9)?[0-9]{10}$')
                        .hasMatch(phoneController.value.text))
                    ? phoneController.text.isEmpty
                        ? Container(
                            width: 0,
                          )
                        : InkWell(
                            onTap: () {
                              phoneController.clear();
                            },
                            child: const Icon(
                              Icons.close,
                              color: gMainColor,
                            ),
                          )
                    : Padding(
                        padding: EdgeInsets.only(bottom: 1.5.h, top: 1.5.h),
                        child: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: gMainColor,
                        )),
                hintText: "MobileNumber",
                hintStyle: TextStyle(
                  fontFamily: "GothamBook",
                  color: gMainColor,
                  fontSize: 9.sp,
                ),
              ),
              keyboardType: TextInputType.phone,
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
            TextFormField(
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: kSecondaryColor,
              controller: passwordController,
              obscureText: !passwordVisibility,
              style: TextStyle(
                  fontFamily: "GothamBook",
                  color: gPrimaryColor,
                  fontSize: 11.sp),
              decoration: InputDecoration(
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
                      passwordVisibility = !passwordVisibility;
                    });
                  },
                  child: Icon(
                    passwordVisibility
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: gPrimaryColor,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              "Resend OTP",
              textAlign: TextAlign.center,
              style: TextStyle(
                  decorationThickness: 3,
                  decoration: TextDecoration.underline,
                  fontFamily: "GothamBook",
                  color: gsecondaryColor,
                  fontSize: 11.sp),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.h),
                  padding:
                      EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: (!RegExp(r'^(?:[+0]9)?[0-9]{10}$')
                                .hasMatch(phoneController.value.text) ||
                            !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,20}$')
                                .hasMatch(passwordController.value.text))
                        ? gMainColor
                        : gPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: gMainColor, width: 1),
                  ),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontFamily: "GothamRoundedBold_21016",
                      color: (!RegExp(r'^(?:[+0]9)?[0-9]{10}$')
                                  .hasMatch(phoneController.value.text) ||
                              !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,20}$')
                                  .hasMatch(passwordController.value.text))
                          ? gPrimaryColor
                          : gMainColor,
                      fontSize: 10.sp,
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
}
