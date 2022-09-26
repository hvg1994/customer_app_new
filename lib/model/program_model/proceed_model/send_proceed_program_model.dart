class ProceedProgramDayModel {
  List<PatientMealTracking>? patientMealTracking;
  String? comment;

  ProceedProgramDayModel({this.patientMealTracking, this.comment});

  ProceedProgramDayModel.fromJson(Map<String, dynamic> json) {
    if (json['patient_meal_tracking'] != null) {
      patientMealTracking = <PatientMealTracking>[];
      json['patient_meal_tracking'].forEach((v) {
        patientMealTracking!.add(new PatientMealTracking.fromJson(v));
      });
    }
    if(json['comment'] != null){
      comment = json['comment'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.patientMealTracking != null) {
      data['patient_meal_tracking'] =
          this.patientMealTracking!.map((v) => v.toJson()).toList();
    }
    if(this.comment != null){
      data['comment'] = this.comment;
    }
    return data;
  }
}

class PatientMealTracking {
  int? userMealItemId;
  int? day;
  String? status;

  PatientMealTracking({this.userMealItemId, this.day, this.status});

  PatientMealTracking.fromJson(Map<String, dynamic> json) {
    userMealItemId = json['user_meal_item_id'];
    day = json['day'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_meal_item_id'] = this.userMealItemId;
    data['day'] = this.day;
    data['status'] = this.status;
    return data;
  }
}