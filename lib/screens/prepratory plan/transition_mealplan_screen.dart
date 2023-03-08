import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/prepratory_meal_model/prep_meal_model.dart';
import 'package:gwc_customer/model/prepratory_meal_model/transition_meal_model.dart';
import 'package:gwc_customer/repository/api_service.dart';
import 'package:gwc_customer/repository/post_program_repo/post_program_repository.dart';
import 'package:gwc_customer/repository/prepratory_repository/prep_repository.dart';
import 'package:gwc_customer/screens/dashboard_screen.dart';
import 'package:gwc_customer/screens/program_plans/meal_pdf.dart';
import 'package:gwc_customer/screens/program_plans/program_start_screen.dart';
import 'package:gwc_customer/services/post_program_service/post_program_service.dart';
import 'package:gwc_customer/services/prepratory_service/prepratory_service.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/open_alert_box.dart';
import 'package:gwc_customer/widgets/vlc_player/vlc_player_with_controls.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../model/program_model/proceed_model/send_proceed_program_model.dart';
import '../../model/program_model/start_post_program_model.dart';
import '../program_plans/day_tracker_ui/day_tracker.dart';

class TransitionMealPlanScreen extends StatefulWidget {
  String totalDays;
  String dayNumber;
  final String? trackerVideoLink;
  final String? postProgramStage;
  TransitionMealPlanScreen({Key? key, required this.dayNumber, required this.totalDays, this.trackerVideoLink, this.postProgramStage}) : super(key: key);

  @override
  State<TransitionMealPlanScreen> createState() => _TransitionMealPlanScreenState();
}

class _TransitionMealPlanScreenState extends State<TransitionMealPlanScreen> {
  String? planNotePdfLink;
  Future? transitionMealFuture;
  getTransitionMeals() {
    transitionMealFuture = PrepratoryMealService(repository: repository).getTransitionMealService();
  }

