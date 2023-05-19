import 'dart:ui';

List<DashboardStagesData> stageData = [
  DashboardStagesData(title:"Evaluation", subTitle:
    "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    rightImage: "assets/images/dashboard_stages/Evalutation.png",
    step: "1",
    btn1Name: "View File",
    type: StageType.evaluation
  ),
  DashboardStagesData(title:"Consultation", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43506.png",
    step: "2",
    btn1Name: "Schedule",
    type: StageType.med_consultation
  ),
  DashboardStagesData(title:"Requested Report", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
    step: "3",
    btn1Name: "Requested report",
      type: StageType.requested_report
  ),
  DashboardStagesData(title:"Medical Report", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
      rightImage: "assets/images/dashboard_stages/Mask Group 43510.png",
      step: "4",
      btn1Name: "Medical Report",
      type: StageType.medical_report
  ),
  DashboardStagesData(title:"Begin Gut Preparation", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43509.png",
    step: "5",
    btn1Name: "View Plan",
    btn2Name: "Track Kit",
      type: StageType.prep_meal
  ),
  DashboardStagesData(title:"Gut Reset Program Start", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43511.png",
    step: "6",
    btn1Name: "View Plan",
      type: StageType.normal_meal
  ),
  DashboardStagesData(title:"Post Program Consultation", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43506.png",
    step: "7",
    btn1Name: "Feedback",
    btn2Name: "Schedule",
      type: StageType.post_consultation
  ),
  DashboardStagesData(title:"GMG Program", subTitle:
  "Lorem lpsum is simply dummy text of the printing and typesetting industry.Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.",
    rightImage: "assets/images/dashboard_stages/Mask Group 43511.png",
    step: "8",
    btn1Name: "View GMG",
    btn2Name: "End report",
    btn3Name: "Track & Earn",
      type: StageType.gmg
  ),

];


updateStageData(int step){
  switch(step){
    case 2:


  }
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
    this.bgColor
});

}

enum StageType {
  evaluation,
  med_consultation,
  requested_report,
  medical_report,
  prep_meal,
  normal_meal,
  post_consultation,
  gmg
}
