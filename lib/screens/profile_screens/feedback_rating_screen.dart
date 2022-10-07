import 'package:flutter/material.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/profile_model/feedback_model.dart';
import 'package:gwc_customer/repository/profile_repository/feedback_repo.dart';
import 'package:gwc_customer/services/profile_screen_service/feedback_service.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/unfocus_widget.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:http/http.dart' as http;
import '../../repository/api_service.dart';
import '../../utils/app_config.dart';

class FeedbackRatingScreen extends StatefulWidget {
  const FeedbackRatingScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackRatingScreen> createState() => _FeedbackRatingScreenState();
}

class _FeedbackRatingScreenState extends State<FeedbackRatingScreen> {
  final feedbackController = TextEditingController();

  final _focusNode = FocusNode();

  bool isSubmitted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(() {
      if(!_focusNode.hasFocus){
        setState(() {

        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(() { });
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 1.h),
              child: ListView(
                shrinkWrap: true,
                children: [
                  buildAppBar(() {}),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Give Feedback',
                        style: TextStyle(
                            fontFamily: "GothamRoundedBold_21016",
                            color: gTextColor,
                            height: 2,
                            fontSize: 12.sp
                        ),
                      ),
                      Text('What do you think of the program',
                        style: TextStyle(
                          fontFamily: "GothamBold",
                          color: gTextColor,
                          height: 2,
                          fontSize: 11.sp,
                        ),
                      ),
                      SizedBox(
                        height: 2.5.h,
                      ),
                      buildRating(),
                      SizedBox(
                        height: 2.5.h,
                      ),
                      Text('Do you have any thoughts you\'d like to share?',
                        style: TextStyle(
                          fontFamily: "GothamMedium",
                          color: gTextColor,
                          fontSize: 9.5.sp,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      TextField(
                        minLines: 6,
                        maxLines: 8,
                        focusNode: _focusNode,
                        controller: feedbackController,
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: gMainColor, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: gMainColor, width: 1),
                          ),
                          hintText: 'Your answer...',
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: (){
                            submitRating();
                          },
                          child: Container(
                            width: 60.w,
                            height: 6.h,
                            padding:
                            EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                              color: feedbackController.text.isEmpty ? gMainColor : gPrimaryColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: gMainColor, width: 1),
                            ),
                            child: Center(
                              child: (isSubmitted) ? buildThreeBounceIndicator() : Text(
                                'Submit',
                                style: TextStyle(
                                  fontFamily: "GothamRoundedBold_21016",
                                  color: feedbackController.text.isEmpty ? gPrimaryColor : gMainColor,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  double rating = 0.0;
  Widget buildRating() {
    return SmoothStarRating(
      color: gMainColor,
      borderColor: gMainColor,
      rating: rating,
      size: 45,
      filledIconData: Icons.star_sharp,
      halfFilledIconData: Icons.star_half_sharp,
      defaultIconData: Icons.star_outline_sharp,
      starCount: 5,
      allowHalfRating: false,
      spacing: 2.0,
      onRatingChanged: (value){
        setState(() {
          rating = value.ceilToDouble();
        });
      },
    );
  }

  submitRating() async{
    setState(() {
      isSubmitted = true;
    });
    Map feedback = {
      'rating' : rating.toString(),
      'feedback' : feedbackController.text
    };
    final res = await FeedbackService(repository: repository).submitFeedbackService(feedback);

    if(res.runtimeType == FeedbackModel){
      FeedbackModel model = res as FeedbackModel;
      AppConfig().showSnackbar(context, model.errorMsg ?? '');
    }
    else{
      ErrorModel model = res as ErrorModel;
      AppConfig().showSnackbar(context, model.message ?? '', isError: true);
    }
    setState(() {
      isSubmitted = false;
    });
  }

  final FeedbackRepository repository = FeedbackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

}
