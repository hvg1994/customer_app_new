import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gwc_customer/model/evaluation_from_models/get_evaluation_model/child_get_evaluation_data_model.dart';
import 'package:gwc_customer/screens/dashboard_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../model/error_model.dart';
import '../../../model/evaluation_from_models/evaluation_model_format2.dart';
import '../../../repository/api_service.dart';
import '../../../repository/evaluation_form_repository/evanluation_form_repo.dart';
import '../../../utils/app_config.dart';
import '../../model/dashboard_model/report_upload_model/report_upload_model.dart';
import '../../model/evaluation_from_models/evaluation_model_format1.dart';
import '../../services/evaluation_fome_service/evaluation_form_service.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'check_box_settings.dart';

class PersonalDetailsScreen2 extends StatefulWidget {
  final EvaluationModelFormat1? evaluationModelFormat1;
  final List? medicalReportList;
  /// this is called when showData is true
  final ChildGetEvaluationDataModel? childGetEvaluationDataModel;
  const PersonalDetailsScreen2({Key? key,
    this.evaluationModelFormat1,
    this.childGetEvaluationDataModel,
    this.medicalReportList}) : super(key: key);

  @override
  State<PersonalDetailsScreen2> createState() => _PersonalDetailsScreenState2();
}

class _PersonalDetailsScreenState2 extends State<PersonalDetailsScreen2> {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  final String otherText = "Other";
  TextEditingController digestionController = TextEditingController();
  TextEditingController specialDietController = TextEditingController();
  TextEditingController foodAllergyController = TextEditingController();
  TextEditingController intoleranceController = TextEditingController();
  TextEditingController cravingsController = TextEditingController();
  TextEditingController dislikeFoodController = TextEditingController();

  String emptyStringMsg = AppConfig().emptyStringMsg;

  String glassesOfWater = "";

  final _pref = AppConfig().preferences;

  final habitCheckBox = [
    CheckBoxSettings(title: "Alcohol"),
    CheckBoxSettings(title: "Smoking"),
    CheckBoxSettings(title: "Coffee"),
    CheckBoxSettings(title: "Tea"),
    CheckBoxSettings(title: "Soft Drinks/Carbonated Drinks"),
    CheckBoxSettings(title: "Drugs"),
  ];
  bool habitOtherSelected = false;
  List selectedHabitCheckBoxList = [];

  final habitOtherController = TextEditingController();
  final mealPreferenceController = TextEditingController();
  final hungerPatternController = TextEditingController();
  final bowelPatternController = TextEditingController();

  final mealPreferenceList = [
    "To eat something sweet within 2 hrs of having food.",
    "To have something bitter or astringent within an hour of having food",
    "Other:"
  ];
  String mealPreferenceSelected = "";

  final hungerPatternList = [
    "Intense, however, tend to eat small or large portions which differ. Also tend to eat frequently, like every 2hrs than eat large meals.",
    "Intense and prefer to eat large meals when i eat. The gaps between meals may be long or short",
    "Not so intense. Tend to eat small portions when hungry. I am fine with long, unpredictable gaps between my meals.",
    "Other:"
  ];
  String hungerPatternSelected = "";

