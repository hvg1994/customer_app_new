import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class PostProgramScreen extends StatefulWidget {
  const PostProgramScreen({Key? key}) : super(key: key);

  @override
  State<PostProgramScreen> createState() => _PostProgramScreenState();
}

class _PostProgramScreenState extends State<PostProgramScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            left: 4.w,
            right: 4.w,
            top: 1.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(height: 1.h),
              Text(
                "Post Program",
                style: TextStyle(
                    fontFamily: "GothamRoundedBold_21016",
                    color: gPrimaryColor,
                    fontSize: 12.sp),
              ),
              SizedBox(height: 2.h),
              buildPostPrograms("assets/images/information.png", "Protocol Guide"),
              buildPostPrograms("assets/images/medical-staff.png", "Consultation"),
            ],
          ),
        ),
      ),
    );
  }

  buildPostPrograms(String image, String title) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
      margin: EdgeInsets.symmetric(vertical: 1.5.h),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gMainColor.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
          ),
        ]
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              height: 9.h,
              image: AssetImage(image),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: "GothamMedium",
                color: gTextColor,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
