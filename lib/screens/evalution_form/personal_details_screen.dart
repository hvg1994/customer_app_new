import 'dart:convert';

import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide GetStringUtils;
import 'package:gwc_customer/model/evaluation_from_models/get_evaluation_model/child_get_evaluation_data_model.dart';
import 'package:gwc_customer/repository/evaluation_form_repository/evanluation_form_repo.dart';
import 'package:gwc_customer/services/evaluation_fome_service/evaluation_form_service.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../utils/app_config.dart';
import '../../model/country_model.dart';
import '../../model/error_model.dart';
import '../../model/evaluation_from_models/evaluation_model_format1.dart';
import '../../model/evaluation_from_models/get_country_details_model.dart';
import '../../model/evaluation_from_models/get_evaluation_model/get_evaluationdata_model.dart';
import '../../model/profile_model/user_profile/user_profile_model.dart';
import '../../repository/api_service.dart';
import '../../repository/profile_repository/get_user_profile_repo.dart';
import '../../services/profile_screen_service/user_profile_service.dart';
import '../../utils/country_list.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'check_box_settings.dart';
import 'personal_details_screen2.dart';
import 'package:gwc_customer/widgets/dart_extensions.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final bool showData;
  final EdgeInsetsGeometry? padding;
  const PersonalDetailsScreen({Key? key, this.showData = false, this.padding})
      : super(key: key);

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  Future? _getEvaluationDataFuture;

  final _pref = AppConfig().preferences;

  bool _ignoreFields = true;

  int ft = -1;
  int inches = -1;
  String heightText = '';

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController healController = TextEditingController();
  TextEditingController conditionController = TextEditingController();
  TextEditingController checkbox1OtherController = TextEditingController();
  TextEditingController digestionController = TextEditingController();
  TextEditingController specialDietController = TextEditingController();
  TextEditingController foodAllergyController = TextEditingController();
  TextEditingController intoleranceController = TextEditingController();
  TextEditingController cravingsController = TextEditingController();
  TextEditingController dislikeFoodController = TextEditingController();
  TextEditingController goToBedController = TextEditingController();
  TextEditingController wakeUpController = TextEditingController();
  TextEditingController exerciseController = TextEditingController();
  TextEditingController stoolsController = TextEditingController();
  TextEditingController symptomsController = TextEditingController();
  TextEditingController tongueCoatingController = TextEditingController();
  TextEditingController urinColorController = TextEditingController();
  TextEditingController urinSmellController = TextEditingController();
  TextEditingController urinLooksLikeController = TextEditingController();
  TextEditingController medicalInterventionsDoneController =
      TextEditingController();
  TextEditingController medicationsController = TextEditingController();
  TextEditingController holisticController = TextEditingController();

  String emptyStringMsg = AppConfig().emptyStringMsg;
  String maritalStatus = "";
  String gender = "";
  String foodPreference = "";
  String tasteYouEnjoy = "";
  String mealsYouHaveADay = "";
  final String otherText = "Other";

  String selectedValue5 = "";
  String selectedValue6 = "";
  String selectedValue7 = "";
  String selectedValue8 = "";
  String selectedValue9 = "";
  String selectedValue10 = "";
  String selectedValue11 = "";
  String selectedValue12 = "";
  String selectedValue13 = "";
  String selectedValue14 = "";
  String selectedValue15 = "";
  String selectedValue16 = "";
  String selectedValue17 = "";
  String selectedValue18 = "";
  String selectedValue19 = "";
  String selectedValue20 = "";
  String selectedValue21 = "";
  String selectedValue22 = "";
  String tongueCoatingRadio = "";
  String urinationValue = "";
  String urineColorValue = "";
  String urineLookLikeValue = "";

  final healthCheckBox1 = <CheckBoxSettings>[
    CheckBoxSettings(title: "Autoimmune Diseases"),
    CheckBoxSettings(title: "Endocrine Diseases (Thyroid/Diabetes/PCOS)"),
    CheckBoxSettings(
        title:
            "Heart Diseases (Palpitations/Low Blood Pressure/High Blood Pressure)"),
    CheckBoxSettings(title: "Renal/Kidney Diseases (Kidney Stones)"),
    CheckBoxSettings(
        title: "Liver Diseases (Cirrhosis/Fatty Liver/Hepatitis/Jaundice)"),
    CheckBoxSettings(
        title:
            "Neurological Diseases (Seizures/Fits/Convulsions/Headache/Migraine/Vertigo)"),
    CheckBoxSettings(
        title:
            "Digestive Diseases (Hernia/Hemorrhoids/Piles/Indigestion/Gall Stone/Pancreatitis/Irritable Bowel Syndrome)"),
    CheckBoxSettings(
        title:
            "Skin Diseases (Psoriasis/Acne/Eczema/Herpes,/Skin Allergies/Dandruff/Rashes)"),
    CheckBoxSettings(
        title:
            "Respiratory Diseases (Athama/Allergic bronchitis/Rhinitis/Sinusitis/Frequent Cold, Cough & Fever/Tonsillitis/Wheezing)"),
    CheckBoxSettings(
        title:
            "Reproductive Diseases (PCOD/Infertility/MenstrualDisorders/Heavy or Scanty Period Bleeding/Increased or Decreased Sexual Drive/Painful Periods /Irregular Cycles)"),
    CheckBoxSettings(
        title:
            "Skeletal Muscle Disorders (Muscular Dystrophy/Rheumatoid Arthritis/Arthritis/Spondylitis/Loss ofMuscle Mass)"),
    CheckBoxSettings(
        title:
            "Psychological/Psychiatric Issues (Depression,Anxiety, OCD, ADHD, Mood Disorders, Schizophrenia,Personality Disorders, Eating Disorders)"),
    CheckBoxSettings(title: "None Of The Above"),
    CheckBoxSettings(title: "Other:"),
  ];

  List<String> selectedHealthCheckBox1 = [];

  final healthCheckBox2 = <CheckBoxSettings>[
    CheckBoxSettings(title: "Body Odor"),
    CheckBoxSettings(title: "Dry Mouth"),
    CheckBoxSettings(title: "Severe Thirst"),
    CheckBoxSettings(title: "Severe Sweet Cravings In The Evening/Night"),
    CheckBoxSettings(title: "Astringent/Pungent/Sour Taste In The Mouth"),
    CheckBoxSettings(title: "Burning Sensation In Your Chest"),
    CheckBoxSettings(title: "Heavy Stomach"),
    CheckBoxSettings(title: "Acid Reflux/Belching/Acidic Regurgitation"),
    CheckBoxSettings(title: "Bad Breathe"),
    CheckBoxSettings(title: "Sweet/Salty/Sour Taste In Your Mouth"),
    CheckBoxSettings(title: "Severe Sweet Craving During the Day"),
    CheckBoxSettings(title: "Dryness In The Mouth Inspite Of Salivatio"),
    CheckBoxSettings(title: "Mood Swings"),
    CheckBoxSettings(title: "Chronic Fatigue or Low Energy Levels"),
    CheckBoxSettings(title: "Insomnia"),
    CheckBoxSettings(title: "Frequent Head/Body Aches"),
    CheckBoxSettings(title: "Gurgling Noise In Your Tummy"),
    CheckBoxSettings(title: "Hypersalivation While Feeling Nauseous"),
    CheckBoxSettings(
        title: "Cannot Start My Day Without A Hot Beverage Once I'm Up"),
    CheckBoxSettings(title: "Gas & Bloating"),
    CheckBoxSettings(title: "Constipation"),
    CheckBoxSettings(title: "Low Immunity/ Falling Ill Frequently"),
    CheckBoxSettings(title: "Inflamation"),
    CheckBoxSettings(title: "Muscle Cramps & Painr"),
    CheckBoxSettings(title: "Acne/Skin Breakouts/Boils"),
    CheckBoxSettings(title: "PMS(Women Only)"),
    CheckBoxSettings(title: "Heaviness"),
    CheckBoxSettings(title: "Lack Of Energy Or Lethargy"),
    CheckBoxSettings(title: "Loss Of Appetite"),
    CheckBoxSettings(title: "Increased Salivation"),
    CheckBoxSettings(title: "Profuse Sweating"),
    CheckBoxSettings(title: "Loss Of Taste"),
    CheckBoxSettings(title: "Nausea Or Vomiting"),
    CheckBoxSettings(title: "Metallic Or Bitter Taste"),
    CheckBoxSettings(title: "Weight Loss"),
    CheckBoxSettings(title: "Weight Gain"),
    CheckBoxSettings(title: "Burping"),
    CheckBoxSettings(
        title:
            "Sour Regurgitation/ Food Regurgitation.(Food Coming back to your mouth)"),
    CheckBoxSettings(title: "Burning while passing urine"),
    CheckBoxSettings(title: "None Of The Above")
  ];

  final foodCheckBox = [
    CheckBoxSettings(title: "North Indian"),
    CheckBoxSettings(title: "South Indian"),
    CheckBoxSettings(title: "Continental"),
    CheckBoxSettings(title: "Mediterranean"),
  ];

  final sleepCheckBox = [
    CheckBoxSettings(title: "I Toss& Turn Alot In Bed"),
    CheckBoxSettings(title: "I Get The Feeling Refreshed"),
    CheckBoxSettings(title: "I Have Difficulty Falling Asleep"),
    CheckBoxSettings(title: "I Sleep Deep"),
    CheckBoxSettings(title: "I Wake Up Feeling Heavy"),
  ];

  final lifeStyleCheckBox = [
    CheckBoxSettings(title: "Drugs"),
    CheckBoxSettings(title: "Cigarettes"),
    CheckBoxSettings(title: "Alcohol"),
    CheckBoxSettings(title: "Others"),
    CheckBoxSettings(title: "None"),
  ];

  final gutTypeCheckBox = [
    CheckBoxSettings(title: "Dry Mouth"),
    CheckBoxSettings(title: "Astringent/Pungent/Sour Taste In The Mouth"),
    CheckBoxSettings(title: "Severe Thrist"),
    CheckBoxSettings(title: "Burning Sensation In Your Chest"),
    CheckBoxSettings(title: "Acid Reflux/Belching/Acidic Regurgitation"),
    CheckBoxSettings(title: "Severe Sweet Cravings In The Evening/Night"),
    CheckBoxSettings(title: "Bad Breathe"),
    CheckBoxSettings(title: "Chest Burning With Nausia"),
    CheckBoxSettings(title: "Heavy Stomach"),
    CheckBoxSettings(title: "Bloating"),
    CheckBoxSettings(title: "A Lot Of Salivation"),
    CheckBoxSettings(title: "Sweet/Salty/Sour Taste In Your Mouth"),
    CheckBoxSettings(title: "Severe Bitter craving During The Day"),
    CheckBoxSettings(title: "Dryness In The Mouth Inspite Of Salivation"),
    CheckBoxSettings(title: "Gassiness"),
    CheckBoxSettings(title: "Gurgling Noise In Your Tummy"),
    CheckBoxSettings(title: "Hypersalivation While Feeling Nauseous"),
    CheckBoxSettings(
        title: "Cannot Start My Day Without A Hot Beverage Once I'm Up"),
    CheckBoxSettings(title: "None Of The Above"),
    CheckBoxSettings(title: "None"),
  ];
  List selectedHealthCheckBox2 = [];

  //********** not used*************

  final urinFrequencyList = [
    CheckBoxSettings(title: "Increased"),
    CheckBoxSettings(title: "Decreased"),
    CheckBoxSettings(title: "No Change"),
  ];
  List selectedUrinFrequencyList = [];
  //*********************************

  //********** not used*************

  final urinColorList = [
    CheckBoxSettings(title: "Clear"),
    CheckBoxSettings(title: "Pale Yello"),
    CheckBoxSettings(title: "Red"),
    CheckBoxSettings(title: "Black"),
    CheckBoxSettings(title: "Yellow"),
  ];
  List selectedUrinColorList = [];
  bool urinColorOtherSelected = false;
  // *******************************

  final urinSmellList = [
    CheckBoxSettings(title: "Normal urine odour"),
    CheckBoxSettings(title: "Fruity"),
    CheckBoxSettings(title: "Ammonia"),
  ];
  List selectedUrinSmellList = [];
  bool urinSmellOtherSelected = false;

  //********** not used*************

  final urinLooksList = [
    CheckBoxSettings(title: "Clear/Transparent"),
    CheckBoxSettings(title: "Foggy/cloudy"),
  ];

  List selectedUrinLooksList = [];
  bool urinLooksLikeOtherSelected = false;
  //***********************************

  final medicalInterventionsDoneBeforeList = [
    CheckBoxSettings(title: "Surgery"),
    CheckBoxSettings(title: "Stents"),
    CheckBoxSettings(title: "Implants"),
  ];
  bool medicalInterventionsOtherSelected = false;
  List selectedmedicalInterventionsDoneBeforeList = [];

  String selectedStoolMatch = '';

  List<PlatformFile> medicalRecords = [];

  /// this is used when showdata is true
  List showMedicalReport = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (!widget.showData) getProfileData();
    });
    pinCodeController.addListener(() {
      setState(() {});
    });
    if (widget.showData) {
      _getEvaluationDataFuture = EvaluationFormService(repository: repository)
          .getEvaluationDataService();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (mounted) {
      pinCodeController.removeListener(() {});
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:widget.showData
          ?BoxDecoration(color: gWhiteColor):  const BoxDecoration(
        image: DecorationImage(
            image: const AssetImage("assets/images/eval_bg.png"),
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.lighten)),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: widget.showData
              ? FutureBuilder(
                  future: _getEvaluationDataFuture,
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      print(snapshot.data.runtimeType);
                      if (snapshot.data.runtimeType == GetEvaluationDataModel) {
                        GetEvaluationDataModel model =
                            snapshot.data as GetEvaluationDataModel;
                        ChildGetEvaluationDataModel? model1 = model.data;
                        storeDetails(model1!);
                        return showUI(context, model: model1);
                      } else {
                        ErrorModel model = snapshot.data as ErrorModel;
                        print(model.message);
                      }
                    } else if (snapshot.hasError) {
                      print("snapshot.error: ${snapshot.error}");
                    }
                    return buildCircularIndicator();
                  })
              : showUI(context),
        ),
      ),
    );
  }

  /// for showData ChildGetEvaluationDataModel? model this is mandatory
  showUI(BuildContext context, {ChildGetEvaluationDataModel? model}) {
    return widget.showData
        ? buildEvaluationForm(model: model)
        : Column(
            children: [
              SizedBox(height: 1.h),
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
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
                    child: buildEvaluationForm()),
              ),
            ],
          );
  }

  buildEvaluationForm({ChildGetEvaluationDataModel? model}) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: (widget.padding != null) ? widget.padding : EdgeInsets.zero,
        child: Column(
          children: [
            buildPersonalDetails(),
            buildHealthDetails(),
            // buildFoodHabitsDetails(),
            // buildSleepDetails(),
            // buildLifeStyleDetails(),
            // buildGutTypeDetails(),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (widget.showData) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => PersonalDetailsScreen2(
                              childGetEvaluationDataModel: model,
                            )));
                  } else {
                    checkFields(context);
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
                        width: eUser().buttonBorderWidth                                      ),
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
          ],
        ),
      ),
    );
  }

  buildPersonalDetails() {
    return Form(
      key: formKey1,
      child: IgnorePointer(
        ignoring: widget.showData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 1.5.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Personal Details",
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
                  "Let Us Know You Better",
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
            buildLabelTextField("First Name:"),
            SizedBox(
              height: 1.h,
            ),
            TextFormField(
              controller: fnameController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                  AppConfig().showSnackbar(
                      context, "Please enter your First Name",
                      isError: true);
                  return 'Please enter your First Name';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", fnameController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("Last Name:"),
            SizedBox(
              height: 1.h,
            ),
            TextFormField(
              controller: lnameController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                  return 'Please enter your Last Name';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", lnameController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Marital Status:'),
            // Text(
            //   'Marital Status:*',
            //   style: TextStyle(
            //     fontSize: 9.sp,
            //     color: kTextColor,
            //     fontFamily: "PoppinsSemiBold",
            //   ),
            // ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              children: [
                Radio(
                  value: "Single",
                  activeColor: kPrimaryColor,
                  groupValue: maritalStatus,
                  onChanged: (value) {
                    setState(() {
                      maritalStatus = value as String;
                    });
                  },
                ),
                Text(
                  'Single',
                  style: buildTextStyle(),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Radio(
                  value: "Married",
                  activeColor: kPrimaryColor,
                  groupValue: maritalStatus,
                  onChanged: (value) {
                    setState(() {
                      maritalStatus = value as String;
                    });
                  },
                ),
                Text(
                  'Married',
                  style: buildTextStyle(),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Radio(
                    value: "Separated",
                    groupValue: maritalStatus,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        maritalStatus = value as String;
                      });
                    }),
                Text(
                  "Separated",
                  style: buildTextStyle(),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Phone Number'),
            // Text(
            //   'Phone Number*',
            //   style: TextStyle(
            //     fontSize: 9.sp,
            //     color: kTextColor,
            //     fontFamily: "PoppinsSemiBold",
            //   ),
            // ),
            SizedBox(
              height: 1.h,
            ),
            TextFormField(
              controller: mobileController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Phone Number';
                } else if (!isPhone(value)) {
                  return 'Please enter valid Mobile Number';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", mobileController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Email ID -'),
            SizedBox(
              height: 1.h,
            ),
            TextFormField(
              controller: emailController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                  return 'Please enter your Email ID';
                } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                  return 'Please enter your valid Email ID';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", emailController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Age'),
            // Text(
            //   'Age*',
            //   style: TextStyle(
            //     fontSize: 9.sp,
            //     color: kTextColor,
            //     fontFamily: "PoppinsSemiBold",
            //   ),
            // ),
            SizedBox(
              height: 1.h,
            ),
            TextFormField(
              controller: ageController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Age';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", ageController),
              textInputAction: TextInputAction.next,
              maxLength: 2,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Gender:'),
            // Text(
            //   'Gender:*',
            //   style: TextStyle(
            //     fontSize: 9.sp,
            //     color: kTextColor,
            //     fontFamily: "PoppinsSemiBold",
            //   ),
            // ),
            SizedBox(
              height: 1.h,
            ),
            Row(
              children: [
                Radio(
                  value: "Male",
                  activeColor: kPrimaryColor,
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value as String;
                    });
                  },
                ),
                Text('Male', style: buildTextStyle()),
                SizedBox(
                  width: 3.w,
                ),
                Radio(
                  value: "Female",
                  activeColor: kPrimaryColor,
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value as String;
                    });
                  },
                ),
                Text(
                  'Female',
                  style: buildTextStyle(),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Radio(
                    value: "Other",
                    groupValue: gender,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        gender = value as String;
                      });
                    }),
                Text(
                  "Other",
                  style: buildTextStyle(),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Flat/House Number'),
            SizedBox(
              height: 1.h,
            ),
            TextFormField(
              controller: address1Controller,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Flat/House Number';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Flat/House Number", address1Controller),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                'Full Postal Address To Deliver Your Ready To Cook Kit'),
            SizedBox(
              height: 1.h,
            ),
            TextFormField(
              controller: address2Controller,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Address';
                } else if (value.length < 10) {
                  return 'Please enter your Address';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Enter your Postal Address", address2Controller),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.streetAddress,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Pin Code'),
            SizedBox(
              height: 1.h,
            ),
            FocusScope(
              onFocusChange: (value) {
                print(value);
                if (cityController.text.isEmpty) {
                  if (!value) {
                    print("editing");
                    String code = _pref?.getString(AppConfig.countryCode) ?? '';
                    if (pinCodeController.text.length < 6) {
                      AppConfig()
                          .showSnackbar(context, 'Pincode should br 6 digits');
                    } else {
                      fetchCountry(pinCodeController.text, 'IN');
                    }
                  }
                }
              },
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: pinCodeController,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Pin Code';
                  } else if (value.length > 7) {
                    return 'Please enter your valid Pin Code';
                  } else {
                    return null;
                  }
                },
                onFieldSubmitted: (value) {
                  if (cityController.text.isEmpty) {
                    String code =
                        _pref?.getString(AppConfig.countryCode) ?? 'IN';
                    if (code.isNotEmpty && code == 'IN') {
                      fetchCountry(value, 'IN');
                    }
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer",
                  pinCodeController,
                  suffixIcon: (pinCodeController.text.length != 6)
                      ? null
                      : GestureDetector(
                          onTap: () {
                            String code =
                                _pref?.getString(AppConfig.countryCode) ?? '';
                            print('code: $code');
                            // if (code.isNotEmpty && code == 'IN') {
                            //   fetchCountry(pinCodeController.text, code);
                            // }
                            fetchCountry(pinCodeController.text, 'IN');

                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: gMainColor,
                            size: 22,
                          ),
                        ),
                ),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('City'),
            SizedBox(
              height: 1.h,
            ),
            IgnorePointer(
              ignoring: _ignoreFields,
              child: TextFormField(
                controller: cityController,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                    return 'Please Enter City';
                  } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                    return 'Please Enter City';
                  } else {
                    return null;
                  }
                },
                decoration: CommonDecoration.buildTextInputDecoration(
                    "Please Select City", cityController),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.streetAddress,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('State'),
            SizedBox(
              height: 1.h,
            ),
            IgnorePointer(
              ignoring: _ignoreFields,
              child: TextFormField(
                controller: stateController,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                    return 'Please Enter State';
                  } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                    return 'Please Enter State';
                  } else {
                    return null;
                  }
                },
                decoration: CommonDecoration.buildTextInputDecoration(
                    "Please Select State", stateController),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.streetAddress,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Country'),
            SizedBox(
              height: 1.h,
            ),
            IgnorePointer(
              ignoring: _ignoreFields,
              child: TextFormField(
                controller: countryController,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                    return 'Please Enter Country';
                  } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                    return 'Please Enter Country';
                  } else {
                    return null;
                  }
                },
                decoration: CommonDecoration.buildTextInputDecoration(
                    "Please Select Country", countryController),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.streetAddress,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }

  buildHealthDetails() {
    return Form(
      key: formKey2,
      child: IgnorePointer(
        ignoring: widget.showData,
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
                      "Health",
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
                  "Important For Your Doctors To Know What You Have Been Through Or Are Going Through At The Moment",
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
            buildLabelTextField('Weight In Kgs'),
            // Text(
            //   'Weight*',
            //   style: TextStyle(
            //     fontSize: 9.sp,
            //     color: kTextColor,
            //     fontFamily: "PoppinsSemiBold",
            //   ),
            // ),
            SizedBox(
              height: 1.h,
            ),
            TextFormField(
              controller: weightController,
              cursorColor: kPrimaryColor,
              maxLength: 3,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Weight';
                } else if (int.tryParse(value)! < 20 ||
                    int.tryParse(value)! > 120) {
                  return 'Please enter Valid Weight';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", weightController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Height In Feet & Inches'),
            SizedBox(
              height: 1.h,
            ),
            showDropdown(),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                'Brief Paragraph About Your Current Complaints Are & What You Are Looking To Heal Here'),
            SizedBox(
              height: 1.h,
            ),
            TextFormField(
              controller: healController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter Heal';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", healController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Please Check All That Apply To You'),
            SizedBox(
              height: 1.h,
            ),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                ...healthCheckBox1
                    .map((e) => buildHealthCheckBox(e, 'health1'))
                    .toList(),
                TextFormField(
                  controller: checkbox1OtherController,
                  cursorColor: kPrimaryColor,
                  validator: (value) {
                    if (value!.isEmpty &&
                        selectedHealthCheckBox1
                            .any((element) => element.contains("Other:"))) {
                      return 'Please Mention Other Details with minimum 2 characters';
                    } else {
                      return null;
                    }
                  },
                  decoration: CommonDecoration.buildTextInputDecoration(
                      "Your answer", checkbox1OtherController),
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            // health checkbox2
            buildLabelTextField('Please Check All That Apply To You'),
            SizedBox(
              height: 1.h,
            ),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                ...healthCheckBox2
                    .map((e) => buildHealthCheckBox(e, 'health2'))
                    .toList(),
                SizedBox(
                  height: 1.h,
                ),
                buildLabelTextField('Tongue Coating'),
                SizedBox(
                  height: 1.h,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Radio(
                            value: "clear",
                            groupValue: tongueCoatingRadio,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                tongueCoatingRadio = value as String;
                              });
                            }),
                        Text(
                          "Clear",
                          style: buildTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            value: "Coated with white layer",
                            groupValue: tongueCoatingRadio,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                tongueCoatingRadio = value as String;
                              });
                            }),
                        Text(
                          "Coated with white layer",
                          style: buildTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                            value: "Coated with yellow layer",
                            groupValue: tongueCoatingRadio,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                tongueCoatingRadio = value as String;
                              });
                            }),
                        Text(
                          "Coated with yellow layer",
                          style: buildTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                            value: "Coated with black layer",
                            groupValue: tongueCoatingRadio,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                tongueCoatingRadio = value as String;
                              });
                            }),
                        Text(
                          "Coated with black layer",
                          style: buildTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                            value: "other",
                            groupValue: tongueCoatingRadio,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                tongueCoatingRadio = value as String;
                              });
                            }),
                        Text(
                          "Other:",
                          style: buildTextStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  controller: tongueCoatingController,
                  cursorColor: kPrimaryColor,
                  validator: (value) {
                    if (value!.isEmpty &&
                        tongueCoatingRadio.toLowerCase().contains("other")) {
                      return 'Please enter the tongue coating details';
                    } else {
                      return null;
                    }
                  },
                  decoration: CommonDecoration.buildTextInputDecoration(
                      "Your answer", tongueCoatingController),
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                "Has Frequency Of Urination Increased Or Decreased In The Recent Past"),
            SizedBox(
              height: 1.h,
            ),
            Row(
              children: [
                Radio(
                  value: "Increased",
                  activeColor: kPrimaryColor,
                  groupValue: urinationValue,
                  onChanged: (value) {
                    setState(() {
                      urinationValue = value as String;
                    });
                  },
                ),
                Text('Increased', style: buildTextStyle()),
                SizedBox(
                  width: 3.w,
                ),
                Radio(
                  value: "Decreased",
                  activeColor: kPrimaryColor,
                  groupValue: urinationValue,
                  onChanged: (value) {
                    setState(() {
                      urinationValue = value as String;
                    });
                  },
                ),
                Text(
                  'Decreased',
                  style: buildTextStyle(),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Radio(
                    value: "No Change",
                    groupValue: urinationValue,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        urinationValue = value as String;
                      });
                    }),
                Text(
                  "No Change",
                  style: buildTextStyle(),
                ),
              ],
            ),
            // Wrap(
            //   // mainAxisSize: MainAxisSize.min,
            //   children: [
            //     ...urinFrequencyList.map(buildWrapingCheckBox).toList()
            //   ],
            // ),
            buildLabelTextField("Urin Color"),
            SizedBox(
              height: 1.h,
            ),
            buildUrineColorRadioButton(),
            // ListView(
            //   shrinkWrap: true,
            //   physics: const BouncingScrollPhysics(),
            //   children: [
            //     Wrap(
            //       children: [
            //         ...urinColorList.map(buildWrapingCheckBox).toList(),
            //       ],
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8),
            //       child: Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           SizedBox(
            //             width: 20,
            //             child: Checkbox(
            //               activeColor: kPrimaryColor,
            //               value: urinColorOtherSelected,
            //               onChanged: (v) {
            //                 setState(() {
            //                   urinColorOtherSelected = v!;
            //                   if(urinColorOtherSelected){
            //                     selectedUrinColorList.add(otherText);
            //                   }
            //                   else{
            //                     selectedUrinColorList.remove(otherText);
            //                   }
            //                 });
            //               },
            //             ),
            //           ),
            //           const SizedBox(
            //             width: 4,
            //           ),
            //           Text(
            //             'Other:',
            //             style: buildTextStyle(),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8),
            //       child: TextFormField(
            //         controller: urinColorController,
            //         cursorColor: kPrimaryColor,
            //         validator: (value) {
            //           if (value!.isEmpty && urinColorOtherSelected) {
            //             return 'Please enter the details about Urin Color';
            //           } else {
            //             return null;
            //           }
            //         },
            //         decoration: CommonDecoration.buildTextInputDecoration(
            //             "Your answer", urinColorController),
            //         textInputAction: TextInputAction.next,
            //         textAlign: TextAlign.start,
            //         keyboardType: TextInputType.text,
            //       ),
            //     ),
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: urinColorController,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value!.isEmpty &&
                      urineColorValue.toLowerCase().contains('other')) {
                    AppConfig().showSnackbar(
                        context, "Please enter the details about Urine Color",
                        isError: true);
                    return 'Please enter the details about Urine Color';
                  } else {
                    return null;
                  }
                },
                decoration: CommonDecoration.buildTextInputDecoration(
                    "Your answer", urinColorController),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("Urine Smell"),
            SizedBox(
              height: 1.h,
            ),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Wrap(
                  children: [
                    ...urinSmellList
                        .map((e) => buildHealthCheckBox(e, 'smell'))
                        .toList(),
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
                    value: urinSmellOtherSelected,
                    onChanged: (v) {
                      setState(() {
                        urinSmellOtherSelected = v!;
                        if (urinSmellOtherSelected) {
                          selectedUrinSmellList.clear();
                          urinSmellList.forEach((element) {
                            element.value = false;
                          });
                          selectedUrinSmellList.add(otherText);
                        } else {
                          selectedUrinSmellList.remove(otherText);
                        }
                        print(selectedUrinSmellList);
                      });
                    },
                  ),
                ),
                // ListTile(
                //   minLeadingWidth: 0,
                //   leading: SizedBox(
                //     width: 20,
                //     child: Checkbox(
                //       activeColor: kPrimaryColor,
                //       value: urinSmellOtherSelected,
                //       onChanged: (v) {
                //         setState(() {
                //           urinSmellOtherSelected = v!;
                //           if (urinSmellOtherSelected) {
                //             selectedUrinSmellList.clear();
                //             urinSmellList.forEach((element) {
                //               element.value = false;
                //             });
                //             selectedUrinSmellList.add(otherText);
                //           } else {
                //             selectedUrinSmellList.remove(otherText);
                //           }
                //           print(selectedUrinSmellList);
                //         });
                //       },
                //     ),
                //   ),
                //   title: Text(
                //     'Other:',
                //     style: buildTextStyle(),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    controller: urinSmellController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty && urinSmellOtherSelected) {
                        return 'Please select the details about urine smell';
                      } else {
                        return null;
                      }
                    },
                    decoration: CommonDecoration.buildTextInputDecoration(
                        "Your answer", urinSmellController),
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("What Does Your Urine Look Like"),
            SizedBox(
              height: 1.h,
            ),
            buildUrineLookRadioButton(),
            // ListView(
            //   shrinkWrap: true,
            //   physics: const BouncingScrollPhysics(),
            //   children: [
            //     Wrap(
            //       children: [
            //         ...urinLooksList.map(buildHealthCheckBox).toList(),
            //       ],
            //     ),
            //     ListTile(
            //       minLeadingWidth: 0,
            //       leading: SizedBox(
            //         width: 20,
            //         child: Checkbox(
            //           activeColor: kPrimaryColor,
            //           value: urinLooksLikeOtherSelected,
            //           onChanged: (v) {
            //             setState(() {
            //               urinLooksLikeOtherSelected = v!;
            //               if(urinLooksLikeOtherSelected){
            //                 selectedUrinLooksList.add(otherText);
            //               }
            //               else{
            //                 selectedUrinLooksList.remove(otherText);
            //               }
            //             });
            //           },
            //         ),
            //       ),
            //       title: Text(
            //         'Other:',
            //         style: buildTextStyle(),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8),
            //       child: TextFormField(
            //         controller: urinLooksLikeController,
            //         cursorColor: kPrimaryColor,
            //         validator: (value) {
            //           if (value!.isEmpty && urinLooksLikeOtherSelected) {
            //             return 'Please enter how Urin Looks';
            //           } else {
            //             return null;
            //           }
            //         },
            //         decoration: CommonDecoration.buildTextInputDecoration(
            //             "Your answer", urinLooksLikeController),
            //         textInputAction: TextInputAction.next,
            //         textAlign: TextAlign.start,
            //         keyboardType: TextInputType.text,
            //       ),
            //     ),
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                controller: urinLooksLikeController,
                cursorColor: kPrimaryColor,
                validator: (value) {
                  if (value!.isEmpty &&
                      urineLookLikeValue.toLowerCase().contains('other')) {
                    AppConfig().showSnackbar(
                        context, "Please enter how Urine Looks",
                        isError: true);
                    return 'Please enter how Urine Looks';
                  } else {
                    return null;
                  }
                },
                decoration: CommonDecoration.buildTextInputDecoration(
                    "Your answer", urinLooksLikeController),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("Which one is the closest match to your stool"),
            SizedBox(
              height: 1.h,
            ),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 18.h,
                  child: const Image(
                    image: AssetImage("assets/images/stool_image.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Radio(
                            value: "Seperate hard lumps",
                            groupValue: selectedStoolMatch,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                selectedStoolMatch = value as String;
                              });
                            }),
                        Text(
                          "Seperate hard lumps",
                          style: buildTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            value: "Lumpy & sausage like",
                            groupValue: selectedStoolMatch,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                selectedStoolMatch = value as String;
                              });
                            }),
                        Text(
                          "Lumpy & sausage like",
                          style: buildTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            value: "Sausage shape with cracks on the surface",
                            groupValue: selectedStoolMatch,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                selectedStoolMatch = value as String;
                              });
                            }),
                        Text(
                          "Sausage shape with cracks on the surface",
                          style: buildTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            value: "Smooth, soft sausage or snake",
                            groupValue: selectedStoolMatch,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                selectedStoolMatch = value as String;
                              });
                            }),
                        Text(
                          "Smooth, soft sausage or snake",
                          style: buildTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            value: "Soft blobs with clear cut edges",
                            groupValue: selectedStoolMatch,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                selectedStoolMatch = value as String;
                              });
                            }),
                        Text(
                          "Soft blobs with clear cut edges",
                          style: buildTextStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            value: "liquid consistency with no solid pieces",
                            groupValue: selectedStoolMatch,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                selectedStoolMatch = value as String;
                              });
                            }),
                        Text(
                          "liquid consistency with no solid pieces",
                          style: buildTextStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("Medical Interventions Done Before"),
            SizedBox(
              height: 1.h,
            ),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Wrap(
                  children: [
                    ...medicalInterventionsDoneBeforeList
                        .map((e) => buildHealthCheckBox(e, 'interventions'))
                        .toList(),
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
                      value: medicalInterventionsOtherSelected,
                    onChanged: (v) {
                      setState(() {
                        medicalInterventionsOtherSelected = v!;
                        if (medicalInterventionsOtherSelected) {
                          selectedmedicalInterventionsDoneBeforeList
                              .add(otherText);
                          selectedmedicalInterventionsDoneBeforeList.clear();
                          medicalInterventionsDoneBeforeList
                              .forEach((element) {
                            element.value = false;
                          });
                          selectedmedicalInterventionsDoneBeforeList
                              .add(otherText);
                        } else {
                          selectedmedicalInterventionsDoneBeforeList
                              .remove(otherText);
                        }
                      });
                    },
                  ),
                ),
                // ListTile(
                //   minLeadingWidth: 0,
                //   leading: SizedBox(
                //     width: 20,
                //     child: Checkbox(
                //       activeColor: kPrimaryColor,
                //       value: medicalInterventionsOtherSelected,
                //       onChanged: (v) {
                //         setState(() {
                //           medicalInterventionsOtherSelected = v!;
                //           if (medicalInterventionsOtherSelected) {
                //             selectedmedicalInterventionsDoneBeforeList
                //                 .add(otherText);
                //             selectedmedicalInterventionsDoneBeforeList.clear();
                //             medicalInterventionsDoneBeforeList
                //                 .forEach((element) {
                //               element.value = false;
                //             });
                //             selectedmedicalInterventionsDoneBeforeList
                //                 .add(otherText);
                //           } else {
                //             selectedmedicalInterventionsDoneBeforeList
                //                 .remove(otherText);
                //           }
                //         });
                //       },
                //     ),
                //   ),
                //   title: Text(
                //     'Other:',
                //     style: buildTextStyle(),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    controller: medicalInterventionsDoneController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty && medicalInterventionsOtherSelected) {
                        return 'Please enter Medical Interventions';
                      } else {
                        return null;
                      }
                    },
                    decoration: CommonDecoration.buildTextInputDecoration(
                        "Your answer", medicalInterventionsDoneController),
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                'Any Medications/Supplements/Inhalers/Contraceptives You Consume At The Moment'),
            TextFormField(
              controller: medicationsController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please mention Any Medications Taken before';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", medicationsController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                'Holistic/Alternative Therapies You Have Been Through & When (Ayurveda, Homeopathy) '),
            SizedBox(
              height: 1.h,
            ),
            TextFormField(
              controller: holisticController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please mention the Therapy taken';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", holisticController),
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField(
                "Please Upload Any & All Medical Records That Might Be Helpful To Evaluate Your Condition Better"),
            SizedBox(
              height: 1.h,
            ),
            GestureDetector(
              onTap: () async {
                final result = await FilePicker.platform
                    .pickFiles(withReadStream: true, allowMultiple: false);

                if (result == null) return;
                if (result.files.first.extension!.contains("pdf") ||
                    result.files.first.extension!.contains("png") ||
                    result.files.first.extension!.contains("jpg")) {
                  medicalRecords.add(result.files.first);
                } else {
                  AppConfig().showSnackbar(
                      context, "Please select png/jpg/Pdf files",
                      isError: true);
                }
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: gMainColor, width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.file_upload_outlined,
                      color: gMainColor,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Add File',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: gMainColor,
                        fontFamily: "PoppinsRegular",
                      ),
                    )
                  ],
                ),
              ),
            ),
            (widget.showData)
                ? showFiles()
                : (medicalRecords.isEmpty)
                    ? Container()
                    : SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          itemCount: medicalRecords.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final file = medicalRecords[index];
                            return buildFile(file, index);
                          },
                        ),
                      ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFile(PlatformFile file, int index) {
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final size = (mb >= 1)
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
    return buildRecordList(file.name, index: index);

    // return Wrap(
    //   children: [
    //     RawChip(
    //         label: Text(file.name),
    //       deleteIcon: Icon(
    //         Icons.cancel,
    //       ),
    //       deleteIconColor: gMainColor,
    //       onDeleted: (){
    //         medicalRecords.removeAt(index);
    //         setState(() {});
    //       },
    //     )
    //   ],
    // );
  }

  checkFields(BuildContext context) {
    print(formKey1.currentState!.validate());
    if (formKey1.currentState!.validate() &&
        formKey2.currentState!.validate()) {
      if (address1Controller.text.isEmpty) {
        AppConfig().showSnackbar(context, "Please Mention Flat Details");
      } else if (address2Controller.text.isEmpty) {
        AppConfig().showSnackbar(context, "Please Postal Address");
      } else if (pinCodeController.text.isEmpty) {
        AppConfig().showSnackbar(context, "Please Mention Pincode");
      } else if (ft == -1 || inches == -1) {
        AppConfig().showSnackbar(context, "Please Select Height");
      } else if (healthCheckBox1.every((element) => element.value == false)) {
        AppConfig().showSnackbar(
            context, "Please Select Atleast 1 option from HealthList1");
      } else if (healthCheckBox2.every((element) => element.value == false)) {
        AppConfig().showSnackbar(
            context, "Please Select Atleast 1 option from HealthList2");
      } else if (tongueCoatingRadio.isEmpty) {
        AppConfig()
            .showSnackbar(context, "Please Select Tongue Coating Details");
      } else if (urinationValue.isEmpty) {
        // else if(urinFrequencyList.every((element) => element.value == false)){
        AppConfig()
            .showSnackbar(context, "Please Select Frequency of Urination");
      } else if (urineColorValue.isEmpty) {
        // else if(urinColorList.every((element) => element.value == false) && !urinColorOtherSelected){
        AppConfig().showSnackbar(context, "Please Select Urine Color");
      } else if (urinSmellList.every((element) => element.value == false) &&
          !urinSmellOtherSelected) {
        AppConfig().showSnackbar(context, "Please Select Atleast 1 Urin Smell");
      } else if (urineLookLikeValue.isEmpty) {
        // else if(urinLooksList.every((element) => element.value == false) && !urinLooksLikeOtherSelected){
        AppConfig().showSnackbar(context, "Please Select Urine Looks List");
      } else if (selectedStoolMatch.isEmpty) {
        AppConfig()
            .showSnackbar(context, "Please Select Closest match to your stool");
      } else if (medicalInterventionsDoneBeforeList
              .every((element) => element.value == false) &&
          medicalInterventionsOtherSelected == false) {
        AppConfig().showSnackbar(
            context, "Please Select Atleast 1 Medication Intervention");
      } else if (medicalRecords.isEmpty) {
        AppConfig().showSnackbar(context, "Please Upload Medical Records");
      } else {
        if (ft != -1 && inches != -1) {
          heightText = '$ft.$inches';
          print(heightText);
        }
        addSelectedValuesToList();
        var eval1 = createFormMap();
        print((eval1 as EvaluationModelFormat1).toMap());
        print(urineColorValue);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => PersonalDetailsScreen2(
                    evaluationModelFormat1: eval1,
                    medicalReportList:
                        medicalRecords.map((e) => e.path).toList())));
      }
    } else {
      if (address1Controller.text.isEmpty) {
        AppConfig().showSnackbar(context, "Please Mention Flat Details",
            isError: true);
      } else if (address2Controller.text.isEmpty) {
        AppConfig()
            .showSnackbar(context, "Please Postal Address", isError: true);
      } else if (pinCodeController.text.isEmpty) {
        AppConfig()
            .showSnackbar(context, "Please Mention Pincode", isError: true);
      } else if (ft == -1 || inches == -1) {
        AppConfig()
            .showSnackbar(context, "Please Select Height", isError: true);
      } else if (healController.text.isEmpty) {
        AppConfig().showSnackbar(context, "Please Mention your heal complaints",
            isError: true);
      } else if (healthCheckBox1.every((element) => element.value == false)) {
        AppConfig().showSnackbar(
            context, "Please Select Atleast 1 option from HealthList1",
            isError: true);
      } else if (healthCheckBox2.every((element) => element.value == false)) {
        AppConfig().showSnackbar(
            context, "Please Select Atleast 1 option from HealthList2",
            isError: true);
      } else if (tongueCoatingRadio.isEmpty) {
        AppConfig().showSnackbar(
            context, "Please Select Tongue Coating Details",
            isError: true);
      } else if (urinationValue.isEmpty) {
        // else if(urinFrequencyList.every((element) => element.value == false)){
        AppConfig().showSnackbar(
            context, "Please Select Frequency of Urination",
            isError: true);
      } else if (urineColorValue.isEmpty) {
        // else if(urinColorList.every((element) => element.value == false) && !urinColorOtherSelected){
        AppConfig()
            .showSnackbar(context, "Please Select Urine Color", isError: true);
      } else if (urinSmellList.every((element) => element.value == false) &&
          !urinSmellOtherSelected) {
        AppConfig().showSnackbar(context, "Please Select Atleast 1 Urin Smell",
            isError: true);
      } else if (urineLookLikeValue.isEmpty) {
        // else if(urinLooksList.every((element) => element.value == false) && !urinLooksLikeOtherSelected){
        AppConfig().showSnackbar(context, "Please Select Urine Looks List",
            isError: true);
      } else if (selectedStoolMatch.isEmpty) {
        AppConfig().showSnackbar(
            context, "Please Select Closest match to your stool",
            isError: true);
      } else if (medicalInterventionsDoneBeforeList
              .every((element) => element.value == false) &&
          medicalInterventionsOtherSelected == false) {
        AppConfig().showSnackbar(
            context, "Please Select Atleast 1 Medication Intervention",
            isError: true);
      } else if (medicalRecords.isEmpty) {
        AppConfig().showSnackbar(context, "Please Upload Medical Records",
            isError: true);
      }
    }
  }

  createFormMap() {
    return EvaluationModelFormat1(
      fname: fnameController.text.capitalize(),
      lname: lnameController.text.capitalize(),
      maritalStatus: maritalStatus,
      phone: mobileController.text,
      email: emailController.text,
      age: ageController.text,
      gender: gender,
      address1: "No. " + address1Controller.text,
      address2: address2Controller.text,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
      pincode: pinCodeController.text,
      weight: weightController.text,
      height: heightText,
      looking_to_heal: healController.text,
      checkList1: selectedHealthCheckBox1.join(','),
      checkList1Other: checkbox1OtherController.text,
      checkList2: selectedHealthCheckBox2.join(','),
      tongueCoating: tongueCoatingRadio,
      tongueCoating_other: (tongueCoatingRadio.toLowerCase().contains("other"))
          ? tongueCoatingController.text
          : '',
      urinationIssue: urinationValue,
      urinColor: urineColorValue,
      urinColor_other: urineColorValue.toLowerCase().contains("other")
          ? urinColorController.text
          : '',
      urinSmell: selectedUrinSmellList.join(','),
      urinSmell_other: urinSmellOtherSelected ? urinSmellController.text : '',
      urinLooksLike: urineLookLikeValue,
      urinLooksLike_other: urineLookLikeValue.toLowerCase().contains("other")
          ? urinLooksLikeController.text
          : '',
      stoolDetails: selectedStoolMatch,
      medical_interventions:
          selectedmedicalInterventionsDoneBeforeList.join(','),
      medical_interventions_other: medicalInterventionsOtherSelected
          ? medicalInterventionsDoneController.text
          : '',
      medication: medicationsController.text,
      holistic: holisticController.text,
    );
  }

  List<String> lst = List.generate(8, (index) => '${index + 1}').toList();
  List<String> lst1 = List.generate(12, (index) => '${index}').toList();

  showDropdown() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: CustomDropdownButton2(
              // buttonHeight: 25,
              // buttonWidth: 45.w,
              hint: 'Feet',
              dropdownItems: lst,
              value: ft == -1 ? null : ft.toString(),
              onChanged: (value) {
                setState(() {
                  ft = int.tryParse(value!) ?? -1;
                });
              },
              buttonDecoration: BoxDecoration(
                color: gWhiteColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gMainColor, width: 1),
              ),
              icon: Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: CustomDropdownButton2(
              // buttonHeight: 25,
              // buttonWidth: 45.w,

              hint: 'Inches',
              dropdownItems: lst1,
              value: (inches == -1) ? null : inches.toString(),
              onChanged: (value) {
                setState(() {
                  inches = int.tryParse(value!) ?? -1;
                });
              },
              buttonDecoration: BoxDecoration(
                color: gWhiteColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gMainColor, width: 1),
              ),
              icon: Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
        ],
      ),
    );
  }

  buildFoodHabitsDetails() {
    return Column(
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
        SizedBox(
          height: 3.h,
        ),
        Text(
          'Food Preferences*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Column(
          children: [
            Row(
              children: [
                Radio(
                  value: "Veg",
                  activeColor: kPrimaryColor,
                  groupValue: foodPreference,
                  onChanged: (value) {
                    setState(() {
                      foodPreference = value as String;
                    });
                  },
                ),
                Text(
                  'Veg',
                  style: buildTextStyle(),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Radio(
                  value: "Non-Veg",
                  activeColor: kPrimaryColor,
                  groupValue: foodPreference,
                  onChanged: (value) {
                    setState(() {
                      foodPreference = value as String;
                    });
                  },
                ),
                Text(
                  'Non-Veg',
                  style: buildTextStyle(),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Radio(
                    value: "Mixed",
                    groupValue: foodPreference,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        foodPreference = value as String;
                      });
                    }),
                Text(
                  "Mixed",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value: "Lacto Veg",
                    groupValue: foodPreference,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        foodPreference = value as String;
                      });
                    }),
                Text(
                  "Lacto Veg",
                  style: buildTextStyle(),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Radio(
                    value: "Ova Veg",
                    groupValue: foodPreference,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        foodPreference = value as String;
                      });
                    }),
                Text(
                  "Ova Veg",
                  style: buildTextStyle(),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'What Kind Of Food Do You Like?*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            ...foodCheckBox.map(buildFoodCheckBox).toList(),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'The Taste You Enjoy*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Column(
          children: [
            Row(
              children: [
                Radio(
                  value: "Sweet",
                  activeColor: kPrimaryColor,
                  groupValue: tasteYouEnjoy,
                  onChanged: (value) {
                    setState(() {
                      tasteYouEnjoy = value as String;
                    });
                  },
                ),
                Text(
                  'Sweet',
                  style: buildTextStyle(),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Radio(
                  value: "Sour",
                  activeColor: kPrimaryColor,
                  groupValue: tasteYouEnjoy,
                  onChanged: (value) {
                    setState(() {
                      tasteYouEnjoy = value as String;
                    });
                  },
                ),
                Text(
                  'Sour',
                  style: buildTextStyle(),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Radio(
                    value: "Bitter",
                    groupValue: tasteYouEnjoy,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        tasteYouEnjoy = value as String;
                      });
                    }),
                Text(
                  "Bitter",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value: "Spicy",
                    groupValue: tasteYouEnjoy,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        tasteYouEnjoy = value as String;
                      });
                    }),
                Text(
                  "Spicy",
                  style: buildTextStyle(),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Radio(
                    value: "Salty",
                    groupValue: tasteYouEnjoy,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        tasteYouEnjoy = value as String;
                      });
                    }),
                Text(
                  "Salty",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value: "Astringent",
                    groupValue: tasteYouEnjoy,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        tasteYouEnjoy = value as String;
                      });
                    }),
                const Text(
                  "Astringent ",
                  style: TextStyle(
                    color: kTextColor,
                    fontFamily: "PoppinsRegular",
                  ),
                ),
                const Text(
                  "( Taste of Dark Chocolate,Supari..)",
                  style: TextStyle(
                    color: kTextColor,
                    fontSize: 12,
                    fontFamily: "PoppinsRegular",
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Number Of Meals You Have A Day*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Column(
          children: [
            Row(
              children: [
                Radio(
                  value: "<2",
                  activeColor: kPrimaryColor,
                  groupValue: mealsYouHaveADay,
                  onChanged: (value) {
                    setState(() {
                      mealsYouHaveADay = value as String;
                    });
                  },
                ),
                Text(
                  '<2',
                  style: buildTextStyle(),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Radio(
                  value: "3-4",
                  activeColor: kPrimaryColor,
                  groupValue: mealsYouHaveADay,
                  onChanged: (value) {
                    setState(() {
                      mealsYouHaveADay = value as String;
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
                    value: "5-6",
                    groupValue: mealsYouHaveADay,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        mealsYouHaveADay = value as String;
                      });
                    }),
                Text(
                  "5-6",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: "More Than 6",
                  activeColor: kPrimaryColor,
                  groupValue: mealsYouHaveADay,
                  onChanged: (value) {
                    setState(() {
                      mealsYouHaveADay = value as String;
                    });
                  },
                ),
                Text(
                  'More Than 6',
                  style: buildTextStyle(),
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Do Certain Food Affect Your Digestion? If So Please Provide Details.*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          controller: digestionController,
          cursorColor: kPrimaryColor,
          validator: (value) {
            if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your Changed';
            } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your valid Changed';
            } else {
              return null;
            }
          },
          decoration: CommonDecoration.buildTextInputDecoration(
              "Your answer", digestionController),
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Do You Follow Any Special Diet(Keto,Etc)? If So Please Provide Details*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          controller: specialDietController,
          cursorColor: kPrimaryColor,
          validator: (value) {
            if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your Changed';
            } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your valid Changed';
            } else {
              return null;
            }
          },
          decoration: CommonDecoration.buildTextInputDecoration(
              "Your answer", specialDietController),
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Do You Have Any Known Food Allergy? If So Please Provide Details.*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          controller: foodAllergyController,
          cursorColor: kPrimaryColor,
          validator: (value) {
            if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your Changed';
            } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your valid Changed';
            } else {
              return null;
            }
          },
          decoration: CommonDecoration.buildTextInputDecoration(
              "Your answer", foodAllergyController),
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Do You Have Any Known Intolerance? If So Please Provide Details.*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          controller: intoleranceController,
          cursorColor: kPrimaryColor,
          validator: (value) {
            if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your Changed';
            } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your valid Changed';
            } else {
              return null;
            }
          },
          decoration: CommonDecoration.buildTextInputDecoration(
              "Your answer", intoleranceController),
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Do You Have Any Severe Food Cravings? If So Please Provide Details.*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          controller: cravingsController,
          cursorColor: kPrimaryColor,
          validator: (value) {
            if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your Changed';
            } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your valid Changed';
            } else {
              return null;
            }
          },
          decoration: CommonDecoration.buildTextInputDecoration(
              "Your answer", cravingsController),
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Do You Dislike Any Food?Please Mention All Of Them*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          controller: dislikeFoodController,
          cursorColor: kPrimaryColor,
          validator: (value) {
            if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your Changed';
            } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your valid Changed';
            } else {
              return null;
            }
          },
          decoration: CommonDecoration.buildTextInputDecoration(
              "Your answer", dislikeFoodController),
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'How Many Glasses Of Water Do You Have A Day?*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            Radio(
              value: "1-2",
              activeColor: kPrimaryColor,
              groupValue: selectedValue5,
              onChanged: (value) {
                setState(() {
                  selectedValue5 = value as String;
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
              groupValue: selectedValue5,
              onChanged: (value) {
                setState(() {
                  selectedValue5 = value as String;
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
                groupValue: selectedValue5,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedValue5 = value as String;
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
                groupValue: selectedValue5,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedValue5 = value as String;
                  });
                }),
            Text(
              "9+",
              style: buildTextStyle(),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Your Water Habit*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Column(
          children: [
            Row(
              children: [
                Radio(
                    value: "I Drink Water Before Meals",
                    groupValue: selectedValue6,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue6 = value as String;
                      });
                    }),
                Text(
                  "I Drink Water Before Meals",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value: "I Usually Drink Water During Meals",
                    groupValue: selectedValue6,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue6 = value as String;
                      });
                    }),
                Text(
                  "I Usually Drink Water During Meals",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value: "I Usually Drink Water After Meals",
                    groupValue: selectedValue6,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue6 = value as String;
                      });
                    }),
                Text(
                  "I Usually Drink Water After Meals",
                  style: buildTextStyle(),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Do You Regularly Consume Meat/Poultry/Sea Food Cooked With Curd/Yoghurt/Milk (Ex.Butter Chicken)*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            Radio(
              value: "Yes",
              activeColor: kPrimaryColor,
              groupValue: selectedValue7,
              onChanged: (value) {
                setState(() {
                  selectedValue7 = value as String;
                });
              },
            ),
            Text(
              'Yes',
              style: buildTextStyle(),
            ),
            SizedBox(
              width: 2.w,
            ),
            Radio(
              value: "No",
              activeColor: kPrimaryColor,
              groupValue: selectedValue7,
              onChanged: (value) {
                setState(() {
                  selectedValue7 = value as String;
                });
              },
            ),
            Text(
              'No',
              style: buildTextStyle(),
            ),
            SizedBox(
              width: 2.w,
            ),
            Radio(
                value: "Sometimes",
                groupValue: selectedValue7,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedValue7 = value as String;
                  });
                }),
            Text(
              "Sometimes",
              style: buildTextStyle(),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'You Tend To Have Cold Water Or Cold Beverages After Non-Veg Fat Meals/Heavy Snacks Like Samosa*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            Radio(
              value: "Yes",
              activeColor: kPrimaryColor,
              groupValue: selectedValue8,
              onChanged: (value) {
                setState(() {
                  selectedValue8 = value as String;
                });
              },
            ),
            Text(
              'Yes',
              style: buildTextStyle(),
            ),
            SizedBox(
              width: 2.w,
            ),
            Radio(
              value: "No",
              activeColor: kPrimaryColor,
              groupValue: selectedValue8,
              onChanged: (value) {
                setState(() {
                  selectedValue8 = value as String;
                });
              },
            ),
            Text(
              'No',
              style: buildTextStyle(),
            ),
            SizedBox(
              width: 2.w,
            ),
            Radio(
                value: "Sometimes",
                groupValue: selectedValue8,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedValue8 = value as String;
                  });
                }),
            Text(
              "Sometimes",
              style: buildTextStyle(),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Do You Eat Fruits With/Right After/Right Before Your main Course?*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            Radio(
              value: "Yes",
              activeColor: kPrimaryColor,
              groupValue: selectedValue9,
              onChanged: (value) {
                setState(() {
                  selectedValue9 = value as String;
                });
              },
            ),
            Text(
              'Yes',
              style: buildTextStyle(),
            ),
            SizedBox(
              width: 2.w,
            ),
            Radio(
              value: "No",
              activeColor: kPrimaryColor,
              groupValue: selectedValue9,
              onChanged: (value) {
                setState(() {
                  selectedValue9 = value as String;
                });
              },
            ),
            Text(
              'No',
              style: buildTextStyle(),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Do You Have Fruits With Milk?*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            Radio(
              value: "Yes",
              activeColor: kPrimaryColor,
              groupValue: selectedValue10,
              onChanged: (value) {
                setState(() {
                  selectedValue10 = value as String;
                });
              },
            ),
            Text(
              'Yes',
              style: buildTextStyle(),
            ),
            SizedBox(
              width: 2.w,
            ),
            Radio(
              value: "No",
              activeColor: kPrimaryColor,
              groupValue: selectedValue10,
              onChanged: (value) {
                setState(() {
                  selectedValue10 = value as String;
                });
              },
            ),
            Text(
              'No',
              style: buildTextStyle(),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Which One Is More Apt*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Column(
          children: [
            Row(
              children: [
                Radio(
                    value: "I Chew My Food Properly",
                    groupValue: selectedValue11,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue11 = value as String;
                      });
                    }),
                Text(
                  "I Chew My Food Properly",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value: "I Swallow My Food Quickly",
                    groupValue: selectedValue11,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue11 = value as String;
                      });
                    }),
                Text(
                  "I Swallow My Food Quickly",
                  style: buildTextStyle(),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Do You Eat Food Even When You Are Not Hungry(Ex. Stress Eating)*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            Radio(
              value: "Yes",
              activeColor: kPrimaryColor,
              groupValue: selectedValue12,
              onChanged: (value) {
                setState(() {
                  selectedValue12 = value as String;
                });
              },
            ),
            Text(
              'Yes',
              style: buildTextStyle(),
            ),
            SizedBox(
              width: 2.w,
            ),
            Radio(
              value: "No",
              activeColor: kPrimaryColor,
              groupValue: selectedValue12,
              onChanged: (value) {
                setState(() {
                  selectedValue12 = value as String;
                });
              },
            ),
            Text(
              'No',
              style: buildTextStyle(),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Do You Have Processed Food More Than 3 Times A Week.(Ex. Chips,Biscuits,Cakes,etc)*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            Radio(
              value: "Yes",
              activeColor: kPrimaryColor,
              groupValue: selectedValue13,
              onChanged: (value) {
                setState(() {
                  selectedValue13 = value as String;
                });
              },
            ),
            Text(
              'Yes',
              style: buildTextStyle(),
            ),
            SizedBox(
              width: 2.w,
            ),
            Radio(
              value: "No",
              activeColor: kPrimaryColor,
              groupValue: selectedValue13,
              onChanged: (value) {
                setState(() {
                  selectedValue13 = value as String;
                });
              },
            ),
            Text(
              'No',
              style: buildTextStyle(),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Do You Have Take Out Or Eat Outside Food More Than 3 Times A Week?*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            Radio(
              value: "Yes",
              activeColor: kPrimaryColor,
              groupValue: selectedValue14,
              onChanged: (value) {
                setState(() {
                  selectedValue14 = value as String;
                });
              },
            ),
            Text(
              'Yes',
              style: buildTextStyle(),
            ),
            SizedBox(
              width: 2.w,
            ),
            Radio(
              value: "No",
              activeColor: kPrimaryColor,
              groupValue: selectedValue14,
              onChanged: (value) {
                setState(() {
                  selectedValue14 = value as String;
                });
              },
            ),
            Text(
              'No',
              style: buildTextStyle(),
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }

  buildSleepDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Sleep",
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
        SizedBox(
          height: 3.h,
        ),
        Text(
          'What Time Do You Usually Go To Bed?*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          controller: goToBedController,
          cursorColor: kPrimaryColor,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your Weight';
            } else {
              return null;
            }
          },
          decoration: CommonDecoration.buildTextInputDecoration(
              "Time - 00:00", goToBedController),
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.name,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'What Time Do You Usuallu Wake Up?*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          controller: wakeUpController,
          cursorColor: kPrimaryColor,
          validator: (value) {
            if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter Heal';
            } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your valid Heal';
            } else {
              return null;
            }
          },
          decoration: CommonDecoration.buildTextInputDecoration(
              "Time - 00:00", wakeUpController),
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'What Does Your Sleep Look Like?*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            ...sleepCheckBox.map(buildSleepCheckBox).toList(),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Your Sleep Cycle Is*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            Radio(
              value: "Regular",
              activeColor: kPrimaryColor,
              groupValue: selectedValue15,
              onChanged: (value) {
                setState(() {
                  selectedValue15 = value as String;
                });
              },
            ),
            Text(
              'Regular',
              style: buildTextStyle(),
            ),
            SizedBox(
              width: 2.w,
            ),
            Radio(
              value: "Irregular",
              activeColor: kPrimaryColor,
              groupValue: selectedValue15,
              onChanged: (value) {
                setState(() {
                  selectedValue15 = value as String;
                });
              },
            ),
            Text(
              'Irregular',
              style: buildTextStyle(),
            ),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'How Many Hours Of Sleep Do You Get In A Day (Average Over A Week)*',
          style: TextStyle(
            fontSize: 9.sp,
            color: kTextColor,
            fontFamily: "PoppinsSemiBold",
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Row(
          children: [
            Radio(
              value: "5 Or Less",
              activeColor: kPrimaryColor,
              groupValue: selectedValue16,
              onChanged: (value) {
                setState(() {
                  selectedValue16 = value as String;
                });
              },
            ),
            Text(
              '5 Or Less',
              style: buildTextStyle(),
            ),
            SizedBox(
              width: 2.w,
            ),
            Radio(
              value: "6-8",
              activeColor: kPrimaryColor,
              groupValue: selectedValue16,
              onChanged: (value) {
                setState(() {
                  selectedValue16 = value as String;
                });
              },
            ),
            Text(
              '6-8',
              style: buildTextStyle(),
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }

  buildHealthCheckBox(CheckBoxSettings healthCheckBox, String from) {
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
          if (from == 'health1') {
            if (healthCheckBox.title == healthCheckBox1[13].title)
            {
              print("if");
              setState(() {
                selectedHealthCheckBox1.clear();
                healthCheckBox1.forEach((element) {
                  element.value = false;
                });
                selectedHealthCheckBox1.add(healthCheckBox.title!);
                healthCheckBox.value = v;
              });
            }
            else if (healthCheckBox.title == healthCheckBox1[12].title) {
              print(" else if");
              setState(() {
                selectedHealthCheckBox1.clear();
                healthCheckBox1.forEach((element) {
                  element.value = false;
                });
                selectedHealthCheckBox1.add(healthCheckBox.title!);
                healthCheckBox.value = v;
              });
            }
            else {
              print("else");
              if (selectedHealthCheckBox1
                  .contains(healthCheckBox1[13].title)) {
                print("if");
                setState(() {
                  selectedHealthCheckBox1.clear();
                  healthCheckBox1[13].value = false;
                });
              } else if (selectedHealthCheckBox1
                  .contains(healthCheckBox1[12].title)) {
                print("else if");

                setState(() {
                  selectedHealthCheckBox1.clear();
                  healthCheckBox1[12].value = false;
                });
              }
              if (v == true) {
                setState(() {
                  selectedHealthCheckBox1.add(healthCheckBox.title!);
                  healthCheckBox.value = v;
                });
              } else {
                setState(() {
                  selectedHealthCheckBox1.remove(healthCheckBox.title!);
                  healthCheckBox.value = v;
                });
              }
            }
            print(selectedHealthCheckBox1);
          }
          else if (from == 'health2') {
            if (healthCheckBox.title == healthCheckBox2.last.title) {
              print("if");
              setState(() {
                selectedHealthCheckBox2.clear();
                healthCheckBox2.forEach((element) {
                  if (element != healthCheckBox2.last.title) {
                    element.value = false;
                  }
                });
                if (v == true) {
                  selectedHealthCheckBox2.add(healthCheckBox.title!);
                  healthCheckBox.value = v;
                } else {
                  selectedHealthCheckBox2.remove(healthCheckBox.title!);
                  healthCheckBox.value = v;
                }
              });
            } else {
              // print("else");
              if (v == true) {
                // print("if");
                setState(() {
                  if (selectedHealthCheckBox2
                      .contains(healthCheckBox2.last.title)) {
                    // print("if");
                    selectedHealthCheckBox2.removeWhere(
                            (element) => element == healthCheckBox2.last.title);
                    healthCheckBox2.forEach((element) {
                      if (element.title == healthCheckBox2.last.title) {
                        element.value = false;
                      }
                    });
                  }
                  selectedHealthCheckBox2.add(healthCheckBox.title!);
                  healthCheckBox.value = v;
                });
              } else {
                setState(() {
                  selectedHealthCheckBox2.remove(healthCheckBox.title!);
                  healthCheckBox.value = v;
                });
              }
            }
            print(selectedHealthCheckBox2);
          }
          else if (from == 'smell') {
            if (urinSmellOtherSelected) {
              if (v == true) {
                setState(() {
                  urinSmellOtherSelected = false;
                  selectedUrinSmellList.clear();
                  selectedUrinSmellList.add(healthCheckBox.title);
                  healthCheckBox.value = v;
                });
              }
            }
            else {
              if (v == true) {
                setState(() {
                  selectedUrinSmellList.add(healthCheckBox.title);
                  healthCheckBox.value = v;
                });
              }
              else {
                setState(() {
                  selectedUrinSmellList.remove(healthCheckBox.title);
                  healthCheckBox.value = v;
                });
              }
            }
            print(selectedUrinSmellList);
          }
          else if (from == 'interventions') {
            if (medicalInterventionsOtherSelected) {
              if (v == true) {
                setState(() {
                  medicalInterventionsOtherSelected = false;
                  selectedmedicalInterventionsDoneBeforeList.clear();
                  selectedmedicalInterventionsDoneBeforeList
                      .add(healthCheckBox.title);
                  healthCheckBox.value = v;
                });
              }
            } else {
              if (v == true) {
                setState(() {
                  selectedmedicalInterventionsDoneBeforeList
                      .add(healthCheckBox.title);
                  healthCheckBox.value = v;
                });
              } else {
                setState(() {
                  selectedmedicalInterventionsDoneBeforeList
                      .remove(healthCheckBox.title);
                  healthCheckBox.value = v;
                });
              }
            }
            print(selectedmedicalInterventionsDoneBeforeList);
          }

          // print("${healthCheckBox.title}=> ${healthCheckBox.value}");
        },
      ),
    );
    // return ListTile(
    //   onTap: (){
    //     print(healthCheckBox.value);
    //     print(healthCheckBox.title);
    //
    //   },
    //   minLeadingWidth: 30,
    //   horizontalTitleGap: 3,
    //   dense: true,
    //   leading: SizedBox(
    //     width: 20,
    //     child: Checkbox(
    //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //       activeColor: kPrimaryColor,
    //       value: healthCheckBox.value,
    //       onChanged: (v) {
    //         if (from == 'health1') {
    //           if (healthCheckBox.title == healthCheckBox1[13].title)
    //           {
    //             print("if");
    //             setState(() {
    //               selectedHealthCheckBox1.clear();
    //               healthCheckBox1.forEach((element) {
    //                 element.value = false;
    //               });
    //               selectedHealthCheckBox1.add(healthCheckBox.title!);
    //               healthCheckBox.value = v;
    //             });
    //           } else if (healthCheckBox.title == healthCheckBox1[12].title) {
    //             print(" else if");
    //             setState(() {
    //               selectedHealthCheckBox1.clear();
    //               healthCheckBox1.forEach((element) {
    //                 element.value = false;
    //               });
    //               selectedHealthCheckBox1.add(healthCheckBox.title!);
    //               healthCheckBox.value = v;
    //             });
    //           } else {
    //             print("else");
    //             if (selectedHealthCheckBox1
    //                 .contains(healthCheckBox1[13].title)) {
    //               print("if");
    //               setState(() {
    //                 selectedHealthCheckBox1.clear();
    //                 healthCheckBox1[13].value = false;
    //               });
    //             } else if (selectedHealthCheckBox1
    //                 .contains(healthCheckBox1[12].title)) {
    //               print("else if");
    //
    //               setState(() {
    //                 selectedHealthCheckBox1.clear();
    //                 healthCheckBox1[12].value = false;
    //               });
    //             }
    //             if (v == true) {
    //               setState(() {
    //                 selectedHealthCheckBox1.add(healthCheckBox.title!);
    //                 healthCheckBox.value = v;
    //               });
    //             } else {
    //               setState(() {
    //                 selectedHealthCheckBox1.remove(healthCheckBox.title!);
    //                 healthCheckBox.value = v;
    //               });
    //             }
    //           }
    //           print(selectedHealthCheckBox1);
    //         }
    //         else if (from == 'health2') {
    //           if (healthCheckBox.title == healthCheckBox2.last.title) {
    //             print("if");
    //             setState(() {
    //               selectedHealthCheckBox2.clear();
    //               healthCheckBox2.forEach((element) {
    //                 if (element != healthCheckBox2.last.title) {
    //                   element.value = false;
    //                 }
    //               });
    //               if (v == true) {
    //                 selectedHealthCheckBox2.add(healthCheckBox.title!);
    //                 healthCheckBox.value = v;
    //               } else {
    //                 selectedHealthCheckBox2.remove(healthCheckBox.title!);
    //                 healthCheckBox.value = v;
    //               }
    //             });
    //           } else {
    //             // print("else");
    //             if (v == true) {
    //               // print("if");
    //               setState(() {
    //                 if (selectedHealthCheckBox2
    //                     .contains(healthCheckBox2.last.title)) {
    //                   // print("if");
    //                   selectedHealthCheckBox2.removeWhere(
    //                       (element) => element == healthCheckBox2.last.title);
    //                   healthCheckBox2.forEach((element) {
    //                     if (element.title == healthCheckBox2.last.title) {
    //                       element.value = false;
    //                     }
    //                   });
    //                 }
    //                 selectedHealthCheckBox2.add(healthCheckBox.title!);
    //                 healthCheckBox.value = v;
    //               });
    //             } else {
    //               setState(() {
    //                 selectedHealthCheckBox2.remove(healthCheckBox.title!);
    //                 healthCheckBox.value = v;
    //               });
    //             }
    //           }
    //           print(selectedHealthCheckBox2);
    //         }
    //         else if (from == 'smell') {
    //           if (urinSmellOtherSelected) {
    //             if (v == true) {
    //               setState(() {
    //                 urinSmellOtherSelected = false;
    //                 selectedUrinSmellList.clear();
    //                 selectedUrinSmellList.add(healthCheckBox.title);
    //                 healthCheckBox.value = v;
    //               });
    //             }
    //           } else {
    //             if (v == true) {
    //               setState(() {
    //                 selectedUrinSmellList.add(healthCheckBox.title);
    //                 healthCheckBox.value = v;
    //               });
    //             } else {
    //               setState(() {
    //                 selectedUrinSmellList.remove(healthCheckBox.title);
    //                 healthCheckBox.value = v;
    //               });
    //             }
    //           }
    //           print(selectedUrinSmellList);
    //         }
    //         else if (from == 'interventions') {
    //           if (medicalInterventionsOtherSelected) {
    //             if (v == true) {
    //               setState(() {
    //                 medicalInterventionsOtherSelected = false;
    //                 selectedmedicalInterventionsDoneBeforeList.clear();
    //                 selectedmedicalInterventionsDoneBeforeList
    //                     .add(healthCheckBox.title);
    //                 healthCheckBox.value = v;
    //               });
    //             }
    //           } else {
    //             if (v == true) {
    //               setState(() {
    //                 selectedmedicalInterventionsDoneBeforeList
    //                     .add(healthCheckBox.title);
    //                 healthCheckBox.value = v;
    //               });
    //             } else {
    //               setState(() {
    //                 selectedmedicalInterventionsDoneBeforeList
    //                     .remove(healthCheckBox.title);
    //                 healthCheckBox.value = v;
    //               });
    //             }
    //           }
    //           print(selectedmedicalInterventionsDoneBeforeList);
    //         }
    //
    //         // print("${healthCheckBox.title}=> ${healthCheckBox.value}");
    //       },
    //     ),
    //   ),
    //   title: Text(
    //     healthCheckBox.title.toString(),
    //     style: buildTextStyle(),
    //   ),
    // );
  }

  buildWrapingCheckBox(CheckBoxSettings healthCheckBox) {
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
          const SizedBox(
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

  buildFoodCheckBox(CheckBoxSettings foodCheckBox) {
    return ListTile(
      leading: Checkbox(
        activeColor: kPrimaryColor,
        value: foodCheckBox.value,
        onChanged: (v) {
          setState(() {
            foodCheckBox.value = v;
          });
        },
      ),
      title: Text(
        foodCheckBox.title.toString(),
        style: buildTextStyle(),
      ),
    );
  }

  buildSleepCheckBox(CheckBoxSettings sleepCheckBox) {
    return ListTile(
      leading: Checkbox(
        activeColor: kPrimaryColor,
        value: sleepCheckBox.value,
        onChanged: (v) {
          setState(() {
            sleepCheckBox.value = v;
          });
        },
      ),
      title: Text(
        sleepCheckBox.title.toString(),
        style: buildTextStyle(),
      ),
    );
  }

  buildLifeStyleCheckBox(CheckBoxSettings lifeStyleCheckBox) {
    return ListTile(
      leading: Checkbox(
        activeColor: kPrimaryColor,
        value: lifeStyleCheckBox.value,
        onChanged: (v) {
          setState(() {
            lifeStyleCheckBox.value = v;
          });
        },
      ),
      title: Text(
        lifeStyleCheckBox.title.toString(),
        style: buildTextStyle(),
      ),
    );
  }

  buildGutTypeCheckBox(CheckBoxSettings gutTypeCheckBox) {
    return ListTile(
      leading: Checkbox(
        activeColor: kPrimaryColor,
        value: gutTypeCheckBox.value,
        onChanged: (v) {
          setState(() {
            gutTypeCheckBox.value = v;
          });
        },
      ),
      title: Text(
        gutTypeCheckBox.title.toString(),
        style: buildTextStyle(),
      ),
    );
  }

  buildLabelTextField(String name) {
    return RichText(
        text: TextSpan(
            text: name,
            style: TextStyle(
              fontSize: 9.sp,
              color: gPrimaryColor,
              fontFamily: "PoppinsSemiBold",
            ),
            children: [
          TextSpan(
            text: ' *',
            style: TextStyle(
              fontSize: 9.sp,
              color: kPrimaryColor,
              fontFamily: "PoppinsSemiBold",
            ),
          )
        ]));
    return Text(
      'Full Name:*',
      style: TextStyle(
        fontSize: 9.sp,
        color: kTextColor,
        fontFamily: "PoppinsSemiBold",
      ),
    );
  }

  bool validEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool isPhone(String input) =>
      RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(input);

  void addSelectedValuesToList() {
    addHealthCheck1();
    addHealthCheck2();
    addUrinFrequencyDetails();
    addUrinColorDetails();
    addUrinSmelldetails();
    addUrinLooksDetails();
    addMedicalInterventionsDetails();
  }

  void addHealthCheck1() {
    selectedHealthCheckBox1.clear();
    for (var element in healthCheckBox1) {
      if (element.value == true) {
        print(element.title);
        selectedHealthCheckBox1.add(element.title!);
      }
    }
  }

  void addHealthCheck2() {
    selectedHealthCheckBox2.clear();
    for (var element in healthCheckBox2) {
      if (element.value == true) {
        print(element.title);
        selectedHealthCheckBox2.add(element.title!);
      }
    }
  }

  void addUrinFrequencyDetails() {
    selectedUrinFrequencyList.clear();
    for (var element in urinFrequencyList) {
      if (element.value == true) {
        print(element.title);
        selectedUrinFrequencyList.add(element.title!);
      }
    }
  }

  void addUrinColorDetails() {
    selectedUrinColorList.clear();
    if (urinColorList.any((element) => element.value == true) ||
        urinColorOtherSelected) {
      for (var element in urinColorList) {
        if (element.value == true) {
          print(element.title);
          selectedUrinColorList.add(element.title!);
        }
      }
      if (urinColorOtherSelected) {
        selectedUrinColorList.add(otherText);
      }
    }
  }

  void addUrinSmelldetails() {
    selectedUrinSmellList.clear();
    if (urinSmellList.any((element) => element.value == true) ||
        urinSmellOtherSelected) {
      for (var element in urinSmellList) {
        if (element.value == true) {
          print(element.title);
          selectedUrinSmellList.add(element.title!);
        }
      }
      if (urinSmellOtherSelected) {
        selectedUrinSmellList.add(otherText);
      }
    }
  }

  void addUrinLooksDetails() {
    selectedUrinLooksList.clear();
    if (urinLooksList.any((element) => element.value == true) ||
        urinLooksLikeOtherSelected) {
      for (var element in urinLooksList) {
        if (element.value == true) {
          print(element.title);
          selectedUrinLooksList.add(element.title!);
        }
      }
      if (urinLooksLikeOtherSelected) {
        selectedUrinLooksList.add(otherText);
      }
    }
  }

  void addMedicalInterventionsDetails() {
    selectedmedicalInterventionsDoneBeforeList.clear();
    if (medicalInterventionsDoneBeforeList
            .any((element) => element.value == true) ||
        medicalInterventionsOtherSelected) {
      for (var element in medicalInterventionsDoneBeforeList) {
        if (element.value == true) {
          print(element.title);
          selectedmedicalInterventionsDoneBeforeList.add(element.title!);
        }
      }
      if (medicalInterventionsOtherSelected) {
        selectedmedicalInterventionsDoneBeforeList.add(otherText);
      }
    }
  }

  final EvaluationFormRepository repository = EvaluationFormRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void storeDetails(ChildGetEvaluationDataModel model) {
    print('storing');
    print('model.urineColorOther: ${model.urineColorOther}');

    fnameController.text = model.patient?.user?.fname ?? '';
    lnameController.text = model.patient?.user?.lname ?? '';
    mobileController.text = model.patient?.user?.phone ?? '';
    maritalStatus = model.patient?.maritalStatus.toString().capitalize() ?? '';
    gender = model.patient?.user?.gender.toString().capitalize() ?? '';
    emailController.text = model.patient?.user?.email ?? '';
    print("age: ${model.patient?.user?.toJson()}");
    ageController.text = model.patient?.user?.age ?? '';
    address1Controller.text = model.patient?.user?.address ?? '';
    address2Controller.text = model.patient?.address2 ?? '';
    stateController.text = model.patient?.state ?? '';
    cityController.text = model.patient?.city ?? '';
    countryController.text = model.patient?.country ?? '';

    pinCodeController.text = model.patient?.user?.pincode ?? '';
    weightController.text = model.weight ?? '';
    heightText = model.height ?? '';
    if (heightText.isNotEmpty) {
      ft = int.tryParse(heightText.split(".").first) ?? -1;
      inches = int.tryParse(heightText.split(".").last) ?? -1;
    }
    healController.text = model.healthProblem ?? '';
    // print("model.listProblems:${jsonDecode(model.listProblems ?? '')}");
    selectedHealthCheckBox1
        .addAll(List.from(jsonDecode(model.listProblems ?? '')));
    // print("selectedHealthCheckBox1[0]:${(selectedHealthCheckBox1[0].split(',') as List).map((e) => e).toList()}");
    selectedHealthCheckBox1 = List.from(
        (selectedHealthCheckBox1[0].split(',') as List).map((e) => e).toList());
    healthCheckBox1.forEach((element) {
      print(
          'selectedHealthCheckBox1.any((element1) => element1 == element.title): ${selectedHealthCheckBox1.any((element1) => element1 == element.title)}');
      if (selectedHealthCheckBox1
          .any((element1) => element1 == element.title)) {
        element.value = true;
      }
    });

    // selectedHealthCheckBox1.forEach((e1) {
    //   healthCheckBox1.forEach((e2) {
    //     print('e1=>$e1 e2=>${e2.title}');
    //     print("e1 == e2.title:${e1 == e2.title}");
    //     if(e1 == e2.title){
    //       e2.value = true;
    //     }
    //   });
    // });
    checkbox1OtherController.text = model.listProblemsOther ?? '';
    selectedHealthCheckBox2
        .addAll(List.from(jsonDecode(model.listBodyIssues ?? '')));
    if (selectedHealthCheckBox2.first != null) {
      selectedHealthCheckBox2 = List.from(
          (selectedHealthCheckBox2.first.split(',') as List)
              .map((e) => e)
              .toList());
      healthCheckBox2.forEach((element) {
        // print('selectedHealthCheckBox2.any((element1) => element1 == element.title): ${selectedHealthCheckBox2.any((element1) => element1 == element.title)}');
        if (selectedHealthCheckBox2
            .any((element1) => element1 == element.title)) {
          element.value = true;
        }
      });
    }
    tongueCoatingRadio = model.tongueCoating ?? '';
    tongueCoatingController.text = model.tongueCoatingOther ?? '';

    selectedUrinFrequencyList
        .addAll(List.from(jsonDecode(model.anyUrinationIssue ?? '')));
    selectedUrinFrequencyList = List.from(
        (selectedUrinFrequencyList[0].split(',') as List)
            .map((e) => e)
            .toList());
    urinationValue = selectedUrinFrequencyList.first;
    // urinFrequencyList.forEach((element) {
    //   if(selectedUrinFrequencyList.any((element1) => element1 == element.title)){
    //     element.value = true;
    //   }
    // });

    selectedUrinColorList.addAll(List.from(jsonDecode(model.urineColor ?? '')));
    selectedUrinColorList = List.from(
        (selectedUrinColorList[0].split(',') as List).map((e) => e).toList());
    urineColorValue = selectedUrinColorList.first;
    urinColorController.text = model.urineColorOther ?? '';

    // urinColorList.forEach((element) {
    //   if(selectedUrinColorList.any((element1) => element1 == element.title)){
    //     element.value = true;
    //   }
    // });

    selectedUrinSmellList.addAll(List.from(jsonDecode(model.urineSmell ?? '')));
    selectedUrinSmellList = List.from(
        (selectedUrinSmellList[0].split(',') as List).map((e) => e).toList());
    urinSmellList.forEach((element) {
      print(selectedUrinSmellList);
      print(
          'urinSmellList.any((element1) => element1 == element.title): ${selectedUrinSmellList.any((element1) => element1 == element.title)}');
      if (selectedUrinSmellList.any((element1) => element1 == element.title)) {
        element.value = true;
      }
      if (selectedUrinSmellList.any((element) => element == otherText)) {
        urinSmellOtherSelected = true;
      }
    });
    urinSmellController.text = model.urineSmellOther ?? '';

    selectedUrinLooksList
        .addAll(List.from(jsonDecode(model.urineLookLike ?? '')));
    selectedUrinLooksList = List.from(
        (selectedUrinLooksList[0].split(',') as List).map((e) => e).toList());
    urineLookLikeValue = selectedUrinLooksList.first;
    // urinLooksList.forEach((element) {
    //   if(selectedUrinLooksList.any((element1) => element1 == element.title)){
    //     element.value = true;
    //   }
    //   if(selectedUrinLooksList.any((element) => element == otherText)){
    //     urinLooksLikeOtherSelected = true;
    //   }
    // });
    urinLooksLikeController.text = model.urineLookLikeOther ?? '';
    selectedStoolMatch = model.closestStoolType ?? '';

    selectedmedicalInterventionsDoneBeforeList.addAll(
        List.from(jsonDecode(model.anyMedicalIntervationDoneBefore ?? '')));
    selectedmedicalInterventionsDoneBeforeList = List.from(
        (selectedmedicalInterventionsDoneBeforeList[0].split(',') as List)
            .map((e) => e)
            .toList());
    medicalInterventionsDoneBeforeList.forEach((element) {
      print(selectedmedicalInterventionsDoneBeforeList);
      print(element.title);
      print(
          'medicalInterventionsDoneBeforeList.any((element1) => element1 == element.title): ${selectedmedicalInterventionsDoneBeforeList.any((element1) => element1 == element.title)}');
      if (selectedmedicalInterventionsDoneBeforeList
          .any((element1) => element1 == element.title)) {
        element.value = true;
      }
      if (selectedmedicalInterventionsDoneBeforeList
          .any((element) => element == otherText)) {
        medicalInterventionsOtherSelected = true;
      }
    });
    print(model.anyMedicalIntervationDoneBeforeOther);
    medicalInterventionsDoneController.text =
        model.anyMedicalIntervationDoneBeforeOther ?? '';
    medicationsController.text = model.anyMedicationConsumeAtMoment ?? '';
    holisticController.text = model.anyTherapiesHaveDoneBefore ?? '';
    print(
        "model.medicalReport.runtimeType: ${model.medicalReport!.split(',')}");
    List list = jsonDecode(model.medicalReport ?? '');
    print("report list: $list ${list.length}");

    showMedicalReport.clear();
    if (list.isNotEmpty) {
      list.forEach((element) {
        print(element);
        showMedicalReport.add(element.toString());
      });
    }
  }

  showFiles() {
    print(showMedicalReport.runtimeType);
    showMedicalReport.forEach((e) {
      print("e==> $e ${e.runtimeType}");
    });
    final widgetList = showMedicalReport
        .map<Widget>((element) => buildRecordList(element))
        .toList();
    return SizedBox(
      width: double.maxFinite,
      child: ListView(
        shrinkWrap: true,
        children: widgetList,
      ),
    );
  }

  buildRecordList(String filename, {int? index}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: OutlinedButton(
        onPressed: () {},
        style: ButtonStyle(
          overlayColor: getColor(Colors.white, const Color(0xffCBFE86)),
          backgroundColor: getColor(Colors.white, const Color(0xffCBFE86)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                filename.split("/").last,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "PoppinsBold",
                  fontSize: 11.sp,
                ),
              ),
            ),
            (widget.showData)
                ? SvgPicture.asset(
                    'assets/images/attach_icon.svg',
                    fit: BoxFit.cover,
                  )
                : GestureDetector(
                    onTap: () {
                      medicalRecords.removeAt(index!);
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.delete_outline_outlined,
                      color: gMainColor,
                    )),
          ],
        ),
      ),
    );
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    // ignore: prefer_function_declarations_over_variables
    final getColor = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };
    return MaterialStateProperty.resolveWith(getColor);
  }

  TextEditingController editingController = TextEditingController();
  bool isLoading = false;

  List<String> newDataList = [];

  bool showLoading = false;

  void fetchCountry(String pinCode, String countryCode) async {
    Navigator.of(context).push(
      PageRouteBuilder(
          opaque: false, // set to false
          pageBuilder: (_, __, ___) => Container(
                child: buildCircularIndicator(),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                  ],
                ),
              )),
    );

    final res = await EvaluationFormService(repository: repository)
        .getCountryDetailsService(pinCode, countryCode);
    print(res);
    if (res.runtimeType == GetCountryDetailsModel) {
      GetCountryDetailsModel model = res as GetCountryDetailsModel;
      if (model.postOffice!.isNotEmpty) {
        print(model.postOffice?.first.state);
        setState(() {
          stateController.text = model.postOffice?.first.state ?? '';
          cityController.text = model.postOffice?.first.district ?? '';
          countryController.text = model.postOffice?.first.country ?? '';
        });
      }
    } else {
      ErrorModel model = res as ErrorModel;
      print(model.message!);
      setState(() {
        _ignoreFields = false;
      });
      AppConfig()
          .showSnackbar(context, "Please Enter Valid Pincode", isError: true);
    }
    Navigator.pop(context);
  }

  Widget buildTabView(
      {required int index,
      required String title,
      required Color color,
      int? itemId}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          heightText = title;
        });
        // onChangedTab(index, id: itemId, title: title);
        Get.back();
      },
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "GothamBook",
          color: gTextColor,
          // color: (statusList[itemId] == title) ? color : gTextColor,
          fontSize: 8.sp,
        ),
      ),
    );
  }

  getProfileData() async {
    Navigator.of(context).push(
      PageRouteBuilder(
          opaque: false, // set to false
          pageBuilder: (_, __, ___) => Container(
                child: buildCircularIndicator(),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                  ],
                ),
              )),
    );
    final res = await UserProfileService(repository: userRepository)
        .getUserProfileService();
    if (res.runtimeType == UserProfileModel) {
      UserProfileModel data = res as UserProfileModel;
      fnameController.text = data.data?.fname ?? '';
      lnameController.text = data.data?.lname ?? '';
      ageController.text = data.data?.age ?? '';
      emailController.text = data.data?.email ?? '';
      mobileController.text = data.data?.phone ?? '';
      gender = (data.data!.gender != null)
          ? data.data!.gender.toString().capitalize()
          : '';
      print(gender);
      print(data.data!.gender.toString());
      setState(() {});
    }
    Navigator.pop(context);
  }

  final UserProfileRepository userRepository = UserProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  buildUrineColorRadioButton() {
    return Column(
      children: [
        Row(
          children: [
            Radio(
              value: "Clear",
              activeColor: kPrimaryColor,
              groupValue: urineColorValue,
              onChanged: (value) {
                setState(() {
                  urineColorValue = value as String;
                });
              },
            ),
            Text('Clear', style: buildTextStyle()),
            SizedBox(
              width: 3.w,
            ),
            Radio(
              value: "Pale Yello",
              activeColor: kPrimaryColor,
              groupValue: urineColorValue,
              onChanged: (value) {
                setState(() {
                  urineColorValue = value as String;
                });
              },
            ),
            Text(
              'Pale Yello',
              style: buildTextStyle(),
            ),
            SizedBox(
              width: 3.w,
            ),
            Radio(
                value: "Red",
                groupValue: urineColorValue,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    urineColorValue = value as String;
                  });
                }),
            Text(
              "Red",
              style: buildTextStyle(),
            ),
          ],
        ),
        Row(
          children: [
            Radio(
              value: "Black",
              activeColor: kPrimaryColor,
              groupValue: urineColorValue,
              onChanged: (value) {
                setState(() {
                  urineColorValue = value as String;
                });
              },
            ),
            Text('Black', style: buildTextStyle()),
            SizedBox(
              width: 3.w,
            ),
            Radio(
              value: "Yellow",
              activeColor: kPrimaryColor,
              groupValue: urineColorValue,
              onChanged: (value) {
                setState(() {
                  urineColorValue = value as String;
                });
              },
            ),
            Text(
              'Yellow',
              style: buildTextStyle(),
            ),
            SizedBox(
              width: 3.w,
            ),
            Radio(
                value: "Other",
                groupValue: urineColorValue,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    urineColorValue = value as String;
                  });
                }),
            Text(
              "Other",
              style: buildTextStyle(),
            ),
          ],
        ),
      ],
    );
  }

  buildUrineLookRadioButton() {
    return Column(
      children: [
        Row(
          children: [
            Radio(
                value: "Clear/Transparent",
                groupValue: urineLookLikeValue,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    urineLookLikeValue = value as String;
                  });
                }),
            Text(
              "Clear/Transparent",
              style: buildTextStyle(),
            ),
          ],
        ),
        Row(
          children: [
            Radio(
                value: "Foggy/cloudy",
                groupValue: urineLookLikeValue,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    urineLookLikeValue = value as String;
                  });
                }),
            Text(
              "Foggy/cloudy",
              style: buildTextStyle(),
            ),
          ],
        ),
        Row(
          children: [
            Radio(
                value: "Other",
                groupValue: urineLookLikeValue,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    urineLookLikeValue = value as String;
                  });
                }),
            Text(
              "Other",
              style: buildTextStyle(),
            ),
          ],
        ),
      ],
    );
  }
}

