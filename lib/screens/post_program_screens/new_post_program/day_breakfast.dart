import 'package:flutter/material.dart';
import 'package:gwc_customer/screens/post_program_screens/new_post_program/early_morning.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class PPDailyTasksUI extends StatefulWidget {
  const PPDailyTasksUI({Key? key}) : super(key: key);

  @override
  State<PPDailyTasksUI> createState() => _PPDailyTasksUIState();
}

class _PPDailyTasksUIState extends State<PPDailyTasksUI> {

  List<StageTypes> stageMap = [
    StageTypes(stageImage: 'assets/images/gmg/early_morning.png', stageName: 'Early Morning'),
    StageTypes(stageImage: 'assets/images/gmg/breakfast.png', stageName: 'Breakfast'),
    StageTypes(stageImage: 'assets/images/gmg/midDay.png', stageName: 'Mid Day'),
    StageTypes(stageImage: 'assets/images/gmg/lunch.png', stageName: 'Lunch'),
    StageTypes(stageImage: 'assets/images/gmg/evening.png', stageName: 'Evening'),
    StageTypes(stageImage: 'assets/images/gmg/dinner.png', stageName: 'Dinner'),
    StageTypes(stageImage: 'assets/images/gmg/postDinner.png', stageName: 'Post Dinner'),
  ];
  
  List<RoutineTask> earlyMorning = [
    RoutineTask(title: 'Coriander Ginger Tea'),
    RoutineTask(title: 'Indian Tea'),
    RoutineTask(title: 'Malnad Kashaya'),
    RoutineTask(title: 'Tulasi Tea'),
    RoutineTask(title: 'Kattam chai'),
    RoutineTask(title: 'Green Tea'),
  ];
  List<RoutineTask> breakfast = [
    RoutineTask(title: 'Pesarattu'),
    RoutineTask(title: 'Idiyappam With Diluted Coconut Milk+Palm Candy Sugar'),
    RoutineTask(title: 'Rice Ambali'),
    RoutineTask(title: 'Steamed Idli With Moong Dal Sambar And Vegetable Peel Chutneys'),
    RoutineTask(title: 'Bottle gourd idli'),
    RoutineTask(title: 'Kadabus with chutneys of mint or coriander.'),
  ];
  List<RoutineTask> midDay = [
    RoutineTask(title: 'Gala apple juice OR whole fruit'),
    RoutineTask(title: 'Fruit Bowl'),
    RoutineTask(title: 'Bulb black grapes juice'),
    RoutineTask(title: 'Veg soup'),
    RoutineTask(title: 'Pomegranate juice'),
    RoutineTask(title: 'Pear fruit'),
  ];
  List<RoutineTask> lunch = [
    RoutineTask(title: 'South Indian Thali Including Soft Cooked Boiled Matta Rice + Buttermilk + Avial + Vegetable Rasam'),
    RoutineTask(title: 'South Indian Thali Including Soft Cooked White Rice + Buttermilk + Vegetable Poriyal(Limit The Coconut To 1 Tsp)+ Vegetable Rasam (Use Carrot Or Any Gourd Vegetable Instead Of Tomato)'),
    RoutineTask(title: 'South Indian Thali Including Soft Cooked White Rice + Curd(4 Tsp-Made From Cow Milk And Fresh) + Vegetable Poriyal(Limit The Coconut To 1 Tsp)+ Cooked Snake Gourd Pachadi '),
  ];
  List<RoutineTask> evening = [
    RoutineTask(title: 'Veg clear soup'),
    RoutineTask(title: 'Coriander Ginger Tea'),
    RoutineTask(title: 'Dry fruits smoothie'),
    RoutineTask(title: 'Senna tea'),
    RoutineTask(title: 'Avocado dry fruits smoothie'),
    RoutineTask(title: 'Apple avocado dry fruits smoothie'),
  ];
  List<RoutineTask> dinner = [
    RoutineTask(title: 'Idiyappam With Vegetable Stew(Prepared By Using Only 2-3 Tsp Of Coconut Milk)'),
    RoutineTask(title: 'Steamed Idli With Moong Dal Sambar And Vegetable Peel Chutneys.'),
    RoutineTask(title: 'Savoury Pongal'),
    RoutineTask(title: 'Neer Dosa With Diluted Coconut Milk+Palm Candy Sugar + Mint Chutney'),
    RoutineTask(title: 'Soft Cooked Rice + Avial'),
  ];
  List<RoutineTask> postDinner = [
    RoutineTask(title: 'Fruit bowl'),
    RoutineTask(title: 'Turmeric Latte'),
    RoutineTask(title: 'Castor oil Hot water'),
    RoutineTask(title: 'Castor oil hot milk'),
    RoutineTask(title: 'Diluted skimmed plain milk'),
  ];

