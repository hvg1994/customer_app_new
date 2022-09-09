import 'package:flutter/material.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:sizer/sizer.dart';

Center buildLoadingBar() {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        color: gPrimaryColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: gMainColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      child: SizedBox(
        height: 2.5.h,
        width: 5.w,
        child: const CircularProgressIndicator(
          color: gMainColor,
          strokeWidth: 2.5,
        ),
      ),
    ),
  );
}

// SnackbarController buildSnackBar(String title, String subTitle) {
//   return Get.snackbar(
//     title,
//     subTitle,
//     titleText: Text(
//       title,
//       style: TextStyle(
//         fontFamily: "PoppinsSemiBold",
//         color: gMainColor,
//         fontSize: 12.sp,
//       ),
//     ),
//     messageText: Text(
//       subTitle,
//       style: TextStyle(
//         fontFamily: "PoppinsMedium",
//         color: gMainColor,
//         fontSize: 10.sp,
//       ),
//     ),
//     backgroundColor: gPrimaryColor,
//     snackPosition: SnackPosition.BOTTOM,
//     colorText: gMainColor,
//     margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
//     borderRadius: 10,
//     borderWidth: 2,
//     duration: const Duration(seconds: 2),
//     isDismissible: true,
//     dismissDirection: DismissDirection.horizontal,
//     forwardAnimationCurve: Curves.decelerate,
//   );
// }

Row buildAppBar(VoidCallback func) {
  return Row(
    children: [
      SizedBox(
        height: 2.h,
        child: InkWell(
          onTap: func,
          child: const Image(
            image: AssetImage("assets/images/Icon ionic-ios-arrow-back.png"),
          ),
        ),
      ),
      SizedBox(
        height: 7.h,
        child: const Image(
          image: AssetImage("assets/images/Gut welness logo.png"),
        ),
      ),
    ],
  );
}

List consultation = [
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
  const Color(0xffFFE6E4),
  const Color(0xffF0FFD8),
];
