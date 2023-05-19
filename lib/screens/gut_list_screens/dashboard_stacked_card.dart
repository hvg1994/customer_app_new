import 'package:flutter/material.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import 'package:sizer/sizer.dart';

class MainStackedCard extends StatefulWidget {
  const MainStackedCard({Key? key}) : super(key: key);

  @override
  State<MainStackedCard> createState() => _MainStackedCardState();
}

class _MainStackedCardState extends State<MainStackedCard> {
  ScrollPhysics physics = const AlwaysScrollableScrollPhysics();
  static const minHeightFactor = 0.15;
  static const maxHeightFactor = 1.0;
  int total = 8;
  int current = 1;
  int locked = 5;
  List currentStageList = [];
  List lockedStageList = [];

  static const newDashboardLockIcon = "assets/images/new_ds/lock.png";


  double heightFactor = minHeightFactor;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: physics,
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: total,
                  itemBuilder: (_, index){
                  if(index < current){
                    return AnimatedAlign(
                      duration: Duration(milliseconds: 800),
                      heightFactor: heightFactor,
                      alignment: Alignment.topCenter,
                      child: bigCard(),
                    );
                  }
                  if(index == current){
                    return Column(
                      children: [
                        SizedBox(
                          height: 220,
                          child: Visibility(
                            visible: heightFactor != minHeightFactor,
                            child: Center(
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    heightFactor = minHeightFactor;
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amber
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: Image.asset("assets/images/up_arrow.png",
                                          fit: BoxFit.scaleDown,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: heightFactor != maxHeightFactor,
                          child: Align(
                            heightFactor: 0.7,
                            alignment: Alignment.topRight,
                            child: smallCard(),
                          ),
                        )
                      ],
                    );
                  }
                  else {
                    return Visibility(
                      visible: heightFactor != maxHeightFactor,
                      child: Align(
                        heightFactor: 0.7,
                        alignment: Alignment.topRight,
                        child: smallCard(),
                      ),
                    );
                  }
                  }
              ),
              SizedBox(height: 10,),
              // ListView.builder(
              //     physics: NeverScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     itemCount: 3,
              //     itemBuilder: (_, index){
              //       return Align(
              //         heightFactor: 0.7,
              //         alignment: Alignment.center,
              //         child: smallCard(),
              //       );
              //     }
              // ),

            ],
          ),
        ),
      ),
    );
  }

  bigCard(){
    return GestureDetector(
      onTap: (){
        print("tap");
      },
      onVerticalDragUpdate: (heightFactor == maxHeightFactor) ? null : (details){
        print("drag");
        print(details.delta);
        print(details.localPosition);

        heightFactor = maxHeightFactor;
        setState(() {

        });

      },
      child: Stack(
        children: [
          Container(
            height: 215,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 25),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: DashboardColors.currentStageBg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(100), blurRadius: 10
                )]
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:10.0),
                          child: Text("Evaluation",
                            style:  TextStyle(
                                fontSize: 12.sp,
                                fontFamily: kFontBold
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:4.0),
                          child: Text("A Critical information needed by our doctors to understand your Medical history, "
                              "Symptoms, Sleep, Diet & Lifestyle for proper diagnosis!",
                              style:  TextStyle(
                                height: 1.2,
                                  fontSize: 9.sp,
                                  fontFamily: kFontBook
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:6.0),
                          child: Text("This evaluation by itself indicates the direction of our diagnosis. "
                              "So please spend quality time to complete your evaluation",
                              style:  TextStyle(
                                height: 1.2,
                                  fontSize: 9.sp,
                                  fontFamily: kFontBook
                              )
                          ),
                        ),
                        buildButton("View File", DashboardColors.currentStageBtnColor, 1)
                      ],
                    )
                ),
                Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.only(top: 15),
                    child: Image.asset("assets/images/new_ds/calender.png"))
              ],
            ),
          ),
          Positioned(
            left: 30,
              top: 1,
              child: StepWidget()
          ),
          Positioned(
              top: 3,
right: 0,left: 0,
              child: SizedBox(
                width: 70,
                height: 25,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/images/\dashboard_stages/center.png",),
                    Positioned(
                        top: 6,
                        left: 5,
                        right: 5,
                        child: Text("Your Current Stage",
                          textAlign: TextAlign.center,
                        ))
                  ],
                ),
              )
          )


        ],
      ),
    );
  }

  StepWidget(){
    return SizedBox(
      width: 70,
      height: 60,
      child: Stack(
        children: [
          Image.asset("assets/images/\dashboard_stages/step.png",
            color: DashboardColors.stepCurrentStageColor,
          ),
          Positioned(
            top: 6,
              left: 5,
              right: 5,
              child: Text("Step 1",
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }

  smallCard(){
    return Stack(
      children: [
        Container(
          height: 120,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [BoxShadow(
              color: Colors.black.withAlpha(100), blurRadius: 10
            )]
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Heading",
                      style:  TextStyle(
                        fontSize: 12.sp,
                        fontFamily: kFontBold
                      ),),
                      SizedBox(width: 8),

                    ],
                  ),
                  SizedBox(height: 8,),
                  Text("sub text",
                      style:  TextStyle(
                          fontSize: 10.sp,
                          fontFamily: kFontBook
                      )
                  )
                ],
              )),
              SizedBox(
                width: 60,
                  height: 60,
                  child: Image.asset("assets/images/new_ds/calender.png"))
            ],
          ),
        ),
        Positioned(
            left: 30,
            top: 1,
            child: StepWidget()
        ),
      ],
    );
  }

  buildButton(String title, Color color, int buttonId) {
    return GestureDetector(
      onTap: () {
        // handleButtonOnTapByType(stageType, buttonId);
      },
      child: IntrinsicWidth(
        child: Container(
          height: 3.h,
          margin: EdgeInsets.symmetric(vertical: 0.3.h),
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: kLineColor,
                blurRadius: 5,
                offset: const Offset(2, 3),
              )
            ],
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: kFontMedium,
                  color: gWhiteColor,
                  fontSize: 8.sp,
                ),
              ),
              // Icon(
              //   Icons.arrow_forward,
              //   color: gMainColor,
              //   size: 10.sp,
              // )
            ],
          ),
        ),
      ),
    );
  }

}



class DashboardColors{
  static const String currentStageFontFamily = kFontSensaBrush;
  static const Color currentStageBg = Color(0xFFFFD23F);
  static const Color currentStageBtnColor = Color(0xFFFD8B7B);

  static const Color pastStageBg = Color(0xFF8CC59E);
  static const Color pastStageBtnColor = Color(0xFF465C4D);

  static const Color stepCurrentStageColor = Color(0xFFf6ca35);

}