  String? currentDay;
  String? totalDays;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentDay = widget.dayNumber;
    totalDays = widget.totalDays;
    getTransitionMeals();
  }

  final PrepratoryRepository repository = PrepratoryRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
      child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: buildAppBar((){
                      Navigator.pop(context);
                    },
                        showHelpIcon: true,
                        helpOnTap: (){
                      if(planNotePdfLink != null || planNotePdfLink!.isNotEmpty){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>
                            MealPdf(pdfLink: planNotePdfLink! ,
                              heading: planNotePdfLink?.split('/').last ?? '',
                              isVideoWidgetVisible: false,
                              headCircleIcon: bsHeadPinIcon,
                              topHeadColor: kBottomSheetHeadGreen,
                            )));
                      }
                      else{
                        AppConfig().showSnackbar(context, "Note Link Not available", isError: true);
                      }
                        }
                        ),
                    ),
                    FutureBuilder(
                      future: transitionMealFuture,
                        builder: (_, snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data.runtimeType == ErrorModel){
                            final res = snapshot.data as ErrorModel;
                            return Center(
                              child: Text(res.message ?? '',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: kFontMedium,
                                ),
                              ),
                            );
                          }
                          else{
                            TransitionMealModel res = snapshot.data as TransitionMealModel;
                            final String currentDayStatus = res.currentDayStatus.toString();
                            print("currentDayStatus top: ${currentDayStatus}");
                            final dataList = res.data!.toJson();
                            if(res.currentDay != null) currentDay = res.currentDay;
                            if(res.totalDays != null) totalDays = res.totalDays;
                            planNotePdfLink = res.note;
                            if(res.previousDayStatus == "0"){
                              Future.delayed(Duration(seconds: 0)).then((value) {
                                return showSymptomsTrackerSheet(context, (int.parse(widget.dayNumber)-1).toString()).then((value) {
                                  getTransitionMeals();
                                });
                              });
                            }
                            if(res.isTransMealCompleted == "1" && (widget.postProgramStage == null || widget.postProgramStage!.isEmpty)){
                              Future.delayed(Duration(seconds: 0)).then((value) {
                                return buildDayCompletedClap();
                              });
                            }
                              return customMealPlanTile(dataList, currentDayStatus);

                          }
                        }
                        else if(snapshot.hasError){
                          return Center(
                            child: Text(snapshot.error.toString() ?? '',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: kFontMedium,
                              ),
                            ),
                          );
                        }
                        return Center(child: buildCircularIndicator(),);
                        }
                    )
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

  customMealPlanTile(Map<String, dynamic> dataList, String currentDayStatus){
    print("currentDayStatus: ${currentDayStatus}");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('Day ${currentDay} of Transition meal plan',
              style: TextStyle(
                  fontFamily: eUser().mainHeadingFont,
                  color: eUser().mainHeadingColor,
                  fontSize: 14.sp

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text('${int.parse(totalDays!) - int.parse(currentDay!)} days Remaining',
              style: TextStyle(
                  fontFamily: kFontMedium,
                  color: gHintTextColor,
                  fontSize: 10.sp
              ),
            ),
          ),
          ...dataList.entries.map((e) {
            List<TransMealSlot> lst = (e.value as List).map((e) => TransMealSlot.fromJson(e)).toList();
            // (e.value as List).forEach((element) {
            //   lst.add(MealSlot.fromJson(element));
            // });
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(e.key,
                    style: TextStyle(
                      height: 1.5,
                      color: MealPlanConstants().mealNameTextColor,
                      fontSize: MealPlanConstants().mealNameFontSize,
                      fontFamily: MealPlanConstants().mealNameFont,
                        // fontSize: MealPlanConstants().mealNameFontSize,
                        // fontFamily: MealPlanConstants().mealNameFont
                    ),
                  ),
                ),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: lst.length,
                  itemBuilder: (_, index){
                    return GestureDetector(
                      onTap: (){
                        showPdf(lst[index].recipeUrl ?? ' ');
                      },
                      child: Container(
                        height:120 ,
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 85,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: (lst[index].itemPhoto == null) ? Image.asset('assets/images/meal_placeholder.png',
                                  fit: BoxFit.fill,
                                ) :
                                Image.network(lst[index].itemPhoto?? '',
                                  errorBuilder: (_, widget, child){
                                    return Image.asset('assets/images/meal_placeholder.png',
                                      fit: BoxFit.fill,
                                    );
                                  },
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 3,
                                    ),
                                    RichText(
                                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                      text: TextSpan(
                                        text: lst[index].name,
                                          style: TextStyle(
                                              fontSize: MealPlanConstants().mealNameFontSize,
                                              fontFamily: MealPlanConstants().mealNameFont,
                                            color: gHintTextColor
                                          ),
                                        children:[
                                          TextSpan(
                                            text: (lst[index].subTitle == null) ? '' : '\t\t\t*${lst[index].subTitle}',
                                            style: TextStyle(
                                              fontSize: MealPlanConstants().mustHaveFontSize,
                                              fontFamily: MealPlanConstants().mustHaveFont,
                                              color: MealPlanConstants().mustHaveTextColor,
                                            ),
                                          )
                                        ]
                                      ),
                                    ),
                                    // Text(lst[index].name ?? 'Brahmari',
                                    //   style: TextStyle(
                                    //       fontSize: MealPlanConstants().mealNameFontSize,
                                    //       fontFamily: MealPlanConstants().mealNameFont
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 2,
                                    // ),
                                    Expanded(
                                      child: Text(lst[index].benefits!.replaceAll("- ",'\n') ??
                                          "- It Calms the nervous system.\n\n- It simulates the pituitary and pineal glands.",
                                        style: TextStyle(
                                          height: 1.2,
                                            fontSize: MealPlanConstants().benifitsFontSize,
                                            fontFamily: MealPlanConstants().benifitsFont
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, index){
                    // if(index.isEven){
                    return orFiled();
                    // }
                    // else return SizedBox();
                  },
                ),
              ],
            );
          }),
          if(currentDayStatus == "0") btn(),
        ],
      ),
    );
  }

  showPdf(String itemUrl) {
    print(itemUrl);
    String? url;
    if(itemUrl.contains('drive.google.com')){
      url = itemUrl;
      // url = 'https://drive.google.com/uc?export=view&id=1LV33e5XOl0YM8r6AqhU6B4oZniWwXcTZ';
      // String baseUrl = 'https://drive.google.com/uc?export=view&id=';
      // print(itemUrl.split('/')[5]);
      // url = baseUrl + itemUrl.split('/')[5];
    }
    else{
      url = itemUrl;
    }
    print(url);
    if(url.isNotEmpty) Navigator.push(context, MaterialPageRoute(builder: (ctx)=> MealPdf(pdfLink: url! ,heading: url.split('/').last,)));
  }

  orFiled(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('------------ ',
              style: TextStyle(
                fontFamily: kFontBold,
                color: gBlackColor
              ),
            ),
            Text('OR',
              style: TextStyle(
                  fontFamily: kFontBold,
                  color: gBlackColor
              ),
            ),
            Text(' ------------',
              style: TextStyle(
                  fontFamily: kFontBold,
                  color: gBlackColor
              ),
            ),
          ],
        ),
      ),
    );
  }

  btn(){
    return Center(
      child: GestureDetector(
        onTap: (){
          showSymptomsTrackerSheet(context, widget.dayNumber).then((value) {
            getTransitionMeals();
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 2.h),
          width: 60.w,
          height: 5.h,
          decoration: BoxDecoration(
            color: eUser().buttonColor,
            borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
            // border: Border.all(color: eUser().buttonBorderColor,
            //     width: eUser().buttonBorderWidth),
          ),
          child: Center(
            child: Text(
              'Proceed to Symptoms Tracker',
              // 'Proceed to Day $proceedToDay',
              style: TextStyle(
                fontFamily: eUser().buttonTextFont,
                color: eUser().buttonTextColor,
                // color: (statusList.length != lst.length) ? gPrimaryColor : gMainColor,
                fontSize: eUser().buttonTextSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
  bool showMealVideo = false;
  VlcPlayerController? _mealPlayerController;
  final _mealKey = GlobalKey<VlcPlayerWithControlsState>();
  videoMp4Widget({required VoidCallback onTap, String? videoName}){
    return InkWell(
      onTap: onTap,
      child: Card(
          child: Row(
              children:[
                Image.asset("assets/images/meal_placeholder.png",
                  height: 35,
                  width: 40,
                ),
                Expanded(child: Text(videoName ?? "Symptom Tracker.mp4",
                  style: TextStyle(
                      fontFamily: kFontBook
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/arrow_for_video.png",
                    height: 35,
                  ),
                )
              ]
          )
      ),
    );
  }
  addUrlToVideoPlayer(String url){
    print("url"+ url);
    _mealPlayerController = VlcPlayerController.asset(
      "assets/images/new_ds/popup_video.mp4",
      // url,
      // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
      // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
      hwAcc: HwAcc.auto,
      autoPlay: true,
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

  buildMealVideo({required VoidCallback onTap}) {
    if(_mealPlayerController != null){
      return Column(
        children: [
          AspectRatio(
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
                    key: _mealKey,
                    controller: _mealPlayerController!,
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
            ),
          ),
          Center(
              child: IconButton(
                icon: Icon(Icons.cancel_outlined,
                  color: gsecondaryColor,
                ),
                onPressed: onTap,
              )
          )
        ],
      );
    }
    else {
      return SizedBox.shrink();
    }
  }
  Future showSymptomsTrackerSheet(BuildContext context, String day) {
    return AppConfig().showSheet(
        context,
        StatefulBuilder(
            builder: (_, setState){
              return Column(
                children:[
                  videoMp4Widget(
                      videoName: "Know more about Symptoms Tracker",
                      onTap: (){
                        addUrlToVideoPlayer("");
                        setState(() {
                          showMealVideo = true;
                        });
                      }),
                  Stack(
                    children: [
                      TrackerUI(from: ProgramMealType.transition.name,
                        proceedProgramDayModel: ProceedProgramDayModel(day: day),),
                      Visibility(
                        visible: showMealVideo,
                        child: Positioned(
                            child: Center(
                                child: buildMealVideo(
                                    onTap: () async{
                                      setState(() {
                                        showMealVideo = false;
                                      });
                                      _mealPlayerController!.stop();
                                      // await _mealPlayerController!.stopRendererScanning();
                                      // await _mealPlayerController!.dispose();
                                    }
                                )
                            )
                        ),
                      )
                    ],
                  )
                ],
              );
            }
        ),
        circleIcon: bsHeadPinIcon,
        bottomSheetHeight: 90.h);
    return  showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        builder: (ctx) {
          return Wrap(
            children: [
              TrackerUI(from: ProgramMealType.transition.name,proceedProgramDayModel: ProceedProgramDayModel(day: day),)
            ],
          );
        }).then((value) {
          setState(() {

          });
          getTransitionMeals();
    });
  }
  bool isOpened = false;

  buildDayCompletedClap() {
    return AppConfig().showSheet(
        context,
        WillPopScope(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: gMainColor),
                  ),
                  child: Lottie.asset(
                    "assets/lottie/clap.json",
                    height: 20.h,
                  ),
                ),
                SizedBox(height: 1.5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Text(
                    "You Have completed the Transition Plan, Now you can proceed to Post Program",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.2,
                      color: gTextColor,
                      fontSize: bottomSheetSubHeadingXLFontSize,
                      fontFamily: bottomSheetSubHeadingMediumFont,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isOpened = true;
                    });
                    Future.delayed(Duration(seconds: 0)).whenComplete(() {
                      openProgressDialog(context);
                    });
                    startPostProgram();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: gsecondaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: kFontMedium,
                        color: gWhiteColor,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onWillPop: ()=>Future.value(false)
        ),
        circleIcon: bsHeadPinIcon,
        bottomSheetHeight: 60.h);
  }

  startPostProgram() async {
    final res = await PostProgramService(repository: _postProgramRepository)
        .startPostProgramService();

    if (res.runtimeType == ErrorModel) {
      ErrorModel model = res as ErrorModel;
      Navigator.pop(context);
      AppConfig().showSnackbar(context, model.message ?? '', isError: true);
    } else {
      Navigator.pop(context);
      if (res.runtimeType == StartPostProgramModel) {
        StartPostProgramModel model = res as StartPostProgramModel;
        print("start program: ${model.response}");
        AppConfig().showSnackbar(context, "Post Program started" ?? '');
        Future.delayed(Duration(seconds: 2)).then((value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => DashboardScreen()),
                  (route) => true);
        });
      }
    }
  }

  final PostProgramRepository _postProgramRepository = PostProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

}
