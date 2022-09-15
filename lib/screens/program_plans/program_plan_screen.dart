import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 5.h),
          child: Column(
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(
                height: 3.h,
              ),
              Expanded(
                child: buildPlans(),
              ),
              ConfirmationSlider(
                  width: 95.w,
                  text: "Slide To Start",
                  sliderButtonContent: const Image(
                    image: AssetImage(
                        "assets/images/noun-arrow-1921075.png"),
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
                      fontFamily: "GothamMedium",
                      color: gTextColor,
                      fontSize: 10.sp),
                  onConfirmation: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DaysProgramPlan(),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  buildPlans() {
    return Column(
      children: [
        const Image(
          image: AssetImage("assets/images/Group 4852.png"),
        ),
        SizedBox(height: 4.h),
        Text(
          "Lorem ipsum is simply dummy text of the printing and typesetting industry.Lorem ipsum has been the industry's standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
          textAlign: TextAlign.center,
          style: TextStyle(
              height: 1.5,
              fontFamily: "GothamMedium",
              color: gTextColor,
              fontSize: 10.sp),
        ),
      ],
    );
  }
}
