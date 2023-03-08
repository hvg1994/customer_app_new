class TransitionMealModel {
  int? status;
  int? errorCode;
  String? key;
  String? note;
  String? totalDays;
  String? currentDay;
  String? currentDayStatus;
  String? previousDayStatus;
  String? isTransMealCompleted;
  Data? data;

  TransitionMealModel({this.status, this.note, this.errorCode,this.totalDays, this.isTransMealCompleted, this.key, this.currentDay, this.data, this.currentDayStatus, this.previousDayStatus});

  TransitionMealModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    errorCode = json['errorCode'];
    key = json['key'];
    note = json['note'];
    totalDays = json['days'];
    currentDay = json['current_day'];
    currentDayStatus =json['current_day_status'].toString();
    previousDayStatus = json['previous_day_status'].toString();
    isTransMealCompleted = json['is_trans_completed'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = this.status;
    data['errorCode'] = this.errorCode;
    data['key'] = this.key;
    data['note'] = this.note;
    data['days'] = this.totalDays;
    data['current_day'] = this.currentDay;
    data['previous_day_status'] = this.previousDayStatus;
    data['current_day_status'] = this.currentDayStatus;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<TransMealSlot>? earlyMorning;
  List<TransMealSlot>? breakfast;
  List<TransMealSlot>? midDay;
  List<TransMealSlot>? lunch;
  List<TransMealSlot>? evening;
  List<TransMealSlot>? dinner;
  List<TransMealSlot>? postDinner;

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
      earlyMorning = <TransMealSlot>[];
      json['Early Morning'].forEach((v) {
        earlyMorning!.add( TransMealSlot.fromJson(v));
      });
    }
    if (json['Breakfast'] != null) {
      breakfast = <TransMealSlot>[];
      json['Breakfast'].forEach((v) {
        breakfast!.add( TransMealSlot.fromJson(v));
      });
    }
    if (json['Mid Day'] != null) {
      midDay = <TransMealSlot>[];
      json['Mid Day'].forEach((v) {
        midDay!.add( TransMealSlot.fromJson(v));
      });
    }
    if (json['Lunch'] != null) {
      lunch = <TransMealSlot>[];
      json['Lunch'].forEach((v) {
        lunch!.add( TransMealSlot.fromJson(v));
      });
    }
    if (json['Evening'] != null) {
      evening = <TransMealSlot>[];
      json['Evening'].forEach((v) {
        evening!.add( TransMealSlot.fromJson(v));
      });
    }
    if (json['Dinner'] != null) {
      dinner = <TransMealSlot>[];
      json['Dinner'].forEach((v) {
        dinner!.add( TransMealSlot.fromJson(v));
      });
    }
    if (json['Post Dinner'] != null) {
      postDinner = <TransMealSlot>[];
      json['Post Dinner'].forEach((v) {
        postDinner!.add( TransMealSlot.fromJson(v));
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

class TransMealSlot {
  int? id;
  int? itemId;
  String? name;
  String? subTitle;
  String? benefits;
  String? itemPhoto;
  String? recipeUrl;

  TransMealSlot(
      {this.id,
      this.itemId,
      this.name,
        this.subTitle,
      this.benefits,
      this.itemPhoto,
      this.recipeUrl});

  TransMealSlot.fromJson(Map<String, dynamic> json) {
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
