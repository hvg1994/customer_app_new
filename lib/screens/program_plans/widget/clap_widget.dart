import 'package:flutter/material.dart';

class ClapWidget extends StatefulWidget {
  const ClapWidget({Key? key}) : super(key: key);

  @override
  State<ClapWidget> createState() => _ClapWidgetState();
}

class _ClapWidgetState extends State<ClapWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox();
    //   Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: [
    //     Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(5),
    //         border: Border.all(color: gMainColor),
    //       ),
    //       child: Lottie.asset(
    //         "assets/lottie/clap.json",
    //         height: 20.h,
    //       ),
    //     ),
    //     SizedBox(height: 1.5.h),
    //     Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 3.w),
    //       child: Text(
    //         "You Have completed the ${listData.length} days Meal Plan, Now you can proceed",
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //           height: 1.2,
    //           color: gTextColor,
    //           fontSize: bottomSheetSubHeadingXLFontSize,
    //           fontFamily: bottomSheetSubHeadingMediumFont,
    //         ),
    //       ),
    //     ),
    //     SizedBox(height: 5.h),
    //     GestureDetector(
    //       onTap: () {
    //         setState(() {
    //           isOpened = true;
    //         });
    //         Future.delayed(Duration(seconds: 0)).whenComplete(() {
    //           openProgressDialog(context);
    //         });
    //         startPostProgram();
    //       },
    //       child: Container(
    //         padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
    //         decoration: BoxDecoration(
    //           color: gsecondaryColor,
    //           borderRadius: BorderRadius.circular(8),
    //           border: Border.all(color: gMainColor, width: 1),
    //         ),
    //         child: Text(
    //           'Next',
    //           style: TextStyle(
    //             fontFamily: kFontMedium,
    //             color: gWhiteColor,
    //             fontSize: 11.sp,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
