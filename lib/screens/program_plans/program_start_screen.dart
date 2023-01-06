import 'package:flutter/material.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/screens/program_plans/meal_plan_screen.dart';
import 'package:gwc_customer/services/program_service/program_service.dart';
import 'package:sizer/sizer.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import '../../model/program_model/start_program_on_swipe_model.dart';
import '../../repository/api_service.dart';
import '../../repository/program_repository/program_repository.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'day_program_plans.dart';
import 'package:http/http.dart' as http;

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
                    startProgram();
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

  final ProgramRepository repository = ProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void startProgram() async{
    final response = await ProgramService(repository: repository).startProgramOnSwipeService('1');

    if(response.runtimeType == StartProgramOnSwipeModel){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MealPlanScreen(),
        ),
      );
    }
    else{
      ErrorModel model = response as ErrorModel;
      AppConfig().showSnackbar(context, model.message ?? AppConfig.oopsMessage);
    }
  }
}
