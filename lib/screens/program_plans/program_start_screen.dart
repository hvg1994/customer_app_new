import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/program_model/meal_plan_details_model/meal_plan_details_model.dart';
import 'package:gwc_customer/repository/prepratory_repository/prep_repository.dart';
import 'package:gwc_customer/screens/prepratory%20plan/prepratory_plan_screen.dart';
import 'package:gwc_customer/screens/prepratory%20plan/transition_mealplan_screen.dart';
import 'package:gwc_customer/screens/program_plans/meal_plan_screen.dart';
import 'package:gwc_customer/services/program_service/program_service.dart';
import 'package:gwc_customer/widgets/open_alert_box.dart';
import 'package:gwc_customer/widgets/vlc_player/vlc_player_with_controls.dart';
import 'package:sizer/sizer.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:wakelock/wakelock.dart';
import '../../model/program_model/meal_plan_details_model/child_meal_plan_details_model.dart';
import '../../model/program_model/start_program_on_swipe_model.dart';
import '../../repository/api_service.dart';
import '../../repository/program_repository/program_repository.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/video/normal_video.dart';
import '../../widgets/widgets.dart';
import '../prepratory plan/new/new_transition_design.dart';
import '../prepratory plan/new/preparatory_new_screen.dart';
import '../prepratory plan/prepratory_meal_completed_screen.dart';
import 'day_program_plans.dart';
import 'package:http/http.dart' as http;

enum ProgramMealType {
  prepratory, program, transition
}

class ProgramPlanScreen extends StatefulWidget {
  final String from;
  final String? videoLink;

  /// this is for meal plans
  final bool? isPrepCompleted;
  const ProgramPlanScreen({Key? key, required this.from, this.isPrepCompleted, this.videoLink}) : super(key: key);

  @override
  State<ProgramPlanScreen> createState() => _ProgramPlanScreenState();
}

class _ProgramPlanScreenState extends State<ProgramPlanScreen> {

  final _pref = AppConfig().preferences;
  bool isStarted = false;