  final bowelPatternList = [
    "I sometimes have soft stools and/or sometimes constipated dry stools",
    "I have soft well formed and/or watery stools",
    "I am usually constipated with either well formed stools or hard stools",
    "Other:"
  ];
  String bowelPatternSelected = "";



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void storeData() {
    final model = widget.childGetEvaluationDataModel;
    print('store');
    print('${model?.hungerPatternOther} ${model?.hungerPattern}');
    digestionController.text = model?.mentionIfAnyFoodAffectsYourDigesion ?? '';
    specialDietController.text = model?.anySpecialDiet ?? '';
    foodAllergyController.text = model?.anyFoodAllergy ?? '';
    intoleranceController.text = model?.anyIntolerance ?? '';
    cravingsController.text = model?.anySevereFoodCravings ?? '';
    dislikeFoodController.text = model?.anyDislikeFood ?? '';
    glassesOfWater = model?.noGalssesDay ?? '';

    // print("model.listProblems:${jsonDecode(model.listProblems ?? '')}");
    selectedHabitCheckBoxList.addAll(List.from(jsonDecode(model?.anyHabbitOrAddiction ?? '')));
    // print("selectedHealthCheckBox1[0]:${(selectedHealthCheckBox1[0].split(',') as List).map((e) => e).toList()}");
    selectedHabitCheckBoxList = List.from((selectedHabitCheckBoxList[0].split(',') as List).map((e) => e).toList());
    habitCheckBox.forEach((element) {
      print(selectedHabitCheckBoxList);
      print('selectedHabitCheckBoxList.any((element1) => element1 == element.title): ${selectedHabitCheckBoxList.any((element1) => element1 == element.title)}');
      if(selectedHabitCheckBoxList.any((element1) => element1 == element.title)){
        element.value = true;
      }
      if(selectedHabitCheckBoxList.any((element) => element.toString().toLowerCase().contains("other"))){
        habitOtherSelected = true;
      }
    });
    habitOtherController.text = model?.anyHabbitOrAddictionOther ?? '';

    mealPreferenceController.text = model?.afterMealPreferenceOther ?? '';
    mealPreferenceSelected = model?.afterMealPreference ?? '';
    hungerPatternController.text = model?.hungerPatternOther ?? '';
    hungerPatternSelected = model?.hungerPattern ?? '';
    bowelPatternSelected = model?.bowelPattern ?? '';
    bowelPatternController.text = model?.bowelPatternOther ?? '';
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/eval_bg.png"),
            fit: BoxFit.fitWidth,
            colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.lighten)
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 3.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildAppBar(() {
                      Navigator.pop(context);
                    }),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text(
                      "Gut Wellness Club \nEvaluation Form",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontFamily: "PoppinsMedium",
                          color: Colors.white,
                          fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        buildFoodHabitsDetails(),
                        buildLifeStyleDetails(),
                        buildBowelDetails(),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              if(formKey1.currentState!.validate() && formKey2.currentState!.validate() && formKey3.currentState!.validate()){
                                print(widget.medicalReportList.runtimeType);
                                submitFormDetails();
                              }
                            },
                            child: Container(
                              width: 50.w,
                              height: 5.h,
                              // padding: EdgeInsets.symmetric(
                              //     vertical: 1.h, horizontal: 25.w),
                              decoration: BoxDecoration(
                                color: eUser().buttonColor,
                                borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                                border: Border.all(
                                    color: eUser().buttonBorderColor,
                                    width: eUser().buttonBorderWidth
                                ),
                              ),
                              child:(isSubmitPressed)
                                  ? buildThreeBounceIndicator(color: eUser().threeBounceIndicatorColor)
                                  : Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontFamily: eUser().buttonTextFont,
                                    color: eUser().buttonTextColor,
                                    fontSize: eUser().buttonTextSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  buildFoodHabitsDetails() {
    return Form(
      key: formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Food Habits",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "PoppinsBold",
                        color: kPrimaryColor,
                        fontSize: 15.sp),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              Text(
                "To Make Your Meal Plans As Simple & Easy For You To Follow As Possible",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontFamily: "PoppinsRegular",
                    color: gMainColor,
                    fontSize: 9.sp),
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          buildLabelTextField("Do Certain Food Affect Your Digestion? If So Please Provide Details."),
          SizedBox(
            height: 1.h,
          ),
          TextFormField(
            controller: digestionController,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty ) {
                return 'Please enter your Changed';
              } else if (value.length < 2) {
                return emptyStringMsg;
              } else {
                return null;
              }
            },
            decoration: CommonDecoration.buildTextInputDecoration(
                "Your answer", digestionController),
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
          ),
          SizedBox(
            height: 2.h,
          ),
          buildLabelTextField("Do You Follow Any Special Diet(Keto,Etc)? If So Please Provide Details"),
          SizedBox(
            height: 1.h,
          ),
          TextFormField(
            controller: specialDietController,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your Changed';
              } else if (value.length < 2) {
                return emptyStringMsg;
              } else {
                return null;
              }
            },
            decoration: CommonDecoration.buildTextInputDecoration(
                "Your answer", specialDietController),
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
          ),
          SizedBox(
            height: 2.h,
          ),
          buildLabelTextField("Do You Have Any Known Food Allergy? If So Please Provide Details."),
          SizedBox(
            height: 1.h,
          ),
          TextFormField(
            controller: foodAllergyController,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty ) {
                return 'Please enter your Changed';
              }else if (value.length < 2) {
                return emptyStringMsg;
              }else {
                return null;
              }
            },
            decoration: CommonDecoration.buildTextInputDecoration(
                "Your answer", foodAllergyController),
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
          ),
          SizedBox(
            height: 2.h,
          ),
          buildLabelTextField("Do You Have Any Known Intolerance? If So Please Provide Details."),
          SizedBox(
            height: 1.h,
          ),
          TextFormField(
            controller: intoleranceController,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty ) {
                return 'Please enter your Changed';
              } else if (value.length < 2) {
                return emptyStringMsg;
              } else {
                return null;
              }
            },
            decoration: CommonDecoration.buildTextInputDecoration(
                "Your answer", intoleranceController),
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
          ),
          SizedBox(
            height: 2.h,
          ),
          buildLabelTextField("Do You Have Any Severe Food Cravings? If So Please Provide Details."),
          SizedBox(
            height: 1.h,
          ),
          TextFormField(
            controller: cravingsController,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty ) {
                return 'Please enter your Changed';
              }else if (value.length < 2) {
                return emptyStringMsg;
              }else {
                return null;
              }
            },
            decoration: CommonDecoration.buildTextInputDecoration(
                "Your answer", cravingsController),
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
          ),
          SizedBox(
            height: 2.h,
          ),
          buildLabelTextField("Do You Dislike Any Food?Please Mention All Of Them"),
          SizedBox(
            height: 1.h,
          ),
          TextFormField(
            controller: dislikeFoodController,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty ) {
                return 'Please enter your Changed';
              } else if (value.length < 2) {
                return emptyStringMsg;
              } else {
                return null;
              }
            },
            decoration: CommonDecoration.buildTextInputDecoration(
                "Your answer", dislikeFoodController),
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
          ),
          SizedBox(
            height: 2.h,
          ),
          buildLabelTextField("How Many Glasses Of Water Do You Have A Day?"),
          SizedBox(
            height: 1.h,
          ),
          Row(
            children: [
              Radio(
                value: "1-2",
                activeColor: kPrimaryColor,
                groupValue: glassesOfWater,
                onChanged: (value) {
                  setState(() {
                    glassesOfWater = value as String;
                  });
                },
              ),
              Text(
                '1-2',
                style: buildTextStyle(),
              ),
              SizedBox(
                width: 3.w,
              ),
              Radio(
                value: "3-4",
                activeColor: kPrimaryColor,
                groupValue: glassesOfWater,
                onChanged: (value) {
                  setState(() {
                    glassesOfWater = value as String;
                  });
                },
              ),
              Text(
                '3-4',
                style: buildTextStyle(),
              ),
              SizedBox(
                width: 3.w,
              ),
              Radio(
                  value: "6-8",
                  groupValue: glassesOfWater,
                  activeColor: kPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      glassesOfWater = value as String;
                    });
                  }),
              Text(
                "6-8",
                style: buildTextStyle(),
              ),
              SizedBox(
                width: 3.w,
              ),
              Radio(
                  value: "9+",
                  groupValue: glassesOfWater,
                  activeColor: kPrimaryColor,
                  onChanged: (value) {
                    setState(() {
                      glassesOfWater = value as String;
                    });
                  }),
              Text(
                "9+",
                style: buildTextStyle(),
              ),
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
        ],
      ),
    );
  }

  buildLifeStyleDetails() {
    return Form(
      key: formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Life Style",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "PoppinsBold",
                        color: kPrimaryColor,
                        fontSize: 15.sp),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              Text(
                "This Tells Us How Your Gut Is & Has Been Treated",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontFamily: "PoppinsRegular",
                    color: gMainColor,
                    fontSize: 9.sp),
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          buildLabelTextField("Habits Or Addiction"),
          SizedBox(
            height: 1.h,
          ),
          ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Wrap(
                children: [
                  ...habitCheckBox.map(buildWrapingCheckBox).toList(),
                ],
              ),
              SizedBox(
                child: CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Text(
                      'Other:',
                      style: buildTextStyle(),
                    ),
                  ),
                  activeColor: kPrimaryColor,
                  value: habitOtherSelected,
                  onChanged: (v) {
                    setState(() {
                      habitOtherSelected = v!;
                      if (habitOtherSelected) {
                        selectedHabitCheckBoxList.clear();
                        habitCheckBox
                            .forEach((element) {
                          element.value = false;
                        });
                        selectedHabitCheckBoxList
                            .add(otherText);
                      }
                      else {
                        selectedHabitCheckBoxList
                            .remove(otherText);
                      }
                    });
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       SizedBox(
              //         width: 20,
              //         child: Checkbox(
              //           activeColor: kPrimaryColor,
              //           value: habitOtherSelected,
              //           onChanged: (v) {
              //             setState(() {
              //               habitOtherSelected = v!;
              //               if (habitOtherSelected) {
              //                 selectedHabitCheckBoxList
              //                     .add(otherText);
              //                 selectedHabitCheckBoxList.clear();
              //                 selectedHabitCheckBoxList
              //                     .forEach((element) {
              //                   element.value = false;
              //                 });
              //                 selectedHabitCheckBoxList
              //                     .add(otherText);
              //               } else {
              //                 selectedHabitCheckBoxList
              //                     .remove(otherText);
              //               }
              //             });
              //           },
              //         ),
              //       ),
              //       SizedBox(
              //         width: 4,
              //       ),
              //       Text(
              //         'Other:',
              //         style: buildTextStyle(),
              //       ),
              //     ],
              //   ),
              // ),
              TextFormField(
                controller: habitOtherController,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value!.isEmpty && habitOtherSelected) {
                    return 'Please mention other habits/addiction which not mentioned above';
                  } else {
                    return null;
                  }
                },
                decoration: CommonDecoration.buildTextInputDecoration(
                    "Your answer", habitOtherController),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
              ),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }

  buildBowelDetails() {
    return Form(
      key: formKey3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Bowel Type",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "PoppinsBold",
                        color: kPrimaryColor,
                        fontSize: 15.sp),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              Text(
                "Is a Barometer For Your Gut Health",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontFamily: "PoppinsRegular",
                    color: gMainColor,
                    fontSize: 9.sp),
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          buildLabelTextField("What is your after meal preference?"),
          SizedBox(
            height: 1.h,
          ),
          ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Radio(
                    value: mealPreferenceList[0],
                    activeColor: kPrimaryColor,
                    groupValue: mealPreferenceSelected,
                    onChanged: (value) {
                      setState(() {
                        mealPreferenceSelected = value as String;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      mealPreferenceList[0],
                      style: buildTextStyle(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: mealPreferenceList[1],
                    activeColor: kPrimaryColor,
                    groupValue: mealPreferenceSelected,
                    onChanged: (value) {
                      setState(() {
                        mealPreferenceSelected = value as String;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      mealPreferenceList[1],
                      style: buildTextStyle(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: mealPreferenceList[2],
                    activeColor: kPrimaryColor,
                    groupValue: mealPreferenceSelected,
                    onChanged: (value) {
                      setState(() {
                        mealPreferenceSelected = value as String;
                      });
                    },
                  ),
                  Text(
                    mealPreferenceList[2],
                    style: buildTextStyle(),
                  ),
                ],
              ),
              TextFormField(
                controller: mealPreferenceController,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value!.isEmpty && mealPreferenceSelected.contains(mealPreferenceList[2])) {
                    return 'Please enter Medical Interventions';
                  } else {
                    return null;
                  }
                },
                decoration: CommonDecoration.buildTextInputDecoration(
                    "Your answer", mealPreferenceController),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          buildLabelTextField("Hunger Pattern"),
          SizedBox(
            height: 1.h,
          ),
          ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Radio(
                    value: hungerPatternList[0],
                    activeColor: kPrimaryColor,
                    groupValue: hungerPatternSelected,
                    onChanged: (value) {
                      setState(() {
                        hungerPatternSelected = value as String;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      hungerPatternList[0],
                      style: buildTextStyle(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: hungerPatternList[1],
                    activeColor: kPrimaryColor,
                    groupValue: hungerPatternSelected,
                    onChanged: (value) {
                      setState(() {
                        hungerPatternSelected = value as String;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      hungerPatternList[1],
                      style: buildTextStyle(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: hungerPatternList[2],
                    activeColor: kPrimaryColor,
                    groupValue: hungerPatternSelected,
                    onChanged: (value) {
                      setState(() {
                        hungerPatternSelected = value as String;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      hungerPatternList[2],
                      style: buildTextStyle(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: hungerPatternList[3],
                    activeColor: kPrimaryColor,
                    groupValue: hungerPatternSelected,
                    onChanged: (value) {
                      setState(() {
                        hungerPatternSelected = value as String;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      hungerPatternList[3],
                      style: buildTextStyle(),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: hungerPatternController,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value!.isEmpty && hungerPatternSelected.contains(hungerPatternList[3])) {
                    return 'Please enter Hunger Pattern';
                  } else {
                    return null;
                  }
                },
                decoration: CommonDecoration.buildTextInputDecoration(
                    "Your answer", hungerPatternController),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          buildLabelTextField("Bowel Pattern"),
          SizedBox(
            height: 1.h,
          ),
          ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Radio(
                    value: bowelPatternList[0],
                    activeColor: kPrimaryColor,
                    groupValue: bowelPatternSelected,
                    onChanged: (value) {
                      setState(() {
                        bowelPatternSelected = value as String;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      bowelPatternList[0],
                      style: buildTextStyle(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: bowelPatternList[1],
                    activeColor: kPrimaryColor,
                    groupValue: bowelPatternSelected,
                    onChanged: (value) {
                      setState(() {
                        bowelPatternSelected = value as String;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      bowelPatternList[1],
                      style: buildTextStyle(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: bowelPatternList[2],
                    activeColor: kPrimaryColor,
                    groupValue: bowelPatternSelected,
                    onChanged: (value) {
                      setState(() {
                        bowelPatternSelected = value as String;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      bowelPatternList[2],
                      style: buildTextStyle(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: bowelPatternList[3],
                    activeColor: kPrimaryColor,
                    groupValue: bowelPatternSelected,
                    onChanged: (value) {
                      setState(() {
                        bowelPatternSelected = value as String;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      bowelPatternList[3],
                      style: buildTextStyle(),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: bowelPatternController,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value!.isEmpty && bowelPatternSelected.contains(bowelPatternList[3])) {
                    return 'Please enter bowel pattern';
                  } else {
                    return null;
                  }
                },
                decoration: CommonDecoration.buildTextInputDecoration(
                    "Your answer", bowelPatternController),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
              ),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }

  buildLifeStyleCheckBox(CheckBoxSettings lifeStyleCheckBox) {
    return ListTile(
      minLeadingWidth: 0,
      leading: SizedBox(
        width: 20,
        child: Checkbox(
          activeColor: kPrimaryColor,
          value: lifeStyleCheckBox.value,
          onChanged: (v) {
            setState(() {
              lifeStyleCheckBox.value = v;
            });
          },
        ),
      ),
      title: Text(
        lifeStyleCheckBox.title.toString(),
        style: buildTextStyle(),
      ),
    );
  }

  buildWrapingCheckBox(CheckBoxSettings healthCheckBox){
    return SizedBox(
      child: CheckboxListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
        controlAffinity: ListTileControlAffinity.leading,
        title: Transform.translate(
          offset: const Offset(-10, 0),
          child: Text(
            healthCheckBox.title.toString(),
            style: buildTextStyle(),
          ),
        ),
        dense: true,
        activeColor: kPrimaryColor,
        value: healthCheckBox.value,
        onChanged: (v) {
          if(habitOtherSelected){
            if(v == true){
              habitOtherSelected = false;
              selectedHabitCheckBoxList.clear();
              selectedHabitCheckBoxList.add(healthCheckBox.title);
              healthCheckBox.value = v;
            }
          }
          else{
            if (v == true) {
              setState(() {
                selectedHabitCheckBoxList.add(healthCheckBox.title);
                healthCheckBox.value = v;
              });
            }
            else {
              setState(() {
                selectedHabitCheckBoxList.remove(healthCheckBox.title);
                healthCheckBox.value = v;
              });
            }
            print(selectedHabitCheckBoxList);
          }
        },
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: kPrimaryColor,
              value: healthCheckBox.value,
              onChanged: (v) {
                setState(() {
                  healthCheckBox.value = v;
                });
              },
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            healthCheckBox.title.toString(),
            style: buildTextStyle(),
          ),
        ],
      ),
    );
  }

  bool validEmail(String email) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool isPhone(String input) => RegExp(
      r'^(?:[+0]9)?[0-9]{10}$'
  ).hasMatch(input);

  void submitFormDetails() {
    checkFields();
  }

  void checkFields() {
    if(digestionController.text.isEmpty){
      AppConfig().showSnackbar(context, "Please Mention the food which affect in digestion");
    }
    else if(specialDietController.text.isEmpty){
      AppConfig().showSnackbar(context, "Please Mention the Special Diet");
    }
    else if(foodAllergyController.text.isEmpty){
      AppConfig().showSnackbar(context, "Please Mention the food allergy Details");
    }
    else if(intoleranceController.text.isEmpty){
      AppConfig().showSnackbar(context, "Please Mention the known intolerance Details");
    }
    else if(cravingsController.text.isEmpty){
      AppConfig().showSnackbar(context, "Please Mention any Severe food cravings");
    }
    else if(dislikeFoodController.text.isEmpty){
      AppConfig().showSnackbar(context, "Please Mention the food which You Dislike");
    }
    else if(glassesOfWater.isEmpty){
      AppConfig().showSnackbar(context, "Please Select how many glasses of water do you have a day");
    }

    else if(habitCheckBox.every((element) => element.value == false) && habitOtherSelected == false){
      AppConfig().showSnackbar(context, "Please Select Habits/Addiction");
    }
    else if(habitOtherSelected == true && habitOtherController.text.isEmpty){
      AppConfig().showSnackbar(context, "Please Mention other Habits/Addiction which not there in list");
    }
    else if(mealPreferenceSelected.isEmpty){
      AppConfig().showSnackbar(context, "Please Select Meal Preference");
    }
    else if(mealPreferenceSelected.toLowerCase().contains("other") && mealPreferenceController.text.isEmpty){
      AppConfig().showSnackbar(context, "Please Mention the Meal Preference");
    }
    else if(hungerPatternSelected.isEmpty){
      AppConfig().showSnackbar(context, "Please Select Hunger Pattern");
    }
    else if(hungerPatternSelected.toLowerCase().contains("other") && hungerPatternController.text.isEmpty){
      AppConfig().showSnackbar(context, "Please Mention the Hunger Pattern");
    }
    else if(bowelPatternSelected.isEmpty){
      AppConfig().showSnackbar(context, "Please Select Bowel Pattern");
    }
    else if(bowelPatternSelected.toLowerCase().contains("other") && bowelPatternController.text.isEmpty){
      AppConfig().showSnackbar(context, "Please Mention the Bowel Pattern");
    }
    else{
      addHabitDetails();
      EvaluationModelFormat2 eval2 = createFormMap();
      print(eval2.toMap());
      Map finalMap = {};
      finalMap.addAll(widget.evaluationModelFormat1!.toMap().cast());
      finalMap.addAll(eval2.toMap().cast());
      print("finalMap: $finalMap");
      callApi(finalMap, widget.medicalReportList!);
    }
  }

  createFormMap(){
    return EvaluationModelFormat2(
      digesion: digestionController.text,
      diet: specialDietController.text,
      foodAllergy: foodAllergyController.text,
      intolerance: intoleranceController.text,
      cravings: cravingsController.text,
      dislikeFood: dislikeFoodController.text,
      glasses_per_day: glassesOfWater,
      habits: selectedHabitCheckBoxList.join(','),
      habits_other: habitOtherSelected ? habitOtherController.text : '',
      mealPreference: mealPreferenceSelected,
      mealPreferenceOther: mealPreferenceController.text,
      hunger: hungerPatternSelected,
      hungerOther: hungerPatternController.text,
      bowelPattern: bowelPatternSelected,
      bowelPatterOther: bowelPatternController.text
    );
  }

  void addHabitDetails() {
    selectedHabitCheckBoxList.clear();
    if(habitCheckBox.any((element) => element.value == true) || habitOtherSelected){
      for (var element in habitCheckBox) {
        if(element.value == true){
          print(element.title);
          selectedHabitCheckBoxList.add(element.title!);
        }
      }
      if(habitOtherSelected){
        selectedHabitCheckBoxList.add(otherText);
      }
    }
  }

  bool isSubmitPressed = false;
  void callApi(Map form, List medicalReports) async{
    setState(() {
      isSubmitPressed = true;
    });
    final res = await EvaluationFormService(repository: repository).submitEvaluationFormService(form, medicalReports);
    print("eval form response" + res.runtimeType.toString());
    if(res.runtimeType == ReportUploadModel){
      ReportUploadModel result = res;
      setState(() {
        isSubmitPressed = false;
      });
      _pref!.setString(AppConfig.EVAL_STATUS, "evaluation_done");
      // AppConfig().showSnackbar(context, result.message ?? '');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
            const DashboardScreen()), (route) {
          print("route.currentResult:${route.currentResult}");
          print(route.isFirst);
        return route.isFirst;
      }
      );
    }
    else{
      ErrorModel result = res;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
      setState(() {
        isSubmitPressed = false;
      });
    }
  }

  final EvaluationFormRepository repository = EvaluationFormRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

}
