import 'dart:convert';

class EvaluationModelFormat2{
  String digesion;
  String diet;
  String foodAllergy;
  String intolerance;
  String cravings;
  String dislikeFood;
  String glasses_per_day;
  String habits;
  String? habits_other;
  String mealPreference;
  String? mealPreferenceOther;
  String hunger;
  String? hungerOther;
  String bowelPattern;
  String? bowelPatterOther;

  EvaluationModelFormat2(
      {
        required this.digesion,
      required this.diet,
      required this.foodAllergy,
      required this.intolerance,
      required this.cravings,
      required this.dislikeFood,
      required this.glasses_per_day,
      required this.habits,
      this.habits_other,
      required this.mealPreference,
      this.mealPreferenceOther,
      required this.hunger,
      this.hungerOther,
      required this.bowelPattern,
      this.bowelPatterOther});

  Map<String, dynamic> toMap() {
    final Map<String, String> data = new Map<String, String>();
    data['mention_if_any_food_affects_your_digesion'] = this.digesion;
    data['any_special_diet'] = this.diet;
    data['any_food_allergy'] = this.foodAllergy;
    data['any_intolerance'] = this.intolerance;
    data['any_severe_food_cravings'] = this.cravings;
    data['any_dislike_food'] = this.dislikeFood;
    data['no_galsses_day'] = this.glasses_per_day;
    data['any_habbit_or_addiction[]'] = this.habits;
    if(habits_other!.isNotEmpty) data['any_habbit_or_addiction_other'] = this.habits_other!;
    data['after_meal_preference'] = this.mealPreference;
    if(mealPreferenceOther!.isNotEmpty) data['after_meal_preference_other'] = this.mealPreferenceOther!;
    data['hunger_pattern'] = this.hunger;
    if(hungerOther!.isNotEmpty) data['hunger_pattern_other'] = this.hungerOther!;
    data['bowel_pattern'] = this.bowelPattern;
    if(bowelPatterOther!.isNotEmpty) data['bowel_pattern_other'] = this.bowelPatterOther!;
    return data;
  }

}