import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding:
                EdgeInsets.only(left: 4.w, right: 4.w, top: 3.h, bottom: 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(() {
                  Navigator.pop(context);
                }),
                SizedBox(height: 2.h),
                Text(
                  "Terms & Conditions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "GothamBold",
                      color: gPrimaryColor,
                      fontSize: 12.sp),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  'Lorem ipsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.It has survived not only five centuries,but also the leap into electronic typesetting,remaining essentially unchanged.It was popularised in the 1960s with the release of Letraset sheets containing Lorem lpsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem lpsum. long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem lpsum is that it has amore_or_less normal distribution of letters, as opposed to using \'Content here,content here\',making it look like readable english. Many desktop publishing packages and web page editors now use Lorem lpsum as their default model text,and asearch for \'lorem lpsum\' will uncover many web sites still in their infancy.Various versions have evolved over the years,sometimes by accident, sometimes on purpose(injected humour and the like).',
                  style: TextStyle(
                    height: 1.8,
                    fontSize: 10.sp,
                    color: gTextColor,
                    fontFamily: "GothamMedium",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
