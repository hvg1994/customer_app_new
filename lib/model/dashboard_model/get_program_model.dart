class GetProgramModel {
  String? data;
  Value? value;

  GetProgramModel({this.data, this.value});

  GetProgramModel.fromJson(Map<String, dynamic> json) {
    print('json:=== $json  ${json['data'].runtimeType} ${json['value'].runtimeType}');
    data = json['data'];
    value = (json['value'] != null ? new Value.fromJson(json['value']) : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    return data;
  }
}

class Value {
  int? id;
  String? userId;
  String? startVideoUrl;
  String? tracker_video_url;
  String? recipeVideo;
  String? programId;
  String? isActive;
  String? startProgram;
  String? mealCurrentDay;
  String? createdAt;
  String? updatedAt;
  Program? program;

  Value(
      {this.id,
        this.userId,
        this.startVideoUrl,
        this.tracker_video_url,
        this.recipeVideo,
        this.programId,
        this.isActive,
        this.startProgram,
        this.mealCurrentDay,
        this.createdAt,
        this.updatedAt,
        this.program});

  Value.fromJson(Map<String, dynamic> json) {
    print("value from json: $json");
    id = json['id'];
    userId = json['user_id'].toString();
    startVideoUrl = json['video'];
    tracker_video_url = json['tracker_video'];
    recipeVideo = json['recipe_video'];
    programId = json['program_id'];
    isActive = json['is_active'].toString();
    startProgram = json['start_program'];
    mealCurrentDay = json['sp_current_day'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    program = json['program'] != null ? new Program.fromJson(json['program'])
        : json['program_days'] != null
        ? new Program.fromJson(json['program_days']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['video'] = this.startVideoUrl;
    data['recipe_video'] = this.recipeVideo;
    data['tracker_video'] = this.tracker_video_url;
    data['program_id'] = this.programId;
    data['is_active'] = this.isActive;
    data['start_program'] = this.startProgram;
    data['sp_current_day'] = this.mealCurrentDay;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.program != null) {
      data['program'] = this.program!.toJson();
    }
    return data;
  }
}

class Program {
  int? id;
  String? issueId;
  String? name;
  String? noOfDays;
  String? desc;
  String? price;
  String? profile;
  String? createdAt;
  String? updatedAt;

  Program(
      {this.id,
        this.issueId,
        this.name,
        this.noOfDays,
        this.desc,
        this.price,
        this.profile,
        this.createdAt,
        this.updatedAt});

  Program.fromJson(Map<String, dynamic> json) {
    print("program from json: $json");
    id = json['id'];
    issueId = json['issue_id'].toString();
    name = json['name'];
    noOfDays = json['no_of_days'];
    desc = json['desc'];
    price = json['price'];
    profile = json['profile'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['issue_id'] = this.issueId;
    data['name'] = this.name;
    data['no_of_days'] = this.noOfDays;
    data['desc'] = this.desc;
    data['price'] = this.price;
    data['profile'] = this.profile;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}