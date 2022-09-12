import 'package:flutter/material.dart';
import 'package:gwc_customer/screens/program_plans/yoga_plan.dart';
import 'package:sizer/sizer.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'day_program_plans.dart';

class ProgramPlanScreen extends StatefulWidget {
  const ProgramPlanScreen({Key? key}) : super(key: key);

  @override
  State<ProgramPlanScreen> createState() => _ProgramPlanScreenState();
}

class _ProgramPlanScreenState extends State<ProgramPlanScreen> {
  List<Widget> itemsData = [];

  @override
  void initState() {
    super.initState();
    getPostsData();
  }

  void getPostsData() {
    List<dynamic> responseList = YOGAPLAN;
    List<Widget> listItems = [];
    for (var post in responseList) {
      listItems.add(
        GestureDetector(
          onTap: () {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (ct) => const DashboardPage()));
          },
          child: Column(
            children: [
              SizedBox(
                height: 16.h,
                child: Image(
                  image: AssetImage(post["image"]),
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                post["slot_time"],
                style: TextStyle(
                    fontFamily: "GothamBook",
                    color: gTextColor,
                    fontSize: 9.sp),
              ),
            ],
          ),
        ),
      );
    }
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding:
            EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildAppBar(() {
                      Navigator.pop(context);
                    }),
                    Text(
                      "Program",
                      style: TextStyle(
                          fontFamily: "GothamRoundedBold_21016",
                          color: gPrimaryColor,
                          fontSize: 12.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Container(
                  height: 40.h,
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/Mask Group 2.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Center(
                    child: Image(
                      height: 15.h,
                      image: const AssetImage("assets/images/Gut welness logo.png"),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Lorem lpsum is simply dummy text of the printing and typesetting idustry",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.5,
                      fontFamily: "GothamBook",
                      color: gMainColor,
                      fontSize: 9.sp),
                ),
                SizedBox(height: 8.h),
                ConfirmationSlider(
                  width: 95.w,
                  text: "Slide To Start",
                  sliderButtonContent: const Image(
                    image: AssetImage(
                        "assets/images/splash_screen/noun-arrow-1921075.png"),
                  ),
                  foregroundColor: kPrimaryColor,
                  foregroundShape: BorderRadius.zero,
                  backgroundShape: BorderRadius.zero,
                  shadow: BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(2, 10),
                  ),
                  textStyle: TextStyle(
                      fontFamily: "GothamBook",
                      color: gTextColor,
                      fontSize: 11.sp),
                  onConfirmation: () {
                        Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DaysProgramPlan(),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildYogaPlan() {
    return SizedBox(
      height: 20.h,
      child: ListView.builder(
        itemCount: itemsData.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return itemsData[index];
        },
      ),
    );
  }
}
