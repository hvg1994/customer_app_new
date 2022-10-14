import 'child_meal_plan_details_model.dart';

class MealPlanDetailsModel {
  int? status;
  int? errorCode;
  String? programDay;
  String? comment;
  List<ChildMealPlanDetailsModel>? data;

  MealPlanDetailsModel(
      {this.status, this.errorCode, this.programDay, this.data, this.comment});

  MealPlanDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    programDay = json['program_day'];
    comment = json['comment'] ?? '';
    if (json['data'] != null) {
      data = <ChildMealPlanDetailsModel>[];
      json['data'].forEach((v) {
        data!.add(new ChildMealPlanDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['program_day'] = this.programDay;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

