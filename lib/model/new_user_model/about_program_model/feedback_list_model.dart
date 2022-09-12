import 'added_by_model.dart';

class FeedbackList {
  int? id;
  String? rating;
  String? feedback;
  AddedBy? addedBy;
  String? createdAt;
  String? updatedAt;

  FeedbackList(
      {this.id,
        this.rating,
        this.feedback,
        this.addedBy,
        this.createdAt,
        this.updatedAt});

  FeedbackList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    feedback = json['feedback'];
    addedBy = json['added_by'] != null
        ? new AddedBy.fromJson(json['added_by'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['feedback'] = this.feedback;
    if (this.addedBy != null) {
      data['added_by'] = this.addedBy!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
