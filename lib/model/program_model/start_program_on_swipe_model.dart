class StartProgramOnSwipeModel {
  int? status;
  int? errorCode;
  Response? response;

  StartProgramOnSwipeModel({this.status, this.errorCode, this.response});

  StartProgramOnSwipeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  int? id;
  String? userId;
  String? programId;
  String? isActive;
  String? startProgram;
  String? createdAt;
  String? updatedAt;

  Response(
      {this.id,
        this.userId,
        this.programId,
        this.isActive,
        this.startProgram,
        this.createdAt,
        this.updatedAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    programId = json['program_id'];
    isActive = json['is_active'];
    startProgram = json['start_program'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['program_id'] = this.programId;
    data['is_active'] = this.isActive;
    data['start_program'] = this.startProgram;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}