  String prepText = "Our preparatory phase transforms gut health by adapting your diet to your unique gut type, achieving optimal acid and enzyme levels. Say goodbye to harmful addictions and habits like smoking and drinking, "
      "and hello to a new, healthier you. Before receiving our product kit, "
      "we encourage you to eat 6-7 meals a day and start breaking those bad habits that may be holding you back.\n\n"
      "So why wait? Start your journey towards detoxification and repair today with our program, and discover the power of optimal gut health. Your body will thank you! ";
      // "The preparatory phase aids in the optimal preparation of the gastrointestinal tract for detoxification and repair. Gut acid and enzyme optimization can be achieved by adapting typical diets to your gut type and condition, as well as avoiding certain addictions/habits such as smoking, drinking, and so on."
      // "Before receiving your product kit, eat 6-7 meals a day, break addictions, and eliminate bad habits. Start your custom plan now.";
  String mealText = "Our approach on healing the condition: To cleanse and heal your stomach, we employ integrated Calm, Move, and Nourish modules that are tailored to your gut type. \n\nEvery meal is scheduled based on the Metabolic nature of your gut and its relationship to your biological clock. This implies that each food item at each meal time has a distinct role in resetting your gut's functionality by adjusting to your biological clock. ";
  String transText = "Congratulations on completing your detox and healing program. Now, let us begin your transition days to enter a normal routine, for optimal healthy gut.";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.videoLink != null && widget.videoLink!.isNotEmpty){
      addUrlToVideoPlayerChewie(widget.videoLink!);
    }
    // addUrlToVideoPlayer("https://media.w3.org/2010/05/sintel/trailer.mp4");
  }

  @override
  void dispose() {
    if(mounted){
      if(videoPlayerController != null) videoPlayerController!.dispose();
      if(_chewieController != null) _chewieController!.dispose();

      // if(_videoPlayerController != null) _videoPlayerController!.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Container(
              height: 100.h,
              padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 5.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildAppBar(() {
                    Navigator.pop(context);
                  }),
                  SizedBox(
                    height: 3.h,
                  ),
                  Expanded(
                    flex: 3,
                    child: buildPlans(),
                  ),
                  (isStarted)
                      ? Center(child: buildThreeBounceIndicator(),)
                      :
                  ConfirmationSlider(
                      width: 95.w,
                      text: "Slide To Start",
                      sliderButtonContent: const Image(
                        image: AssetImage(
                            "assets/images/noun-arrow-1921075.png"),
                      ),
                      foregroundColor: kPrimaryColor,
                      foregroundShape: BorderRadius.zero,
                      backgroundShape: BorderRadius.zero,
                      shadow: BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(2, 10),
                      ),
                      textStyle: TextStyle(
                          fontFamily: kFontMedium,
                          color: gTextColor,
                          fontSize: 10.sp),
                      onConfirmation: () {
                        if(videoPlayerController != null) videoPlayerController!.pause();
                        if(_chewieController != null) _chewieController!.pause();

                        showConfirmSheet();

                      })
                ],
              ),
            )
        ),
      ),
    );
  }

  // **  *add url to video on initstate *************************


  VideoPlayerController? videoPlayerController;
  ChewieController ? _chewieController;
  addUrlToVideoPlayerChewie(String url) async {
    print("url" + url);
    videoPlayerController = VideoPlayerController.network(Uri.parse(url).toString());
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        aspectRatio: 16/9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        // customControls: Center(
        //   child: FittedBox(
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         IconButton(
        //           onPressed: () => _seekRelative(_seekStepBackward),
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: Icon(Icons.replay_10),
        //         ),
        //         IconButton(
        //           onPressed: (){
        //             if(videoPlayerController!.value.isPlaying){
        //               videoPlayerController!.pause();
        //             }
        //             else{
        //               videoPlayerController!.play();
        //             }
        //             setState(() {
        //
        //             });
        //           },
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: (videoPlayerController!.value.isPlaying) ? Icon(Icons.pause)  : Icon(Icons.play_arrow),
        //         ),
        //         IconButton(
        //           onPressed: () => _seekRelative(_seekStepForward),
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: Icon(Icons.forward_10),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        hideControlsTimer: Duration(seconds: 3),
        showControls: false

    );
    if (!await Wakelock.enabled) {
      Wakelock.enable();
    }
  }

  // VlcPlayerController? _videoPlayerController;
  // final _key = GlobalKey<VlcPlayerWithControlsState>();
  // addUrlToVideoPlayer(String url) async {
  //   print("url" + url);
  //   _videoPlayerController = VlcPlayerController.network(
  //     url,
  //     // url,
  //     // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
  //     // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
  //     hwAcc: HwAcc.auto,
  //     autoPlay: true,
  //     options: VlcPlayerOptions(
  //       advanced: VlcAdvancedOptions([
  //         VlcAdvancedOptions.networkCaching(2000),
  //       ]),
  //       subtitle: VlcSubtitleOptions([
  //         VlcSubtitleOptions.boldStyle(true),
  //         VlcSubtitleOptions.fontSize(30),
  //         VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
  //         VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
  //         // works only on externally added subtitles
  //         VlcSubtitleOptions.color(VlcSubtitleColor.navy),
  //       ]),
  //       http: VlcHttpOptions([
  //         VlcHttpOptions.httpReconnect(true),
  //       ]),
  //       rtp: VlcRtpOptions([
  //         VlcRtpOptions.rtpOverRtsp(true),
  //       ]),
  //     ),
  //   );
  //   if (!await Wakelock.enabled) {
  //     Wakelock.enable();
  //   }
  // }

  buildAboutStartSlideVideo() {
    if(_chewieController != null){
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gPrimaryColor, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Center(
                  child: OverlayVideo(
                    isControlsVisible: false,
                    controller: _chewieController!,
                  ),
                ),
              ),
            ),
          ),
          // if(!_customVideoPlayerController!.videoPlayerController.value.isPlaying)AspectRatio(
          //     aspectRatio: 16/9,
          //   child: SizedBox.expand(
          //     child: Container(
          //       color: Colors.black45,
          //       child: FittedBox(
          //         child: Row(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //           children: [
          //             IconButton(
          //               onPressed: (){
          //                 _customVideoPlayerController!.videoPlayerController.play();
          //               },
          //               color: gWhiteColor,
          //               iconSize: 15,
          //               icon: Icon(Icons.play_arrow),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(child:
          // AspectRatio(
          //   aspectRatio: 16/9,
          //   child: GestureDetector(
          //     onTap: (){
          //       print("onTap");
          //       if(_aboutSlideStartController != null){
          //         if(_customVideoPlayerController!.videoPlayerController.value.isPlaying){
          //           _customVideoPlayerController!.videoPlayerController.pause();
          //         }
          //         else{
          //           _customVideoPlayerController!.videoPlayerController.play();
          //         }
          //       }
          //       setState(() {
          //
          //       });
          //     },
          //   ),
          // )
          // )

        ],
      );
      // return AspectRatio(
      //   aspectRatio: 16/9,
      //   child: Container(
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(5),
      //       border: Border.all(color: gPrimaryColor, width: 1),
      //     ),
      //     child: ClipRRect(
      //       borderRadius: BorderRadius.circular(5),
      //       child: Center(
      //         child: VlcPlayerWithControls(
      //           key: _key,
      //           controller: _aboutSlideStartController!,
      //           showVolume: false,
      //           showVideoProgress: false,
      //           seekButtonIconSize: 10.sp,
      //           playButtonIconSize: 14.sp,
      //           replayButtonSize: 10.sp,
      //         ),
      //         // child: VlcPlayer(
      //         //   controller: _videoPlayerController!,
      //         //   aspectRatio: 16 / 9,
      //         //   virtualDisplay: false,
      //         //   placeholder: Center(child: CircularProgressIndicator()),
      //         // ),
      //       ),
      //     ),
      //   ),
      // );
    }
    // else if(_videoPlayerController != null){
    //   return Stack(
    //     children: [
    //       AspectRatio(
    //         aspectRatio: 16/9,
    //         child: Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(5),
    //             border: Border.all(color: gPrimaryColor, width: 1),
    //             // boxShadow: [
    //             //   BoxShadow(
    //             //     color: Colors.grey.withOpacity(0.3),
    //             //     blurRadius: 20,
    //             //     offset: const Offset(2, 10),
    //             //   ),
    //             // ],
    //           ),
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.circular(5),
    //             child: Center(
    //               // child: CustomVideoPlayer(
    //               //   customVideoPlayerController: _customVideoPlayerController!,
    //               // ),
    //                 child: VlcPlayerWithControls(
    //                   key: _key,
    //                   controller: _videoPlayerController!,
    //                   showVolume: false,
    //                   showVideoProgress: false,
    //                   seekButtonIconSize: 10.sp,
    //                   playButtonIconSize: 14.sp,
    //                   replayButtonSize: 10.sp,
    //                 )
    //             ),
    //           ),
    //         ),
    //       ),
    //       // if(!_customVideoPlayerController!.videoPlayerController.value.isPlaying)AspectRatio(
    //       //     aspectRatio: 16/9,
    //       //   child: SizedBox.expand(
    //       //     child: Container(
    //       //       color: Colors.black45,
    //       //       child: FittedBox(
    //       //         child: Row(
    //       //           crossAxisAlignment: CrossAxisAlignment.center,
    //       //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       //           children: [
    //       //             IconButton(
    //       //               onPressed: (){
    //       //                 _customVideoPlayerController!.videoPlayerController.play();
    //       //               },
    //       //               color: gWhiteColor,
    //       //               iconSize: 15,
    //       //               icon: Icon(Icons.play_arrow),
    //       //             ),
    //       //           ],
    //       //         ),
    //       //       ),
    //       //     ),
    //       //   ),
    //       // ),
    //       // Positioned(child:
    //       // AspectRatio(
    //       //   aspectRatio: 16/9,
    //       //   child: GestureDetector(
    //       //     onTap: (){
    //       //       print("onTap");
    //       //       if(_aboutSlideStartController != null){
    //       //         if(_customVideoPlayerController!.videoPlayerController.value.isPlaying){
    //       //           _customVideoPlayerController!.videoPlayerController.pause();
    //       //         }
    //       //         else{
    //       //           _customVideoPlayerController!.videoPlayerController.play();
    //       //         }
    //       //       }
    //       //       setState(() {
    //       //
    //       //       });
    //       //     },
    //       //   ),
    //       // )
    //       // )
    //
    //     ],
    //   );
    //   // return AspectRatio(
    //   //   aspectRatio: 16/9,
    //   //   child: Container(
    //   //     decoration: BoxDecoration(
    //   //       borderRadius: BorderRadius.circular(5),
    //   //       border: Border.all(color: gPrimaryColor, width: 1),
    //   //     ),
    //   //     child: ClipRRect(
    //   //       borderRadius: BorderRadius.circular(5),
    //   //       child: Center(
    //   //         child: VlcPlayerWithControls(
    //   //           key: _key,
    //   //           controller: _aboutSlideStartController!,
    //   //           showVolume: false,
    //   //           showVideoProgress: false,
    //   //           seekButtonIconSize: 10.sp,
    //   //           playButtonIconSize: 14.sp,
    //   //           replayButtonSize: 10.sp,
    //   //         ),
    //   //         // child: VlcPlayer(
    //   //         //   controller: _videoPlayerController!,
    //   //         //   aspectRatio: 16 / 9,
    //   //         //   virtualDisplay: false,
    //   //         //   placeholder: Center(child: CircularProgressIndicator()),
    //   //         // ),
    //   //       ),
    //   //     ),
    //   //   ),
    //   // );
    // }
    else {
      return SizedBox.shrink();
    }
  }
