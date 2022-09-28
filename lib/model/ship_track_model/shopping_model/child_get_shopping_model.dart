class ChildGetShoppingModel {
  int? id;
  String? teamPatientId;
  String? itemId;
  String? totalWeight;
  String? addedBy;
  String? createdAt;
  String? updatedAt;
  String? itemWeight;
  MealItem? mealItem;

  ChildGetShoppingModel(
      {this.id,
        this.teamPatientId,
        this.itemId,
        this.totalWeight,
        this.addedBy,
        this.createdAt,
        this.updatedAt,
        this.itemWeight,
        this.mealItem});

  ChildGetShoppingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamPatientId = json['team_patient_id'];
    itemId = json['item_id'];
    totalWeight = json['total_weight'];
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    itemWeight = json['item_weight'] ?? '';
    mealItem = json['meal_item'] != null
        ? new MealItem.fromJson(json['meal_item'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['team_patient_id'] = this.teamPatientId;
    data['item_id'] = this.itemId;
    data['total_weight'] = this.totalWeight;
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['item_weight'] = this.itemWeight;
    if (this.mealItem != null) {
      data['meal_item'] = this.mealItem!.toJson();
    }
    return data;
  }
}

class MealItem {
  int? id;
  String? name;
  String? mealTimingId;
  String? recipeId;
  String? programId;
  String? inCookingKit;
  String? addedBy;
  String? createdAt;
  String? updatedAt;
  List<MealItemWeight>? mealItemWeight;

  MealItem(
      {this.id,
        this.name,
        this.mealTimingId,
        this.recipeId,
        this.programId,
        this.inCookingKit,
        this.addedBy,
        this.createdAt,
        this.updatedAt,
        this.mealItemWeight});

  MealItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mealTimingId = json['meal_timing_id'];
    recipeId = json['recipe_id'];
    programId = json['program_id'];
    inCookingKit = json['in_cooking_kit'];
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['meal_item_weight'] != null) {
      mealItemWeight = <MealItemWeight>[];
      json['meal_item_weight'].forEach((v) {
        mealItemWeight!.add(new MealItemWeight.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['meal_timing_id'] = this.mealTimingId;
    data['recipe_id'] = this.recipeId;
    data['program_id'] = this.programId;
    data['in_cooking_kit'] = this.inCookingKit;
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.mealItemWeight != null) {
      data['meal_item_weight'] =
          this.mealItemWeight!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MealItemWeight {
  int? id;
  String? mealPlanItemId;
  String? weight;
  String? weightTypeId;
  String? createdAt;
  String? updatedAt;
  WeightType? weightType;

  MealItemWeight(
      {this.id,
        this.mealPlanItemId,
        this.weight,
        this.weightTypeId,
        this.createdAt,
        this.updatedAt,
        this.weightType});

  MealItemWeight.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mealPlanItemId = json['meal_plan_item_id'];
    weight = json['weight'];
    weightTypeId = json['weight_type_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    weightType = json['weight_type'] != null
        ? new WeightType.fromJson(json['weight_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['meal_plan_item_id'] = this.mealPlanItemId;
    data['weight'] = this.weight;
    data['weight_type_id'] = this.weightTypeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.weightType != null) {
      data['weight_type'] = this.weightType!.toJson();
    }
    return data;
  }
}

class WeightType {
  int? id;
  String? unit;
  String? createdAt;
  String? updatedAt;

  WeightType({this.id, this.unit, this.createdAt, this.updatedAt});

  WeightType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unit = json['unit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unit'] = this.unit;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}