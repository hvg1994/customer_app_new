import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'days_plan_data.dart';
import 'meal_plan_screen.dart';

class DaysProgramPlan extends StatefulWidget {
  const DaysProgramPlan({Key? key}) : super(key: key);

  @override
  State<DaysProgramPlan> createState() => _DaysProgramPlanState();
}

class _DaysProgramPlanState extends State<DaysProgramPlan> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(height: 1.h),
              Text(
                "Program",
                style: TextStyle(
                    fontFamily: "GothamBold",
                    color: gPrimaryColor,
                    fontSize: 11.sp),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: buildDaysPlan(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildDaysPlan() {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 20,
            mainAxisExtent: 15.5.h),
        itemCount: dayPlansData.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              //  buildDayCompleted();
             // buildDayNotCompleted();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealPlanScreen(
                    day: dayPlansData[index]["day"],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      image: AssetImage(dayPlansData[index]["image"]),
                      fit: BoxFit.fill),
                  border: Border.all(color: dayPlansData[index]["color"], width: 2)),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 0.5.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: dayPlansData[index]["color"],
                      ),
                      child: Text(
                        " DAY ${dayPlansData[index]["day"]}",
                        style: TextStyle(
                          fontFamily: "GothamMedium",
                          color: gTextColor,
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  buildDayNotCompleted() {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(top: 2.h, left: 10.w, right: 10.w),
        decoration: const BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        height: size.height * 0.50,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
                    child: Icon(
                      Icons.clear,
                      color: gMainColor,
                      size: 1.8.h,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gMainColor),
              ),
              child: Image(
                height: 20.h,
                image: const AssetImage("assets/images/Pop up.png"),
              ),
            ),
            SizedBox(height: 1.5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                "Your Day 1 Meal Plan Not yet completed you want to continue the day 2 Meal Plan ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontFamily: "GothamBold",
                  color: gTextColor,
                  fontSize: 10.sp,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: gPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: gMainColor, width: 1),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: "GothamRoundedBold_21016",
                    color: gMainColor,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildDayCompleted() {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(top: 2.h, left: 10.w, right: 10.w),
        decoration: const BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        height: size.height * 0.50,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
                    child: Icon(
                      Icons.clear,
                      color: gMainColor,
                      size: 1.8.h,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gMainColor),
              ),
              child: Image(
                height: 20.h,
                image: const AssetImage("assets/images/Image 2.png"),
              ),
            ),
            SizedBox(height: 1.5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                "Your Have completed the 15 days Meal Plan, Now you can proceed to Post Protocol",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontFamily: "GothamBold",
                  color: gTextColor,
                  fontSize: 10.sp,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: gPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: gMainColor, width: 1),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: "GothamRoundedBold_21016",
                    color: gMainColor,
                    fontSize: 12.sp,
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
