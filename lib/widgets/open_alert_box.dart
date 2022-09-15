import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'constants.dart';

openAlertBox({
  required BuildContext context,
  bool titleNeeded = false,
  String? title,
  String? content,
  bool isSingleButton = false,
  String? negativeButtonName,
  required String positiveButtonName,
  VoidCallback? negativeButton,
  required VoidCallback positiveButton,
  bool barrierDismissible = true
}) {
  return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        backgroundColor: kPrimaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0.sp))),
        contentPadding: EdgeInsets.only(top: 1.h),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          decoration: BoxDecoration(
              color: gWhiteColor, borderRadius: BorderRadius.circular(8)),
          width: 50.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Visibility(
                visible: titleNeeded,
                child: Text(
                  title ?? 'Are you sure?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "GothamRoundedBold_21016",
                      color: gPrimaryColor,
                      fontSize: 13.sp),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 2.h),
                height: 1,
                color: Colors.grey.withOpacity(0.3),
              ),
              Text(
                content ?? 'Do you want to exit an App?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "GothamMedium",
                    color: gsecondaryColor,
                    fontSize: 11.sp),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !isSingleButton,
                    child: GestureDetector(
                      onTap: negativeButton ?? () => Navigator.of(context).pop(false),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                            color: gMainColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          negativeButtonName ?? "NO",
                          style: TextStyle(
                            fontFamily: "GothamRoundedBold_21016",
                            color: gPrimaryColor,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: !isSingleButton,
                      child: SizedBox(width: 5.w)),
                  GestureDetector(
                    onTap: positiveButton ?? () => SystemNavigator.pop(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.h, horizontal: 5.w),
                      decoration: BoxDecoration(
                          color: gPrimaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        positiveButtonName ?? "YES",
                        style: TextStyle(
                          fontFamily: "GothamRoundedBold_21016",
                          color: gMainColor,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h)
            ],
          ),
        ),
      ));
}