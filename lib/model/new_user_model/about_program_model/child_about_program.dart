import 'feedback_list_model.dart';
import 'feeds_model/feedsListModel.dart';
import 'testimonial_model.dart';

class ChildAboutProgramModel {
  List<String>? aboutProgram;
  Testimonial? testimonial;
  List<FeedbackList>? feedbackList;
  List<FeedsListModel>? feedsList;


  ChildAboutProgramModel({this.aboutProgram, this.testimonial, this.feedbackList});

  ChildAboutProgramModel.fromJson(Map<String, dynamic> json) {
    aboutProgram = json['about_program'].cast<String>();
    testimonial = json['testimonial'] != null
        ? new Testimonial.fromJson(json['testimonial'])
        : null;
    if (json['feedback_list'] != null) {
      feedbackList = <FeedbackList>[];
      json['feedback_list'].forEach((v) {
        feedbackList!.add(new FeedbackList.fromJson(v));
      });
    }
    if (json['feed_list'] != null) {
      feedsList = <FeedsListModel>[];
      json['feed_list'].forEach((v) {
        feedsList!.add(new FeedsListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about_program'] = this.aboutProgram;
    if (this.testimonial != null) {
      data['testimonial'] = this.testimonial!.toJson();
    }
    if (this.feedbackList != null) {
      data['feedback_list'] =
          this.feedbackList!.map((v) => v.toJson()).toList();
    }
    if (this.feedsList != null) {
      data['feed_list'] = this.feedsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
