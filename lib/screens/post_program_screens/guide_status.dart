import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class GuideStatus extends StatefulWidget {
  final String title;
  const GuideStatus({Key? key, required this.title}) : super(key: key);

  @override
  State<GuideStatus> createState() => _GuideStatusState();
}

class _GuideStatusState extends State<GuideStatus> {
  String selectedValue = "";

  List dayReaction = [
    {
      "reaction": "assets/lottie/sad_face.json",
      "day": "Day 1",
    },
    {
      "reaction": "assets/lottie/sad_look.json",
      "day": "Day 2",
    },
    {
      "reaction": "assets/lottie/happy_face.json",
      "day": "Day 3",
    },
    {
      "reaction": "assets/lottie/sad_face.json",
      "day": "Day 4",
    },
    {
      "reaction": "assets/lottie/sad_look.json",
      "day": "Day 5",
    },
    {
      "reaction": "assets/lottie/happy_face.json",
      "day": "Day 6",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
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
                      widget.title,
                      style: TextStyle(
                          fontFamily: "GothamBold",
                          color: gPrimaryColor,
                          fontSize: 11.sp),
                    ),
                    // buildList(),
                    Lottie.asset('assets/lottie/emoji_waiting.json'),
                    Container(
                      width: double.maxFinite,
                      height: 1,
                      color: gGreyColor.withOpacity(0.3),
                    ),
                    SizedBox(height: 1.5.h),
                  ],
                ),
              ),
              buildTile('assets/lottie/loading_tick.json', "Do"),
              buildTile('assets/lottie/loading_wrong.json', "Don't Do"),
              buildTile('assets/lottie/loading_wrong.json', "None"),
            ],
          ),
        ),
      ),
    );
  }

  buildTile(String lottie, String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 3.h,
                child: Lottie.asset(lottie),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    color: gBlackColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
              Radio(
                value: title,
                activeColor: kPrimaryColor,
                groupValue: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                    Navigator.pop(context, title);
                  });
                },
              ),
            ],
          ),
          Container(
            width: double.maxFinite,
            height: 1,
            color: gGreyColor.withOpacity(0.3),
          ),
          SizedBox(height: 1.h),
          Text(
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
            style: TextStyle(
              height: 1.5,
              fontSize: 8.sp,
              color: gBlackColor,
              fontFamily: "GothamBook",
            ),
          )
        ],
      ),
    );
  }

  buildList() {
    return SizedBox(
      height: 30.h,
      child: ListView.builder(
        itemCount: dayReaction.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 5.h),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(dayReaction[index]["reaction"], height: 15.h),
                SizedBox(height: 2.h),
                Text(
                  dayReaction[index]["day"],
                  style: TextStyle(
                      fontFamily: "GothamMedium",
                      color: gBlackColor,
                      fontSize: 10.sp),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
