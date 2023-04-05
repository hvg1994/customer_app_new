import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/prepratory_meal_model/prep_meal_model.dart';
import 'package:gwc_customer/model/prepratory_meal_model/transition_meal_model.dart';
import 'package:gwc_customer/model/program_model/proceed_model/send_proceed_program_model.dart';
import 'package:gwc_customer/model/program_model/start_post_program_model.dart';
import 'package:gwc_customer/repository/api_service.dart';
import 'package:gwc_customer/repository/prepratory_repository/prep_repository.dart';
import 'package:gwc_customer/screens/dashboard_screen.dart';
import 'package:gwc_customer/screens/prepratory%20plan/new/meal_plan_recipe_details.dart';
import 'package:gwc_customer/screens/program_plans/day_tracker_ui/day_tracker.dart';
import 'package:gwc_customer/screens/program_plans/meal_pdf.dart';
import 'package:gwc_customer/screens/program_plans/program_start_screen.dart';
import 'package:gwc_customer/services/post_program_service/post_program_service.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../../../repository/post_program_repo/post_program_repository.dart';
import '../../../services/prepratory_service/prepratory_service.dart';

class NewTransitionDesign extends StatefulWidget {
  String totalDays;
  String dayNumber;
  final String? trackerVideoLink;
  final String? postProgramStage;
  final bool viewDay1Details;
  NewTransitionDesign(
      {Key? key,
      required this.dayNumber,
      required this.totalDays,
      this.trackerVideoLink,
      this.postProgramStage,
      this.viewDay1Details = false})
      : super(key: key);

  @override
  State<NewTransitionDesign> createState() => _NewTransitionDesignState();
}

