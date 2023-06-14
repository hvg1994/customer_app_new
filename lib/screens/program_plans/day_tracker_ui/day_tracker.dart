import 'dart:io';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/program_model/proceed_model/get_proceed_model.dart';
import 'package:gwc_customer/model/program_model/proceed_model/send_proceed_program_model.dart';
import 'package:gwc_customer/repository/api_service.dart';
import 'package:gwc_customer/repository/program_repository/program_repository.dart';
import 'package:gwc_customer/screens/evalution_form/check_box_settings.dart';
import 'package:gwc_customer/screens/program_plans/meal_plan_screen.dart';
import 'package:gwc_customer/screens/program_plans/program_start_screen.dart';
import 'package:gwc_customer/services/prepratory_service/prepratory_service.dart';
import 'package:gwc_customer/services/program_service/program_service.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import '../../../repository/prepratory_repository/prep_repository.dart';
import '../../../services/vlc_service/check_state.dart';
import '../../../widgets/pip_package.dart';
import '../../../widgets/video/normal_video.dart';
import '../../combined_meal_plan/combined_meal_screen.dart';
import '../../prepratory plan/new/new_transition_design.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../meal_pdf.dart';

// class DayMealTracerUI extends StatefulWidget {
//   final ProceedProgramDayModel proceedProgramDayModel;
//   const DayMealTracerUI({Key? key, required this.proceedProgramDayModel}) : super(key: key);
//
//   @override
//   State<DayMealTracerUI> createState() => _DayMealTracerUIState();
// }
//
// class _DayMealTracerUIState extends State<DayMealTracerUI> {
//
//   final formKey = GlobalKey<FormState>();
//   List missedAnything = [
//     "Yes, I have",  "No, I've Done It All"
//   ];
//
//   String selectedMissedAnything = '';
//
//   final mealPlanMissedController = TextEditingController();
//
//   final symptomsCheckBox1 = <CheckBoxSettings>[
//     CheckBoxSettings(title: "Aches, pain, and soreness"),
//     CheckBoxSettings(title: "Nausea"),
//     CheckBoxSettings(title: "Vomiting"),
//     CheckBoxSettings(title: "Diarrhea"),
//     CheckBoxSettings(title: "Constipation"),
//     CheckBoxSettings(title: "Headache"),
//     CheckBoxSettings(title: "fever or flu-like symptoms"),
//     CheckBoxSettings(title: "Cold"),
//     CheckBoxSettings(title: "Frequent urination"),
//     CheckBoxSettings(title: "Urinary tract discharges"),
//     CheckBoxSettings(title: "Skin eruptions, including boils, hives, and rashes"),
//     CheckBoxSettings(title: "Emotional Disturbances like anger, despair, sadness, fear"),
//     CheckBoxSettings(title: "Anxiety, Mood swings, Phobias"),
//     CheckBoxSettings(title: "Joints &/or Muscle Pain"),
//     CheckBoxSettings(title: "Chills"),
//     CheckBoxSettings(title: "Stuffy Nose"),
//     CheckBoxSettings(title: "Congestion"),
//     CheckBoxSettings(title: "Change in Blood Pressure"),
//     CheckBoxSettings(title: "Severe Joint pain / Body ache"),
//     CheckBoxSettings(title: "Dry cough / Dryness of mouth"),
//     CheckBoxSettings(title: "Loss of appetite / tastelessness"),
//     CheckBoxSettings(title: "Severe thirst"),
//     CheckBoxSettings(title: "Weaker sense of hearing / vision"),
//     CheckBoxSettings(title: "Reduction in physical, mental, and or digestive capacity"),
//     CheckBoxSettings(title: "Feeling dizzy / giddiness"),
//     CheckBoxSettings(title: "Mind agitation"),
//     CheckBoxSettings(title: "Weakness / restlessness / cramps / sleeplessness"),
//     CheckBoxSettings(title: "None Of The Above"),
//   ];
//   List selectedSymptoms1 = [];
//
//   final symptomsCheckBox2 = <CheckBoxSettings>[
//     CheckBoxSettings(title: "Satisfactory release of Solid waste matter / Gas from stomach and or Urine"),
//     CheckBoxSettings(title: "Lightness in the Chest / Abdomen"),
//     CheckBoxSettings(title: "Odour free burps"),
//     CheckBoxSettings(title: "Freshness in the Mouth"),
//     CheckBoxSettings(title: "Easily getting hungry, thirsty, or both"),
//     CheckBoxSettings(title: "Clear tongue/Sense (absence of discharges from sense organs such as the skin's sweat or perspiration, the ears, the nose, the tongue, and the eyes)"),
//     CheckBoxSettings(title: "Odour free breath"),
//     CheckBoxSettings(title: "No Body odour"),
//     CheckBoxSettings(title: "Weight loss"),
//     CheckBoxSettings(title: "Peaceful Sleep"),
//     CheckBoxSettings(title: "Easy Digestion"),
//     CheckBoxSettings(title: "Increased energy levels"),
//     CheckBoxSettings(title: "Reduced / absence of cravings"),
//     CheckBoxSettings(title: "Feeling of internal wellbeing and happiness"),
//     CheckBoxSettings(title: "Reduced / Absence of Detox related Recovery symptoms as mentioned in the previous question"),
//     CheckBoxSettings(title: "None of the above"),
//   ];
//
//   List selectedSymptoms2 = [];
//
//   String selectedCalmModule = '';
//
//   final worriesController = TextEditingController();
//   final eatSomethingController = TextEditingController();
//   final anyMedicationsController = TextEditingController();
//
//   String didYouCompleteCalmMoveModule = '';
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     mealPlanMissedController.addListener(() {
//       setState(() {
//
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     mealPlanMissedController.removeListener(() { });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage("assets/images/eval_bg.png"),
//             fit: BoxFit.fitWidth,
//             colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.lighten)
//         ),
//       ),
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           body: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 3.h),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     buildAppBar(() {
//                       Navigator.pop(context);
//                     }),
//                     SizedBox(
//                       width: 3.w,
//                     ),
//                     Expanded(
//                       child: Text(
//                         "Gut Wellness Club \nMeal Tracker Day${widget.proceedProgramDayModel.day ?? ''}",
//                         textAlign: TextAlign.start,
//                         style: TextStyle(
//                             fontFamily: "PoppinsMedium",
//                             color: Colors.white,
//                             fontSize: 12.sp),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 4.h,
//               ),
//               Expanded(
//                 child: Container(
//                   width: double.maxFinite,
//                   padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: 2, color: Colors.grey.withOpacity(0.5))
//                     ],
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: SingleChildScrollView(
//                     physics: const AlwaysScrollableScrollPhysics(),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Gut Detox Program Status Tracker",
//                                   textAlign: TextAlign.start,
//                                   style: TextStyle(
//                                       fontFamily: "PoppinsBold",
//                                       color: kPrimaryColor,
//                                       fontSize: 15.sp),
//                                 ),
//                                 SizedBox(
//                                   width: 2.w,
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                     height: 1,
//                                     color: kPrimaryColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               "Your detox & healing program tracker that takes less than 1 minute to fill but essential for your doctors to track, manage & intervene effectively.",
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                   fontFamily: "PoppinsRegular",
//                                   color: gMainColor,
//                                   fontSize: 9.sp),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 2.5.h,
//                         ),
//                         buildLabelTextField("Have You Missed Anything In Your Meal Or Yoga Plan Today?"),
//                         SizedBox(
//                           height: 1.h,
//                         ),
//                         ...missedAnything.map((e) => Row(
//                           children: [
//                             Radio<String>(
//                               value: e,
//                               activeColor: kPrimaryColor,
//                               groupValue: selectedMissedAnything,
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedMissedAnything = value as String;
//                                 });
//                               },
//                             ),
//                             Text(
//                               e,
//                               style: buildTextStyle(),
//                             ),
//                           ],
//                         )),
//                         showRespectiveWidget()
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   showRespectiveWidget() {
//     if(selectedMissedAnything.contains(missedAnything[0])){
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Missed Items",
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                         fontFamily: "PoppinsBold",
//                         color: kPrimaryColor,
//                         fontSize: 15.sp),
//                   ),
//                   SizedBox(
//                     width: 2.w,
//                   ),
//                   Expanded(
//                     child: Container(
//                       height: 1,
//                       color: kPrimaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//               Text(
//                 "Important to understand if this will affect your program & how we can fix it :)",
//                 textAlign: TextAlign.start,
//                 style: TextStyle(
//                     fontFamily: "PoppinsRegular",
//                     color: gMainColor,
//                     fontSize: 9.sp),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 3.h,
//           ),
//           buildLabelTextField("What Did you Miss In Your Meal Plan Or Yoga Today?"),
//           SizedBox(
//             height: 0.5.h,
//           ),
//           TextFormField(
//             controller: mealPlanMissedController,
//             cursorColor: kPrimaryColor,
//             validator: (value) {
//               if (value!.isEmpty ) {
//                 return 'Please Mention What Did you Miss In Your Meal Plan Or Yoga Today?';
//               }else {
//                 return null;
//               }
//             },
//             decoration: CommonDecoration.buildTextInputDecoration(
//                 "Your answer", mealPlanMissedController),
//             textInputAction: TextInputAction.next,
//             textAlign: TextAlign.start,
//             keyboardType: TextInputType.text,
//           ),
//           SizedBox(
//             height: 3.h,
//           ),
//           if(mealPlanMissedController.text.isNotEmpty) symptomsTracker()
//         ],
//       );
//     }
//     else if(selectedMissedAnything.contains(missedAnything[1])){
//       return symptomsTracker();
//     }
//     else return SizedBox.shrink();
//   }
//
//   symptomsTracker(){
//     return Form(
//       key: formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Symptom Tracker",
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                         fontFamily: "PoppinsBold",
//                         color: kPrimaryColor,
//                         fontSize: 15.sp),
//                   ),
//                   SizedBox(
//                     width: 2.w,
//                   ),
//                   Expanded(
//                     child: Container(
//                       height: 1,
//                       color: kPrimaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//               Text(
//                 "For your doctor to know if you are on track :)",
//                 textAlign: TextAlign.start,
//                 style: TextStyle(
//                     fontFamily: "PoppinsRegular",
//                     color: gMainColor,
//                     fontSize: 9.sp),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 3.h,
//           ),
//           buildLabelTextField('Did you deal with any of the following withdrawal symptoms from detox today? If "Yes," then choose all that apply. If no, choose none of the above.'),
//           SizedBox(
//             height: 1.h,
//           ),
//           ...symptomsCheckBox1.map((e)=> buildHealthCheckBox(e, '1')).toList(),
//           SizedBox(
//             height: 1.h,
//           ),
//           buildLabelTextField('Did any of the following (adequate) detoxification / healing signs and symptoms happen to you today? If "Yes," then choose all that apply. If no, choose none of the above.'),
//           SizedBox(
//             height: 2.h,
//           ),
//           ...symptomsCheckBox2.map((e)=> buildHealthCheckBox(e, '2')).toList(),
//           SizedBox(
//             height: 2.h,
//           ),
//           buildLabelTextField('Please let us know if you notice any other signs or have any other worries. If none, enter "No."'),
//           SizedBox(
//             height: 1.h,
//           ),
//           TextFormField(
//             controller: worriesController,
//             cursorColor: kPrimaryColor,
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Please let us know if you notice any other signs or have any other worries.';
//               }else {
//                 return null;
//               }
//             },
//             decoration: CommonDecoration.buildTextInputDecoration(
//                 "Your answer", worriesController),
//             textInputAction: TextInputAction.next,
//             textAlign: TextAlign.start,
//             keyboardType: TextInputType.name,
//           ),
//           SizedBox(
//             height: 2.h,
//           ),
//           buildLabelTextField('Did you eat something other than what was on your meal plan? If "Yes", please give more information? If not, type "No."'),
//           SizedBox(
//             height: 1.h,
//           ),
//           TextFormField(
//             controller: eatSomethingController,
//             cursorColor: kPrimaryColor,
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Did you eat something other than what was on your meal plan?';
//               }else {
//                 return null;
//               }
//             },
//             decoration: CommonDecoration.buildTextInputDecoration(
//                 "Your answer", eatSomethingController),
//             textInputAction: TextInputAction.next,
//             textAlign: TextAlign.start,
//             keyboardType: TextInputType.name,
//           ),
//           SizedBox(
//             height: 2.h,
//           ),
//           buildLabelTextField('Did you complete the Calm and Move modules suggested today?'),
//           SizedBox(
//             height: 1.h,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(
//                     width: 25,
//                     child: Radio(
//                       value: "Yes",
//                       activeColor: kPrimaryColor,
//                       groupValue: selectedCalmModule,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedCalmModule = value as String;
//                         });
//                       },
//                     ),
//                   ),
//                   Text(
//                     'Yes',
//                     style: buildTextStyle(),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 width: 10.w,
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(
//                     width: 25,
//                     child: Radio(
//                       value: "No",
//                       activeColor: kPrimaryColor,
//                       groupValue: selectedCalmModule,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedCalmModule = value as String;
//                         });
//                       },
//                     ),
//                   ),
//                   Text(
//                     'No',
//                     style: buildTextStyle(),
//                   ),
//                 ],
//               )
//             ],
//           ),
//           SizedBox(
//             height: 2.h,
//           ),
//           buildLabelTextField('Have you had a medical exam or taken any medications during the program? If "Yes", please give more information. Type "No" if not.'),
//           SizedBox(
//             height: 1.h,
//           ),
//           TextFormField(
//             controller: anyMedicationsController,
//             cursorColor: kPrimaryColor,
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Have you had a medical exam or taken any medications during the program?';
//               }else {
//                 return null;
//               }
//             },
//             decoration: CommonDecoration.buildTextInputDecoration(
//                 "Your answer", anyMedicationsController),
//             textInputAction: TextInputAction.done,
//             textAlign: TextAlign.start,
//             keyboardType: TextInputType.name,
//           ),
//           SizedBox(
//             height: 3.h,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   primary: eUser().buttonColor,
//                   onSurface: eUser().buttonTextColor,
//                   padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(eUser().buttonBorderRadius)
//                   ),
//                 ),
//                 onPressed: (){
//                   if(formKey.currentState!.validate()){
//                     if(selectedCalmModule.isNotEmpty){
//                       if(selectedSymptoms1.isNotEmpty){
//                         if(selectedSymptoms2.isNotEmpty){
//                           proceed();
//                         }
//                         else{
//                           AppConfig().showSnackbar(context, "Please select Detoxification/healing signs", isError: true);
//                         }
//                       }
//                       else{
//                         AppConfig().showSnackbar(context, "Please select withdrawal symptoms", isError: true);
//                       }
//                     }
//                     else{
//                       AppConfig().showSnackbar(context, "Please select Calm & Move Modules", isError: true);
//                     }
//                   }
//                 },
//                 child: Center(
//                   child: Text('Submit',
//                     style: TextStyle(
//                       fontFamily: "GothamRoundedBold",
//                       color: Colors.white,
//                       fontSize: 12.sp,
//                     ),
//                   ),
//                 ),
//               ),
//             ],),
//         ],
//       ),
//     );
//   }
//
//   buildHealthCheckBox(CheckBoxSettings healthCheckBox, String from) {
//     return ListTile(
//       minLeadingWidth: 30,
//       horizontalTitleGap: 3,
//       dense: true,
//       leading: SizedBox(
//         width: 20,
//         child: Checkbox(
//           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           activeColor: kPrimaryColor,
//           value: healthCheckBox.value,
//           onChanged: (v) {
//             if(from == '1'){
//               if(healthCheckBox.title == symptomsCheckBox1.last.title){
//                 print("if");
//                 setState(() {
//                   selectedSymptoms1.clear();
//                   symptomsCheckBox1.forEach((element) {
//                     element.value = false;
//                   });
//                   selectedSymptoms1.add(healthCheckBox.title!);
//                   healthCheckBox.value = v;
//                 });
//               }
//               else{
//                 print("else");
//                 if(selectedSymptoms1.contains(symptomsCheckBox1.last.title)){
//                   print("if");
//                   setState(() {
//                     selectedSymptoms1.clear();
//                     symptomsCheckBox1.last.value = false;
//                   });
//                 }
//                 if(v == true){
//                   setState(() {
//                     selectedSymptoms1.add(healthCheckBox.title!);
//                     healthCheckBox.value = v;
//                   });
//                 }
//                 else{
//                   setState(() {
//                     selectedSymptoms1.remove(healthCheckBox.title!);
//                     healthCheckBox.value = v;
//                   });
//                 }
//               }
//               print(selectedSymptoms1);
//             }
//             else if(from == '2'){
//               if(healthCheckBox.title == symptomsCheckBox2.last.title){
//                 print("if");
//                 setState(() {
//                   selectedSymptoms2.clear();
//                   symptomsCheckBox2.forEach((element) {
//                     element.value = false;
//                     // if(element.title != symptomsCheckBox2.last.title){
//                     // }
//                   });
//                   if(v == true){
//                     selectedSymptoms2.add(healthCheckBox.title);
//                     healthCheckBox.value = v;
//                   }
//                   else{
//                     selectedSymptoms2.remove(healthCheckBox.title!);
//                     healthCheckBox.value = v;
//                   }
//                 });
//               }
//               else{
//                 // print("else");
//                 if(v == true){
//                   // print("if");
//                   setState(() {
//                     if(selectedSymptoms2.contains(symptomsCheckBox2.last.title)){
//                       // print("if");
//                       selectedSymptoms2.removeWhere((element) => element == symptomsCheckBox2.last.title);
//                       symptomsCheckBox2.forEach((element) {
//                         element.value = false;
//                       });
//                     }
//                     selectedSymptoms2.add(healthCheckBox.title!);
//                     healthCheckBox.value = v;
//                   });
//                 }
//                 else{
//                   setState(() {
//                     selectedSymptoms2.remove(healthCheckBox.title!);
//                     healthCheckBox.value = v;
//                   });
//                 }
//               }
//               print(selectedSymptoms2);
//             }
//             // print("${healthCheckBox.title}=> ${healthCheckBox.value}");
//
//           },
//         ),
//       ),
//       title: Text(
//         healthCheckBox.title.toString(),
//         style: buildTextStyle(),
//       ),
//     );
//   }
//
//   void proceed() async {
//     ProceedProgramDayModel? model;
//     model = ProceedProgramDayModel(
//       patientMealTracking: widget.proceedProgramDayModel.patientMealTracking,
//       comment: widget.proceedProgramDayModel.comment,
//       userProgramStatusTracking: '1',
//       day: widget.proceedProgramDayModel.day,
//       missedAnyThingRadio: selectedMissedAnything,
//       didUMiss: mealPlanMissedController.text,
//       withdrawalSymptoms: selectedSymptoms1.join(','),
//       detoxification: selectedSymptoms2.join(','),
//       haveAnyOtherWorries: worriesController.text,
//       eatSomthingOther: eatSomethingController.text,
//       completedCalmMoveModules: selectedCalmModule,
//       hadAMedicalExamMedications: anyMedicationsController.text
//     );
//     final result = await ProgramService(repository: repository).proceedDayMealDetailsService(model);
//
//     print("result: $result");
//
//     if(result.runtimeType == GetProceedModel){
//       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DaysProgramPlan()), (route) => route.isFirst);
//     }
//     else{
//       ErrorModel model = result as ErrorModel;
//       AppConfig().showSnackbar(context, model.message ?? '', isError: true);
//     }
//   }
//
//   final ProgramRepository repository = ProgramRepository(
//     apiClient: ApiClient(
//       httpClient: http.Client(),
//     ),
//   );
//
//
// }

class TrackerUI extends StatefulWidget {
  final String? trackerVideoLink;
  final bool isPreviousDaySheet;
  final ProceedProgramDayModel? proceedProgramDayModel;

  /// from is used for maintaining api url for meal and transition
  final String from;
  const TrackerUI(
      {Key? key,
        this.proceedProgramDayModel,
        required this.from,
        this.trackerVideoLink,
        this.isPreviousDaySheet = false,
      })
      : super(key: key);

  @override
  State<TrackerUI> createState() => _TrackerUIState();
}

class _TrackerUIState extends State<TrackerUI> {
  final formKey = GlobalKey<FormState>();
  final question2 = GlobalKey<FormState>();
  final question3 = GlobalKey<FormState>();
  List missedAnything = ["Yes, I have", "No, I've Done It All"];

  String selectedMissedAnything = '';

  final mealPlanMissedController = TextEditingController();
  bool showMealVideo = false;
  VideoPlayerController? _sheetVideoController, _yogaVideoController;
  ChewieController? _sheetChewieController, _yogaChewieController;
  bool isEnabled = false;
  String? planNotePdfLink;
  VideoPlayerController? mealPlayerController;
  ChewieController? _chewieController;

  bool showProgress = false;

  addUrlToVideoPlayerChewie(String url) async {
    print("url" + url);
    mealPlayerController = VideoPlayerController.network(url);
    _chewieController = ChewieController(
        videoPlayerController: mealPlayerController!,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        hideControlsTimer: Duration(seconds: 3),
        showControls: true);
    if (await Wakelock.enabled == false) {
      Wakelock.enable();
    }
  }

  initChewieView(String? url) {
    print("init url: $url");
    _yogaVideoController =
        VideoPlayerController.network(Uri.parse(url!).toString());
    _yogaChewieController = ChewieController(
        videoPlayerController: _yogaVideoController!,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        allowedScreenSleep: false,
        hideControlsTimer: Duration(seconds: 3),
        showControls: true);

    final _ori = MediaQuery.of(context).orientation;
    print(_ori.name);
    bool isPortrait = _ori == Orientation.portrait;
    if (isPortrait) {
      AutoOrientation.landscapeAutoMode();
    }
  }

  final PageController _pageController = PageController(initialPage: 0);

  late List<Widget> pages = [
    buildQuestion1(),
    buildQuestion2(),
    buildQuestion3(),
    buildQuestion4(),
    buildQuestion5(),
    buildQuestion6(),
    buildQuestion7(),
  ];

  List<PlatformFile> medicalRecords = [];
  List<File> fileFormatList = [];
  List<MultipartFile> newList = <MultipartFile>[];

  final symptomsCheckBox1 = <CheckBoxSettings>[
    CheckBoxSettings(title: "Aches, pain, and soreness"),
    CheckBoxSettings(title: "Nausea"),
    CheckBoxSettings(title: "Vomiting"),
    CheckBoxSettings(title: "Diarrhea"),
    CheckBoxSettings(title: "Constipation"),
    CheckBoxSettings(title: "Headache"),
    CheckBoxSettings(title: "Fever or flu-like symptoms"),
    CheckBoxSettings(title: "Cold"),
    CheckBoxSettings(title: "Frequent urination"),
    CheckBoxSettings(title: "Urinary tract discharges"),
    CheckBoxSettings(
        title: "Skin eruptions, including boils, hives, and rashes"),
    CheckBoxSettings(
        title: "Emotional Disturbances like anger, despair, sadness, fear"),
    CheckBoxSettings(title: "Anxiety, Mood swings, Phobias"),
    CheckBoxSettings(title: "Joints &/or Muscle Pain"),
    CheckBoxSettings(title: "Chills"),
    CheckBoxSettings(title: "Stuffy Nose"),
    CheckBoxSettings(title: "Congestion"),
    CheckBoxSettings(title: "Change in Blood Pressure"),
    CheckBoxSettings(title: "Severe Joint pain / Body ache"),
    CheckBoxSettings(title: "Dry cough / Dryness of mouth"),
    CheckBoxSettings(title: "Loss of appetite / tastelessness"),
    CheckBoxSettings(title: "Severe thirst"),
    CheckBoxSettings(title: "Weaker sense of hearing / vision"),
    CheckBoxSettings(
        title: "Reduction in physical, mental, and or digestive capacity"),
    CheckBoxSettings(title: "Feeling dizzy / giddiness"),
    CheckBoxSettings(title: "Mind agitation"),
    CheckBoxSettings(title: "Weakness / restlessness / cramps / sleeplessness"),
    CheckBoxSettings(title: "None Of The Above"),
  ];
  List selectedSymptoms1 = [];

  final symptomsCheckBox2 = <CheckBoxSettings>[
    CheckBoxSettings(
        title:
        "Satisfactory release of Solid waste matter / Gas from stomach and or Urine"),
    CheckBoxSettings(title: "Lightness in the Chest / Abdomen"),
    CheckBoxSettings(title: "Odour free burps"),
    CheckBoxSettings(title: "Freshness in the Mouth"),
    CheckBoxSettings(title: "Easily getting hungry, thirsty, or both"),
    CheckBoxSettings(
        title:
        "Clear tongue/Sense (absence of discharges from sense organs such as the skin's sweat or perspiration, the ears, the nose, the tongue, and the eyes)"),
    CheckBoxSettings(title: "Odour free breath"),
    CheckBoxSettings(title: "No Body odour"),
    CheckBoxSettings(title: "Weight loss"),
    CheckBoxSettings(title: "Peaceful Sleep"),
    CheckBoxSettings(title: "Easy Digestion"),
    CheckBoxSettings(title: "Increased energy levels"),
    CheckBoxSettings(title: "Reduced / absence of cravings"),
    CheckBoxSettings(title: "Feeling of internal wellbeing and happiness"),
    CheckBoxSettings(
        title:
        "Reduced / Absence of Detox related Recovery symptoms as mentioned in the previous question"),
    CheckBoxSettings(title: "None of the above"),
  ];

  List selectedSymptoms2 = [];

  String selectedCalmModule = '';

  final worriesController = TextEditingController();
  final eatSomethingController = TextEditingController();
  final anyMedicationsController = TextEditingController();

  final List<Question> questions = [
    Question(
      'Did you deal with any of the following withdrawal symptoms from detox today? If "Yes," then choose all that apply. If no, choose none of the above.',
    ),
    Question(
      'Did any of the following (adequate) detoxification / healing signs and symptoms happen to you today? If "Yes," then choose all that apply. If no, choose none of the above.',
    ),
    Question(
      'Please let us know if you notice any other signs or have any other worries. If none, enter "No."',
    ),
    Question(
      'Did you eat something other than what was on your meal plan? If "Yes", please give more information? If not, type "No."',
    ),
    Question(
      'Did you complete the Calm and Move modules suggested today?',
    ),
    Question(
      'Have you had a medical exam or taken any medications during the program? If "Yes", please give more information. Type "No" if not.',
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mealPlanMissedController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mealPlanMissedController.removeListener(() {});
  }

  double headingFont = 12.sp;
  double subHeadingFont = 10.sp;
  double questionFont = 10.sp;

  @override
  Widget build(BuildContext context) {
    print("Video Player : ${widget.trackerVideoLink}");
    return SafeArea(
      child: Scaffold(
        body: mainView(),
      ),
    );
  }

  mainView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  child: buildAppBar(() {}, isBackEnable: true),
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  Container(
                    height: 15.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(22)),
                      color: kBottomSheetHeadYellow,
                    ),
                    child: Center(
                      child: Image.asset(
                        bsHeadStarsIcon,
                        alignment: Alignment.topRight,
                        fit: BoxFit.scaleDown,
                        width: 30.w,
                        height: 10.h,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.maxFinite,
                      padding:
                      EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                      decoration: const BoxDecoration(
                        color: gBackgroundColor,
                        // borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(22),
                        //     topRight: Radius.circular(22)),
                      ),
                      child: Column(
                        children: [
                          videoMp4Widget(
                              videoName: "Know more about Symptoms Tracker",
                              onTap: () {
                                addTrackerUrlToChewiePlayer(
                                    widget.trackerVideoLink ?? '');
                                // addTrackerUrlToVideoPlayer(widget.trackerVideoLink ?? '');
                                setState(() {
                                  showMealVideo = true;
                                });
                              }),
                          SizedBox(height: 1.h),
                          Expanded(
                              child: Stack(
                                children: [
                                  PageView.builder(
                                      itemCount: 7,
                                      physics: NeverScrollableScrollPhysics(),
                                      controller: _pageController,
                                      itemBuilder: (context, index) {
                                        return pages[index];
                                      }),
                                  Visibility(
                                    visible: showMealVideo,
                                    child: Positioned(child: Center(
                                        child: buildMealVideo(onTap: () async {
                                          setState(() {
                                            showMealVideo = false;
                                          });
                                          if (await Wakelock.enabled == true) {
                                            Wakelock.disable();
                                          }
                                          if (_sheetVideoController != null)
                                            _sheetVideoController!.dispose();
                                          if (_sheetChewieController != null)
                                            _sheetChewieController!.dispose();

                                          // await _mealPlayerController!.stopRendererScanning();
                                          // await _mealPlayerController!.dispose();
                                        }))),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                top: 15.h,
                left: 5,
                right: 5,
                child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5,
                            color: gHintTextColor.withOpacity(0.8))
                      ],
                    ),
                    child: CircleAvatar(
                      maxRadius: 40.sp,
                      backgroundColor: kBottomSheetHeadCircleColor,
                      child: Image.asset(
                        bsHeadBellIcon,
                        fit: BoxFit.scaleDown,
                        width: 45,
                        height: 45,
                      ),
                    ))),
            Positioned(
                top: 21.h,
                right: 3.w,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      if(widget.isPreviousDaySheet){
                        Navigator.pop(context);
                      }
                    },
                    child: Icon(
                      Icons.cancel_outlined,
                      color: gsecondaryColor,
                      size: 28,
                    ))),
          ],
        );
      },
    );
  }

  videoPlayerView() {
    return PIPStack(
      shrinkAlignment: Alignment.bottomRight,
      backgroundWidget: backgroundWidgetForPIP(),
      pipWidget: isEnabled
          ? Consumer<CheckState>(
        builder: (_, model, __) {
          Wakelock.enable();
          print("model.isChanged: ${model.isChanged} $isEnabled");
          if (model.isChanged) {}
          return Container(
            color: Colors.black,
            child: Center(
                child: Chewie(
                  controller: _yogaChewieController!,
                )),
          );
          // return VlcPlayerWithControls(
          //   key: _key,
          //   controller: _controller!,
          //   showVolume: false,
          //   showVideoProgress: !model.isChanged,
          //   seekButtonIconSize: 10.sp,
          //   playButtonIconSize: 14.sp,
          //   replayButtonSize: 14.sp,
          //   showFullscreenBtn: true,
          // );
        },
      )
      //     ? FutureBuilder(
      //   future: _initializeVideoPlayerFuture,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       // If the VideoPlayerController has finished initialization, use
      //       // the data it provides to limit the aspect ratio of the video.
      //       return VlcPlayer(
      //         controller: _videoPlayerController,
      //         aspectRatio: 16 / 9,
      //         placeholder: Center(child: CircularProgressIndicator()),
      //       );
      //     } else {
      //       // If the VideoPlayerController is still initializing, show a
      //       // loading spinner.
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // )
      //     ? Container(
      //   color: Colors.pink,
      // )
          : const SizedBox(),
      pipEnabled: isEnabled,
      pipExpandedHeight: double.infinity,
      onClosed: () async {
        // await _controller.stop();
        // await _controller.dispose();
        setState(() {
          isEnabled = !isEnabled;
        });
        if (await Wakelock.enabled) {
          Wakelock.disable();
        }
        if (_yogaVideoController != null) _yogaVideoController!.dispose();
        if (_yogaChewieController != null) _yogaChewieController!.dispose();

        // if (_trackerVideoPlayerController != null) _trackerVideoPlayerController!.stop();
      },
      onPip: () async {
        setState(() {
          isEnabled = true;
        });
        final _ori = MediaQuery.of(context).orientation;
        print(_ori.name);
        bool isPortrait = _ori == Orientation.portrait;
        if (!isPortrait) {
          AutoOrientation.portraitUpMode();
        }
      },
    );
  }

  backgroundWidgetForPIP() {
    return mainView();
  }

  showRespectiveWidget() {
    if (selectedMissedAnything.contains(missedAnything[0])) {
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
                    "Missed Items",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: "PoppinsBold",
                        color: kPrimaryColor,
                        fontSize: 11.sp),
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
                "Important to understand if this will affect your program & how we can fix it :)",
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
          buildLabelTextField(
              "What Did you Miss In Your Meal Plan Or Yoga Today?"),
          SizedBox(
            height: 0.5.h,
          ),
          TextFormField(
            controller: mealPlanMissedController,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Mention What Did you Miss In Your Meal Plan Or Yoga Today?';
              } else {
                return null;
              }
            },
            decoration: CommonDecoration.buildTextInputDecoration(
                "Your answer", mealPlanMissedController),
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
          ),
          SizedBox(
            height: 3.h,
          ),
          if (mealPlanMissedController.text.isNotEmpty) symptomsTracker()
        ],
      );
    } else if (selectedMissedAnything.contains(missedAnything[1])) {
      return symptomsTracker();
    } else
      return SizedBox.shrink();
  }

  buildNextButton(String pageNo, VoidCallback func) {
    return Align(
      alignment: Alignment.topRight,
      child: IntrinsicWidth(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: eUser().buttonColor,
              onSurface: eUser().buttonTextColor,
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(eUser().buttonBorderRadius)),
            ),
            onPressed: func,
            child: Center(
              child: Text(
                pageNo,
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
    );
  }

  symptomsTracker() {
    return Form(
      key: formKey,
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
                    "Symptom Tracker",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: kFontMedium,
                        color: gBlackColor,
                        fontSize: headingFont),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: kLineColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "For your doctor to know if you are on track :)",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gHintTextColor,
                    fontSize: subHeadingFont),
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          buildLabelTextField(
              'Did you deal with any of the following withdrawal symptoms from detox today? If "Yes," then choose all that apply. If no, choose none of the above.',
              fontSize: questionFont),
          SizedBox(
            height: 1.h,
          ),
          ...symptomsCheckBox1.map((e) => buildHealthCheckBox(e, '1', (){})).toList(),
          SizedBox(
            height: 1.h,
          ),
          buildLabelTextField(
              'Did any of the following (adequate) detoxification / healing signs and symptoms happen to you today? If "Yes," then choose all that apply. If no, choose none of the above.',
              fontSize: questionFont),
          SizedBox(
            height: 2.h,
          ),
          ...symptomsCheckBox2.map((e) => buildHealthCheckBox(e, '2', (){})).toList(),
          SizedBox(
            height: 2.h,
          ),
          buildLabelTextField(
              'Please let us know if you notice any other signs or have any other worries. If none, enter "No."',
              fontSize: questionFont),
          TextFormField(
            controller: worriesController,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please let us know if you notice any other signs or have any other worries.';
              } else {
                return null;
              }
            },
            decoration: CommonDecoration.buildTextInputDecoration(
                "Your answer", worriesController),
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.name,
          ),
          SizedBox(
            height: 3.h,
          ),
          buildLabelTextField(
              'Did you eat something other than what was on your meal plan? If "Yes", please give more information? If not, type "No."',
              fontSize: questionFont),
          TextFormField(
            controller: eatSomethingController,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Did you eat something other than what was on your meal plan?';
              } else {
                return null;
              }
            },
            decoration: CommonDecoration.buildTextInputDecoration(
                "Your answer", eatSomethingController),
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.name,
          ),
          SizedBox(
            height: 3.h,
          ),
          buildLabelTextField(
              'Did you complete the Calm and Move modules suggested today?',
              fontSize: questionFont),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCalmModule = "Yes";
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 25,
                      child: Radio(
                        value: "Yes",
                        activeColor: kPrimaryColor,
                        groupValue: selectedCalmModule,
                        onChanged: (value) {
                          setState(() {
                            selectedCalmModule = value as String;
                          });
                        },
                      ),
                    ),
                    Text(
                      'Yes',
                      style: buildTextStyle(
                          color: selectedCalmModule == 'Yes'
                              ? kTextColor
                              : gHintTextColor,
                          fontFamily: selectedCalmModule == 'Yes'
                              ? kFontMedium
                              : kFontBook),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCalmModule = "No";
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 25,
                      child: Radio(
                        value: "No",
                        activeColor: kPrimaryColor,
                        groupValue: selectedCalmModule,
                        onChanged: (value) {
                          setState(() {
                            selectedCalmModule = value as String;
                          });
                        },
                      ),
                    ),
                    Text(
                      'No',
                      style: buildTextStyle(
                          color: selectedCalmModule == 'No'
                              ? kTextColor
                              : gHintTextColor,
                          fontFamily: selectedCalmModule == 'No'
                              ? kFontMedium
                              : kFontBook),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          buildLabelTextField(
              'Have you had a medical exam or taken any medications during the program? If "Yes", please give more information. Type "No" if not.',
              fontSize: questionFont),
          TextFormField(
            controller: anyMedicationsController,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Have you had a medical exam or taken any medications during the program?';
              } else {
                return null;
              }
            },
            decoration: CommonDecoration.buildTextInputDecoration(
                "Your answer", anyMedicationsController),
            textInputAction: TextInputAction.done,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.name,
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: eUser().buttonColor,
                  onSurface: eUser().buttonTextColor,
                  padding:
                  EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(eUser().buttonBorderRadius)),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (selectedCalmModule.isNotEmpty) {
                      if (selectedSymptoms1.isNotEmpty) {
                        if (selectedSymptoms2.isNotEmpty) {
                          // proceed(set);
                        } else {
                          Get.snackbar(
                            "",
                            'Please select Detoxification/healing signs',
                            titleText: SizedBox.shrink(),
                            colorText: gWhiteColor,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: gsecondaryColor.withOpacity(0.55),
                          );
                          // AppConfig().showSnackbar(context, "Please select Detoxification/healing signs", isError: true);
                        }
                      } else {
                        Get.snackbar(
                          "",
                          'Please select withdrawal symptoms',
                          titleText: SizedBox.shrink(),
                          colorText: gWhiteColor,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: gsecondaryColor.withOpacity(0.55),
                        );
                        // AppConfig().showSnackbar(context, "Please select withdrawal symptoms", isError: true);
                      }
                    } else {
                      Get.snackbar(
                        "",
                        'Please select Calm & Move Modules',
                        titleText: SizedBox.shrink(),
                        colorText: gWhiteColor,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: gsecondaryColor.withOpacity(0.55),
                      );
                      // Get.showSnackbar(context, "Please select Calm & Move Modules", isError: true);
                    }
                  }
                },
                child: Center(
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
            ],
          ),
          SizedBox(
            height: 5.h,
          )
        ],
      ),
    );
  }

  buildHealthCheckBox(CheckBoxSettings healthCheckBox, String from, Function setstate) {
    return IntrinsicWidth(
      child: CheckboxListTile(
        visualDensity: VisualDensity(vertical: -3), // to compact
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
        controlAffinity: ListTileControlAffinity.leading,
        title: Transform.translate(
          offset: const Offset(-10, 0),
          child: Text(
            healthCheckBox.title.toString(),
            style: buildTextStyle(
                color: healthCheckBox.value == true
                    ? kTextColor
                    : gHintTextColor,
                fontFamily:
                healthCheckBox.value == true ? kFontMedium : kFontBook),
          ),
        ),
        dense: true,
        activeColor: kPrimaryColor,
        value: healthCheckBox.value,
        onChanged: (v) {
          print(v);
          if (from == '1') {
            if (healthCheckBox.title == symptomsCheckBox1.last.title) {
              print("if");
              setstate(() {
                selectedSymptoms1.clear();
                symptomsCheckBox1.forEach((element) {
                  element.value = false;
                });
                if(v == true){
                  selectedSymptoms1.add(healthCheckBox.title!);
                }
                healthCheckBox.value = v;
              });
            }
            else {
              print("else");
              if (selectedSymptoms1.contains(symptomsCheckBox1.last.title)) {
                print("if");
                setstate(() {
                  selectedSymptoms1.clear();
                  symptomsCheckBox1.last.value = false;
                });
              }
              if (v == true) {
                setstate(() {
                  selectedSymptoms1.add(healthCheckBox.title!);
                  healthCheckBox.value = v;
                });
              } else {
                setstate(() {
                  selectedSymptoms1.remove(healthCheckBox.title!);
                  healthCheckBox.value = v;
                });
              }
            }
            print(selectedSymptoms1);
          } else if (from == '2') {
            if (healthCheckBox.title == symptomsCheckBox2.last.title) {
              print("if");
              setstate(() {
                selectedSymptoms2.clear();
                symptomsCheckBox2.forEach((element) {
                  element.value = false;
                  // if(element.title != symptomsCheckBox2.last.title){
                  // }
                });
                if (v == true) {
                  selectedSymptoms2.add(healthCheckBox.title);
                  healthCheckBox.value = v;
                } else {
                  selectedSymptoms2.remove(healthCheckBox.title!);
                  healthCheckBox.value = v;
                }
              });
            } else {
              // print("else");
              if (v == true) {
                // print("if");
                setstate(() {
                  if (selectedSymptoms2
                      .contains(symptomsCheckBox2.last.title)) {
                    // print("if");
                    selectedSymptoms2.removeWhere(
                            (element) => element == symptomsCheckBox2.last.title);
                    symptomsCheckBox2.forEach((element) {
                      element.value = false;
                    });
                  }
                  selectedSymptoms2.add(healthCheckBox.title!);
                  healthCheckBox.value = v;
                });
              } else {
                setstate(() {
                  selectedSymptoms2.remove(healthCheckBox.title!);
                  healthCheckBox.value = v;
                });
              }
            }
            print(selectedSymptoms2);
          }
        },
      ),
    );

    return ListTile(
      visualDensity: VisualDensity(vertical: -3), // to compact
      minVerticalPadding: 0,
      minLeadingWidth: 30,
      horizontalTitleGap: 0,
      dense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      leading: SizedBox(
        width: 24,
        height: 10,
        child: Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: kPrimaryColor,
          value: healthCheckBox.value,
          onChanged: (v) {
            if (from == '1') {
              if (healthCheckBox.title == symptomsCheckBox1.last.title) {
                print("if");
                setState(() {
                  selectedSymptoms1.clear();
                  symptomsCheckBox1.forEach((element) {
                    element.value = false;
                  });
                  selectedSymptoms1.add(healthCheckBox.title!);
                  healthCheckBox.value = v;
                });
              } else {
                print("else");
                if (selectedSymptoms1.contains(symptomsCheckBox1.last.title)) {
                  print("if");
                  setState(() {
                    selectedSymptoms1.clear();
                    symptomsCheckBox1.last.value = false;
                  });
                }
                if (v == true) {
                  setState(() {
                    selectedSymptoms1.add(healthCheckBox.title!);
                    healthCheckBox.value = v;
                  });
                } else {
                  setState(() {
                    selectedSymptoms1.remove(healthCheckBox.title!);
                    healthCheckBox.value = v;
                  });
                }
              }
              print(selectedSymptoms1);
            } else if (from == '2') {
              if (healthCheckBox.title == symptomsCheckBox2.last.title) {
                print("if");
                setState(() {
                  selectedSymptoms2.clear();
                  symptomsCheckBox2.forEach((element) {
                    element.value = false;
                    // if(element.title != symptomsCheckBox2.last.title){
                    // }
                  });
                  if (v == true) {
                    selectedSymptoms2.add(healthCheckBox.title);
                    healthCheckBox.value = v;
                  } else {
                    selectedSymptoms2.remove(healthCheckBox.title!);
                    healthCheckBox.value = v;
                  }
                });
              } else {
                // print("else");
                if (v == true) {
                  // print("if");
                  setState(() {
                    if (selectedSymptoms2
                        .contains(symptomsCheckBox2.last.title)) {
                      // print("if");
                      selectedSymptoms2.removeWhere(
                              (element) => element == symptomsCheckBox2.last.title);
                      symptomsCheckBox2.forEach((element) {
                        element.value = false;
                      });
                    }
                    selectedSymptoms2.add(healthCheckBox.title!);
                    healthCheckBox.value = v;
                  });
                } else {
                  setState(() {
                    selectedSymptoms2.remove(healthCheckBox.title!);
                    healthCheckBox.value = v;
                  });
                }
              }
              print(selectedSymptoms2);
            }
            // print("${healthCheckBox.title}=> ${healthCheckBox.value}");
          },
        ),
      ),
      title: Text(
        healthCheckBox.title.toString(),
        style: buildTextStyle(
            color: healthCheckBox.value == true ? kTextColor : gHintTextColor,
            fontFamily: healthCheckBox.value == true ? kFontMedium : kFontBook),
      ),
    );
  }

  void proceed(setstate) async {
    ProceedProgramDayModel? model;
    print("day => ${widget.proceedProgramDayModel!.day}");
    model = (ProgramMealType.detox.name == widget.from
        || ProgramMealType.healing.name == widget.from)
        ? ProceedProgramDayModel(
        patientMealTracking:
        widget.proceedProgramDayModel!.patientMealTracking,
        comment: widget.proceedProgramDayModel!.comment,
        userProgramStatusTracking: '1',
        day: widget.proceedProgramDayModel!.day,
        missedAnyThingRadio: widget
            .proceedProgramDayModel!.patientMealTracking!
            .any((element) => element.status == 'unfollowed')
            ? missedAnything[0]
            : missedAnything[1],
        // didUMiss: mealPlanMissedController.text,
        didUMiss: widget.proceedProgramDayModel!.comment,
        withdrawalSymptoms: selectedSymptoms1.join(','),
        detoxification: selectedSymptoms2.join(','),
        haveAnyOtherWorries: worriesController.text,
        eatSomthingOther: eatSomethingController.text,
        completedCalmMoveModules: selectedCalmModule,
        hadAMedicalExamMedications: anyMedicationsController.text)
        : ProceedProgramDayModel(
        day: widget.proceedProgramDayModel!.day,
        userProgramStatusTracking: '1',

        //missedAnyThingRadio: selectedMissedAnything,
        // didUMiss: mealPlanMissedController.text,
        //didUMiss: "",
        withdrawalSymptoms: selectedSymptoms1.join(','),
        detoxification: selectedSymptoms2.join(','),
        haveAnyOtherWorries: worriesController.text,
        eatSomthingOther: eatSomethingController.text,
        completedCalmMoveModules: selectedCalmModule,
        hadAMedicalExamMedications: anyMedicationsController.text,);
    setstate(() {
      showProgress = true;
    });
    final result = (ProgramMealType.detox.name == widget.from)
        ? await ProgramService(repository: repository)
        .proceedDayMealDetailsService(model, newList, "detox")
        : (ProgramMealType.healing.name == widget.from)
        ? await ProgramService(repository: repository)
        .proceedDayMealDetailsService(model, newList, "healing")
        : await PrepratoryMealService(repository: prepRepository)
        .proceedDayMealDetailsService(model);

    print("result: $result");

    if (result.runtimeType == GetProceedModel) {
      setstate(() {
        showProgress = false;
      });
      final _pref = AppConfig().preferences;
      final trackerUrl = _pref!.getString(AppConfig().trackerVideoUrl);

      (ProgramMealType.detox.name == widget.from)
          ? Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) =>
              CombinedPrepMealTransScreen(stage: 1)
              // MealPlanScreen()
          ),
              (route) => route.isFirst)
          : (ProgramMealType.healing.name == widget.from)
          ? Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) =>
              CombinedPrepMealTransScreen(stage: 2)
            // MealPlanScreen()
          ),
              (route) => route.isFirst)
          : Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CombinedPrepMealTransScreen(stage: 3)
                // NewTransitionDesign(
                // totalDays: '', dayNumber: '', trackerVideoLink: trackerUrl),
          ),
              (route) => route.isFirst);
    }
    else {
      setstate(() {
        showProgress = false;
      });
      ErrorModel model = result as ErrorModel;
      AppConfig().showSnackbar(context, model.message ?? '', isError: true);
    }
  }

  final ProgramRepository repository = ProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final PrepratoryRepository prepRepository = PrepratoryRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  Widget buildQuestion1() {
    return StatefulBuilder(builder: (_, setstate) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Gut Detox Program Status Tracker",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: kFontMedium,
                      color: gBlackColor,
                      fontSize: headingFont),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: kLineColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Text(
              "Your detox & healing program tracker that takes less than 1 minute to fill but essential for your doctors to track, manage & intervene effectively.",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontFamily: kFontMedium,
                  height: 1.4,
                  color: gHintTextColor,
                  fontSize: subHeadingFont),
            ),
            SizedBox(height: 2.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Symptom Tracker",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: kFontMedium,
                      color: gBlackColor,
                      fontSize: headingFont),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Container(
                    height: 1,
                    color: kLineColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Text(
              "For your doctor to know if you are on track :)",
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontFamily: kFontMedium,
                  color: gHintTextColor,
                  fontSize: subHeadingFont),
            ),
            SizedBox(height: 2.h),
            buildLabelTextField(
                'Did you deal with any of the following withdrawal symptoms from detox today? If "Yes," then choose all that apply. If no, choose none of the above.',
                fontSize: questionFont),
            SizedBox(
              height: 1.h,
            ),
            ...symptomsCheckBox1
                .map((e) => buildHealthCheckBox(e, '1', setstate))
                .toList(),
            buildNextButton("01/07", () {
              if (selectedSymptoms1.isNotEmpty) {
                _pageController
                    .nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear)
                    .then((value) {
                  Scrollable.ensureVisible(question2.currentContext!,
                      duration: const Duration(milliseconds: 200));
                });
              }
              else {
                Get.snackbar(
                  "",
                  'Please select withdrawal symptoms',
                  titleText: const SizedBox.shrink(),
                  colorText: gWhiteColor,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: gsecondaryColor.withOpacity(0.55),
                );
              }
            }),
            SizedBox(height: 2.h),
          ],
        ),
      );
    });
  }

  Widget buildQuestion2() {
    return StatefulBuilder(builder: (_, setstate) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabelTextField(
                'Did any of the following (adequate) detoxification / healing signs and symptoms happen to you today? If "Yes," then choose all that apply. If no, choose none of the above.',
                fontSize: questionFont,
                key: question2),
            SizedBox(
              height: 2.h,
            ),
            ...symptomsCheckBox2
                .map((e) => buildHealthCheckBox(e, '2', setstate))
                .toList(),
            buildNextButton("02/07", () {
              if (selectedSymptoms2.isNotEmpty) {
                _pageController
                    .nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear)
                    .then((value) {
                  Scrollable.ensureVisible(question3.currentContext!,
                      duration: const Duration(milliseconds: 200));
                });
              } else {
                Get.snackbar(
                  "",
                  'Please select Detoxification/healing signs',
                  titleText: const SizedBox.shrink(),
                  colorText: gWhiteColor,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: gsecondaryColor.withOpacity(0.55),
                );
              }
            }),
            SizedBox(height: 2.h),
          ],
        ),
      );
    });
  }

  Widget buildQuestion3() {
    return StatefulBuilder(builder: (_, setstate) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabelTextField(
                'Please let us know if you notice any other signs or have any other worries. If none, enter "No."',
                fontSize: questionFont,
                key: question3),
            TextFormField(
              controller: worriesController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please let us know if you notice any other signs or have any other worries.';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", worriesController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
            ),
            buildNextButton("03/07", () {
              if (worriesController.text.isNotEmpty) {
                _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              } else {
                Get.snackbar(
                  "",
                  'Please Enter Your Answer',
                  titleText: SizedBox.shrink(),
                  colorText: gWhiteColor,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: gsecondaryColor.withOpacity(0.55),
                );
              }
            }),
            SizedBox(height: 2.h),
          ],
        ),
      );
    });
  }

  Widget buildQuestion4() {
    return StatefulBuilder(builder: (_, setstate) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabelTextField(
                'Did you eat something other than what was on your meal plan? If "Yes", please give more information? If not, type "No."',
                fontSize: questionFont),
            TextFormField(
              controller: eatSomethingController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Did you eat something other than what was on your meal plan?';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", eatSomethingController),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
            ),
            buildNextButton("04/07", () {
              if (eatSomethingController.text.isNotEmpty) {
                _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              } else {
                Get.snackbar(
                  "",
                  'Please Enter Your Answer',
                  titleText: SizedBox.shrink(),
                  colorText: gWhiteColor,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: gsecondaryColor.withOpacity(0.55),
                );
              }
            }),
            SizedBox(height: 2.h),
          ],
        ),
      );
    });
  }

  Widget buildQuestion5() {
    return StatefulBuilder(builder: (_, setstate) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabelTextField(
                'Did you complete the Calm and Move modules suggested today?',
                fontSize: questionFont),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setstate(() {
                      selectedCalmModule = "Yes";
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 25,
                        child: Radio(
                          value: "Yes",
                          activeColor: kPrimaryColor,
                          groupValue: selectedCalmModule,
                          onChanged: (value) {
                            setstate(() {
                              selectedCalmModule = value as String;
                            });
                          },
                        ),
                      ),
                      Text(
                        'Yes',
                        style: buildTextStyle(
                            color: selectedCalmModule == 'Yes'
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily: selectedCalmModule == 'Yes'
                                ? kFontMedium
                                : kFontBook),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                GestureDetector(
                  onTap: () {
                    setstate(() {
                      selectedCalmModule = "No";
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 25,
                        child: Radio(
                          value: "No",
                          activeColor: kPrimaryColor,
                          groupValue: selectedCalmModule,
                          onChanged: (value) {
                            setstate(() {
                              selectedCalmModule = value as String;
                            });
                          },
                        ),
                      ),
                      Text(
                        'No',
                        style: buildTextStyle(
                            color: selectedCalmModule == 'No'
                                ? kTextColor
                                : gHintTextColor,
                            fontFamily: selectedCalmModule == 'No'
                                ? kFontMedium
                                : kFontBook),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            buildNextButton("05/07", () {
              if (selectedCalmModule.isNotEmpty) {
                _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              } else {
                Get.snackbar(
                  "",
                  'Please select Calm & Move Modules',
                  titleText: const SizedBox.shrink(),
                  colorText: gWhiteColor,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: gsecondaryColor.withOpacity(0.55),
                );
              }
            }),
            SizedBox(height: 2.h),
          ],
        ),
      );
    });
  }

  Widget buildQuestion6() {
    return StatefulBuilder(builder: (_, setstate) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabelTextField(
                'Have you had a medical exam or taken any medications during the program? If "Yes", please give more information. Type "No" if not.',
                fontSize: questionFont),
            TextFormField(
              controller: anyMedicationsController,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Have you had a medical exam or taken any medications during the program?';
                } else {
                  return null;
                }
              },
              decoration: CommonDecoration.buildTextInputDecoration(
                  "Your answer", anyMedicationsController),
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
            ),
            buildNextButton("06/07", () {
              if (anyMedicationsController.text.isNotEmpty) {
                _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              } else {
                Get.snackbar(
                  "",
                  'Please Enter Your Answer',
                  titleText: const SizedBox.shrink(),
                  colorText: gWhiteColor,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: gsecondaryColor.withOpacity(0.55),
                );
              }
            }),
            SizedBox(height: 2.h),
          ],
        ),
      );
    });
  }

  buildQuestion7() {
    return StatefulBuilder(builder: (_, setState) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 2.h),
            Text(
              "Any image you would like to share with your doctor?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: questionFont,
                color: gBlackColor,
                height: 1.35,
                fontFamily: kFontMedium,
              ),
            ),
            SizedBox(height: 3.h),
            GestureDetector(
              onTap: () async {
                final result = await FilePicker.platform
                    .pickFiles(withReadStream: true, allowMultiple: false);

                if (result == null) return;
                if (result.files.first.extension!.contains("png") ||
                    result.files.first.extension!.contains("jpg") ||
                    result.files.first.extension!.contains("jpeg")) {
                  medicalRecords.add(result.files.first);
                  addFilesToList(File(result.paths.first!));
                } else {
                  AppConfig().showSnackbar(
                      context, "Please select png/jpg/jpeg files",
                      isError: true);
                }

                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: gHintTextColor.withOpacity(0.3), width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.file_upload_outlined,
                      color: gsecondaryColor,
                      size: 2.5.h,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Add File',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: gsecondaryColor,
                        fontFamily: "GothamMedium",
                      ),
                    )
                  ],
                ),
              ),
            ),
            (medicalRecords.isEmpty)
                ? SizedBox()
                : Center(
              child: SizedBox(
                height: 27.h,
                child: ListView.builder(
                  itemCount: medicalRecords.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final file = medicalRecords[index];
                    return buildFile(file, index);
                  },
                ),
              ),
            ),
            SizedBox(height: 2.h),
            IntrinsicWidth(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: eUser().buttonColor,
                    onSurface: eUser().buttonTextColor,
                    padding:
                    EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(eUser().buttonBorderRadius)),
                  ),
                  onPressed: () {
                    proceed(setState);
                  },
                  child: showProgress
                      ? buildThreeBounceIndicator(color: gWhiteColor)
                      : Center(
                    child: Text(
                      "Submit",
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
      );
    });
  }

  addFilesToList(File file) async {
    print("file: ${file}");
    newList.clear();
    setState(() {
      fileFormatList.add(file);
    });

    for (int i = 0; i < fileFormatList.length; i++) {
      var stream =
      http.ByteStream(DelegatingStream.typed(fileFormatList[i].openRead()));
      var length = await fileFormatList[i].length();
      var multipartFile = http.MultipartFile(
          "tracking_attachment", stream, length,
          filename: fileFormatList[i].path);
      newList.add(multipartFile);
      print("newList : $newList");
    }

    setState(() {});
  }

  Widget buildFile(PlatformFile file, int index) {
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final size = (mb >= 1)
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Image.file(
        File(file.path.toString()),
        width: 30.w,
        height: 20.h,
      ),
    );
  }

  videoMp4Widget({required VoidCallback onTap, String? videoName}) {
    return InkWell(
      onTap: onTap,
      child: Card(
          child: Row(children: [
            Image.asset(
              "assets/images/meal_placeholder.png",
              height: 35,
              width: 40,
            ),
            Expanded(
                child: Text(
                  videoName ?? "Symptom Tracker.mp4",
                  style: TextStyle(fontFamily: kFontBook),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "assets/images/arrow_for_video.png",
                height: 35,
              ),
            )
          ])),
    );
  }

  // addTrackerUrlToVideoPlayer(String url) async {
  //   print("url" + url);
  //   _trackerVideoPlayerController = VlcPlayerController.network(
  //     Uri.parse(url).toString(),
  //     // url,
  //     // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
  //     // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
  //     hwAcc: HwAcc.auto,
  //     autoPlay: true,
  //     options: VlcPlayerOptions(
  //       advanced: VlcAdvancedOptions([
  //         VlcAdvancedOptions.networkCaching(2000),
  //       ]),
  //       subtitle: VlcSubtitleOptions([
  //         VlcSubtitleOptions.boldStyle(true),
  //         VlcSubtitleOptions.fontSize(30),
  //         VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
  //         VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
  //         // works only on externally added subtitles
  //         VlcSubtitleOptions.color(VlcSubtitleColor.navy),
  //       ]),
  //       http: VlcHttpOptions([
  //         VlcHttpOptions.httpReconnect(true),
  //       ]),
  //       rtp: VlcRtpOptions([
  //         VlcRtpOptions.rtpOverRtsp(true),
  //       ]),
  //     ),
  //   );
  //   _trackerVideoPlayerController!.play();
  //   if (await Wakelock.enabled == false) {
  //     Wakelock.enable();
  //   }
  // }
  addTrackerUrlToChewiePlayer(String url) async {
    print("url" + url);
    _sheetVideoController =
        VideoPlayerController.network(Uri.parse(url).toString());
    _sheetChewieController = ChewieController(
        videoPlayerController: _sheetVideoController!,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        allowedScreenSleep: false,
        hideControlsTimer: Duration(seconds: 3),
        showControls: false);
    if (await Wakelock.enabled == false) {
      Wakelock.enable();
    }
  }

  buildMealVideo({required VoidCallback onTap}) {
    if (_sheetChewieController != null) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gPrimaryColor, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Center(
                    child: OverlayVideo(
                      controller: _sheetChewieController!,
                      isControlsVisible: false,
                    )),
              ),
            ),
          ),
          Center(
              child: IconButton(
                icon: Icon(
                  Icons.cancel_outlined,
                  color: gsecondaryColor,
                ),
                onPressed: onTap,
              ))
        ],
      );
    }
    // else if (_trackerVideoPlayerController != null) {
    //   return Column(
    //     children: [
    //       AspectRatio(
    //         aspectRatio: 16 / 9,
    //         child: Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(5),
    //             border: Border.all(color: gPrimaryColor, width: 1),
    //             // boxShadow: [
    //             //   BoxShadow(
    //             //     color: Colors.grey.withOpacity(0.3),
    //             //     blurRadius: 20,
    //             //     offset: const Offset(2, 10),
    //             //   ),
    //             // ],
    //           ),
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(5),
    //             child: Center(
    //                 child: VlcPlayerWithControls(
    //                   key: _trackerKey,
    //                   controller: _trackerVideoPlayerController!,
    //                   showVolume: false,
    //                   showVideoProgress: false,
    //                   seekButtonIconSize: 10.sp,
    //                   playButtonIconSize: 14.sp,
    //                   replayButtonSize: 10.sp,
    //                 )
    //             ),
    //           ),
    //         ),
    //       ),
    //       Center(
    //           child: IconButton(
    //         icon: Icon(
    //           Icons.cancel_outlined,
    //           color: gsecondaryColor,
    //         ),
    //         onPressed: onTap,
    //       ))
    //     ],
    //   );
    // }
    else {
      return SizedBox.shrink();
    }
  }

  Future<bool> _onWillPop() async {
    final _ori = MediaQuery.of(context).orientation;
    bool isPortrait = _ori == Orientation.portrait;
    if (!isPortrait) {
      AutoOrientation.portraitUpMode();
      // setState(() {
      //   isEnabled = false;
      // });
    }
    print(isEnabled);
    return !isEnabled ? true : false;
    // return false;
  }
}

class Question {
  String text;
  Question(this.text);
}