/*
variables:
 List<Countries> _countryModel = [];
  List<String> countryList = [];
  List<String> stateList = [];
   String countryValue = "";
  String stateValue = "";
  String cityValue = "";

initstate:
      CountryModel res = CountryModel.fromJson(countries);
    res.countries!.forEach((element) {
      _countryModel.add(element);
      countryList.add(element.country.toString());
    });
    print('countryList: $countryList');

 UI:
   stateDropdown(){
    return GestureDetector(
      onTap: (){
        // openAlertBox();
        editingController.clear();
        newDataList.clear();
        newDataList.addAll(countryList);
        _showCountriesDialog();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(
                color: gGreyColor.withOpacity(0.5),
                width: 1.0,
                style: BorderStyle.solid
            ),)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              countryValue.isEmpty ? 'Select Country' : countryValue,
              style: TextStyle(
                fontFamily: "PoppinsRegular",
                color: gBlackColor,
                fontSize: 10.sp,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_outlined)
          ],
        ),
      ),
    );
  }
  countryDropdown(){
    return GestureDetector(
      onTap: countryValue.isEmpty ? null : (){
        editingController.clear();
        newDataList.clear();
        stateList.clear();
        _countryModel.forEach((element) {
          if(element.country == countryValue){
            stateList.addAll(element.states!);
          }
        });
        newDataList.addAll(stateList);
        _showStatesDialog();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(
                color: gGreyColor.withOpacity(0.5),
                width: 1.0, style: BorderStyle.solid),)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              countryValue.isEmpty ? 'Select Country First' : stateValue.isEmpty ? 'Select State' : stateValue,
              style: TextStyle(
                fontFamily: "PoppinsRegular",
                color: gBlackColor,
                fontSize: 10.sp,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_outlined)
          ],
        ),
      ),
    );
  }


   void _showCountriesDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState)
              {
                return AlertDialog(
                  title: Text('Select Country'),
                  content: Container(
                      width: double.minPositive,
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                isLoading = true;
                                filterSearchResults(value);
                              });
                            },
                            controller: editingController,
                            decoration: InputDecoration(
                                contentPadding:
                                EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                labelText: "Search",
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)))),
                          ),
                          Expanded(
                            child: !isLoading ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: newDataList == null ? 0 : newDataList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  dense: true,
                                  // visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                  minVerticalPadding: 0,
                                  title: Text(newDataList[index]),
                                  onTap: () => onSelectedValue(index),
                                );
                              },
                            ) : Text("No records found"),
                          ),
                        ],
                      )),
                );
              });
        });
  }

  void _showStatesDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState)
              {
                return AlertDialog(
                  title: Text('Select State'),
                  content: Container(
                      width: double.minPositive,
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                isLoading = true;
                                filterSearchResults(value, isCountry: false);
                              });
                            },
                            controller: editingController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                labelText: "Search",
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)))),
                          ),
                          Expanded(
                            child: !isLoading ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: newDataList == null ? 0 : newDataList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  dense: true,
                                  // visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                  minVerticalPadding: 0,
                                  title: Text(newDataList[index]),
                                  onTap: () => onSelectedValue(index, isCountry: false),
                                );
                              },
                            ) : Text("No records found"),
                          ),
                        ],
                      )),
                );
              });
        });
  }



   onSelectedValue(int index, {bool isCountry = true})  {
    setState(() {
      print("Selected dialog value is....${newDataList[index]}");
      Navigator.pop(context, newDataList[index]);
      if(isCountry){
        countryValue = newDataList[index];
        stateValue = '';
      }
      else{
        stateValue = newDataList[index];
      }
    });
  }

  filter method:
    void filterSearchResults(String query, {bool isCountry = true}) {
    setState(() {
     if(isCountry){
       newDataList = countryList
           .where((string) => string.toLowerCase().contains(query.toLowerCase()))
           .toList();
     }
     else{
       newDataList = stateList
           .where((string) => string.toLowerCase().contains(query.toLowerCase()))
           .toList();
     }
      debugPrint("Checking Country Name ${newDataList.toString()}");
      isLoading = false;
    });
  }



 */
