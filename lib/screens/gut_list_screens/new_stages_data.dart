import 'dart:ui';

const String consultationStage2SubText = "Make sure to join your consultation within 5 minutes of your consultation time.";
const String consultationStage3SubText = "Congrats on completing your consultation, hope you had an insightful chat with your doctor.";

const String requestedReportStage2SubText = "Thanks for uploading your reports.\nYou doctor is now analyzing your case, allow us 2 working days to proceed to the next step.";

const String prepStage2SubText = "Prep your gut while your doctors finalizing your plan & ready your kit.";
const String prepStage3SubText = "Keep prepping your gut until your kit arrives.\nYour plan & kit are now ready, Ship your kit now!";


List<DashboardStagesData> stageData = [
  DashboardStagesData(title:"Evaluation", subTitle:
    "Congrats on completing your evaluation. This will help us select the right doctor for you based on the details you have entered & will give us preliminary analysis on the direction in which must start your treatment.",
    rightImage: "assets/images/dashboard_stages/Evalutation.png",
    step: "1",
    btn1Name: "View File",
    type: StageType.evaluation
  ),
  DashboardStagesData(title:"Consultation", subTitle:
  "Meet your doctor for a detailed consultation designed to understand the root cause of your condition & lay the ground work for your customized program creation.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43506.png",
    step: "2",
    btn1Name: "Schedule",
    type: StageType.med_consultation
  ),
  DashboardStagesData(
      title:"Request Report",
      subTitle: "Your doctor has requested for a few reports. Do upload them here to proceed further.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
    step: "3",
    btn1Name: "Requested report",
      type: StageType.requested_report
  ),
  DashboardStagesData(
      title:"Analysis",
      subTitle: "Your doctor is now analyzing your case, allow us 2 working days to proceed to the next step. We'll send you a notification when ready.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
      step: "4",
      type: StageType.requested_report
  ),
  DashboardStagesData(title:"Medical Report", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
      step: "5",
      btn1Name: "Medical Report",
      type: StageType.medical_report
  ),
  DashboardStagesData(title:"Gut Preparation",
      subTitle:
  "Before you program starts we must prime your gut for the detox & healing it will undergo, Start preparing your gut now.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43509.png",
    step: "6",
    btn1Name: "Prep",
      btn2Name: "Ship Kit",
      type: StageType.prep_meal
  ),
  DashboardStagesData(title:"Gut Reset Program Start", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43511.png",
    step: "7",
    btn1Name: "View Plan",
      type: StageType.normal_meal
  ),
  DashboardStagesData(title:"Post Program Consultation", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43506.png",
    step: "8",
    btn1Name: "Feedback",
    btn2Name: "Schedule",
      type: StageType.post_consultation
  ),
  DashboardStagesData(title:"GMG Program", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43511.png",
    step: "9",
    btn1Name: "View GMG",
    btn2Name: "End report",
    btn3Name: "Track & Earn",
      type: StageType.gmg
  ),

];

List<DashboardStagesData> defaultStageData = [
  DashboardStagesData(title:"Evaluation", subTitle:
  "Congrats on completing your evaluation. This will help us select the right doctor for you based on the details you have entered & will give us preliminary analysis on the direction in which must start your treatment.",
      rightImage: "assets/images/dashboard_stages/Evalutation.png",
      step: "1",
      btn1Name: "View File",
      type: StageType.evaluation
  ),
  DashboardStagesData(title:"Consultation", subTitle:
  "Meet your doctor for a detailed consultation designed to understand the root cause of your condition & lay the ground work for your customized program creation.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43506.png",
      step: "2",
      btn1Name: "Schedule",
      type: StageType.med_consultation
  ),
  DashboardStagesData(
      title:"Request Report",
      subTitle: "Your doctor has requested for a few reports. Do upload them here to proceed further.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
      step: "3",
      btn1Name: "Requested report",
      type: StageType.requested_report
  ),
  DashboardStagesData(
      title:"Analysis",
      subTitle: "Your doctor is now analyzing your case, allow us 2 working days to proceed to the next step. We'll send you a notification when ready.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
      step: "4",
      type: StageType.requested_report
  ),
  DashboardStagesData(title:"Medical Report", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
      step: "5",
      btn1Name: "Medical Report",
      type: StageType.medical_report
  ),
  DashboardStagesData(title:"Gut Preparation",
      subTitle:
      "Before you program starts we must prime your gut for the detox & healing it will undergo, Start preparing your gut now.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43509.png",
      step: "6",
      btn1Name: "Prep",
      btn2Name: "Ship Kit",
      type: StageType.prep_meal
  ),
  DashboardStagesData(title:"Gut Reset Program Start", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43511.png",
      step: "7",
      btn1Name: "View Plan",
      type: StageType.normal_meal
  ),
  DashboardStagesData(title:"Post Program Consultation", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43506.png",
      step: "8",
      btn1Name: "Feedback",
      btn2Name: "Schedule",
      type: StageType.post_consultation
  ),
  DashboardStagesData(title:"GMG Program", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43511.png",
      step: "9",
      btn1Name: "View GMG",
      btn2Name: "End report",
      btn3Name: "Track & Earn",
      type: StageType.gmg
  ),

];



updateStageData(){
 stageData = defaultStageData;
}


const stagesData = [
  {
    "title": "Evaluation",
    "subText":
        "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    "image": "assets/images/dashboard_stages/Evalutation.png",
    "step": "1",
  },
  {
    "title": "Consultation",
    "subText":
        "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    "image": "assets/images/dashboard_stages/Mask Group 43506.png",
    "step": "2",
  },
  {
    "title": "Upload Reports",
    "subText":
        "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    "image": "assets/images/dashboard_stages/Mask Group 43510.png",
    "step": "3",
  },
  {
    "title": "Begin Gut Preparation",
    "subText":
        "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    "image": "assets/images/dashboard_stages/Mask Group 43509.png",
    "step": "4",
  },
  {
    "title": "Gut Reset Program Start",
    "subText":
        "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    "image": "assets/images/dashboard_stages/Mask Group 43511.png",
    "step": "5",
  },
  {
    "title": "Post Program Consultation",
    "subText":
        "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    "image": "assets/images/dashboard_stages/Mask Group 43506.png",
    "step": "6",
  },
  {
    "title": "GMG Program",
    "subText":
        "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    "image": "assets/images/dashboard_stages/Mask Group 43511.png",
    "step": "7",
  },
];


class DashboardStagesData{
  String title;
  String subTitle;
  String rightImage;
  String step;
  String? btn1Name;
  // VoidCallback? btn1Tap;
  String? btn2Name;
  // VoidCallback? btn2Tap;
  String? btn3Name;
  // VoidCallback? btn3Tap;
  StageType type;
  Color? bgColor;
  Color? btn1Color;
  Color? btn2Color;
  Color? btn3Color;


  DashboardStagesData({
    required this.title,
    required this.subTitle,
    required this.rightImage,
    required this.step,
    this.btn1Name,
    // this.btn1Tap,
    this.btn2Name,
    // this.btn2Tap,
    this.btn3Name,
    // this.btn3Tap,
    required this.type,
    this.bgColor,
    this.btn1Color,
    this.btn2Color,
    this.btn3Color
});

}

enum StageType {
  evaluation,
  med_consultation,
  requested_report,
  analysis,
  medical_report,
  prep_meal,
  normal_meal,
  post_consultation,
  gmg
}
