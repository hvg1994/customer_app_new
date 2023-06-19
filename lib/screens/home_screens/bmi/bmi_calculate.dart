import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:gwc_customer/screens/home_screens/bmi/weight_slider.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'bmi_result.dart';
import 'calculate_bmi.dart';

enum Gender { male, female }

class BMICalculate extends StatefulWidget {
  const BMICalculate({Key? key}) : super(key: key);

  @override
  _BMICalculateState createState() => _BMICalculateState();
}

class _BMICalculateState extends State<BMICalculate> {
  Gender? selectedGender;
  int height = 180;
  int weight = 60;
  int age = 18;

  RulerPickerController? _rulerPickerController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.w, bottom: 1.h, top: 1.h),
                child: buildAppBar(
                  () {
                    Navigator.pop(context);
                  },
                  showNotificationIcon: false,
                  isBackEnable: true,
                  showLogo: false,
                  showChild: true,
                  child: Text(
                    "BMI Calculator",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: eUser().mainHeadingColor,
                      fontFamily: eUser().mainHeadingFont,
                      fontSize: eUser().mainHeadingFontSize,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = Gender.male;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        decoration: BoxDecoration(
                            color: gWhiteColor,
                            borderRadius: BorderRadius.circular(10.0),
                            border: selectedGender == Gender.male
                                ? Border.all(color: gBlackColor, width: 2)
                                : Border.all(color: kLineColor, width: 1)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.male_sharp,
                                size: 8.h,
                                color: selectedGender == Gender.male
                                    ? gMainColor
                                    : gHintTextColor),
                            SizedBox(height: 2.h),
                            Text(
                              "Male",
                              style: selectedGender == Gender.male
                                  ? TextStyle(
                                      color: eUser().mainHeadingColor,
                                      fontFamily: eUser().mainHeadingFont,
                                      fontSize: eUser().userFieldLabelFontSize,
                                    )
                                  : TextStyle(
                                      color: eUser().mainHeadingColor,
                                      fontFamily: eUser().userTextFieldFont,
                                      fontSize: eUser().userFieldLabelFontSize,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedGender = Gender.female;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        decoration: BoxDecoration(
                            color: gWhiteColor,
                            borderRadius: BorderRadius.circular(10.0),
                            border: selectedGender == Gender.female
                                ? Border.all(color: gBlackColor, width: 2)
                                : Border.all(color: kLineColor, width: 1)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.female_sharp,
                                size: 8.h,
                                color: selectedGender == Gender.female
                                    ? kBigCircleBorderRed
                                    : gHintTextColor),
                            SizedBox(height: 2.h),
                            Text(
                              "Female",
                              style: selectedGender == Gender.female
                                  ? TextStyle(
                                      color: eUser().mainHeadingColor,
                                      fontFamily: eUser().mainHeadingFont,
                                      fontSize: eUser().userFieldLabelFontSize,
                                    )
                                  : TextStyle(
                                      color: eUser().mainHeadingColor,
                                      fontFamily: eUser().userTextFieldFont,
                                      fontSize: eUser().userFieldLabelFontSize,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: EdgeInsets.symmetric(vertical: 3.h),
                decoration: BoxDecoration(
                    color: gWhiteColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: kLineColor, width: 1)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Height (in cm)',
                      style: TextStyle(
                        color: eUser().mainHeadingColor,
                        fontFamily: eUser().mainHeadingFont,
                        fontSize: eUser().mainHeadingFontSize,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            height.toString(),
                            style: TextStyle(
                              color: eUser().mainHeadingColor,
                              fontFamily: eUser().mainHeadingFont,
                              fontSize: eUser().userFieldLabelFontSize,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'cm',
                            style: TextStyle(
                              color: eUser().userTextFieldColor,
                              fontFamily: eUser().userTextFieldFont,
                              fontSize: eUser().userTextFieldFontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        color: kBigCircleBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RulerPicker(
                        controller: _rulerPickerController,
                        beginValue: 120,
                        rulerBackgroundColor: kBigCircleBg,
                        endValue: 220,
                        initValue: height,
                        // scaleLineStyleList: [
                        //   ScaleLineStyle(
                        //       color: Colors.grey, width: 1.5, height: 30, scale: 0),
                        //   ScaleLineStyle(
                        //       color: Colors.grey, width: 1, height: 25, scale: 5),
                        //   ScaleLineStyle(
                        //       color: Colors.grey, width: 1, height: 15, scale: -1)
                        // ],
                        // onBuildRulerScalueText: (index, scaleValue) {
                        //   return ''.toString();
                        // },
                        onValueChange: (value) {
                          setState(() {
                            height = value;
                          });
                        },
                        width: MediaQuery.of(context).size.width,
                        height: 8.h,
                        rulerMarginTop: 1.5.h,
                        // marker: Icon(
                        //   Icons.arrow_drop_down_sharp,
                        //   size: 5.h,
                        //   color: gBlackColor,
                        // ),
                      ),
                    ),
                    // Container(
                    //   margin:
                    //       EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    //   padding: EdgeInsets.symmetric(horizontal: 3.w),
                    //   decoration: BoxDecoration(
                    //     color: kBigCircleBg,
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: HorizontalPicker(
                    //     height: 10.h,
                    //     minValue: 120,
                    //     maxValue: 220,
                    //     divisions: 1000,
                    //     suffix: "  ",
                    //     initialPosition: InitialPosition.center,
                    //     showCursor: false,
                    //     backgroundColor: kBigCircleBg,
                    //     activeItemTextColor: kNumberCircleRed,
                    //     passiveItemsTextColor: gHintTextColor,
                    //     onChanged: (double newHeight) {
                    //       setState(() {
                    //         height = newHeight.round();
                    //       });
                    //     },
                    //   ),
                    // ),
                    // SliderTheme(
                    //   data: SliderTheme.of(context).copyWith(
                    //     inactiveTrackColor: kNumberCircleAmber.withOpacity(0.3),
                    //     activeTrackColor: kNumberCircleRed,
                    //     thumbColor: Color(0xFFE83D66),
                    //     overlayColor: Color(0x29E83D66),
                    //     thumbShape:
                    //         RoundSliderThumbShape(enabledThumbRadius: 10.0),
                    //     overlayShape:
                    //         RoundSliderOverlayShape(overlayRadius: 20.0),
                    //   ),
                    //   child: Slider(
                    //     value: height.toDouble(),
                    //     min: 120.0,
                    //     max: 220.0,
                    //     onChanged: (double newHeight) {
                    //       setState(() {
                    //         height = newHeight.round();
                    //       });
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 22.h,
                      margin: const EdgeInsets.all(10.0),
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      decoration: BoxDecoration(
                          color: gWhiteColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: kLineColor, width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Weight (in kg)',
                            style: TextStyle(
                              color: eUser().mainHeadingColor,
                              fontFamily: eUser().mainHeadingFont,
                              fontSize: eUser().mainHeadingFontSize,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Container(
                              height: 10.h,
                              decoration: BoxDecoration(
                                color: kBigCircleBg,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Icon(
                                    Icons.arrow_drop_down_sharp,
                                    size: 5.h,
                                    color: gBlackColor,
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) =>
                                        constraints.isTight
                                            ? Container()
                                            : WeightSlider(
                                                minValue: 30,
                                                maxValue: 110,
                                                width: constraints.maxWidth,
                                                value: weight,
                                                onChanged: (val) => setState(
                                                    () => weight = val),
                                                scrollController:
                                                    ScrollController(
                                                  initialScrollOffset:
                                                      (weight - 30) *
                                                          constraints.maxWidth /
                                                          3,
                                                ),
                                              ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     buildAgeIcon(
                          //       () {
                          //         setState(() {
                          //           weight--;
                          //         });
                          //       },
                          //       Icons.remove,
                          //     ),
                          //     Text(
                          //       weight.toString(),
                          //       style: TextStyle(
                          //         color: eUser().mainHeadingColor,
                          //         fontFamily: eUser().mainHeadingFont,
                          //         fontSize: eUser().mainHeadingFontSize,
                          //       ),
                          //     ),
                          //     buildAgeIcon(
                          //       () {
                          //         setState(() {
                          //           weight++;
                          //         });
                          //       },
                          //       Icons.add,
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 22.h,
                      margin: const EdgeInsets.all(10.0),
                      padding: EdgeInsets.only(top: 4.h, bottom: 6.h),
                      decoration: BoxDecoration(
                          color: gWhiteColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: kLineColor, width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Age',
                            style: TextStyle(
                              color: eUser().mainHeadingColor,
                              fontFamily: eUser().mainHeadingFont,
                              fontSize: eUser().mainHeadingFontSize,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildAgeIcon(
                                () {
                                  setState(() {
                                    age--;
                                  });
                                },
                                Icons.remove,
                              ),
                              Text(
                                age.toString(),
                                style: TextStyle(
                                  color: eUser().mainHeadingColor,
                                  fontFamily: eUser().mainHeadingFont,
                                  fontSize: eUser().mainHeadingFontSize,
                                ),
                              ),
                              buildAgeIcon(
                                () {
                                  setState(() {
                                    age++;
                                  });
                                },
                                Icons.add,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              IntrinsicWidth(
                child: GestureDetector(
                  onTap: () {
                    CalculateBmi calc =
                        CalculateBmi(height: height, weight: weight);
                    showSymptomsTrackerSheet(
                      context,
                      calc.calulate(),
                      calc.getComment(),
                      calc.getResult(),
                    );
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return ResultPage(
                    //         bmi: calc.calulate(),
                    //         comment: calc.getComment(),
                    //         result: calc.getResult(),
                    //       );
                    //     },
                    //   ),
                    // );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: kNumberCircleRed,
                      borderRadius:
                          BorderRadius.circular(eUser().buttonBorderRadius),
                      // border: Border.all(
                      //     color: eUser().buttonBorderColor,
                      //     width: eUser().buttonBorderWidth
                      // ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontFamily: eUser().buttonTextFont,
                        color: eUser().buttonTextColor,
                        fontSize: eUser().userFieldLabelFontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildAgeIcon(VoidCallback func, IconData icon) {
    return InkWell(
      onTap: func,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: gWhiteColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: kLineColor, width: 1)),
        child: Icon(
          icon,
          size: 2.h,
        ),
      ),
    );
  }

  showSymptomsTrackerSheet(
      BuildContext context, String bmi, String comment, String result) {
    return AppConfig().showSheet(
      context,
      SizedBox(
        child: ResultPage(
          bmi: bmi,
          comment: comment,
          result: result,
        ),
      ),
      circleIcon: bsHeadPinIcon,
      bottomSheetHeight: 70.h,
      isSheetCloseNeeded: true,
    );
  }
}
