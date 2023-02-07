import 'package:flutter/material.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/repository/api_service.dart';
import 'package:gwc_customer/repository/prepratory_repository/prep_repository.dart';
import 'package:gwc_customer/services/prepratory_service/prepratory_service.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../model/success_message_model.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class PrepratoryMealCompletedScreen extends StatefulWidget {
  const PrepratoryMealCompletedScreen({Key? key}) : super(key: key);

  @override
  State<PrepratoryMealCompletedScreen> createState() => _PrepratoryMealCompletedScreenState();
}

class _PrepratoryMealCompletedScreenState extends State<PrepratoryMealCompletedScreen> {

  List<QuestionsView> questions = [
    QuestionsView("Has your hunger improved?", -1, 'hunger_improved'),
    QuestionsView("Has your appetite improved?", -1, 'appetite_improved'),
    QuestionsView("Are you feeling light?", -1, 'feeling_light'),
    QuestionsView("Are you feeling energetic? ", -1, 'feeling_energetic'),
    QuestionsView("Are you feeling a mild reduction in your primary symptoms?", -1, 'mild_reduction')
  ];

  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              buildAppBar((){}),
              Center(child: SizedBox(
                width: 50.w,
                height: 50.w,
                child: Image.asset("assets/images/prep_meal_completed.png",
                  fit: BoxFit.scaleDown,
                ),
              )),
              SizedBox(
                height: 2.h,
              ),
              Center(
                child: Text("You Have Successfully Completed \n The Preparatory Meal Plan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    fontFamily: kFontMedium,
                    fontSize: 12.sp,
                    color: gPrimaryColor
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: questions.length,
                  itemBuilder: (_, index){
                    return radioView(questions[index], index);
                  },
              ),
              SizedBox(
                height: 5.h,
              ),
              GestureDetector(
                onTap: (){
                  if(questions.any((element) => element.selected == -1)){
                    AppConfig().showSnackbar(context, "Please Fill all questions", isError: true);
                  }
                  else{
                    submitPrepratoryMealTrackDetails();
                  }
                },
                child: Center(
                  child: Container(
                    width: 40.w,
                    height: 4.5.h,
                    // padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: eUser().buttonColor,
                      borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                      // border: Border.all(color: eUser().buttonBorderColor,
                      //     width: eUser().buttonBorderWidth),
                    ),
                    child: (showProgress)
                        ? buildThreeBounceIndicator(color: eUser().threeBounceIndicatorColor)
                        : Center(
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontFamily:
                          kFontRBold2,
                          color: gWhiteColor,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  radioView(QuestionsView view, int index){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(view.question,
            style: TextStyle(
                fontFamily: kFontMedium,
                fontSize: 11.sp,
                color: gBlackColor
            ),
          ),
          Row(
            children: [
              radioBtnView(view.selected, "Yes", index),
              SizedBox( width: 25,),
              radioBtnView(view.selected, "No", index)
            ],
          ),
          Container(
            height: 5,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.7),
                  width: 1.0,
                ),
              ),
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //     Colors.grey.withOpacity(0.3),
              //     Colors.grey.withOpacity(0.3),
              //   ],
              // ),
            ),
          )
        ],
      ),
    );
  }

  radioBtnView(int selected, String btnName, index){
    return GestureDetector(
      onTap: (){
        if(btnName == "Yes"){
          setState(() {
            questions[index].selected = 0;
          });
          print("selected: $selected");
        }
        else{
          setState(() {
            questions[index].selected = 1;
          });
          print(selected);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 15,
            child: Radio(
              value: (btnName == "Yes") ? 0 : 1,
              groupValue: selected,
              onChanged: (value){
                print("value: $value");
                setState(() {
                  questions[index].selected = value as int;
                });
              },
              activeColor: gsecondaryColor,
            ),
          ),
          SizedBox( width: 5,),
          Text(btnName,
            style: TextStyle(
                fontFamily: kFontLight,
                fontSize: 10.sp,
                color: (questions[index].selected == 1 && btnName == "No" ||
                    questions[index].selected == 0 && btnName == "Yes" ) ? gsecondaryColor : gBlackColor,
            ),
          )
        ],
      ),
    );
  }

  final PrepratoryRepository repository = PrepratoryRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  submitPrepratoryMealTrackDetails() async{
    setState(() {
      showProgress = true;
    });
    Map sendDetailsMap = {};
    questions.forEach((element) {
      sendDetailsMap.putIfAbsent(element.sendKey, () => element.selected == 0 ? 'Yes' : 'No');
    });

    print(sendDetailsMap);
    final res = await PrepratoryMealService(repository: repository).sendPrepratoryMealTrackDetailsService(sendDetailsMap);

    if(res.runtimeType == ErrorModel){
      final result = res as ErrorModel;
      print("Submit error: ${res.message}");
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
    }
    else{
      final result = res as SuccessMessageModel;
      AppConfig().showSnackbar(context, result.errorMsg ?? '');
      Navigator.pop(context);
      print("submit success");
    }
    setState(() {
      showProgress = false;
    });
  }


}

class QuestionsView{
  String question;
  int selected;
  String sendKey;

  QuestionsView(this.question, this.selected, this.sendKey);
}