  List stages = [0,1,2,3,4,5,6];
  int currentStage = 0;
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
          child: Scaffold(
            body: showUIBasedOnStage(currentStage),
          )
      ),
    );
  }

  Future<bool> _onWillPop() async {
    var value;
    setState(() {
      if (currentStage != 0) {
        currentStage--;
      }
      // else if(currentStage == 0){
      //   AppConfig().showSnackbar(context, "Please Submit");
      //   value =
      // }
      else{
        value = Future.value(true);
      }
    });
    return value ?? Future.value(false);
  }

  dayWithImage(BuildContext context, String imageName, String stage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Day 1'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Center(child: Image(
              // height: 20.h,
              width: 70.w,
              image: AssetImage(imageName),
              fit: BoxFit.fitHeight,
            )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Center(
            child: Column(
              children: [
                Text(stage),
                SizedBox(
                  height: 10,
                ),
                Text('Suggested for your Gut type')
              ],
            ),
          ),
        )
      ],
    );
  }

  bottomShowView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Text('Early Morning'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('Coriander ginger tea'),
          ),
          Expanded(
            child: Column(
              children: [
                Text('Benifits'),
                Text('* Heals the gut epithelia'),
                Text('* Gut mucosal health'),
                Text('* Builds gut micro biome and immunity'),
              ],
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                print(currentStage);
                if(currentStage < stages.length){
                  setState(() {
                    currentStage++;
                  });
                }
              },
              child: Container(
                padding:
                EdgeInsets.symmetric(vertical: 1.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: eUser().buttonColor,
                  borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                  border: Border.all(
                      color: eUser().buttonBorderColor,
                      width: eUser().buttonBorderWidth
                  ),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: eUser().buttonTextFont,
                    color: eUser().buttonTextColor,
                    fontSize: eUser().buttonTextSize,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 6,
          )
        ],
      ),
    );
  }

  bottomSendView(BuildContext context, String heading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          showBottomHeadingView(heading, '', 'This meal should not skip'),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
                itemBuilder: (_, index){
                  return listViewItems('abc', false);
                }
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                print(stages.length);
                if(currentStage < stages.length-1){
                  setState(() {
                    currentStage++;
                  });
                }
                else if(currentStage == stages.length-1){

                }
                print(currentStage);
              },
              child: Container(
                padding:
                EdgeInsets.symmetric(vertical: 1.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: eUser().buttonColor,
                  borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                  border: Border.all(
                      color: eUser().buttonBorderColor,
                      width: eUser().buttonBorderWidth
                  ),
                ),
                child: Text(
                  (currentStage == stages.length-1) ? 'Submit' : 'Next',
                  style: TextStyle(
                    fontFamily: eUser().buttonTextFont,
                    color: eUser().buttonTextColor,
                    fontSize: eUser().buttonTextSize,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 6,
          )
        ],
      ),
    );
  }

  listViewItems(String title, bool isSelected){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Text(title)),
              Image.asset('assets/images/gmg/Symbol.png',
                width: 15, height: 15,
              )
            ],
          ),
          Divider(
            color: gBlackColor,
          )
        ],
      ),
    );
  }

  showBottomHeadingView(String title, String subTitle, String suffixText){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          (suffixText.isEmpty) ? Text(title) :
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(suffixText)
            ],
          ),
          (subTitle.isEmpty) ? SizedBox.shrink() : Text(subTitle)
        ],
      ),
    );
  }

  Widget showUIBasedOnStage(int currentStage){
    Widget? _widget;
    switch(currentStage){
      case 0: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[0].stageImage , stageMap[0].stageName),
        bottomWidget: bottomSendView(context, stageMap[0].stageName),
      );
      break;
      case 1: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[1].stageImage , stageMap[1].stageName),
        bottomWidget: bottomSendView(context, stageMap[1].stageName),
      );
      break;
      case 2: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[2].stageImage , stageMap[2].stageName),
        bottomWidget: bottomSendView(context, stageMap[2].stageName),
      );
      break;
      case 3: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[3].stageImage , stageMap[3].stageName),
        bottomWidget: bottomSendView(context, stageMap[3].stageName),
      );
      break;
      case 4: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[4].stageImage , stageMap[4].stageName),
        bottomWidget: bottomSendView(context, stageMap[4].stageName),
      );
      break;
      case 5: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[5].stageImage , stageMap[5].stageName),
        bottomWidget: bottomSendView(context, stageMap[5].stageName),
      );
      break;
      case 6: _widget = ShowStageUI(
        topWidget: dayWithImage(context, stageMap[6].stageImage , stageMap[6].stageName),
        bottomWidget: bottomSendView(context, stageMap[6].stageName),
      );
      break;
    }
    return _widget ?? SizedBox(child: Text(currentStage.toString()),);
  }
}


class RoutineTask{
  String title;
  bool isSelected;
  RoutineTask({required this.title, this.isSelected = false});
}

class StageTypes{
  String stageImage;
  String stageName;
  StageTypes({required this.stageImage, required this.stageName});
}