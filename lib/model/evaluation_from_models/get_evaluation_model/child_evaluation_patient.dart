import 'child_evaluation_user.dart';

class ChildEvalPatient {
  int? id;
  String? userId;
  String? maritalStatus;
  String? pincode;
  String? weight;
  String? isArchieved;
  String? createdAt;
  String? updatedAt;
  ChildEvalUser? user;

  ChildEvalPatient(
      {this.id,
        this.userId,
        this.maritalStatus,
        this.pincode,
        this.weight,
        this.isArchieved,
        this.createdAt,
        this.updatedAt,
        this.user});

  ChildEvalPatient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'] ?? '';
    maritalStatus = json['marital_status'] ?? '';
    pincode = json['pincode'] ?? '';
    weight = json['weight'] ?? '';
    isArchieved = json['is_archieved'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    user = json['user'] != null ? new ChildEvalUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['marital_status'] = this.maritalStatus;
    data['pincode'] = this.pincode;
    data['weight'] = this.weight;
    data['is_archieved'] = this.isArchieved;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
