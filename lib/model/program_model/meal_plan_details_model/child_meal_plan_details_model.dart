class ChildMealPlanDetailsModel {
  String? type;
  String? mealTime;
  int? itemId;
  String? name;
  String? mealWeight;
  String? weightType;
  String? url;
  String? status;
  String? itemImage;
  String? subTitle;
  String? benefits;

  ChildMealPlanDetailsModel(
      {this.type,
        this.mealTime,
        this.itemId,
        this.name,
        this.mealWeight,
        this.weightType,
        this.url,
        this.status,
        this.subTitle,
        this.itemImage,
        this.benefits
      });

  ChildMealPlanDetailsModel.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? '';
    mealTime = json['meal_time'] ?? '';
    itemId = json['item_id'] ?? '';
    name = json['name'] ?? '';
    mealWeight = json['meal_weight'] ?? '';
    weightType = json['weight_type'] ?? '';
    url = json['url'] ?? '';
    status = json['status'] ?? '';
    subTitle = json['subtitle'] ?? '';
    itemImage = json['item_photo'] ?? '';
    benefits = json['benefits'] ?? '';
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['meal_time'] = this.mealTime;
    data['item_id'] = this.itemId;
    data['name'] = this.name;
    data['meal_weight'] = this.mealWeight;
    data['weight_type'] = this.weightType;
    data['url'] = this.url;
    data['status'] = this.status;
    data['subtitle'] = this.subTitle;
    data['item_photo'] = this.itemImage;
    data['benefits'] = this.benefits;
    return data;
  }
}