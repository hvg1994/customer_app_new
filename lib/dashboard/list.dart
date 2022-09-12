import 'package:flutter/material.dart';
import 'package:gwc_customer/dashboard/List/program_stages_datas.dart';
import 'package:gwc_customer/screens/post_program_screens/post_program_screen.dart';
import 'package:gwc_customer/screens/program_plans/program_plan_screen.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

import '../screens/ayurveda_screens/ayurveda_calender_time_screen.dart';
import '../screens/cook_kit_shipping_screens/cook_kit_tracking.dart';
import 'List/list_view_effect.dart';

class GutList extends StatefulWidget {
  const GutList({Key? key}) : super(key: key);

  @override
  State<GutList> createState() => _GutListState();
}

class _GutListState extends State<GutList> {
  String isSelected = "";

  final Duration _duration = const Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(height: 3.h),
              Text(
                "Program Stages",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "GothamRoundedBold_21016",
                    color: gPrimaryColor,
                    fontSize: 11.sp),
              ),
              SizedBox(height: 1.h),
              Expanded(
                child: ListViewEffect(
                  duration: _duration,
                  children: ProgramStages.map((s) => _buildWidgetExample(
                      ProgramsData(s['title']!, s['image']!))).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changedIndex(String index) {
    setState(() {
      isSelected = index;
    });
  }

  Widget _buildWidgetExample(ProgramsData programsData) {
    return GestureDetector(
      onTap: () {
        changedIndex(programsData.title);
      },
      child: Container(
          padding:
              EdgeInsets.only(left: 2.w, top: 0.5.h, bottom: 0.5.h, right: 5.w),
          margin: EdgeInsets.symmetric(vertical: 1.5.h),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: gMainColor.withOpacity(0.3), width: 1),
            boxShadow: (isSelected != programsData.title)
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 1,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(2, 10),
                    ),
                  ],
          ),
          child: Row(
            children: [
              (isSelected == programsData.title)
                  ? Image(
                      height: 9.h,
                      image: AssetImage(programsData.image),
                    )
                  : ColorFiltered(
                      colorFilter:
                          const ColorFilter.mode(Colors.grey, BlendMode.darken),
                      child: Image(
                        height: 9.h,
                        image: AssetImage(programsData.image),
                      ),
                    ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  programsData.title,
                  style: TextStyle(
                    fontFamily: "GothamMedium",
                    color: (isSelected == programsData.title)
                        ? gMainColor
                        : gsecondaryColor,
                    fontSize: 10.sp,
                  ),
                ),
              ),
              (isSelected == programsData.title)
                  ? InkWell(
                      onTap: () {
                        if (programsData.title == "Consultation") {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AyurvedaCalenderTimeScreen(),
                            ),
                          );
                        } else if (programsData.title == "Shipping") {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CookKitTracking(),
                            ),
                          );
                        } else if (programsData.title == "Programs") {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProgramPlanScreen(),
                            ),
                          );
                        } else if (programsData.title == "Post Program") {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PostProgramScreen(),
                            ),
                          );
                        }
                      },
                      child: Image(
                        height: 3.h,
                        image: const AssetImage(
                            "assets/images/noun-arrow-1018952.png"),
                      ),
                    )
                  : Container(
                      width: 2.w,
                    ),
            ],
          )),
    );
  }
}

class ProgramsData {
  ProgramsData(this.title, this.image);

  String title;
  String image;
}