// **********************************************************************

  buildPlans() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const Image(
        //   image: AssetImage("assets/images/Group 4852.png"),
        // ),
        buildAboutStartSlideVideo(),
        SizedBox(height: 4.h),
        Text(
          (widget.from == ProgramMealType.prepratory.name)
              ? prepText
              : widget.from == ProgramMealType.program.name
              ? mealText
              : transText,
          textAlign: TextAlign.justify,
          style: TextStyle(
              height: 1.5,
              fontFamily: kFontMedium,
              color: gTextColor,
              fontSize: 10.sp),
        ),
        TextButton(
            onPressed: (){
              if(videoPlayerController != null) videoPlayerController!.pause();
              if(_chewieController != null) _chewieController!.pause();

              // if(_videoPlayerController != null) _videoPlayerController!.stop();
              if(widget.from == ProgramMealType.prepratory.name){
                //get Preparatory day1 meals
                gotoScreen(PreparatoryPlanScreen(dayNumber: "1", totalDays: '1',viewDay1Details: true,));
              }
              else if(widget.from == ProgramMealType.program.name){
                //get Normal Program day1 meals
                final mealUrl = _pref!.getString(AppConfig().receipeVideoUrl);
                final trackerUrl = _pref!.getString(AppConfig().trackerVideoUrl);

                gotoScreen( MealPlanScreen(
                  receipeVideoLink: mealUrl,
                  trackerVideoLink: trackerUrl,
                  viewDay1Details: true,
                ),);
              }
              else if(widget.from == ProgramMealType.transition.name){
                //get Transition day1 meals
                final trackerUrl = _pref!.getString(AppConfig().trackerVideoUrl);

                gotoScreen(NewTransitionDesign(
                    totalDays: '1',
                    dayNumber: '1',
                  trackerVideoLink: trackerUrl
                  ,viewDay1Details: true,));
                //old screen
                // gotoScreen(TransitionMealPlanScreen(dayNumber: "1",
                //   totalDays: "1",trackerVideoLink: trackerUrl,viewDay1Details: true,));
              }
            },
            //Preparatory Meal Plan
            child: Text("View Day1 "
                "${(widget.from == ProgramMealType.prepratory.name) ? 'Prepratory Meal Plan'
                : (widget.from == ProgramMealType.transition.name) ? 'Transition Meal Plan'
                : 'Meal Plan'} >",
              style: TextStyle(
                  height: 1.5,
                  fontFamily: kFontBold,
                  color: gsecondaryColor,
                  fontSize: 11.sp
              ),
            )
        ),
      ],
    );
  }

  final ProgramRepository repository = ProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final PrepratoryRepository prepTransRepo = PrepratoryRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void startProgram() async{
    setState(() {
      isStarted = true;
    });
    // await _videoPlayerController!.stop();
    String? start;
    if(widget.from == ProgramMealType.prepratory.name){
      start = "2";
    }
    else if(widget.from == ProgramMealType.program.name){
      start = "1";
    }
    else if(widget.from == ProgramMealType.transition.name){
      start = "3";
    }

    if(start != null){
      // Future.delayed(Duration(seconds: 10)).then((value) {
      //   setState(() {
      //     isStarted = false;
      //   });
      // });
      final response = await ProgramService(repository: repository).startProgramOnSwipeService(start);

      if(response.runtimeType == StartProgramOnSwipeModel){
        //PrepratoryPlanScreen()
        if(widget.from == ProgramMealType.prepratory.name){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PreparatoryPlanScreen(dayNumber: "1", totalDays: '1',),
            ),
          );
        }
        else if(widget.from == ProgramMealType.program.name){
          if(widget.isPrepCompleted != null && widget.isPrepCompleted == true){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PrepratoryMealCompletedScreen(),
              ),
            );
          }
          else{
            final mealUrl = _pref!.getString(AppConfig().receipeVideoUrl);
            final trackerUrl = _pref!.getString(AppConfig().trackerVideoUrl);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MealPlanScreen(
                  receipeVideoLink: mealUrl,
                  trackerVideoLink: trackerUrl,
                ),
              ),
            );
          }
        }
        else if(widget.from == ProgramMealType.transition.name){
          final trackerUrl = _pref!.getString(AppConfig().trackerVideoUrl);

          gotoScreen(NewTransitionDesign(
            totalDays: '1',
            dayNumber: '1',
            trackerVideoLink: trackerUrl
          ));

          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         TransitionMealPlanScreen(
          //           dayNumber: "1",
          //           totalDays: "1",
          //           trackerVideoLink: trackerUrl,),
          //   ),
          // );
        }
      }
      else{
        ErrorModel model = response as ErrorModel;
        Get.snackbar(
          "",
          model.message ?? AppConfig.oopsMessage,
          titleText: SizedBox.shrink(),
          colorText: gWhiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: gsecondaryColor.withOpacity(0.55),
        );
        AppConfig().showSnackbar(context, model.message ?? AppConfig.oopsMessage);
      }
      setState(() {
        isStarted = false;
      });
    }
  }


  // ********** To DISPLAY MEALS, PREP MEAL, TRANS MEAL *******************

  Map<String, List<ChildMealPlanDetailsModel>> mealPlanData1 = {};

  getNormalMeals() async {
    final result = await ProgramService(repository: repository)
        .getMealPlanDetailsService("1");
    print("result: $result");

    if (result.runtimeType == MealPlanDetailsModel) {
      print("meal plan");
      MealPlanDetailsModel model = result as MealPlanDetailsModel;

      model.data!.keys.forEach((element) {
        print("before element $element");
      });
      // mealPlanData1.addAll(model.data!);
      mealPlanData1 = Map.of(model.data!);
      mealPlanData1.keys.forEach((element) {
        print("key==> $element");
      });

      mealPlanData1.values.forEach((element) {
        element.forEach((element1) {
          print("element1.toJson(): ${element1.toJson()}");
        });
      });
      print('meal list: ${mealPlanData1}');
      print('mealPlanData1.values.length:${mealPlanData1.values.length}');
    } else {
      ErrorModel model = result as ErrorModel;
      debugPrint(model.message ?? '');
      Future.delayed(Duration(seconds: 0)).whenComplete(() {
       AppConfig().showSnackbar(context, "Something went worng!", isError: true);
      });
    }
    print(result);
  }



  // **********************************************************************

 gotoScreen(screenName){
   Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => screenName,
     ),
   );
 }

  void showConfirmSheet() {
    return AppConfig().showSheet(context,
        Column(
          mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Center(
            child: Image.asset("assets/images/slide_start_popup.png",
              fit: BoxFit.fill,
              width: 80.w,
            ),
          ),
        ),
        SizedBox(width: 2.5.h),
        Center(
          child: Text("Once you slide,next day will be\nconsidered as Day 1 of the Program,\nAre you sure?",
            style: TextStyle(
                fontSize: bottomSheetHeadingFontSize,
                fontFamily: bottomSheetHeadingFontFamily,
                height: 1.65
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 2.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async{
                startProgram();
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 1.h, horizontal: 8.5.w
                ),
                decoration: BoxDecoration(
                    color: gsecondaryColor,
                    border: Border.all(color: kLineColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Yes",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gWhiteColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5.w),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 1.h, horizontal: 8.5.w),
                decoration: BoxDecoration(
                    color: gWhiteColor,
                    border: Border.all(color: kLineColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "No",
                  style: TextStyle(
                    fontFamily: kFontMedium,
                    color: gsecondaryColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h)
      ],
    ),
        bottomSheetHeight: 60.h,
      circleIcon: bsHeadPinIcon
    );
  }

}
