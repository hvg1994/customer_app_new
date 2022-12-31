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
import '../../model/evaluation_from_models/get_evaluation_model/get_evaluationdata_model.dart';
import '../../repository/api_service.dart';
import '../../repository/profile_repository/get_user_profile_repo.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'check_box_settings.dart';
import 'package:gwc_customer/widgets/dart_extensions.dart';

class EvaluationGetDetails extends StatefulWidget {
  final bool isFromProfile;
  const EvaluationGetDetails({Key? key,this.isFromProfile = false})
      : super(key: key);

  @override
  State<EvaluationGetDetails> createState() => _EvaluationGetDetailsState();
}

class _EvaluationGetDetailsState extends State<EvaluationGetDetails> {
  Future? _getEvaluationDataFuture;

  String emptyStringMsg = AppConfig().emptyStringMsg;
  String maritalStatus = "";
  String gender = "";
  String foodPreference = "";
  String tasteYouEnjoy = "";
  String mealsYouHaveADay = "";
  final String otherText = "Other";

  String glassesOfWater = "";

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

  List selectedHealthCheckBox1 = [];

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

    _getEvaluationDataFuture = EvaluationFormService(repository: repository)
        .getEvaluationDataService();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.isFromProfile
          ? const BoxDecoration(color: gWhiteColor)
          : const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/eval_bg.png"),
                  fit: BoxFit.fitWidth,
                  colorFilter:
                      ColorFilter.mode(kPrimaryColor, BlendMode.lighten)),
            ),
      child: SafeArea(
        child: SafeArea(
          child: Scaffold(
            body: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  const Opacity(
                    opacity: 0.2,
                    child: Image(
                      image: AssetImage("assets/images/Group 10082.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  FutureBuilder(
                      future: _getEvaluationDataFuture,
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          print(snapshot.data.runtimeType);
                          if (snapshot.data.runtimeType ==
                              GetEvaluationDataModel) {
                            GetEvaluationDataModel model =
                                snapshot.data as GetEvaluationDataModel;
                            ChildGetEvaluationDataModel? model1 = model.data;
                            getDetails(model1);
                            //storeDetails(model1!);
                            return buildEvaluationForm(model: model1);
                          } else {
                            ErrorModel model = snapshot.data as ErrorModel;
                            print(model.message);
                          }
                        } else if (snapshot.hasError) {
                          print("snapshot.error: ${snapshot.error}");
                        }
                        return buildCircularIndicator();
                      }),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  showUI(BuildContext context, {ChildGetEvaluationDataModel? model}) {
    return widget.isFromProfile
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
                  child: buildEvaluationForm(model: model),
                ),
              ),
            ],
          );
  }

  buildEvaluationForm({ChildGetEvaluationDataModel? model}) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: (widget.isFromProfile) ? 0 : 8),
        child: Column(
          children: [
            if(!widget.isFromProfile)
            buildAppBar(() {
              Navigator.pop(context);
            }),
              SizedBox(height: 2.h),
            buildPersonalDetails(model),
            SizedBox(height: 1.h),
            buildHealthDetails(model),
            SizedBox(height: 1.h),
            buildFoodHabitsDetails(model),
            SizedBox(height: 1.h),
            buildLifeStyleDetails(model),
            SizedBox(height: 1.h),
            buildBowelDetails(model),
          ],
        ),
      ),
    );
  }

  buildContainer(String title) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      margin: EdgeInsets.symmetric(vertical: 1.h),
      // width: double.maxFinite,
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: gGreyColor.withOpacity(0.5),
      //     width: 1,
      //   ),
      //   borderRadius: BorderRadius.circular(8),
      //   color: gWhiteColor,
      // ),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontFamily: "GothamBook", color: gBlackColor, fontSize: 9.sp),
      ),
    );
  }

  buildPersonalDetails(ChildGetEvaluationDataModel? model) {
    return Column(
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
                SizedBox(width: 2.w),
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
        SizedBox(height: 2.h),
        buildLabelTextField("Full Name:"),
        SizedBox(height: 1.h),
        Row(
          children: [
            Text(
              model?.patient?.user?.fname ?? '',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontFamily: "GothamBook", color: gBlackColor, fontSize: 9.sp),
            ),
            // buildContainer(model?.patient?.user?.fname ?? ''),
            SizedBox(width: 2.w),
            Text(
              model?.patient?.user?.lname ?? '',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontFamily: "GothamBook", color: gBlackColor, fontSize: 9.sp),
            ),
            // buildContainer(model?.patient?.user?.lname ?? ''),
          ],
        ),
        SizedBox(height: 2.h),
        buildLabelTextField('Marital Status:'),
        Row(
          children: [
            Radio(
              value: "Single",
              activeColor: kPrimaryColor,
              groupValue: model?.patient?.maritalStatus.toString().capitalize(),
              onChanged: (value) {},
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
              groupValue: model?.patient?.maritalStatus.toString().capitalize(),
              onChanged: (value) {},
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
                groupValue:
                    model?.patient?.maritalStatus.toString().capitalize(),
                activeColor: kPrimaryColor,
                onChanged: (value) {}),
            Text(
              "Separated",
              style: buildTextStyle(),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        buildLabelTextField('Phone Number'),
        buildContainer(model?.patient?.user?.phone ?? ''),
        SizedBox(height: 1.h),
        buildLabelTextField('Email ID -'),
        buildContainer(model?.patient?.user?.email ?? ''),
        SizedBox(height: 1.h),
        buildLabelTextField('Age'),
        buildContainer(model?.patient?.user?.age ?? ''),
        SizedBox(height: 1.h),
        buildLabelTextField('Gender:'),
        Row(
          children: [
            Radio(
              value: "Male",
              activeColor: kPrimaryColor,
              groupValue: model?.patient?.user?.gender.toString().capitalize(),
              onChanged: (value) {},
            ),
            Text('Male', style: buildTextStyle()),
            SizedBox(
              width: 3.w,
            ),
            Radio(
              value: "Female",
              activeColor: kPrimaryColor,
              groupValue: model?.patient?.user?.gender.toString().capitalize(),
              onChanged: (value) {},
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
                groupValue:
                    model?.patient?.user?.gender.toString().capitalize(),
                activeColor: kPrimaryColor,
                onChanged: (value) {}),
            Text(
              "Other",
              style: buildTextStyle(),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        buildLabelTextField('Address'),
        Row(
          children: [
            buildContainer("${model?.patient?.user?.address ?? ''},"),
            SizedBox(width: 1.w),
            buildContainer(model?.patient?.address2 ?? ''),
          ],
        ),
        SizedBox(height: 1.h),
        buildLabelTextField('Pin Code'),
        buildContainer(model?.patient?.user?.pincode ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField('City'),
        buildContainer(model?.patient?.city ?? ''),
        SizedBox(height: 1.h),
        buildLabelTextField('State'),
        buildContainer(model?.patient?.state ?? ''),
        SizedBox(height: 1.h),
        buildLabelTextField('Country'),
        buildContainer(model?.patient?.country ?? ''),
        // SizedBox(height: 3.h),
      ],
    );
  }

  buildHealthDetails(ChildGetEvaluationDataModel? model) {
    return Column(
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
        SizedBox(height: 2.h),
        buildLabelTextField('Weight In Kgs'),
        buildContainer(model?.weight ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField('Height In Feet & Inches'),
        buildContainer(model?.height ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            'Brief Paragraph About Your Current Complaints Are & What You Are Looking To Heal Here'),
        buildContainer(model?.healthProblem ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField('Please Check All That Apply To You'),
        SizedBox(height: 1.h),
        showSelectedHealthBox(),
        buildContainer(model?.listProblemsOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField('Please Check All That Apply To You'),
        SizedBox(height: 1.h),
        showSelectedHealthBox2(),
        SizedBox(height: 1.h),
        buildLabelTextField('Tongue Coating'),
        SizedBox(height: 1.h),
        Column(
          children: [
            Row(
              children: [
                Radio(
                    value: "clear",
                    groupValue: model?.tongueCoating,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {}),
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
                    groupValue: model?.tongueCoating,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {}),
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
                    groupValue: model?.tongueCoating,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {}),
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
                    groupValue: model?.tongueCoating,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {}),
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
                    groupValue: model?.tongueCoating,
                    activeColor: kPrimaryColor,
                    onChanged: (value) {}),
                Text(
                  "Other:",
                  style: buildTextStyle(),
                ),
              ],
            ),
          ],
        ),
        buildContainer(model?.tongueCoatingOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "Has Frequency Of Urination Increased Or Decreased In The Recent Past"),
        SizedBox(height: 1.h),
        buildUrination("${model?.anyUrinationIssue}"),
        buildLabelTextField("Urin Color"),
        SizedBox(height: 1.h),
        buildUrineColorRadioButton(
            "${model?.urineColor.toString().capitalize()}"),
        buildContainer(model?.urineColorOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("Urine Smell"),
        SizedBox(height: 1.h),
        showSelectedUrinSmellList(),
        buildContainer(model?.urineSmellOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("What Does Your Urine Look Like"),
        SizedBox(height: 1.h),
        buildUrineLookRadioButton("${model?.urineLookLike}"),
        buildContainer(model?.urineSmellOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("Which one is the closest match to your stool"),
        SizedBox(height: 1.h),
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
            SizedBox(height: 1.h),
            Column(
              children: [
                Row(
                  children: [
                    Radio(
                        value: "Seperate hard lumps",
                        groupValue: model?.closestStoolType,
                        activeColor: kPrimaryColor,
                        onChanged: (value) {}),
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
                        groupValue: model?.closestStoolType,
                        activeColor: kPrimaryColor,
                        onChanged: (value) {}),
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
                        groupValue: model?.closestStoolType,
                        activeColor: kPrimaryColor,
                        onChanged: (value) {}),
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
                        groupValue: model?.closestStoolType,
                        activeColor: kPrimaryColor,
                        onChanged: (value) {}),
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
                        groupValue: model?.closestStoolType,
                        activeColor: kPrimaryColor,
                        onChanged: (value) {}),
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
                        groupValue: model?.closestStoolType,
                        activeColor: kPrimaryColor,
                        onChanged: (value) {}),
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
        SizedBox(height: 1.h),
        buildLabelTextField("Medical Interventions Done Before"),
        SizedBox(height: 1.h),
        showSelectedMedicalInterventionsList(),
        buildContainer(model?.anyMedicalIntervationDoneBeforeOther ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            'Any Medications/Supplements/Inhalers/Contraceptives You Consume At The Moment'),
        buildContainer(model?.anyMedicationConsumeAtMoment ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            'Holistic/Alternative Therapies You Have Been Through & When (Ayurveda, Homeopathy) '),
        SizedBox(height: 1.h),
        buildContainer(model?.anyTherapiesHaveDoneBefore ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("Uploaded Files"),
        SizedBox(height: 1.h),
        showFiles(),
        SizedBox(height: 2.h),
      ],
    );
  }

  buildFoodHabitsDetails(ChildGetEvaluationDataModel? model) {
    return Column(
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
        SizedBox(height: 2.h),
        buildLabelTextField(
            "Do Certain Food Affect Your Digestion? If So Please Provide Details."),
        SizedBox(height: 1.h),
        buildContainer(model?.mentionIfAnyFoodAffectsYourDigesion ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "Do You Follow Any Special Diet(Keto,Etc)? If So Please Provide Details"),
        SizedBox(height: 1.h),
        buildContainer(model?.anySpecialDiet ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "Do You Have Any Known Food Allergy? If So Please Provide Details."),
        SizedBox(height: 1.h),
        buildContainer(model?.anyFoodAllergy ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "Do You Have Any Known Intolerance? If So Please Provide Details."),
        SizedBox(height: 1.h),
        buildContainer(model?.anyIntolerance ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "Do You Have Any Severe Food Cravings? If So Please Provide Details."),
        SizedBox(height: 1.h),
        buildContainer(model?.anySevereFoodCravings ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField(
            "Do You Dislike Any Food?Please Mention All Of Them"),
        SizedBox(height: 1.h),
        buildContainer(model?.anyDislikeFood ?? ""),
        SizedBox(height: 1.h),
        buildLabelTextField("How Many Glasses Of Water Do You Have A Day?"),
        SizedBox(height: 1.h),
        Row(
          children: [
            Radio(
              value: "1-2",
              activeColor: kPrimaryColor,
              groupValue: model?.noGalssesDay,
              onChanged: (value) {},
            ),
            Text(
              '1-2',
              style: buildTextStyle(),
            ),
            SizedBox(width: 3.w),
            Radio(
              value: "3-4",
              activeColor: kPrimaryColor,
              groupValue: model?.noGalssesDay,
              onChanged: (value) {},
            ),
            Text(
              '3-4',
              style: buildTextStyle(),
            ),
            SizedBox(width: 3.w),
            Radio(
                value: "6-8",
                groupValue: model?.noGalssesDay,
                activeColor: kPrimaryColor,
                onChanged: (value) {}),
            Text(
              "6-8",
              style: buildTextStyle(),
            ),
            SizedBox(width: 3.w),
            Radio(
                value: "9+",
                groupValue: model?.noGalssesDay,
                activeColor: kPrimaryColor,
                onChanged: (value) {}),
            Text(
              "9+",
              style: buildTextStyle(),
            ),
          ],
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  buildLifeStyleDetails(ChildGetEvaluationDataModel? model) {
    return Column(
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
        SizedBox(height: 1.h),
        buildLabelTextField("Habits Or Addiction"),
        SizedBox(height: 1.h),
        showSelectedHabitsList(),
        buildContainer(model?.anyHabbitOrAddictionOther ?? ""),
        SizedBox(height: 2.h),
      ],
    );
  }

  buildBowelDetails(ChildGetEvaluationDataModel? model) {
    return Column(
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
        SizedBox(height: 1.h),
        buildLabelTextField("What is your after meal preference?"),
        SizedBox(height: 1.h),
        ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                Radio(
                  value: mealPreferenceList[0],
                  activeColor: kPrimaryColor,
                  groupValue: model?.afterMealPreference,
                  onChanged: (value) {},
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
                  groupValue: model?.afterMealPreference,
                  onChanged: (value) {},
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
                  groupValue: model?.afterMealPreference,
                  onChanged: (value) {},
                ),
                Text(
                  mealPreferenceList[2],
                  style: buildTextStyle(),
                ),
              ],
            ),
            buildContainer(model?.afterMealPreferenceOther ?? ""),
          ],
        ),
        SizedBox(height: 1.h),
        buildLabelTextField("Hunger Pattern"),
        SizedBox(height: 1.h),
        ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                Radio(
                  value: hungerPatternList[0],
                  activeColor: kPrimaryColor,
                  groupValue: model?.hungerPattern,
                  onChanged: (value) {},
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
                  groupValue: model?.hungerPattern,
                  onChanged: (value) {},
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
                  groupValue: model?.hungerPattern,
                  onChanged: (value) {},
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
                  groupValue: model?.hungerPattern,
                  onChanged: (value) {},
                ),
                Expanded(
                  child: Text(
                    hungerPatternList[3],
                    style: buildTextStyle(),
                  ),
                ),
              ],
            ),
            buildContainer(model?.hungerPatternOther ?? ""),
          ],
        ),
        SizedBox(height: 1.h),
        buildLabelTextField("Bowel Pattern"),
        SizedBox(height: 1.h),
        ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                Radio(
                  value: bowelPatternList[0],
                  activeColor: kPrimaryColor,
                  groupValue: model?.bowelPattern,
                  onChanged: (value) {},
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
                  groupValue: model?.bowelPattern,
                  onChanged: (value) {},
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
                  groupValue: model?.bowelPattern,
                  onChanged: (value) {},
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
                  groupValue: model?.bowelPattern,
                  onChanged: (value) {},
                ),
                Expanded(
                  child: Text(
                    bowelPatternList[3],
                    style: buildTextStyle(),
                  ),
                ),
              ],
            ),
            buildContainer(model?.bowelPatternOther ?? ""),
          ],
        ),
        SizedBox(height: 1.h),
      ],
    );
  }

  buildLabelTextField(String name) {
    return RichText(
      text: TextSpan(
        text: name,
        style: TextStyle(
          fontSize: 11.sp,
          color: gBlackColor,
          fontFamily: "GothamMedium",
        ),
        children: [
          TextSpan(
            text: ' *',
            style: TextStyle(
              fontSize: 9.sp,
              color: gGreyColor,
              fontFamily: "PoppinsSemiBold",
            ),
          ),
        ],
      ),
    );
  }

  final EvaluationFormRepository repository = EvaluationFormRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

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
            SvgPicture.asset(
              'assets/images/attach_icon.svg',
              fit: BoxFit.cover,
            )
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

  final UserProfileRepository userRepository = UserProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  buildUrination(String anyUrinationIssue) {
    print("Urination: $anyUrinationIssue");
    selectedUrinFrequencyList
        .addAll(List.from(jsonDecode(anyUrinationIssue ?? '')));
    selectedUrinFrequencyList = List.from(
        (selectedUrinFrequencyList[0].split(',') as List)
            .map((e) => e)
            .toList());
    urinationValue = selectedUrinFrequencyList.first;

    return Row(
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
    );
  }

  buildUrineColorRadioButton(String title) {
    print("UrinColor: $title");
    selectedUrinColorList.addAll(List.from(jsonDecode(title ?? '')));
    selectedUrinColorList = List.from(
        (selectedUrinColorList[0].split(',') as List).map((e) => e).toList());
    urineColorValue = selectedUrinColorList.first.toString().capitalize();

    return Column(
      children: [
        Row(
          children: [
            Radio(
              value: "Clear",
              activeColor: kPrimaryColor,
              groupValue: urineColorValue,
              onChanged: (value) {},
            ),
            Text('Clear', style: buildTextStyle()),
            SizedBox(
              width: 3.w,
            ),
            Radio(
              value: "Pale Yello",
              activeColor: kPrimaryColor,
              groupValue: urineColorValue,
              onChanged: (value) {},
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
                onChanged: (value) {}),
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
              onChanged: (value) {},
            ),
            Text('Black', style: buildTextStyle()),
            SizedBox(
              width: 3.w,
            ),
            Radio(
              value: "Yellow",
              activeColor: kPrimaryColor,
              groupValue: urineColorValue,
              onChanged: (value) {},
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
                onChanged: (value) {}),
            Text(
              "Other",
              style: buildTextStyle(),
            ),
          ],
        ),
      ],
    );
  }

  buildUrineLookRadioButton(String urineLookLike) {
    print("UrineLookLike: $urineLookLike");
    selectedUrinLooksList.addAll(List.from(jsonDecode(urineLookLike ?? '')));
    selectedUrinLooksList = List.from(
        (selectedUrinLooksList[0].split(',') as List).map((e) => e).toList());
    urineLookLikeValue = selectedUrinLooksList.first;
    print("value: $urineLookLikeValue");
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

  showSelectedHealthBox() {
    print("selectedHealthCheckBox1: $selectedHealthCheckBox1");
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedHealthCheckBox1.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(
            Icons.check_box_outlined,
            color: gsecondaryColor,
          ),
          title: Text(
            selectedHealthCheckBox1[index] ?? "",
            style: TextStyle(
              fontSize: 10.sp,
              height: 1.3,
              color: gBlackColor,
              fontFamily: "GothamBook",
            ),
          ),
        );
      },
    );
  }

  showSelectedHealthBox2() {
    print("selectedHealthCheckBox2: $selectedHealthCheckBox2");
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedHealthCheckBox2.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(
            Icons.check_box_outlined,
            color: gsecondaryColor,
          ),
          title: Text(
            selectedHealthCheckBox2[index] ?? "",
            style: TextStyle(
              fontSize: 10.sp,
              height: 1.3,
              color: gBlackColor,
              fontFamily: "GothamBook",
            ),
          ),
        );
      },
    );
  }

  showSelectedUrinSmellList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedUrinSmellList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(
            Icons.check_box_outlined,
            color: gsecondaryColor,
          ),
          title: Text(
            selectedUrinSmellList[index] ?? "",
            style: TextStyle(
              fontSize: 10.sp,
              height: 1.3,
              color: gBlackColor,
              fontFamily: "GothamBook",
            ),
          ),
        );
      },
    );
  }

  showSelectedMedicalInterventionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedmedicalInterventionsDoneBeforeList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(
            Icons.check_box_outlined,
            color: gsecondaryColor,
          ),
          title: Text(
            selectedmedicalInterventionsDoneBeforeList[index] ?? "",
            style: TextStyle(
              fontSize: 10.sp,
              height: 1.3,
              color: gBlackColor,
              fontFamily: "GothamBook",
            ),
          ),
        );
      },
    );
  }

  showSelectedHabitsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedHabitCheckBoxList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(
            Icons.check_box_outlined,
            color: gsecondaryColor,
          ),
          title: Text(
            selectedHabitCheckBoxList[index] ?? "",
            style: TextStyle(
              fontSize: 10.sp,
              height: 1.3,
              color: gBlackColor,
              fontFamily: "GothamBook",
            ),
          ),
        );
      },
    );
  }

  void getDetails(ChildGetEvaluationDataModel? model) {
    //---- health checkbox1 ----//
    print(model?.listProblems);
    List lifeStyle = jsonDecode("${model?.listProblems}")
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',');
    print(lifeStyle);
    selectedHealthCheckBox1 = lifeStyle;
    print("selectedHealthCheckBox1: $selectedHealthCheckBox1");

    //---- health checkbox2 ----//
    print(model?.listBodyIssues);
    List lifeStyle1 = jsonDecode("${model?.listBodyIssues}")
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',');
    print(lifeStyle1);
    selectedHealthCheckBox2 = lifeStyle1;
    print("selectedHealthCheckBox2: $selectedHealthCheckBox2");

    //---- urineSmell ----//
    print(model?.urineSmell);
    List lifeStyle2 = jsonDecode("${model?.urineSmell}")
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',');
    print(lifeStyle2);
    selectedUrinSmellList = lifeStyle2;
    print("selectedUrinSmellList: $selectedUrinSmellList");

    //---- anyMedicalIntervationDoneBefore ----//
    print(model?.anyMedicalIntervationDoneBefore);
    List lifeStyle3 = jsonDecode("${model?.anyMedicalIntervationDoneBefore}")
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',');
    print(lifeStyle3);
    selectedmedicalInterventionsDoneBeforeList = lifeStyle3;
    print(
        "selectedmedicalInterventionsDoneBeforeList: $selectedmedicalInterventionsDoneBeforeList");

    //---- selectedHabitCheckBoxList ----//
    print(model?.anyHabbitOrAddiction);
    List lifeStyle4 = jsonDecode("${model?.anyHabbitOrAddiction}")
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',');
    print(lifeStyle4);
    selectedHabitCheckBoxList = lifeStyle4;
    print("selectedHabitCheckBoxList: $selectedHabitCheckBoxList");
  }
}
