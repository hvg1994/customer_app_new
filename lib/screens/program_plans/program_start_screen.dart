import 'package:flutter/material.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/screens/prepratory%20plan/prepratory_meal_completed_screen.dart';
import 'package:gwc_customer/screens/prepratory%20plan/prepratory_plan_screen.dart';
import 'package:gwc_customer/screens/prepratory%20plan/transition_mealplan_screen.dart';
import 'package:gwc_customer/screens/program_plans/meal_plan_screen.dart';
import 'package:gwc_customer/services/program_service/program_service.dart';
import 'package:gwc_customer/widgets/open_alert_box.dart';
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

enum ProgramMealType {
  prepratory, program, transition
}

class ProgramPlanScreen extends StatefulWidget {
  final String from;
  final bool? isPrepCompleted;
  const ProgramPlanScreen({Key? key, required this.from, this.isPrepCompleted}) : super(key: key);

  @override
  State<ProgramPlanScreen> createState() => _ProgramPlanScreenState();
}

class _ProgramPlanScreenState extends State<ProgramPlanScreen> {

  final _pref = AppConfig().preferences;
  bool isSlided = false;
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
              (isSlided) ? Center(child: buildThreeBounceIndicator(),) :ConfirmationSlider(
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
                      fontFamily: kFontMedium,
                      color: gTextColor,
                      fontSize: 10.sp),
                  onConfirmation: () {
                    setState(() {
                      isSlided = true;
                    });
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
          (widget.from == ProgramMealType.prepratory.name)
              ? "The preparatory phase aids in the optimal preparation of the gastrointestinal tract for detoxification and repair. Gut acid and enzyme optimization can be achieved by adapting typical diets to your gut type and condition, as well as avoiding certain addictions/habits such as smoking, drinking, and so on."
              : widget.from == ProgramMealType.program.name
              ? "Our approach on healing the condition: To cleanse and heal your stomach, we employ integrated Calm, Move, and Nourish modules that are tailored to your gut type. \n\nEvery meal is scheduled based on the Metabolic nature of your gut and its relationship to your biological clock. This implies that each food item at each meal time has a distinct role in resetting your gut's functionality by adjusting to your biological clock. "
              : "Congratulations on completing your detox and healing program. Now, let us begin your transition days to enter a normal routine, for optimal healthy gut.",
          textAlign: TextAlign.justify,
          style: TextStyle(
              height: 1.5,
              fontFamily: kFontMedium,
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

    String? start;
    if(widget.from == ProgramMealType.prepratory.name){
      start = "2";
    }
    else if(widget.from == ProgramMealType.program.name){
      start = "1";
    }
    else if(widget.from == ProgramMealType.transition.name){
      start = "3";
    }

    if(start != null){
      final response = await ProgramService(repository: repository).startProgramOnSwipeService(start);

      if(response.runtimeType == StartProgramOnSwipeModel){
        //PrepratoryPlanScreen()
        if(widget.from == ProgramMealType.prepratory.name){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PrepratoryPlanScreen(dayNumber: "1", totalDays: '1',),
            ),
          );
        }
        else if(widget.from == ProgramMealType.program.name){
          if(widget.isPrepCompleted != null && widget.isPrepCompleted == false){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PrepratoryMealCompletedScreen(),
              ),
            );
          }
          else{
            final mealUrl = _pref!.getString(AppConfig().receipeVideoUrl);
            final trackerUrl = _pref!.getString(AppConfig().trackerVideoUrl);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MealPlanScreen(
                  receipeVideoLink: mealUrl,
                  trackerVideoLink: trackerUrl,
                ),
              ),
            );
          }
        }
        else if(widget.from == ProgramMealType.transition.name){
          final trackerUrl = _pref!.getString(AppConfig().trackerVideoUrl);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TransitionMealPlanScreen(dayNumber: "1",totalDays: "1",trackerVideoLink: trackerUrl,),
            ),
          );
        }
      }
      else{
        ErrorModel model = response as ErrorModel;
        AppConfig().showSnackbar(context, model.message ?? AppConfig.oopsMessage);
      }
    }
  }
}
