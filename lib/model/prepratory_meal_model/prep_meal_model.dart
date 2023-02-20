class PrepratoryMealModel {
  int? status;
  int? errorCode;
  String? key;
  String? days;
  String? currentDay;
  String? isPrepCompleted;
  String? note;
  Data? data;

  PrepratoryMealModel({this.status, this.note, this.currentDay, this.errorCode, this.key, this.data, this.isPrepCompleted, this.days});

  PrepratoryMealModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    currentDay = json['current_day'];
    isPrepCompleted = json['is_prep_completed'];
    note = json['note'];
    days = json['days'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    data['current_day'] = this.currentDay;
    data['is_prep_completed'] = this.isPrepCompleted;
    data['days'] = this.days;
    data['note'] = this.note;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<MealSlot>? earlyMorning;
  List<MealSlot>? breakfast;
  List<MealSlot>? midDay;
  List<MealSlot>? lunch;
  List<MealSlot>? evening;
  List<MealSlot>? dinner;
  List<MealSlot>? postDinner;

  Data(
      {this.earlyMorning,
      this.breakfast,
      this.midDay,
      this.lunch,
      this.evening,
      this.dinner,
      this.postDinner});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Early Morning'] != null) {
      earlyMorning = <MealSlot>[];
      json['Early Morning'].forEach((v) {
        earlyMorning!.add( MealSlot.fromJson(v));
      });
    }
    if (json['Breakfast'] != null) {
      breakfast = <MealSlot>[];
      json['Breakfast'].forEach((v) {
        breakfast!.add( MealSlot.fromJson(v));
      });
    }
    if (json['Mid Day'] != null) {
      midDay = <MealSlot>[];
      json['Mid Day'].forEach((v) {
        midDay!.add( MealSlot.fromJson(v));
      });
    }
    if (json['Lunch'] != null) {
      lunch = <MealSlot>[];
      json['Lunch'].forEach((v) {
        lunch!.add( MealSlot.fromJson(v));
      });
    }
    if (json['Evening'] != null) {
      evening = <MealSlot>[];
      json['Evening'].forEach((v) {
        evening!.add( MealSlot.fromJson(v));
      });
    }
    if (json['Dinner'] != null) {
      dinner = <MealSlot>[];
      json['Dinner'].forEach((v) {
        dinner!.add( MealSlot.fromJson(v));
      });
    }
    if (json['Post Dinner'] != null) {
      postDinner = <MealSlot>[];
      json['Post Dinner'].forEach((v) {
        postDinner!.add( MealSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.earlyMorning != null) {
      data['Early Morning'] =
          this.earlyMorning!.map((v) => v.toJson()).toList();
    }
    if (this.breakfast != null) {
      data['Breakfast'] = this.breakfast!.map((v) => v.toJson()).toList();
    }
    if (this.midDay != null) {
      data['Mid Day'] = this.midDay!.map((v) => v.toJson()).toList();
    }
    if (this.lunch != null) {
      data['Lunch'] = this.lunch!.map((v) => v.toJson()).toList();
    }
    if (this.evening != null) {
      data['Evening'] = this.evening!.map((v) => v.toJson()).toList();
    }
    if (this.dinner != null) {
      data['Dinner'] = this.dinner!.map((v) => v.toJson()).toList();
    }
    if (this.postDinner != null) {
      data['Post Dinner'] = this.postDinner!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealSlot {
  int? id;
  int? itemId;
  String? name;
  String? subTitle;
  String? benefits;
  String? itemPhoto;
  String? recipeUrl;

  MealSlot(
      {this.id,
      this.itemId,
      this.name,
        this.subTitle,
      this.benefits,
      this.itemPhoto,
      this.recipeUrl});

  MealSlot.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    name = json['name'];
    subTitle = json['subtitle'];
    benefits = json['benefits'];
    itemPhoto = json['item_photo'];
    recipeUrl = json['recipe_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['name'] = this.name;
    data['subtitle'] = this.subTitle;
    data['benefits'] = this.benefits;
    data['item_photo'] = this.itemPhoto;
    data['recipe_url'] = this.recipeUrl;
    return data;
  }
}
