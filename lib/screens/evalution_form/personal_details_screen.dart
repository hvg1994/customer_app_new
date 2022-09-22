import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gwc_customer/model/evaluation_from_models/get_evaluation_model/child_get_evaluation_data_model.dart';
import 'package:gwc_customer/repository/evaluation_form_repository/evanluation_form_repo.dart';
import 'package:gwc_customer/services/evaluation_fome_service/evaluation_form_service.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../utils/app_config.dart';
import '../../model/error_model.dart';
import '../../model/evaluation_from_models/evaluation_model_format1.dart';
import '../../model/evaluation_from_models/get_evaluation_model/get_evaluationdata_model.dart';
import '../../repository/api_service.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'check_box_settings.dart';
import 'personal_details_screen2.dart';
import 'package:gwc_customer/widgets/dart_extensions.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final bool showData;
  const PersonalDetailsScreen({Key? key, this.showData = false}) : super(key: key);

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  Future? _getEvaluationDataFuture;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
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
  TextEditingController medicalInterventionsDoneController = TextEditingController();
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

  final healthCheckBox1 = <CheckBoxSettings>[
    CheckBoxSettings(title: "Autoimmune Diseases"),
    CheckBoxSettings(title: "Endocrine Diseases (Thyroid/Diabetes/PCOS)"),
    CheckBoxSettings(title: "Heart Diseases (Palpitations/Low Blood Pressure/High Blood Pressure)"),
    CheckBoxSettings(title: "Renal/Kidney Diseases (Kidney Stones)"),
    CheckBoxSettings(title: "Liver Diseases (Cirrhosis/Fatty Liver/Hepatitis/Jaundice)"),
    CheckBoxSettings(title: "Neurological Diseases (Seizures/Fits/Convulsions/Headache/Migraine/Vertigo)"),
    CheckBoxSettings(title: "Digestive Diseases (Hernia/Hemorrhoids/Piles/Indigestion/Gall Stone/Pancreatitis/Irritable Bowel Syndrome)"),
    CheckBoxSettings(title: "Skin Diseases (Psoriasis/Acne/Eczema/Herpes,/Skin Allergies/Dandruff/Rashes)"),
    CheckBoxSettings(title: "Respiratory Diseases (Athama/Allergic bronchitis/Rhinitis/Sinusitis/Frequent Cold, Cough & Fever/Tonsillitis/Wheezing)"),
    CheckBoxSettings(title: "Reproductive Diseases (PCOD/Infertility/MenstrualDisorders/Heavy or Scanty Period Bleeding/Increased or Decreased Sexual Drive/Painful Periods /Irregular Cycles)"),
    CheckBoxSettings(title: "Skeletal Muscle Disorders (Muscular Dystrophy/Rheumatoid Arthritis/Arthritis/Spondylitis/Loss ofMuscle Mass)"),
    CheckBoxSettings(title: "Psychological/Psychiatric Issues (Depression,Anxiety, OCD, ADHD, Mood Disorders, Schizophrenia,Personality Disorders, Eating Disorders)"),
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
    CheckBoxSettings(title: "Cannot Start My Day Without A Hot Beverage Once I'm Up"),
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
    CheckBoxSettings(title: "Sour Regurgitation/ Food Regurgitation.(Food Coming back to your mouth)"),
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

  final urinFrequencyList = [
    CheckBoxSettings(title: "Increased"),
    CheckBoxSettings(title: "Decreased"),
    CheckBoxSettings(title: "No Change"),
  ];
  List selectedUrinFrequencyList = [];

  final urinColorList = [
    CheckBoxSettings(title: "Clear"),
    CheckBoxSettings(title: "Pale Yello"),
    CheckBoxSettings(title: "Red"),
    CheckBoxSettings(title: "Black"),
    CheckBoxSettings(title: "Yellow"),
  ];
  List selectedUrinColorList = [];
  bool urinColorOtherSelected = false;

  final urinSmellList = [
    CheckBoxSettings(title: "Normal urine odour"),
    CheckBoxSettings(title: "Fruity"),
    CheckBoxSettings(title: "Ammonia"),
  ];
  List selectedUrinSmellList = [];
  bool urinSmellOtherSelected = false;


  final urinLooksList = [
    CheckBoxSettings(title: "Clear/Transparent"),
    CheckBoxSettings(title: "Foggy/cloudy"),
  ];
  List selectedUrinLooksList = [];
  bool urinLooksLikeOtherSelected = false;


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
    if(widget.showData){
      _getEvaluationDataFuture = EvaluationFormService(repository: repository).getEvaluationDataService();
    }
  }

  @override
  void setState(fn) {
    if(mounted) super.setState(fn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(mounted) super.dispose();
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
          body: widget.showData
              ? FutureBuilder(
            future: _getEvaluationDataFuture,
              builder: (_, snapshot){
              if(snapshot.hasData){
                 print(snapshot.data);
                print(snapshot.data.runtimeType);
                if(snapshot.data.runtimeType == GetEvaluationDataModel){
                  GetEvaluationDataModel model = snapshot.data as GetEvaluationDataModel;
                  ChildGetEvaluationDataModel? model1 = model.data;
                  storeDetails(model1!);
                  return showUI(context, model: model1);
                }
                else{
                  ErrorModel model = snapshot.data as ErrorModel;
                  print(model.message);
                }
              }
              else if(snapshot.hasError){
                print("snapshot.error: ${snapshot.error}");
              }
                return buildCircularIndicator();
              }
          )
              : showUI(context),
        ),
      ),
    );
  }

  showUI(BuildContext context, {ChildGetEvaluationDataModel? model}){
    return Column(
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
                  buildPersonalDetails(),
                  buildHealthDetails(),
                  // buildFoodHabitsDetails(),
                  // buildSleepDetails(),
                  // buildLifeStyleDetails(),
                  // buildGutTypeDetails(),
                  Center(
                    child: CommonButton.sendButton(() {
                      if(widget.showData){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => PersonalDetailsScreen2(showData: true, childGetEvaluationDataModel: model,)));
                      }
                      else{
                        checkFields(context);
                      }
                    }, "Next"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
            buildLabelTextField("Full Name:"),
            SizedBox(
              height: 1.h,
            ),
            TextFormField(
              controller: nameController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                  return 'Please enter your Name';
                } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                  return 'Please enter your valid Name';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", nameController),
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
                }  else if (!isPhone(value)){
                  return 'Please enter valid Mobile Number';
                }
                else {
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
              maxLength: 3,
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
            buildLabelTextField('Full Postal Address To Deliver Your Ready To Cook Kit'),
            SizedBox(
              height: 1.h,
            ),
            TextFormField(
              controller: addressController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                  return 'Please enter your Address';
                } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
                  return 'Please enter your valid Address';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", addressController),
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
            TextFormField(
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
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", pinCodeController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
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
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your Weight';
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
            TextFormField(
              controller: heightController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty ) {
                  return 'Please enter your Height';
                }  else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", heightController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField('Brief Paragraph About Your Current Complaints Are & What You Are Looking To Heal Here'),
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
                ...healthCheckBox1.map(buildHealthCheckBox).toList(),
                TextFormField(
                  controller: checkbox1OtherController,
                  cursorColor: kPrimaryColor,
                  validator: (value) {
                    if (value!.isEmpty && selectedHealthCheckBox1.any((element) => element.contains("Other:"))) {
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
                ...healthCheckBox2.map(buildHealthCheckBox).toList(),
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
                    if (value!.isEmpty && tongueCoatingRadio.toLowerCase().contains("other")) {
                      return 'Please enter the tongue coating details';
                    }
                    else {
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
            buildLabelTextField("Has Frequency Of Urination Increased Or Decreased In The Recent Past"),
            SizedBox(
              height: 1.h,
            ),
            Wrap(
              // mainAxisSize: MainAxisSize.min,
              children: [
                ...urinFrequencyList.map(buildWrapingCheckBox).toList()
              ],
            ),
            buildLabelTextField("Urin Color"),
            SizedBox(
              height: 1.h,
            ),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Wrap(
                  children: [
                    ...urinColorList.map(buildWrapingCheckBox).toList(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                        child: Checkbox(
                          activeColor: kPrimaryColor,
                          value: urinColorOtherSelected,
                          onChanged: (v) {
                            setState(() {
                              urinColorOtherSelected = v!;
                              if(urinColorOtherSelected){
                                selectedUrinColorList.add(otherText);
                              }
                              else{
                                selectedUrinColorList.remove(otherText);
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Other:',
                        style: buildTextStyle(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    controller: urinColorController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty && urinColorOtherSelected) {
                        return 'Please enter the details about Urin Color';
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
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("Urin Smell"),
            SizedBox(
              height: 1.h,
            ),
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Wrap(
                  children: [
                    ...urinSmellList.map(buildHealthCheckBox).toList(),
                  ],
                ),
                ListTile(
                  minLeadingWidth: 0,
                  leading: SizedBox(
                    width: 20,
                    child: Checkbox(
                      activeColor: kPrimaryColor,
                      value: urinSmellOtherSelected,
                      onChanged: (v) {
                        setState(() {
                          urinSmellOtherSelected = v!;
                          if(urinSmellOtherSelected){
                            selectedUrinSmellList.add(otherText);
                          }
                          else{
                            selectedUrinSmellList.remove(otherText);
                          }
                        });
                      },
                    ),
                  ),
                  title: Text(
                    'Other:',
                    style: buildTextStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    controller: urinSmellController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty && urinSmellOtherSelected) {
                        return 'Please enter the details about urin smell';
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
            ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Wrap(
                  children: [
                    ...urinLooksList.map(buildHealthCheckBox).toList(),
                  ],
                ),
                ListTile(
                  minLeadingWidth: 0,
                  leading: SizedBox(
                    width: 20,
                    child: Checkbox(
                      activeColor: kPrimaryColor,
                      value: urinLooksLikeOtherSelected,
                      onChanged: (v) {
                        setState(() {
                          urinLooksLikeOtherSelected = v!;
                          if(urinLooksLikeOtherSelected){
                            selectedUrinLooksList.add(otherText);
                          }
                          else{
                            selectedUrinLooksList.remove(otherText);
                          }
                        });
                      },
                    ),
                  ),
                  title: Text(
                    'Other:',
                    style: buildTextStyle(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextFormField(
                    controller: urinLooksLikeController,
                    cursorColor: kPrimaryColor,
                    validator: (value) {
                      if (value!.isEmpty && urinLooksLikeOtherSelected) {
                        return 'Please enter how Urin Looks';
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
              ],
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
                  child: Image(
                    image: AssetImage("assets/images/stool_image.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Column(
                  children: [
                    Row (
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
                    ...medicalInterventionsDoneBeforeList.map(buildHealthCheckBox).toList(),
                  ],
                ),
                ListTile(
                  minLeadingWidth: 0,
                  leading: SizedBox(
                    width: 20,
                    child: Checkbox(
                      activeColor: kPrimaryColor,
                      value: medicalInterventionsOtherSelected,
                      onChanged: (v) {
                        setState(() {
                          medicalInterventionsOtherSelected = v!;
                          if(medicalInterventionsOtherSelected){
                            selectedmedicalInterventionsDoneBeforeList.add(otherText);
                          }
                          else{
                            selectedmedicalInterventionsDoneBeforeList.remove(otherText);
                          }
                        });
                      },
                    ),
                  ),
                  title: Text(
                    'Other:',
                    style: buildTextStyle(),
                  ),
                ),
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
            buildLabelTextField('Any Medications/Supplements/Inhalers/Contraceptives You Consume At The Moment'),
            TextFormField(
              controller: medicationsController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please mention Any Medications Taken before';
                } else if (value.length < 2) {
                  return emptyStringMsg;
                }else {
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
            buildLabelTextField('Holistic/Alternative Therapies You Have Been Through & When (Ayurveda, Homeopathy) '),
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
                }else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", holisticController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 2.h,
            ),
            buildLabelTextField("Please Upload Any & All Medical Records That Might Be Helpful To Evaluate Your Condition Better"),
            SizedBox(
              height: 1.h,
            ),
            GestureDetector(
              onTap: ()async{
                final result = await FilePicker.platform
                    .pickFiles(
                    withReadStream: true,
                    allowMultiple: false
                );

                if (result == null) return;
                if(result.files.first.extension!.contains("pdf") || result.files.first.extension!.contains("png") || result.files.first.extension!.contains("jpg")){
                  medicalRecords.add(result.files.first);
                }
                else{
                  AppConfig().showSnackbar(context, "Please select png/jpg/Pdf files", isError: true);
                }
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: gMainColor,
                    width: 1
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.file_upload_outlined,
                      color: gMainColor,
                    ),
                    const SizedBox(width: 4,),
                    Text('Add File',
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
  checkFields(BuildContext context){
    print(formKey1.currentState!.validate());
    if(formKey1.currentState!.validate() && formKey2.currentState!.validate()){
      if(medicalRecords.isEmpty){
        AppConfig().showSnackbar(context, "Please Upload Medical Records");
      }
      else{
        addSelectedValuesToList();
        var eval1 = createFormMap();
        print((eval1 as EvaluationModelFormat1).toMap());
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => PersonalDetailsScreen2(evaluationModelFormat1: eval1,medicalReportList: medicalRecords.map((e) => e.path).toList())));
      }
    }

  }
  createFormMap(){
    return EvaluationModelFormat1(
        name: nameController.text,
      maritalStatus: maritalStatus,
      phone: mobileController.text,
      email: emailController.text,
      age: ageController.text,
      gender: gender,
      address: addressController.text,
      pincode: pinCodeController.text,
      weight: weightController.text,
      height: heightController.text,
      looking_to_heal: healController.text,
      checkList1: selectedHealthCheckBox1.join(','),
      checkList1Other: checkbox1OtherController.text,
      checkList2: selectedHealthCheckBox2.join(','),
      tongueCoating: tongueCoatingRadio,
      tongueCoating_other: (tongueCoatingRadio.toLowerCase().contains("other")) ? tongueCoatingController.text : '',
      urinationIssue:selectedUrinFrequencyList.join(','),
      urinColor: selectedUrinColorList.join(','),
      urinColor_other: urinColorOtherSelected ? urinColorController.text : '',
      urinSmell: selectedUrinSmellList.join(','),
      urinSmell_other: urinSmellOtherSelected ? urinSmellController.text : '',
      urinLooksLike: selectedUrinLooksList.join(','),
      urinLooksLike_other: urinLooksLikeOtherSelected ? urinLooksLikeController.text : '',
      stoolDetails: selectedStoolMatch,
      medical_interventions: selectedmedicalInterventionsDoneBeforeList.join(','),
      medical_interventions_other: medicalInterventionsOtherSelected ? medicalInterventionsDoneController.text : '',
      medication: medicationsController.text,
      holistic: holisticController.text,
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

  buildLifeStyleDetails() {
    return Column(
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
        SizedBox(
          height: 3.h,
        ),
        Text(
          'Your Thoughts*',
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
                    value:
                        "My Past,Future & External Environment Affects Me At Time But I Bounce Back Quick & Don't Brood",
                    groupValue: selectedValue17,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue17 = value as String;
                      });
                    }),
                Text(
                  "My Past,Future & External Environment Affects Me \nAt Time But I Bounce Back Quick & Don't Brood",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value:
                        "Spend A Lot Of Time Thinking About My Past,Future & External Evnironment",
                    groupValue: selectedValue17,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue17 = value as String;
                      });
                    }),
                Text(
                  "Spend A Lot Of Time Thinking About My Past,\nFuture & External Evnironment",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                    value:
                        "I Take Life As It Comes, Don't Dwell Much On My Past,Future Or External Factors",
                    groupValue: selectedValue17,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue17 = value as String;
                      });
                    }),
                Text(
                  "I Take Life As It Comes, Don't Dwell Much On \nMy Past,Future Or External Factors",
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
          'Would You Say You Have Been More Unhappy Than Happy Over The Last Few Months?*',
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
              groupValue: selectedValue18,
              onChanged: (value) {
                setState(() {
                  selectedValue18 = value as String;
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
              groupValue: selectedValue18,
              onChanged: (value) {
                setState(() {
                  selectedValue18 = value as String;
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
          'Do You Consume Any Of The Followimg? Pick All That Apply.*',
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
            ...lifeStyleCheckBox.map(buildLifeStyleCheckBox).toList(),
          ],
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Do You Like The Digital Life More Than Your Family/Friend Time?*',
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
              groupValue: selectedValue19,
              onChanged: (value) {
                setState(() {
                  selectedValue19 = value as String;
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
              groupValue: selectedValue19,
              onChanged: (value) {
                setState(() {
                  selectedValue19 = value as String;
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
          'Do You Exercise? If So Please Mention Details.*',
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
          controller: exerciseController,
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
              "Your answer", exerciseController),
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }

  buildGutTypeDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Gut Type",
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
          'What Is Your Preference Past A Meal*',
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
                    value: "Eat Something Sweet Within 2 Hours Of Your Meal",
                    groupValue: selectedValue20,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue20 = value as String;
                      });
                    }),
                Text(
                  "Eat Something Sweet Within 2 Hours Of Your Meal",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value:
                        "Have Something Bitter Or Astringent Within 1 Hour Of Your Meal",
                    groupValue: selectedValue20,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue20 = value as String;
                      });
                    }),
                Text(
                  "Have Something Bitter Or Astringent Within \n1 Hour Of Your Meal",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                    value: "To Have A Hot Drink Within An Hour Of A Meal",
                    groupValue: selectedValue20,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue20 = value as String;
                      });
                    }),
                Text(
                  "To Have A Hot Drink Within An Hour Of A Meal",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                    value: "None",
                    groupValue: selectedValue20,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue20 = value as String;
                      });
                    }),
                Text(
                  "None",
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
          'What Does Hunger Look Like For You?*',
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
                    value: "Intense But Small Portions Frequently.",
                    groupValue: selectedValue21,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue21 = value as String;
                      });
                    }),
                Text(
                  "Intense But Small Portions Frequently.",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value: "Intense But Large Portions A Few Times",
                    groupValue: selectedValue21,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue21 = value as String;
                      });
                    }),
                Text(
                  "Intense But Large Portions A Few Times",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                    value: "Not So Intense & Small Portions Multiple Times",
                    groupValue: selectedValue21,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue21 = value as String;
                      });
                    }),
                Text(
                  "Not So Intense & Small Portions Multiple Times",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                    value: "Not So Intense But Large Portions A Few Times",
                    groupValue: selectedValue21,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue21 = value as String;
                      });
                    }),
                Text(
                  "Not So Intense But Large Portions A Few Times",
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
          'Stools*',
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
                    value: "Watery Stool",
                    groupValue: selectedValue22,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue22 = value as String;
                      });
                    }),
                Text(
                  "Watery Stool",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value: "Constipated With Dry/Hard Stool",
                    groupValue: selectedValue22,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue22 = value as String;
                      });
                    }),
                Text(
                  "Constipated With Dry/Hard Stool",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                    value: "Well Formed Stool",
                    groupValue: selectedValue22,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue22 = value as String;
                      });
                    }),
                Text(
                  "Well Formed Stool",
                  style: buildTextStyle(),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                    value: "Others",
                    groupValue: selectedValue22,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedValue22 = value as String;
                      });
                    }),
                Text(
                  "Others",
                  style: buildTextStyle(),
                ),
              ],
            ),
          ],
        ),
        TextFormField(
          controller: stoolsController,
          cursorColor: kPrimaryColor,
          validator: (value) {
            if (value!.isEmpty || !RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your Condition';
            } else if (!RegExp(r"^[a-z A-Z]").hasMatch(value)) {
              return 'Please enter your valid Condition';
            } else {
              return null;
            }
          },
          decoration: CommonDecoration.buildTextInputDecoration(
              "Your answer", stoolsController),
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(
          height: 2.h,
        ),
        Text(
          'Any Other Gut Symptoms? Pick All That Apply*',
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
            ...gutTypeCheckBox.map(buildGutTypeCheckBox).toList(),
          ],
        ),
        TextFormField(
          controller: symptomsController,
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
              "Your answer", symptomsController),
          textInputAction: TextInputAction.next,
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }

  buildHealthCheckBox(CheckBoxSettings healthCheckBox) {
    return ListTile(
      minLeadingWidth: 30,
      horizontalTitleGap: 3,
      dense: true,
      leading: SizedBox(
        width: 20,
        child: Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: kPrimaryColor,
          value: healthCheckBox.value,
          onChanged: (v) {
            setState(() {
              healthCheckBox.value = v;
            });
            print("${healthCheckBox.title}=> ${healthCheckBox.value}");
            // if(selectedHealthCheckBox1.contains(v)){
            //   selectedHealthCheckBox1.remove(v);
            // }
            // else{
            //   selectedHealthCheckBox1.add(v);
            // }
          },
        ),
      ),
      title: Text(
        healthCheckBox.title.toString(),
        style: buildTextStyle(),
      ),
    );
  }

  buildWrapingCheckBox(CheckBoxSettings healthCheckBox){
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

  buildLabelTextField(String name){
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
          ]
        )
    );
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

  bool isPhone(String input) => RegExp(
      r'^(?:[+0]9)?[0-9]{10}$'
  ).hasMatch(input);

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
      if(element.value == true){
        print(element.title);
        selectedHealthCheckBox1.add(element.title!);
      }
    }
  }

  void addHealthCheck2() {
    selectedHealthCheckBox2.clear();
    for (var element in healthCheckBox2) {
      if(element.value == true){
        print(element.title);
        selectedHealthCheckBox2.add(element.title!);
      }
    }
  }

  void addUrinFrequencyDetails() {
    selectedUrinFrequencyList.clear();
    for (var element in urinFrequencyList) {
      if(element.value == true){
        print(element.title);
        selectedUrinFrequencyList.add(element.title!);
      }
    }
  }


  void addUrinColorDetails() {
    selectedUrinColorList.clear();
    if(urinColorList.any((element) => element.value == true) || urinColorOtherSelected){
      for (var element in urinColorList) {
        if(element.value == true){
          print(element.title);
          selectedUrinColorList.add(element.title!);
        }
      }
      if(urinColorOtherSelected){
        selectedUrinColorList.add(otherText);
      }
    }
  }

  void addUrinSmelldetails() {
    selectedUrinSmellList.clear();
    if(urinSmellList.any((element) => element.value == true) || urinSmellOtherSelected){
      for (var element in urinSmellList) {
        if(element.value == true){
          print(element.title);
          selectedUrinSmellList.add(element.title!);
        }
      }
      if(urinSmellOtherSelected){
        selectedUrinSmellList.add(otherText);
      }
    }
  }

  void addUrinLooksDetails() {
    selectedUrinLooksList.clear();
    if(urinLooksList.any((element) => element.value == true) || urinLooksLikeOtherSelected){
      for (var element in urinLooksList) {
        if(element.value == true){
          print(element.title);
          selectedUrinLooksList.add(element.title!);
        }
      }
      if(urinLooksLikeOtherSelected){
        selectedUrinLooksList.add(otherText);
      }
    }
  }

  void addMedicalInterventionsDetails() {
    selectedmedicalInterventionsDoneBeforeList.clear();
    if(medicalInterventionsDoneBeforeList.any((element) => element.value == true) || medicalInterventionsOtherSelected){
      for (var element in medicalInterventionsDoneBeforeList) {
        if(element.value == true){
          print(element.title);
          selectedmedicalInterventionsDoneBeforeList.add(element.title!);
        }
      }
      if(medicalInterventionsOtherSelected){
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
    nameController.text = model.patient?.user?.name ?? '';
    mobileController.text = model.patient?.user?.phone ?? '';
    maritalStatus = model.patient?.maritalStatus.toString().capitalize() ?? '';
    gender = model.patient?.user?.gender.toString().capitalize() ?? '';
    emailController.text = model.patient?.user?.email ?? '';
    print("age: ${model.patient?.user?.toJson()}");

    ageController.text = model.patient?.user?.age ?? '';
    addressController.text = model.patient?.user?.address ?? '';
    pinCodeController.text = model.patient?.user?.pincode ?? '';


    weightController.text = model.weight ?? '';
    heightController.text = model.height ?? '';
    healController.text = model.healthProblem ?? '';
    // print("model.listProblems:${jsonDecode(model.listProblems ?? '')}");
    selectedHealthCheckBox1.addAll(List.from(jsonDecode(model.listProblems ?? '')));
    // print("selectedHealthCheckBox1[0]:${(selectedHealthCheckBox1[0].split(',') as List).map((e) => e).toList()}");
    selectedHealthCheckBox1 = List.from((selectedHealthCheckBox1[0].split(',') as List).map((e) => e).toList());
    healthCheckBox1.forEach((element) {
      print('selectedHealthCheckBox1.any((element1) => element1 == element.title): ${selectedHealthCheckBox1.any((element1) => element1 == element.title)}');
      if(selectedHealthCheckBox1.any((element1) => element1 == element.title)){
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
    selectedHealthCheckBox2.addAll(List.from(jsonDecode(model.listBodyIssues ?? '')));
    if(selectedHealthCheckBox2.first != null){
      selectedHealthCheckBox2 = List.from((selectedHealthCheckBox2.first.split(',') as List).map((e) => e).toList());
      healthCheckBox2.forEach((element) {
        print('selectedHealthCheckBox2.any((element1) => element1 == element.title): ${selectedHealthCheckBox2.any((element1) => element1 == element.title)}');
        if(selectedHealthCheckBox2.any((element1) => element1 == element.title)){
          element.value = true;
        }
      });
    }
    tongueCoatingRadio = model.tongueCoating ?? '';
    tongueCoatingController.text = model.tongueCoatingOther ?? '';


    selectedUrinFrequencyList.addAll(List.from(jsonDecode(model.anyUrinationIssue ?? '')));
    selectedUrinFrequencyList = List.from((selectedUrinFrequencyList[0].split(',') as List).map((e) => e).toList());
    urinFrequencyList.forEach((element) {
      if(selectedUrinFrequencyList.any((element1) => element1 == element.title)){
        element.value = true;
      }
    });

    selectedUrinColorList.addAll(List.from(jsonDecode(model.urineColor ?? '')));
    selectedUrinColorList = List.from((selectedUrinColorList[0].split(',') as List).map((e) => e).toList());
    urinColorList.forEach((element) {
      if(selectedUrinColorList.any((element1) => element1 == element.title)){
        element.value = true;
      }
    });
    selectedUrinSmellList.addAll(List.from(jsonDecode(model.urineSmell ?? '')));
    selectedUrinSmellList = List.from((selectedUrinSmellList[0].split(',') as List).map((e) => e).toList());
    urinSmellList.forEach((element) {
      if(selectedUrinSmellList.any((element1) => element1 == element.title)){
        element.value = true;
      }
    });
    urinSmellController.text = model.urineSmellOther ?? '';

    selectedUrinLooksList.addAll(List.from(jsonDecode(model.urineLookLike ?? '')));
    selectedUrinLooksList = List.from((selectedUrinLooksList[0].split(',') as List).map((e) => e).toList());
    urinLooksList.forEach((element) {
      if(selectedUrinLooksList.any((element1) => element1 == element.title)){
        element.value = true;
      }
    });
    urinLooksLikeController.text = model.urineLookLikeOther ?? '';
    selectedStoolMatch = model.closestStoolType ?? '';

    selectedmedicalInterventionsDoneBeforeList.addAll(List.from(jsonDecode(model.anyMedicalIntervationDoneBefore ?? '')));
    selectedmedicalInterventionsDoneBeforeList = List.from((selectedmedicalInterventionsDoneBeforeList[0].split(',') as List).map((e) => e).toList());
    medicalInterventionsDoneBeforeList.forEach((element) {
      if(selectedmedicalInterventionsDoneBeforeList.any((element1) => element1 == element.title)){
        element.value = true;
      }
    });

    medicalInterventionsDoneController.text = model.anyMedicalIntervationDoneBeforeOther ?? '';
    medicationsController.text = model.anyMedicationConsumeAtMoment ?? '';
    holisticController.text = model.anyTherapiesHaveDoneBefore ?? '';
    List list = jsonDecode(model.medicalReport ?? '');
    print("report list: $list ${list.length}");

    showMedicalReport.clear();
    if(list.isNotEmpty){
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
    final widgetList = showMedicalReport.map<Widget>((element) => buildRecordList(element)).toList();
    return SizedBox(
      width: double.maxFinite,
      child:  ListView(
        shrinkWrap: true,
        children: widgetList,
      ),
    );
  }


  buildRecordList(String filename, {int? index}){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: OutlinedButton(
        onPressed: ()
        {

        },
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
            (widget.showData) ? SvgPicture.asset(
                'assets/images/attach_icon.svg',
              fit: BoxFit.cover,
            ) : GestureDetector(
              onTap: (){
                medicalRecords.removeAt(index!);
                setState(() {});
              },
                child: Icon(Icons.delete_outline_outlined, color: gMainColor,)),
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
}
