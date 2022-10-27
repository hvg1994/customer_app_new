import 'package:flutter/material.dart';
import 'package:gwc_customer/screens/post_program_screens/protocol_guide_screen.dart';
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
                    fontFamily: "GothamBold",
                    color: gPrimaryColor,
                    fontSize: 11.sp),
              ),
              SizedBox(height: 2.h),
              buildPostPrograms(
                "assets/images/medical-staff.png",
                "Consultation",
                () {},
              ),
              buildPostPrograms(
                "assets/images/information.png",
                "Protocol Guide",
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProtocolGuideScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildPostPrograms(String image, String title, func) {
    return GestureDetector(
      onTap: func,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
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
            ]),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                height: 8.h,
                image: AssetImage(image),
              ),
            ),
            SizedBox(width: 5.w),
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
      ),
    );
  }
}
