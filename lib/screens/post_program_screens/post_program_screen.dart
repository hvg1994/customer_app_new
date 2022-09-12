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
          padding:
          EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 5.h),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              Text(
                "Post Program",
                style: TextStyle(
                    fontFamily: "GothamRoundedBold_21016",
                    color: gPrimaryColor,
                    fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
