// To parse this JSON data, do
//
//     final medicalFeedbackModel = medicalFeedbackModelFromJson(jsonString);

import 'dart:convert';

MedicalFeedbackModel medicalFeedbackModelFromJson(String str) => MedicalFeedbackModel.fromJson(json.decode(str));

String medicalFeedbackModelToJson(MedicalFeedbackModel data) => json.encode(data.toJson());

class MedicalFeedbackModel {
  int status;
  String key;
  Data data;

  MedicalFeedbackModel({
    required this.status,
    required this.key,
    required this.data,
  });

  factory MedicalFeedbackModel.fromJson(Map<String, dynamic> json) => MedicalFeedbackModel(
    status: json["status"],
    key: json["key"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "key": key,
    "data": data.toJson(),
  };
}

class Data {
  int? id;
  String? resolvedDigestiveIssue;
  String? unresolvedDigestiveIssue;
  String? mealPreferences;
  String? hungerPattern;
  String? bowelPattern;
  String? lifestyleHabits;
  String? addedBy;
  String? createdAt;
  String? updatedAt;

  Data({
     this.id,
     this.resolvedDigestiveIssue,
     this.unresolvedDigestiveIssue,
     this.mealPreferences,
     this.hungerPattern,
     this.bowelPattern,
     this.lifestyleHabits,
     this.addedBy,
     this.createdAt,
     this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    resolvedDigestiveIssue: json["resolved_digestive_issue"],
    unresolvedDigestiveIssue: json["unresolved_digestive_issue"],
    mealPreferences: json["meal_preferences"],
    hungerPattern: json["hunger_pattern"],
    bowelPattern: json["bowel_pattern"],
    lifestyleHabits: json["lifestyle_habits"],
    addedBy: json["added_by"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "resolved_digestive_issue": resolvedDigestiveIssue,
    "unresolved_digestive_issue": unresolvedDigestiveIssue,
    "meal_preferences": mealPreferences,
    "hunger_pattern": hungerPattern,
    "bowel_pattern": bowelPattern,
    "lifestyle_habits": lifestyleHabits,
    "added_by": addedBy,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
