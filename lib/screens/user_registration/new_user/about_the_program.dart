import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/new_user_model/about_program_model/about_program_model.dart';
import 'package:gwc_customer/model/new_user_model/about_program_model/child_about_program.dart';
import 'package:gwc_customer/model/new_user_model/about_program_model/feedback_list_model.dart';
import 'package:gwc_customer/repository/new_user_repository/about_program_repository.dart';
import 'package:gwc_customer/services/new_user_service/about_program_service.dart';
import 'package:gwc_customer/widgets/vlc_player/vlc_player_with_controls.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../../../repository/api_service.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/vlc_player/controls_overlay.dart';
import '../../../widgets/widgets.dart';
import 'register_screen.dart';
import 'package:http/http.dart' as http;

class AboutTheProgram extends StatefulWidget {
  const AboutTheProgram({Key? key}) : super(key: key);

  @override
  State<AboutTheProgram> createState() => _AboutTheProgramState();
}

class _AboutTheProgramState extends State<AboutTheProgram> {
  final _key = GlobalKey<VlcPlayerWithControlsState>();

  double rating = 4.5;
  final pageController = PageController();

  late AboutProgramService _aboutProgramService;

  late Future _aboutProgramFuture;

  VlcPlayerController? _videoPlayerController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _aboutProgramService = AboutProgramService(repository: repository);
    getFuture();
  }

  getFuture(){
    _aboutProgramFuture = _aboutProgramService.serverAboutProgramService();
  }

  addUrlToVideoPlayer(String url){
    print("url"+ url);
    _videoPlayerController = VlcPlayerController.network(
      // url,
      // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
      'https://media.w3.org/2010/05/sintel/trailer.mp4',
      hwAcc: HwAcc.auto,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(true),
          VlcSubtitleOptions.fontSize(30),
          VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
          VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
          // works only on externally added subtitles
          VlcSubtitleOptions.color(VlcSubtitleColor.navy),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    print('dispose');
    await _videoPlayerController!.stop();
    await _videoPlayerController!.stopRendererScanning();
    await _videoPlayerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 1.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                child: FutureBuilder(
                  future: _aboutProgramFuture,
                  builder: (_, snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data.runtimeType == AboutProgramModel){
                        AboutProgramModel _programModel = snapshot.data as AboutProgramModel;
                        ChildAboutProgramModel? _aboutProgramText = _programModel.data;
                        // #1
                        String _programText = _aboutProgramText?.aboutProgram?.first ?? '';
                        // #2 video player
                        if(_aboutProgramText!.testimonial !=null){
                          String videoLink = _aboutProgramText.testimonial?.video ?? '';
                          addUrlToVideoPlayer(videoLink);
                        }
                        // #3 feedback List
                        List<FeedbackList> feedbackList = _aboutProgramText.feedbackList ?? [];
                        print("feedbackList: $feedbackList");
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Testimonial",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: eUser().mainHeadingFont,
                                    color: eUser().mainHeadingColor,
                                    fontSize: eUser().mainHeadingFontSize
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              buildTestimonial(),
                              SizedBox(height: 2.h),
                              Text(
                                "About The Program",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: eUser().mainHeadingFont,
                                    color: eUser().mainHeadingColor,
                                    fontSize: eUser().mainHeadingFontSize
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Card(
                                elevation: 7,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 3.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: gPrimaryColor, width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(2, 10),
                                      ),
                                    ],
                                  ),
                                  child: Image(
                                    image: AssetImage('assets/images/about_program.jpeg'),
                                  ),
                                  // child: Text(
                                  //   _programText,
                                  //   // 'Lorem lpsum is simply dummy text of the printing and typesetting industry. Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.',
                                  //   style: TextStyle(
                                  //     height: 1.7,
                                  //     fontFamily: "GothamBook",
                                  //     color: gTextColor,
                                  //     fontSize: 9.sp,
                                  //   ),
                                  // ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Feedback",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: eUser().mainHeadingFont,
                                    color: eUser().mainHeadingColor,
                                    fontSize: eUser().mainHeadingFontSize
                                ),
                              ),
                              SizedBox(height: 2.h),
                              buildFeedback(feedbackList),
                              SizedBox(height: 2.h),
                              Center(
                                child: GestureDetector(
                                  onTap: () async{
                                    print("tap");
                                    final res = await _videoPlayerController?.isPlaying();
                                    if(res != null && res == true){
                                      await _videoPlayerController?.stop();
                                    }
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 1.h, horizontal: 15.w),
                                    decoration: BoxDecoration(
                                      color: eUser().buttonColor,
                                      borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                                      border: Border.all(
                                          color: eUser().buttonBorderColor,
                                          width: eUser().buttonBorderWidth                                      ),
                                    ),
                                    child: Text(
                                      'Next',
                                      style: TextStyle(
                                        fontFamily: eUser().buttonTextFont,
                                        color: eUser().buttonTextColor,
                                        fontSize: eUser().buttonTextSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else{
                        ErrorModel data = snapshot.data as ErrorModel;
                        print("data.message: ${data.message}");
                        if(data.message!.contains("Connection closed before full header was received")){
                          getFuture();
                        }
                        return Center(
                          child: Column(
                            children: [
                              Text(data.message ?? '',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: 'GothamMedium'
                                ),
                              ),
                              TextButton(
                                  onPressed: (){
                                    getFuture();
                                  },
                                  child: Text("Retry",
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontFamily: 'GothamMedium'
                                    ),
                                  )
                              )
                            ],
                          )
                        );
                      }
                    }
                    return buildCircularIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  buildTestimonial() {
    if(_videoPlayerController != null){
      return AspectRatio(
        aspectRatio: 16/9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: gPrimaryColor, width: 1),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.3),
            //     blurRadius: 20,
            //     offset: const Offset(2, 10),
            //   ),
            // ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Center(
              child: VlcPlayerWithControls(
                key: _key,
                controller: _videoPlayerController!,
                showVolume: false,
                showVideoProgress: false,
                seekButtonIconSize: 10.sp,
                playButtonIconSize: 14.sp,
                replayButtonSize: 10.sp,
              ),
              // child: VlcPlayer(
              //   controller: _videoPlayerController!,
              //   aspectRatio: 16 / 9,
              //   virtualDisplay: false,
              //   placeholder: Center(child: CircularProgressIndicator()),
              // ),
            ),
          ),
          // child: Stack(
          //   children: <Widget>[
          //     ClipRRect(
          //       borderRadius: BorderRadius.circular(5),
          //       child: Center(
          //         child: VlcPlayer(
          //           controller: _videoPlayerController!,
          //           aspectRatio: 16 / 9,
          //           virtualDisplay: false,
          //           placeholder: Center(child: CircularProgressIndicator()),
          //         ),
          //       ),
          //     ),
          //     ControlsOverlay(controller: _videoPlayerController,)
          //   ],
          // ),
        ),
      );
    }
    else {
      return SizedBox.shrink();
    }
  }

  isPlaying() async {
    if(_videoPlayerController != null) {
      final value = await _videoPlayerController?.isPlaying();
      print("isPlaying: $value");
      return value;
    }
    else{
      return false;
    }
  }


  buildFeedback(List<FeedbackList> feedbackList) {
    if(feedbackList.isNotEmpty){
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: gPrimaryColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(2, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
              child: PageView(
                  controller: pageController,
                  children: [
                    ...feedbackList.map((e) => buildFeedbackList(e)).toList()
                  ]
                // [
                //   buildFeedbackList(),
                //   buildFeedbackList(),
                //   buildFeedbackList(),
                // ],
              ),
            ),
            SmoothPageIndicator(
              controller: pageController,
              count: feedbackList.length,
              axisDirection: Axis.horizontal,
              effect: JumpingDotEffect(
                dotColor: Colors.amberAccent,
                activeDotColor: gsecondaryColor,
                dotHeight: 1.h,
                dotWidth: 2.w,
                jumpScale: 2,
              ),
            ),
          ],
        ),
      );
    }
    else{
      return SizedBox.shrink();
    }
  }

  Widget buildRating(String starRating) {
    return SmoothStarRating(
      color: Colors.amber,
      borderColor: Colors.amber,
      rating: double.tryParse(starRating) ?? rating,
      size: 2.h,
      filledIconData: Icons.star_sharp,
      halfFilledIconData: Icons.star_half_sharp,
      defaultIconData: Icons.star_outline_sharp,
      starCount: 5,
      allowHalfRating: true,
      spacing: 2.0,
    );
  }

  buildFeedbackList(FeedbackList feedback) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(2, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                  radius: 3.h,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/images/cheerful.png",
                  )
              ),
            ),
            SizedBox(width: 3.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedback.addedBy?.name ?? '',
                  style: TextStyle(
                      fontFamily: "GothamRoundedBold_21016",
                      color: gPrimaryColor,
                      fontSize: 10.sp),
                ),
                SizedBox(height: 0.3.h),
                buildRating(feedback.rating ?? ''),
              ],
            ),
          ],
        ),
        Text(
          feedback.feedback ??
              'Lorem lpsum is simply dummy text of the printing and typesetting industry. Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.',
          style: TextStyle(
            height: 1.7,
            fontFamily: "GothamBook",
            color: gTextColor,
            fontSize: 9.sp,
          ),
        ),
      ],
    );
  }

  final AboutProgramRepository repository = AboutProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