class _NewTransitionDesignState extends State<NewTransitionDesign> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  //
  // final List<String> _list = [
  //   "Breakfast",
  //   "Mid Day",
  //   "Lunch",
  //   "Dinner",
  //   "Post Dinner"
  // ];


  List<String> _list = [];

  Map<String, List<TransMealSlot>> tabs = {};


  Map<String, TransSubItems> slotNamesForTabs = {};

  List subItemNames = [];
  int tabSize = 1;

  bool showLoading = true;

  String selectedItemName = "";


  getTransitionMeals() async {
    final result = await PrepratoryMealService(repository: repository)
        .getTransitionMealService();

    if (result.runtimeType == ErrorModel) {
      final res = result as ErrorModel;
      return Center(
        child: Text(
          res.message ?? '',
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: kFontMedium,
          ),
        ),
      );
    }
    else {
      TransitionMealModel res = result as TransitionMealModel;
      final String currentDayStatus = res.currentDayStatus.toString();
      print("currentDayStatus top: ${currentDayStatus}");
      final dataList = res.data ?? {};
      if (res.currentDay != null) currentDay = res.currentDay;
      if (res.totalDays != null) totalDays = res.totalDays;
      planNotePdfLink = res.note;

      slotNamesForTabs.addAll(dataList);

      slotNamesForTabs.forEach((key,value) {
        _list.add(key);

        print("$key ==> ${value.subItems!.length}");
      });


      updateTabSize();
    }
    setState(() {
      showLoading = false;
    });

  }

  String selectedSubTab = "";
  List<Map<String, List<TransMealSlot>>> selectedTabs = [];

  updateTabSize(){
    selectedTabs.clear();
    slotNamesForTabs.forEach((key, value) {
      if(_list[selectedIndex] == key){
        print("tabsize: ${value.subItems!.length}");
       setState(() {
         tabSize = value.subItems!.length;
         selectedTabs.add(value.subItems!);
       });
      }
    });

    selectedSubTab = selectedTabs.first.keys.first;

    print("selectedTabs: $selectedTabs");
  }


  String? planNotePdfLink;
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

  @override
  void dispose() {
    if (_mealPlayerController != null) _mealPlayerController!.dispose();
    if (_customVideoPlayerController != null) {
      _customVideoPlayerController!.dispose();
    }

    super.dispose();
  }

  final PrepratoryRepository repository = PrepratoryRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: showLoading ? kWhiteColor : Color(0xffC8DE95).withOpacity(0.6),
        body: showLoading
            ? Center(child: buildCircularIndicator(),)
            : DefaultTabController(
          length: tabSize,
          child: StatefulBuilder(
            builder: (_, setstate) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 1.h, left: 3.w),
                    child: buildAppBar(
                            () {
                          Navigator.pop(context);
                        },
                        showHelpIcon: true,
                        helpOnTap: () {
                          if (planNotePdfLink != null ||
                              planNotePdfLink!.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => MealPdf(
                                    pdfLink: planNotePdfLink!,
                                    heading:
                                    planNotePdfLink?.split('/').last ??
                                        '',
                                    isVideoWidgetVisible: false,
                                    headCircleIcon: bsHeadPinIcon,
                                    topHeadColor: kBottomSheetHeadGreen,
                                    isSheetCloseNeeded: true,
                                    sheetCloseOnTap: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                            );
                          } else {
                            AppConfig().showSnackbar(
                                context, "Note Link Not available",
                                isError: true);
                          }
                        }),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Day ${1} Transition Meal Plan',
                    style: TextStyle(
                        fontFamily: eUser().mainHeadingFont,
                        color: eUser().mainHeadingColor,
                        fontSize: eUser().mainHeadingFontSize),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '2 Days Remaining',
                    style: TextStyle(
                        fontFamily: eUser().userTextFieldFont,
                        color: eUser().mainHeadingColor,
                        fontSize: eUser().userTextFieldHintFontSize),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 28.w, vertical: 4.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if(selectedIndex == 0){}
                            else{
                              setstate(() {
                                if (selectedIndex > 0) {
                                  selectedIndex--;
                                }
                                updateTabSize();
                                print(selectedIndex);
                              });
                            }
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: eUser().mainHeadingColor,
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            _list[selectedIndex],
                            style: TextStyle(
                                fontFamily: eUser().mainHeadingFont,
                                color: eUser().mainHeadingColor,
                                fontSize: eUser().mainHeadingFontSize),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setstate(() {
                              if(selectedIndex == _list.length-1) {}
                              else{
                                if (selectedIndex >= 0 &&
                                    selectedIndex != _list.length-1) {
                                  selectedIndex++;
                                }
                                print(selectedIndex);
                                updateTabSize();
                                print(selectedIndex);
                              }
                            });
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: eUser().mainHeadingColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: TabBar(
                      // padding: EdgeInsets.symmetric(horizontal: 3.w),
                      isScrollable: true,
                      unselectedLabelColor: tabBarHintColor,
                      labelColor: gBlackColor,
                      controller: _tabController,
                      unselectedLabelStyle: TextStyle(
                          fontFamily: kFontBook,
                          color: gHintTextColor,
                          fontSize: 9.sp),
                      labelStyle: TextStyle(
                          fontFamily: kFontMedium,
                          color: gBlackColor,
                          fontSize: 9.sp),
                      indicator: BoxDecoration(
                        color: gWhiteColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      onTap: (index) {
                        print("ontap: $index");

                        selectedTabs.forEach((element) {
                          print(element.keys.elementAt(index));
                          setstate((){
                            selectedSubTab = element.keys.elementAt(index);
                          });
                        });
                      },
                      tabs:buildTabs()
                       // [selectedTabs.map((e) => _buildTabs(e)).to]


                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 3.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.w, vertical: 1.h),
                      decoration: const BoxDecoration(
                        color: gBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                            color: kLineColor,
                            offset: Offset(2, 3),
                            blurRadius: 5,
                          )
                        ],
                        // border: Border.all(
                        //   width: 1,
                        //   color: kLineColor,
                        // ),
                      ),
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: buildTabBarView(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        )
    );
  }

  buildTabs(){
    List<Widget> widgetList = [];

    selectedTabs.forEach((element) {
      element.forEach((key, value) {
        widgetList.add(Tab(text: key,));
      });
    });
    return widgetList;
  }

  buildTabBarView(){
    print("buildTabBarView");
    List<Widget> widgetList = [];

    print(selectedSubTab);

    selectedTabs.forEach((element) {
      element.forEach((key, value) {
          widgetList.add(buildTabView(value));
      });
    });
    // selectedTabs.forEach((element) {
    //   element.forEach((key, value) {
    //     if(key == selectedSubTab){
    //       print("$key // $value");
    //       widgetList.add(buildTabView(value));
    //     }
    //   });
    // });

    return widgetList;
  }

  buildTabView(List<TransMealSlot> value) {
    return SizedBox(
      height: 65.h,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          // physics: const NeverScrollableScrollPhysics(),
          itemCount: value.length,
          itemBuilder: (context, index) {
            return Container(
              width: 300,
              margin: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: gBackgroundColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: buildReceipeDetails(value[index]),
            );
          }),
    );
  }

  buildReceipeDetails(TransMealSlot value) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          bottom: 0,
          left: 2.w,
          right: 0,
          top: 6.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: kLineColor.withOpacity(0.2), width: 0.9),
              // boxShadow: [
              //   BoxShadow(
              //     color: gBlackColor.withOpacity(0.1),
              //     offset: Offset(2, 3),
              //     blurRadius: 5,
              //   )
              // ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    value.name ?? '',
                    style: TextStyle(
                        fontFamily: eUser().mainHeadingFont,
                        color: eUser().mainHeadingColor,
                        fontSize: eUser().mainHeadingFontSize),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  (value.benefits != null)
                      ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...value.benefits!.split('*').map((element) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle_sharp,
                              color: gGreyColor,
                              size: 1.h,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                element ?? '',
                                style: TextStyle(
                                    fontFamily: eUser().userTextFieldFont,
                                    height: 1.5,
                                    color: eUser().userTextFieldColor,
                                    fontSize: eUser().userTextFieldHintFontSize),
                              ),
                            ),
                          ],
                        );
                      })
                    ],
                  )
                      : SizedBox(),
                  SizedBox(height: 5.h),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                              () =>  MealPlanRecipeDetails(
                            meal: MealSlot.fromJson(value.toJson()),
                          ),
                        );
                      },
                      child: Container(
                        // margin: EdgeInsets.symmetric(horizontal: 5.w),
                        padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                          color: newDashboardGreenButtonColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: kLineColor,
                              offset: Offset(2, 3),
                              blurRadius: 5,
                            )
                          ],
                          // border: Border.all(
                          //   width: 1,
                          //   color: kLineColor,
                          // ),
                        ),
                        child: Text(
                          "Recipe",
                          style: TextStyle(
                            color: gWhiteColor,
                            fontFamily: 'GothamBook',
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0.h,
          left: 0,
          right: 0,
          child: Container(
            padding:const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: newDashboardGreenButtonColor,
              boxShadow: [
                BoxShadow(
                  color: gBlackColor.withOpacity(0.1),
                  offset: Offset(2, 3),
                  blurRadius: 5,
                )
              ],
            ),
            child: Center(
              child: CircleAvatar(
                radius: 8.h,
                backgroundImage: AssetImage("assets/images/Group 3252.png"),
              ),
            ),
          ),
        ),
      ],
    );
  }

  showPdf(String itemUrl) {
    print(itemUrl);
    String? url;
    if (itemUrl.contains('drive.google.com')) {
      url = itemUrl;
      // url = 'https://drive.google.com/uc?export=view&id=1LV33e5XOl0YM8r6AqhU6B4oZniWwXcTZ';
      // String baseUrl = 'https://drive.google.com/uc?export=view&id=';
      // print(itemUrl.split('/')[5]);
      // url = baseUrl + itemUrl.split('/')[5];
    } else {
      url = itemUrl;
    }
    print(url);
    if (url.isNotEmpty)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => MealPdf(
                    pdfLink: url!,
                    heading: url.split('/').last,
                  )));
  }

  orFiled() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '------------ ',
              style: TextStyle(fontFamily: kFontBold, color: gBlackColor),
            ),
            Text(
              'OR',
              style: TextStyle(fontFamily: kFontBold, color: gBlackColor),
            ),
            Text(
              ' ------------',
              style: TextStyle(fontFamily: kFontBold, color: gBlackColor),
            ),
          ],
        ),
      ),
    );
  }

  btn() {
    return Center(
      child: GestureDetector(
        onTap: () {
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

  VideoPlayerController? _mealPlayerController;
  CustomVideoPlayerController? _customVideoPlayerController;
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      CustomVideoPlayerSettings(
    controlBarAvailable: false,
    showPlayButton: true,
    playButton: Center(
      child: Icon(
        Icons.play_circle,
        color: Colors.white,
      ),
    ),
    settingsButtonAvailable: false,
    playbackSpeedButtonAvailable: false,
    placeholderWidget: Container(
      child: Center(child: CircularProgressIndicator()),
      color: gBlackColor,
    ),
  );

  videoMp4Widget({required VoidCallback onTap, String? videoName}) {
    return InkWell(
      onTap: onTap,
      child: Card(
          child: Row(children: [
        Image.asset(
          "assets/images/meal_placeholder.png",
          height: 35,
          width: 40,
        ),
        Expanded(
            child: Text(
          videoName ?? "Symptom Tracker.mp4",
          style: TextStyle(fontFamily: kFontBook),
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/arrow_for_video.png",
            height: 35,
          ),
        )
      ])),
    );
  }

  addUrlToVideoPlayer(String url) async {
    print("url" + url);
    _mealPlayerController =
        VideoPlayerController.network(Uri.parse(url).toString());
    _mealPlayerController!.initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _mealPlayerController!,
      customVideoPlayerSettings: _customVideoPlayerSettings,
    );
    _mealPlayerController!.play();
    if (await Wakelock.enabled == false) {
      Wakelock.enable();
    }
  }

  buildMealVideo({required VoidCallback onTap}) {
    if (_mealPlayerController != null) {
      return Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
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
                      child: CustomVideoPlayer(
                        customVideoPlayerController:
                            _customVideoPlayerController!,
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
              Positioned(
                  child: AspectRatio(
                aspectRatio: 16 / 9,
                child: GestureDetector(
                  onTap: () {
                    print("onTap");
                    if (_mealPlayerController != null) {
                      if (_customVideoPlayerController!
                          .videoPlayerController.value.isPlaying) {
                        _customVideoPlayerController!.videoPlayerController
                            .pause();
                      } else {
                        _customVideoPlayerController!.videoPlayerController
                            .play();
                      }
                    }
                  },
                ),
              ))
            ],
          ),
          Center(
              child: IconButton(
            icon: Icon(
              Icons.cancel_outlined,
              color: gsecondaryColor,
            ),
            onPressed: onTap,
          ))
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Future showSymptomsTrackerSheet(BuildContext context, String day) {
    return AppConfig().showSheet(context,
        StatefulBuilder(builder: (_, setState) {
      return Column(
        children: [
          videoMp4Widget(
              videoName: "Know more about Symptoms Tracker",
              onTap: () {
                addUrlToVideoPlayer("");
                setState(() {
                  showMealVideo = true;
                });
              }),
          Stack(
            children: [
              TrackerUI(
                from: ProgramMealType.transition.name,
                proceedProgramDayModel: ProceedProgramDayModel(day: day),
              ),
              Visibility(
                visible: showMealVideo,
                child: Positioned(
                    child: Center(child: buildMealVideo(onTap: () async {
                  setState(() {
                    showMealVideo = false;
                  });
                  if (await Wakelock.enabled == true) {
                    Wakelock.disable();
                  }
                  if (_mealPlayerController != null)
                    _mealPlayerController!.dispose();
                  if (_customVideoPlayerController != null)
                    _customVideoPlayerController!.dispose();

                  // await _mealPlayerController!.stopRendererScanning();
                  // await _mealPlayerController!.dispose();
                }))),
              )
            ],
          )
        ],
      );
    }), circleIcon: bsHeadPinIcon, bottomSheetHeight: 90.h);
    return showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        builder: (ctx) {
          return Wrap(
            children: [
              TrackerUI(
                from: ProgramMealType.transition.name,
                proceedProgramDayModel: ProceedProgramDayModel(day: day),
              )
            ],
          );
        }).then((value) {
      setState(() {});
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
                      // openProgressDialog(context);
                    });
                    startPostProgram();
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
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
            onWillPop: () => Future.value(false)),
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
