import 'dart:convert';
import 'package:easy_scroll_to_index/easy_scroll_to_index.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/program_model/proceed_model/send_proceed_program_model.dart';
import 'package:gwc_customer/model/program_model/program_days_model/child_program_day.dart';
import 'package:gwc_customer/model/program_model/program_days_model/program_day_model.dart';
import 'package:gwc_customer/model/program_model/start_post_program_model.dart';
import 'package:gwc_customer/repository/post_program_repo/post_program_repository.dart';
import 'package:gwc_customer/repository/program_repository/program_repository.dart';
import 'package:gwc_customer/screens/dashboard_screen.dart';
import 'package:gwc_customer/screens/program_plans/day_tracker_ui/day_tracker.dart';
import 'package:gwc_customer/screens/program_plans/program_start_screen.dart';
import 'package:gwc_customer/services/post_program_service/post_program_service.dart';
import 'package:gwc_customer/widgets/open_alert_box.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../model/program_model/meal_plan_details_model/child_meal_plan_details_model.dart';
import '../../model/program_model/meal_plan_details_model/meal_plan_details_model.dart';
import '../../repository/api_service.dart';
import '../../services/program_service/program_service.dart';
import '../../services/vlc_service/check_state.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/pip_package.dart';
import '../../widgets/vlc_player/vlc_player_with_controls.dart';
import '../../widgets/widgets.dart';
import 'day_program_plans.dart';
import 'meal_pdf.dart';
import 'meal_plan_data.dart';
import 'package:http/http.dart' as http;
import 'package:simple_tooltip/simple_tooltip.dart';

class MealPlanScreen extends StatefulWidget {
  final String? postProgramStage;
  const MealPlanScreen({Key? key, this.postProgramStage}) : super(key: key);

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final _pref = AppConfig().preferences;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();

  int planStatus = 0;
  String headerText = "";
  Color textColor = gWhiteColor;
  String? planNotePdfLink;
  bool showToolTip = true;
  bool shoppingToolTip = true;

  String btnText = 'Proceed to Symptoms Tracker';

  bool isLoading = false;

  String errorMsg = '';

  List<ChildMealPlanDetailsModel>? shoppingData;

  Map<String, List<ChildMealPlanDetailsModel>> mealPlanData1 = {};

  final tableHeadingBg = gHintTextColor.withOpacity(0.4);

  List<String> list = [
    "Followed",
    "Unfollowed",
  ];

  List<String> sendList = [
    "followed",
    "unfollowed",
  ];

  //****************  video player variables  *************

  // for video player
  VlcPlayerController? _controller;
  final _key = GlobalKey<VlcPlayerWithControlsState>();

  var checkState;

  /// to check enable / disable
  bool isEnabled = false;

  String videoName = '';
  String mealTime = '';

  final _scrollController = ScrollToIndexController();

  // *******************************************************

  // ***************** getDay Api Params *******************

  int? nextDay;
  int? presentDay;
  int? selectedDay;
  bool? isDayCompleted;
  List<ChildProgramDayModel> listData = [];

  bool isOpened = false;

  // *****************      End   ************************

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  getProgramDays() async {
    setState(() {
      isLoading = true;
    });
    final res = await ProgramService(repository: repository)
        .getMealProgramDaysService();
    if (res.runtimeType == ProgramDayModel) {
      final model = res as ProgramDayModel;
      print(model.toJson());
      // model.data!.forEach((element) {
      //   print('${element.dayNumber} -- ${element.color}');
      // });
      _pref!.setInt(AppConfig.STORE_LENGTH, model.data!.length);
      presentDay = int.tryParse(model.presentDay!);
      nextDay = int.tryParse(model.presentDay!)! + 1;
      selectedDay = int.tryParse(model.presentDay!);
      model.data!.forEach((element) {
        if (element.dayNumber == presentDay.toString()) {
          isDayCompleted = element.isCompleted == 1;
        }
      });
      print("next day: $nextDay");
      print(isDayCompleted);
      Future.delayed(Duration(seconds: 1)).then((value) {
        _scrollController.easyScrollToIndex(
            index: model.data!.indexWhere(
                    (element) => element.dayNumber == presentDay.toString()) +
                1);
      });
      print(
          "index==> ${model.data!.indexWhere((element) => element.dayNumber == presentDay.toString()).toDouble()}");
      // _scrollController.jumpTo(
      //     model.data!.indexWhere((element) => element.dayNumber == presentDay.toString()).toDouble(),
      //     // duration: const Duration(seconds: 2),
      //     // curve: Curves.easeIn
      // );
      getMeals();

      buildDays(model);
    } else {
      ErrorModel model = res as ErrorModel;
      errorMsg = model.message ?? '';
      print('get program Days error:${model.message}');
      Future.delayed(Duration(seconds: 0)).whenComplete(() {
        setState(() {
          isLoading = false;
        });
        showAlert(context, model.status!,
            isSingleButton: !(model.status != '401'), positiveButton: () {
          if (model.status == '401') {
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
            getProgramDays();
          }
        });
      });
    }
  }

  buildDays(ProgramDayModel model) {
    listData = model.data!;
    // this is for bottomsheet
    if (listData.last.isCompleted == 1) {
      if (widget.postProgramStage == null || widget.postProgramStage!.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!isOpened) {
            setState(() {
              isOpened = true;
            });
            buildDayCompletedClap();
          }
        });
      }
    }
  }

  buildDayCompleted() {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: false,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(top: 2.h, left: 10.w, right: 10.w),
          decoration: const BoxDecoration(
            color: gWhiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          height: size.height * 0.50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isOpened = false;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: gMainColor, width: 1),
                      ),
                      child: Icon(
                        Icons.clear,
                        color: gMainColor,
                        size: 1.8.h,
                      ),
                    ),
                  ),
                ),
              ),
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
                  "You Have completed the ${listData.length} days Meal Plan, Now you can proceed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    fontFamily: kFontBold,
                    color: gTextColor,
                    fontSize: 10.sp,
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
                  padding:
                      EdgeInsets.symmetric(vertical: 1.h, horizontal: 15.w),
                  decoration: BoxDecoration(
                    color: gPrimaryColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: gMainColor, width: 1),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: "GothamRoundedBold_21016",
                      color: gMainColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildDayCompletedClap() {
    return AppConfig().showSheet(
        context,
        Column(
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
                "You Have completed the ${listData.length} days Meal Plan, Now you can proceed",
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

  final _switchController = ValueNotifier<bool>(false);

  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _switchController.addListener(() {
      setState(() {
        if (_switchController.value) {
          _checked = true;
        } else {
          _checked = false;
        }
      });
    });
    getProgramDays();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      commentController.addListener(() {
        setState(() {});
      });
    });
  }

  getMeals() async {
    statusList.clear();
    lst.clear();
    final result = await ProgramService(repository: repository)
        .getMealPlanDetailsService(selectedDay.toString());
    print("result: $result");

    if (result.runtimeType == MealPlanDetailsModel) {
      print("meal plan");
      MealPlanDetailsModel model = result as MealPlanDetailsModel;
      setState(() {
        isLoading = false;
        showShimmer = false;
        planNotePdfLink = model.note;
      });
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
      // when day completed
      if (isDayCompleted != null && isDayCompleted == true) {
        mealPlanData1.forEach((key, value) {
          (value).forEach((element) {
            statusList.putIfAbsent(
                element.itemId, () => element.status.toString().capitalize);
          });
        });
        // mealPlanData1.forEach((element) {
        //   print(element.toJson());
        //   statusList.putIfAbsent(element.itemId, () => element.status.toString().capitalize);
        // });
        commentController.text = model.comment ?? '';
      }
      mealPlanData1.values.forEach((element) {
        element.forEach((item) {
          lst.add(item);
        });
      });
      print(
          'mealPlanData1.values.length:${mealPlanData1.values.length}, ${lst.length}');
    } else {
      ErrorModel model = result as ErrorModel;
      errorMsg = model.message ?? '';
      Future.delayed(Duration(seconds: 0)).whenComplete(() {
        setState(() {
          showShimmer = false;
          isLoading = false;
        });
        showAlert(context, model.status!,
            isSingleButton: !(model.status != '401'), positiveButton: () {
          if (model.status == '401') {
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            getMeals();
            Navigator.pop(context);
          }
        });
      });
    }
    print(result);
  }

  showAlert(
    BuildContext context,
    String status, {
    bool isSingleButton = true,
    required VoidCallback positiveButton,
  }) {
    return openAlertBox(
        context: context,
        barrierDismissible: false,
        content: errorMsg,
        titleNeeded: false,
        isSingleButton: isSingleButton,
        positiveButtonName: (status == '401') ? 'Go Back' : 'Retry',
        positiveButton: positiveButton,
        negativeButton: isSingleButton
            ? null
            : () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
        negativeButtonName: isSingleButton ? null : 'Go Back');
  }

  initVideoView(String? url) {
    print("init url: $url");
    _controller = VlcPlayerController.network(
      // url ??
      Uri.parse(
              'https://gwc.disol.in/storage/uploads/users/recipes/Calm Module - Functional (AR).mp4')
          .toString(),
      hwAcc: HwAcc.full,
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

    print(
        "_controller.isReadyToInitialize: ${_controller!.isReadyToInitialize}");
    _controller!.addOnInitListener(() async {
      await _controller!.startRendererScanning();
    });
  }

  @override
  void dispose() async {
    super.dispose();
    _switchController.dispose();
    commentController.dispose();
    await _controller?.dispose();
    await _controller?.stopRendererScanning();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
        child: SafeArea(
          child: Scaffold(
            body: videoPlayerView(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final _ori = MediaQuery.of(context).orientation;
    bool isPortrait = _ori == Orientation.portrait;
    if (!isPortrait) {
      AutoOrientation.portraitUpMode();
      // setState(() {
      //   isEnabled = false;
      // });
    }
    print(isEnabled);
    return !isEnabled ? true : false;
    // return false;
  }

  bool showShimmer = false;
  dayItems(int index) {
    return GestureDetector(
      onTap: checkOnTapCondition(index, listData)
          ? () {
              print(index);
              setState(() {
                showShimmer = true;
                selectedDay = int.parse(listData[index].dayNumber!);
                isDayCompleted = listData[index].isCompleted == 1;
              });
              print("isDayCompleted: $isDayCompleted");
              getMeals();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => MealPlanScreen(
              //       // day: dayPlansData[index]["day"],
              //       isCompleted: listData[index].isCompleted == 1 ? true : null,
              //       day: listData[index].dayNumber!,
              //       presentDay: model.presentDay.toString(),
              //       nextDay: nextDay.toString() ?? "-1",
              //     ),
              //   ),
              // );
            }
          : null,
      child: Opacity(
        opacity: getOpacity(index, listData),
        child: Container(
            // height: 5.h,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: MealPlanConstants().dayBorderColor),
                borderRadius:
                    BorderRadius.circular(MealPlanConstants().dayBorderRadius),
                color: (listData[index].isCompleted == 1)
                    ? MealPlanConstants().dayBgSelectedColor
                    : (listData[index].dayNumber == presentDay.toString())
                        ? MealPlanConstants().dayBgPresentdayColor
                        : MealPlanConstants().dayBgNormalColor),
            margin: EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                'DAY ${listData[index].dayNumber!}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize:
                        (listData[index].dayNumber == presentDay.toString() ||
                                listData[index].dayNumber == nextDay.toString())
                            ? MealPlanConstants().presentDayTextSize
                            : MealPlanConstants().DisableDayTextSize,
                    fontFamily:
                        (listData[index].dayNumber == presentDay.toString() ||
                                listData[index].dayNumber == nextDay.toString())
                            ? MealPlanConstants().dayTextFontFamily
                            : MealPlanConstants().dayUnSelectedTextFontFamily,
                    color: (listData[index].isCompleted == 1 ||
                            listData[index].dayNumber == presentDay.toString())
                        ? MealPlanConstants().dayTextSelectedColor
                        : MealPlanConstants().dayTextColor),
              ),
            )),
      ),
    );
  }

  checkOnTapCondition(int index, List<ChildProgramDayModel> listData) {
    if (index == 0) {
      return true;
    } else if (listData[index - 1].isCompleted == 1) {
      return true;
    } else if (index != listData.length - 1 &&
        listData[index + 1].dayNumber == (nextDay).toString()) {
      return true;
    } else if (listData[listData.length - 2].isCompleted == 1 &&
        index == listData.length - 1) {
      return true;
    } else if (int.parse(listData[index].dayNumber!) == nextDay) {
      return true;
    } else if (int.parse(listData[index].dayNumber!) < presentDay! &&
        listData[index].isCompleted == 0) {
      return true;
    } else {
      return false;
    }
    // ((index == 0) || listData[index-1].isCompleted == 1)
  }

  getOpacity(int index, List<ChildProgramDayModel> listData) {
    if (index == 0) {
      return 1.0;
    } else if (listData[index - 1].isCompleted == 1) {
      return 1.0;
    } else if (index != listData.length - 1 &&
        listData[index + 1].dayNumber == (presentDay! + 1).toString()) {
      return 1.0;
    } else if (listData[listData.length - 2].isCompleted == 1 &&
        index == listData.length - 1) {
      return 1.0;
    } else if (int.parse(listData[index].dayNumber!) == nextDay) {
      return 1.0;
    } else if (int.parse(listData[index].dayNumber!) < presentDay! &&
        listData[index].isCompleted == 0) {
      return 1.0;
    } else {
      return 0.4;
    }
  }

  getBgColor(int index, List<ChildProgramDayModel> listData) {
    if (index == 0) {
      return 1.0;
    } else if (listData[index - 1].isCompleted == 1) {
      return 1.0;
    } else if (index != listData.length - 1 &&
        listData[index + 1].dayNumber == (presentDay! + 1).toString()) {
      return 1.0;
    } else if (listData[listData.length - 2].isCompleted == 1 &&
        index == listData.length - 1) {
      return 1.0;
    } else if (int.parse(listData[index].dayNumber!) == nextDay) {
      return 1.0;
    } else {
      return 0.7;
    }
  }
  // getTextColor(int index, List<ChildProgramDayModel> listData) {
  //   if(index == 0){
  //     return MealPlanConstants().dayTextColor;
  //   }
  //   else if(listData[index-1].isCompleted == 1){
  //     return MealPlanConstants().dayTextColor;
  //   }
  //   else if(index != listData.length-1 && listData[index+1].dayNumber == (presentDay!+1).toString()){
  //     return 1.0;
  //   }
  //   else if(listData[listData.length-2].isCompleted == 1 && index == listData.length-1){
  //     return 1.0;
  //   }
  //   else if(int.parse(listData[index].dayNumber!) == nextDay){
  //     return 1.0;
  //   }
  //   else{
  //     return 0.7;
  //   }
  // }

  backgroundWidgetForPIP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 1.h, left: 4.w, right: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 2.h,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Image(
                            image: AssetImage(
                                "assets/images/Icon ionic-ios-arrow-back.png"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 6.h,
                        child: const Image(
                          image:
                              AssetImage("assets/images/Gut welness logo.png"),
                        ),
                        //SvgPicture.asset("assets/images/splash_screen/Inside Logo.svg"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SimpleTooltip(
                        borderColor: gWhiteColor,
                        maxWidth: 50.w,
                        ballonPadding: EdgeInsets.symmetric(
                            horizontal: 0.w, vertical: 0.h),
                        arrowTipDistance: 2,
                        arrowLength: 10,
                        arrowBaseWidth: 10,
                        hideOnTooltipTap: true,
                        // targetCenter: const Offset(3,4),
                        tooltipTap: () {
                          setState(() {
                            shoppingToolTip = false;
                          });
                        },
                        animationDuration: const Duration(seconds: 3),
                        show: shoppingToolTip,
                        tooltipDirection: TooltipDirection.down,
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                shoppingToolTip = false;
                              });
                            },
                            child: Image(
                              height: 3.h,
                              image: AssetImage("assets/images/list.png"),
                            ),
                          ),
                        ),
                        content: Text(
                          "Tap here for Shopping List",
                          style: TextStyle(
                              fontSize: PPConstants().topViewSubFontSize,
                              fontFamily: MealPlanConstants().mealNameFont,
                              color: gHintTextColor),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.help_outline_rounded,
                          color: gMainColor,
                        ),
                        onPressed: () {
                          if (planNotePdfLink != null ||
                              planNotePdfLink!.isNotEmpty) {
                            AppConfig().showSheet(context, Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text("Want to know more about the program? Please read",
                                    style: TextStyle(
                                        fontSize: bottomSheetHeadingFontSize,
                                        fontFamily: bottomSheetHeadingFontFamily,
                                        height: 1.4
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Divider(
                                    color: kLineColor,
                                    thickness: 1.2,
                                  ),
                                ),
                                Expanded(child: SfPdfViewer.network(
                                    planNotePdfLink!
                                ),),
                                SizedBox(
                                  height: 3.h,
                                )
                              ],
                            ),
                                bottomSheetHeight: 85.h, circleIcon: bsHeadBulbIcon, topColor: kBottomSheetHeadGreen);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (ctx) => MealPdf(
                            //               pdfLink: planNotePdfLink!,
                            //               heading: "Note",
                            //             )));
                          } else {
                            AppConfig().showSnackbar(
                                context, "Note Link Not available",
                                isError: true);
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                // "Day ${widget.day} Meal Plan",
                (selectedDay == null)
                    ? "Day Meal & Yoga Plan"
                    : "Day ${selectedDay} Meal & Yoga Plan",
                style: TextStyle(
                    fontFamily: eUser().mainHeadingFont,
                    color: eUser().mainHeadingColor,
                    fontSize: eUser().mainHeadingFontSize),
              ),
              SizedBox(
                height: 1.h,
              ),
              SizedBox(
                  height: 4.h,
                  child: EasyScrollToIndex(
                    controller: _scrollController, // ScrollToIndexController
                    itemCount: listData.length,
                    itemWidth: 50,
                    itemHeight: 4.h,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return dayItems(index);
                    },
                  )),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Expanded(
          child: (isLoading)
              ? Center(
                  child: buildCircularIndicator(),
                )
              : (mealPlanData1 != null)
                  ? SizedBox(
                      child: SingleChildScrollView(
                        child: (showShimmer)
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey.withOpacity(0.3),
                                highlightColor: Colors.grey.withOpacity(0.7),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    // buildNewItemList(),
                                    // buildNewItemList(),
                                    // buildNewItemList(),
                                    // buildNewItemList(),
                                    // buildNewItemList(),
                                    //                buildMealPlan(),
                                    ...groupList(),
                                    Visibility(
                                      visible: (statusList.isNotEmpty &&
                                          statusList.values.any((element) =>
                                              element
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains('unfollowed'))),
                                      child: IgnorePointer(
                                        ignoring: isDayCompleted == true,
                                        child: Container(
                                          height: 15.h,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 4.w, vertical: 1.h),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 3.w),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                blurRadius: 20,
                                                offset: const Offset(2, 10),
                                              ),
                                            ],
                                          ),
                                          child: TextFormField(
                                            controller: commentController,
                                            cursorColor: gPrimaryColor,
                                            style: TextStyle(
                                                fontFamily: "GothamBook",
                                                color: gTextColor,
                                                fontSize: 11.sp),
                                            decoration: InputDecoration(
                                              suffixIcon: commentController
                                                          .text.isEmpty ||
                                                      isDayCompleted != null
                                                  ? SizedBox()
                                                  : InkWell(
                                                      onTap: () {
                                                        commentController
                                                            .clear();
                                                      },
                                                      child: const Icon(
                                                        Icons.close,
                                                        color: gTextColor,
                                                      ),
                                                    ),
                                              hintText: "Comments",
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                fontFamily: "GothamBook",
                                                color: gTextColor,
                                                fontSize: 9.sp,
                                              ),
                                            ),
                                            textInputAction:
                                                TextInputAction.next,
                                            textAlign: TextAlign.start,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: buttonVisibility(),
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            print(
                                                "statusList.length: ${statusList.length}");
                                            print("lst.length ${lst.length}");
                                            print('..............');
                                          },
                                          // (statusList.length != lst.length)
                                          //     ? () => AppConfig().showSnackbar(context, "Please complete the Meal Plan Status", isError: true)
                                          //     // : (statusList.values.any((element) => element.toString().toLowerCase() == 'unfollowed') && commentController.text.isEmpty)
                                          //     // ? () => AppConfig().showSnackbar(context, "Please Mention the comments why you unfollowed?", isError: true)
                                          //     : () {
                                          //   print("this one $presentDay");
                                          //   for(int i = 0; i< presentDay!; i++){
                                          //     print(presentDay);
                                          //     if(listData[i].isCompleted == 0
                                          //         && i+1 != selectedDay!
                                          //     ){
                                          //       AppConfig().showSnackbar(context, "Please Complete Day ${listData[i].dayNumber}", isError: true);
                                          //       break;
                                          //     }
                                          //     else if(listData[i].isCompleted == 1) {
                                          //       print("completed already");
                                          //     }
                                          //     else if(i+1 == presentDay || i+1 == selectedDay){
                                          //       print("u can access $presentDay");
                                          //       sendData();
                                          //       break;
                                          //     }
                                          //     else{
                                          //       print("u r trying else");
                                          //     }
                                          //   }
                                          // },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 2.h),
                                            width: btnText.length > 22
                                                ? 75.w
                                                : 60.w,
                                            height: 5.h,
                                            decoration: BoxDecoration(
                                              color: (statusList.length ==
                                                      lst.length)
                                                  ? eUser().buttonColor
                                                  : tableHeadingBg,
                                              borderRadius:
                                                  BorderRadius.circular(eUser()
                                                      .buttonBorderRadius),
                                              // border: Border.all(color: eUser().buttonBorderColor,
                                              //     width: eUser().buttonBorderWidth),
                                            ),
                                            child: Center(
                                              child: Text(
                                                btnText,
                                                // 'Proceed to Day $proceedToDay',
                                                style: TextStyle(
                                                  fontFamily:
                                                      eUser().buttonTextFont,
                                                  color:
                                                      eUser().buttonTextColor,
                                                  // color: (statusList.length != lst.length) ? gPrimaryColor : gMainColor,
                                                  fontSize:
                                                      eUser().buttonTextSize,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  // buildNewItemList(),
                                  // buildNewItemList(),
                                  // buildNewItemList(),
                                  // buildNewItemList(),
                                  // buildNewItemList(),
                                  //                buildMealPlan(),
                                  ...groupList(),
                                  Visibility(
                                    visible: (statusList.isNotEmpty &&
                                        statusList.values.any((element) =>
                                            element
                                                .toString()
                                                .toLowerCase()
                                                .contains('unfollowed'))),
                                    child: IgnorePointer(
                                      ignoring: isDayCompleted == true,
                                      child: Container(
                                        height: 15.h,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4.w, vertical: 1.h),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              blurRadius: 20,
                                              offset: const Offset(2, 10),
                                            ),
                                          ],
                                        ),
                                        child: TextFormField(
                                          controller: commentController,
                                          cursorColor: gPrimaryColor,
                                          style: TextStyle(
                                              fontFamily: "GothamBook",
                                              color: gTextColor,
                                              fontSize: 11.sp),
                                          decoration: InputDecoration(
                                            suffixIcon: commentController
                                                        .text.isEmpty ||
                                                    isDayCompleted != null
                                                ? SizedBox()
                                                : InkWell(
                                                    onTap: () {
                                                      commentController.clear();
                                                    },
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: gTextColor,
                                                    ),
                                                  ),
                                            hintText: "Comments",
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                              fontFamily: "GothamBook",
                                              color: gTextColor,
                                              fontSize: 9.sp,
                                            ),
                                          ),
                                          textInputAction: TextInputAction.next,
                                          textAlign: TextAlign.start,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: buttonVisibility(),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap:
                                            // (){
                                            //   print("statusList.length: ${statusList.length}");
                                            //   print("lst.length ${lst.length}");
                                            //
                                            // },
                                            (statusList.length != lst.length)
                                                ? () => AppConfig().showSnackbar(
                                                    context,
                                                    "Please complete the Meal Plan Status",
                                                    isError: true)
                                                // : (statusList.values.any((element) => element.toString().toLowerCase() == 'unfollowed') && commentController.text.isEmpty)
                                                // ? () => AppConfig().showSnackbar(context, "Please Mention the comments why you unfollowed?", isError: true)
                                                : () {
                                                    print(
                                                        "this one $presentDay");
                                                    for (int i = 0;
                                                        i < presentDay!;
                                                        i++) {
                                                      print(presentDay);
                                                      if (listData[i]
                                                                  .isCompleted ==
                                                              0 &&
                                                          i + 1 !=
                                                              selectedDay!) {
                                                        AppConfig().showSnackbar(
                                                            context,
                                                            "Please Complete Day ${listData[i].dayNumber}",
                                                            isError: true);
                                                        break;
                                                      } else if (listData[i]
                                                              .isCompleted ==
                                                          1) {
                                                        print(
                                                            "completed already");
                                                      } else if (i + 1 ==
                                                              presentDay ||
                                                          i + 1 ==
                                                              selectedDay) {
                                                        print(
                                                            "u can access $presentDay");
                                                        sendData();
                                                        break;
                                                      } else {
                                                        print(
                                                            "u r trying else");
                                                      }
                                                    }
                                                  },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 2.h),
                                          width:
                                              btnText.length > 22 ? 75.w : 60.w,
                                          height: 5.h,
                                          decoration: BoxDecoration(
                                            color: (statusList.length ==
                                                    lst.length)
                                                ? eUser().buttonColor
                                                : tableHeadingBg,
                                            borderRadius: BorderRadius.circular(
                                                eUser().buttonBorderRadius),
                                            // border: Border.all(color: eUser().buttonBorderColor,
                                            //     width: eUser().buttonBorderWidth),
                                          ),
                                          child: Center(
                                            child: Text(
                                              btnText,
                                              // 'Proceed to Day $proceedToDay',
                                              style: TextStyle(
                                                fontFamily:
                                                    eUser().buttonTextFont,
                                                color: eUser().buttonTextColor,
                                                // color: (statusList.length != lst.length) ? gPrimaryColor : gMainColor,
                                                fontSize:
                                                    eUser().buttonTextSize,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    )
                  : SizedBox.shrink(),
        ),
      ],
    );
  }

  videoPlayerView() {
    return PIPStack(
      shrinkAlignment: Alignment.bottomRight,
      backgroundWidget: backgroundWidgetForPIP(),
      pipWidget: isEnabled
          ? Consumer<CheckState>(
              builder: (_, model, __) {
                print("model.isChanged: ${model.isChanged} $isEnabled");
                return VlcPlayerWithControls(
                  key: _key,
                  controller: _controller!,
                  showVolume: false,
                  showVideoProgress: !model.isChanged,
                  seekButtonIconSize: 10.sp,
                  playButtonIconSize: 14.sp,
                  replayButtonSize: 14.sp,
                  showFullscreenBtn: true,
                );
              },
            )
          //     ? FutureBuilder(
          //   future: _initializeVideoPlayerFuture,
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       // If the VideoPlayerController has finished initialization, use
          //       // the data it provides to limit the aspect ratio of the video.
          //       return VlcPlayer(
          //         controller: _videoPlayerController,
          //         aspectRatio: 16 / 9,
          //         placeholder: Center(child: CircularProgressIndicator()),
          //       );
          //     } else {
          //       // If the VideoPlayerController is still initializing, show a
          //       // loading spinner.
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //   },
          // )
          //     ? Container(
          //   color: Colors.pink,
          // )
          : const SizedBox(),
      pipEnabled: isEnabled,
      pipExpandedHeight: double.infinity,
      onClosed: () {
        // await _controller.stop();
        // await _controller.dispose();
        setState(() {
          isEnabled = !isEnabled;
        });
      },
    );
  }

  buildMealPlan() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(2, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            height: 5.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                color: tableHeadingBg
                // gradient: LinearGradient(colors: [
                //   Color(0xffE06666),
                //   Color(0xff93C47D),
                //   Color(0xffFFD966),
                // ],
                //     begin: Alignment.topLeft, end: Alignment.topRight
                // ),
                ),
            // child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Container(
            //       margin: EdgeInsets.only(left:10),
            //       child: Text(
            //         'Time',
            //         style: TextStyle(
            //           color: gWhiteColor,
            //           fontSize: 11.sp,
            //           fontFamily: "GothamMedium",
            //         ),
            //       ),
            //     ),
            //     Text(
            //       'Meal/Yoga',
            //       style: TextStyle(
            //         color: gWhiteColor,
            //         fontSize: 11.sp,
            //         fontFamily: "GothamMedium",
            //       ),
            //     ),
            //     Container(
            //       margin: EdgeInsets.only(right:10),
            //       child: Text(
            //         'Status',
            //         style: TextStyle(
            //           color: gWhiteColor,
            //           fontSize: 11.sp,
            //           fontFamily: "GothamMedium",
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ),
          DataTable(
            headingTextStyle: TextStyle(
              color: gWhiteColor,
              fontSize: 5.sp,
              fontFamily: "GothamMedium",
            ),
            headingRowHeight: 5.h,
            horizontalMargin: 2.w,
            // columnSpacing: 60,
            dataRowHeight: getRowHeight(),
            // headingRowColor: MaterialStateProperty.all(const Color(0xffE06666)),
            columns: <DataColumn>[
              DataColumn(
                label: Text(
                  ' Time',
                  style: TextStyle(
                    color: eUser().userFieldLabelColor,
                    fontSize: 11.sp,
                    fontFamily: kFontBold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Meal/Yoga',
                  style: TextStyle(
                    color: eUser().userFieldLabelColor,
                    fontSize: 11.sp,
                    fontFamily: kFontBold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  ' Status',
                  style: TextStyle(
                    color: eUser().userFieldLabelColor,
                    fontSize: 11.sp,
                    fontFamily: kFontBold,
                  ),
                ),
              ),
            ],
            rows: dataRowWidget(),
          ),
        ],
      ),
    );
  }

  groupList() {
    List<Column> _data = [];

    mealPlanData1.forEach((dayTime, value) {
      print("dayTime ===> $dayTime");
      value.forEach((element) {
        print("values ==> ${element.toJson()}");
      });
      _data.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Text(
              dayTime,
              style: TextStyle(
                height: 1.5,
                color: MealPlanConstants().mealNameTextColor,
                fontSize: 12.sp,
                fontFamily: MealPlanConstants().mealNameFont,
              ),
            ),
          ),
          ...value
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  (value.indexOf(e) == 0) &&
                                          mealPlanData1.values
                                                  .toList()
                                                  .indexWhere((element) =>
                                                      element == value) ==
                                              1
                                      ? SimpleTooltip(
                                          borderColor: gWhiteColor,
                                          maxWidth: 50.w,
                                          ballonPadding: EdgeInsets.symmetric(
                                              horizontal: 1.w, vertical: 0.5.h),
                                          arrowTipDistance: -10,
                                          arrowLength: 10,
                                          arrowBaseWidth: 10,
                                          // targetCenter: const Offset(3,4),
                                          tooltipTap: () {
                                            setState(() {
                                              showToolTip = false;
                                            });
                                          },
                                          animationDuration:
                                              const Duration(seconds: 3),
                                          show: showToolTip,
                                          tooltipDirection: TooltipDirection.up,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: GestureDetector(
                                              onTap: e.url == null
                                                  ? null
                                                  : e.type == 'item'
                                                      ? () {
                                                          setState(() {
                                                            showToolTip = false;
                                                          });
                                                          showPdf(
                                                              e.url!, e.name);
                                                        }
                                                      : () => showVideo(e),
                                              child: Container(
                                                height: 90,
                                                width: 90,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: (e.itemImage != null &&
                                                        e.itemImage!.isNotEmpty)
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Image.network(
                                                          e.itemImage!,
                                                          errorBuilder:
                                                              (ctx, _, __) {
                                                            return Image.asset(
                                                              'assets/images/meal_placeholder.png',
                                                              fit: BoxFit.fill,
                                                            );
                                                          },
                                                          fit: BoxFit.fill,
                                                        ),
                                                      )
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Image.asset(
                                                          'assets/images/meal_placeholder.png',
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                          content: Text(
                                            "Tap here for Recipe",
                                            style: TextStyle(
                                                fontSize: PPConstants()
                                                    .topViewSubFontSize,
                                                fontFamily: MealPlanConstants()
                                                    .mealNameFont,
                                                color: gHintTextColor),
                                          ),
                                        )
                                      : Align(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: e.url == null
                                                ? null
                                                : e.type == 'item'
                                                    ? () {
                                                        setState(() {
                                                          showToolTip = false;
                                                        });
                                                        showPdf(e.url!, e.name);
                                                      }
                                                    : () => showVideo(e),
                                            child: Container(
                                              height: 90,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: (e.itemImage != null &&
                                                      e.itemImage!.isNotEmpty)
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Image.network(
                                                        e.itemImage!,
                                                        errorBuilder:
                                                            (ctx, _, __) {
                                                          return Image.asset(
                                                            'assets/images/meal_placeholder.png',
                                                            fit: BoxFit.fill,
                                                          );
                                                        },
                                                        fit: BoxFit.fill,
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Image.asset(
                                                        'assets/images/meal_placeholder.png',
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: e.subTitle != null ||
                                          e.subTitle!.isNotEmpty,
                                      child: Text(
                                        e.subTitle ?? "* Must Have",
                                        style: TextStyle(
                                          fontSize: MealPlanConstants()
                                              .mustHaveFontSize,
                                          fontFamily:
                                              MealPlanConstants().mustHaveFont,
                                          color: MealPlanConstants()
                                              .mustHaveTextColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      e.name ?? 'Morning Yoga',
                                      style: TextStyle(
                                          fontSize: MealPlanConstants()
                                              .mealNameFontSize,
                                          fontFamily:
                                              MealPlanConstants().mealNameFont,
                                          color: gHintTextColor),
                                    ),
                                    // Text(e.mealTime ?? "B/W 6-8am",
                                    //   style: TextStyle(
                                    //       fontSize: 9.sp,
                                    //       fontFamily: kFontMedium
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 8,
                                    // ),
                                    Expanded(
                                      child: Text(
                                        e.benefits!.replaceAll("- ", '\n') ??
                                            '',
                                        // "- Good for Health and super food\n\n- Good for Health and super food\n\n- Good for Health and super food\n\n- Very Effective and quick recipe,\n\n- Ready To Cook",
                                        style: TextStyle(
                                            fontSize: MealPlanConstants()
                                                .benifitsFontSize,
                                            fontFamily: MealPlanConstants()
                                                .benifitsFont),
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  print(
                                    value.indexWhere((element) {
                                      print(element.name);
                                      print(e.name);
                                      return element.name == e.name;
                                    }),
                                  );
                                  showFollowSheet(e);
                                  // openAlertBox(
                                  //     title: 'Did you Follow this?',
                                  //     titleNeeded: true,
                                  //     context: context,
                                  //     isContentNeeded: false,
                                  //     positiveButtonName: 'Followed',
                                  //     positiveButton: () {
                                  //       onChangedTab(0,
                                  //           id: e.itemId, title: list[0]);
                                  //       Navigator.pop(context);
                                  //     },
                                  //     negativeButtonName: 'Missed It',
                                  //     negativeButton: () {
                                  //       onChangedTab(0,
                                  //           id: e.itemId, title: list[1]);
                                  //       Navigator.pop(context);
                                  //     });
                                },
                                child: (statusList.isNotEmpty &&
                                        statusList.containsKey(e.itemId) &&
                                        statusList[e.itemId] == list[0])
                                    ? Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 4),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(eUser()
                                                      .buttonBorderRadius),
                                              color: gPrimaryColor),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Followed',
                                                style: TextStyle(
                                                    fontSize: 8.sp,
                                                    fontFamily: kFontMedium,
                                                    color: gWhiteColor),
                                              ),
                                              Image.asset(
                                                'assets/images/followed2.png',
                                                width: 20,
                                                height: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : (statusList.isNotEmpty &&
                                            statusList.containsKey(e.itemId) &&
                                            statusList[e.itemId] == list[1])
                                        ? Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 4),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(eUser()
                                                          .buttonBorderRadius),
                                                  color: gsecondaryColor),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Missed It',
                                                    style: TextStyle(
                                                        fontSize: 8.sp,
                                                        fontFamily: kFontMedium,
                                                        color: gWhiteColor),
                                                  ),
                                                  Image.asset(
                                                    'assets/images/unfollowed.png',
                                                    width: 20,
                                                    height: 20,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(eUser()
                                                          .buttonBorderRadius),
                                                  color: Colors.grey),
                                              child: Text(
                                                'Status',
                                                style: TextStyle(
                                                    fontSize: 8.sp,
                                                    fontFamily: kFontMedium,
                                                    color: gWhiteColor),
                                              ),
                                            ),
                                          ),
                              ),
                            ],
                          ),
                        ),
                        Divider()
                      ],
                    ),
                  ))
              .toList(),
        ],
      ));
    });
    return _data;
  }

  showFollowSheet(ChildMealPlanDetailsModel e) {
    print("eeeee:$e");
    return AppConfig().showSheet(context, showFollowWidget(e),
        bottomSheetHeight: 45.h, circleIcon: bsHeadPinIcon);
  }

  showFollowWidget(ChildMealPlanDetailsModel e) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Observe. Let's go!",
            style: TextStyle(
                fontSize: bottomSheetHeadingFontSize,
                fontFamily: bottomSheetHeadingFontFamily,
                color: gsecondaryColor,
                height: 1.4),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 1.5.h),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            color: kLineColor,
            thickness: 1.2,
          ),
        ),
        SizedBox(height: 1.5.h),
        Center(
          child: Text(
            "You ate it or you didn't. Tell us about it.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: gTextColor,
              fontSize: bottomSheetSubHeadingXFontSize,
              fontFamily: bottomSheetSubHeadingMediumFont,
            ),
          ),
        ),
        SizedBox(height: 4.5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                onChangedTab(0, id: e.itemId, title: list[1]);
                Navigator.pop(context);
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 10.w),
                decoration: BoxDecoration(
                    color: gsecondaryColor,
                    border: Border.all(color: kLineColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Missed",
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
              onTap: () {
                onChangedTab(0, id: e.itemId, title: list[0]);
                Navigator.pop(context);
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 10.w),
                decoration: BoxDecoration(
                    color: gPrimaryColor,
                    border: Border.all(color: kLineColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Followed",
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
        SizedBox(height: 1.h)
      ],
    );
  }

  showDataRow() {
    return mealPlanData1.entries.map((e) {
      return DataRow(cells: [
        DataCell(
          Text(
            'e.mealTime.toString()',
            style: TextStyle(
              height: 1.5,
              color: gTextColor,
              fontSize: 8.sp,
              fontFamily: "GothamBold",
            ),
          ),
        ),
        DataCell(
          GestureDetector(
            // onTap: e.url == null ? null : e.type == 'item' ? () => showPdf(e.url!) : () => showVideo(e),
            child: Row(
              children: [
                'e.type' == 'yoga'
                    ? GestureDetector(
                        onTap: () {},
                        child: Image(
                          image: const AssetImage(
                              "assets/images/noun-play-1832840.png"),
                          height: 2.h,
                        ),
                      )
                    : const SizedBox(),
                if ('e.type ' == 'yoga') SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    "e.name.toString()",
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.5,
                      color: gTextColor,
                      fontSize: 8.sp,
                      fontFamily: "GothamBook",
                    ),
                  ),
                ),
              ],
            ),
          ),
          placeholder: true,
        ),
        DataCell(
            // (widget.isCompleted == null) ?
            Theme(
          data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: oldPopup(e.value.first),
        )
            // : Text(e.status ?? '',
            //     textAlign: TextAlign.start,
            //     style: TextStyle(
            //       fontFamily: "GothamBook",
            //       color: gTextColor,
            //       fontSize: 8.sp,
            //     ),
            //   ),
            ),
        // DataCell(
        //   Text(
        //     e.key.toString(),
        //     style: TextStyle(
        //       height: 1.5,
        //       color: gTextColor,
        //       fontSize: 8.sp,
        //       fontFamily: "GothamBold",
        //     ),
        //   ),
        // ),
        // DataCell(
        //   ListView.builder(
        //       shrinkWrap: true,
        //       itemCount: e.value.length,
        //       itemBuilder: (_, index){
        //         return GestureDetector(
        //           onTap: e.value[index].url == null ? null : e.value[index].url == 'item' ? () => showPdf(e.value[index].url!) : () => showVideo(e.value[index]),
        //           child: Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               e.value[index].type == 'yoga'
        //                   ? GestureDetector(
        //                 onTap: () {},
        //                 child: Image(
        //                   image: const AssetImage(
        //                       "assets/images/noun-play-1832840.png"),
        //                   height: 2.h,
        //                 ),
        //               )
        //                   : const SizedBox(),
        //               if(e.value[index].type == 'yoga') SizedBox(width: 2.w),
        //               Expanded(
        //                 child: Text(
        //                   "${e.value.map((value) => value.name)}",
        //                   // " ${e.name.toString()}",
        //                   maxLines: 3,
        //                   textAlign: TextAlign.start,
        //                   overflow: TextOverflow.ellipsis,
        //                   style: TextStyle(
        //                     height: 1.5,
        //                     color: gTextColor,
        //                     fontSize: 8.sp,
        //                     fontFamily: "GothamBook",
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         );
        //       }
        //   ),
        //   placeholder: true,
        // ),
        // DataCell(
        //     Theme(
        //       data: Theme.of(context).copyWith(
        //         highlightColor: Colors.transparent,
        //         splashColor: Colors.transparent,
        //       ),
        //       child: oldPopup(e.value[0]),
        //     )
        //   // (widget.isCompleted == null) ?
        //   //   ListView.builder(
        //   //     shrinkWrap: true,
        //   //       itemBuilder: (_, index){
        //   //         return ;
        //   //       }
        //   //   )
        //   // : Text(e.status ?? '',
        //   //     textAlign: TextAlign.start,
        //   //     style: TextStyle(
        //   //       fontFamily: "GothamBook",
        //   //       color: gTextColor,
        //   //       fontSize: 8.sp,
        //   //     ),
        //   //   ),
        // ),
      ]);
    });
    return shoppingData!
        .map((e) => DataRow(
              cells: [
                DataCell(
                  Text(
                    e.mealTime.toString(),
                    style: TextStyle(
                      height: 1.5,
                      color: gTextColor,
                      fontSize: 8.sp,
                      fontFamily: "GothamBold",
                    ),
                  ),
                ),
                DataCell(
                  GestureDetector(
                    onTap: e.url == null
                        ? null
                        : e.type == 'item'
                            ? () => showPdf(e.url!, e.name)
                            : () => showVideo(e),
                    child: Row(
                      children: [
                        e.type == 'yoga'
                            ? GestureDetector(
                                onTap: () {},
                                child: Image(
                                  image: const AssetImage(
                                      "assets/images/noun-play-1832840.png"),
                                  height: 2.h,
                                ),
                              )
                            : const SizedBox(),
                        if (e.type == 'yoga') SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            " ${e.name.toString()}",
                            maxLines: 3,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              height: 1.5,
                              color: gTextColor,
                              fontSize: 8.sp,
                              fontFamily: "GothamBook",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  placeholder: true,
                ),
                DataCell(
                    // (widget.isCompleted == null) ?
                    Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: oldPopup(e),
                )
                    // : Text(e.status ?? '',
                    //     textAlign: TextAlign.start,
                    //     style: TextStyle(
                    //       fontFamily: "GothamBook",
                    //       color: gTextColor,
                    //       fontSize: 8.sp,
                    //     ),
                    //   ),
                    ),
              ],
            ))
        .toList();
  }

  List<DataRow> dataRowWidget() {
    List<DataRow> _data = [];
    mealPlanData1.forEach((dayTime, value) {
      _data.add(DataRow(cells: [
        DataCell(
          Text(
            dayTime,
            style: TextStyle(
              height: 1.5,
              color: gTextColor,
              fontSize: 8.sp,
              fontFamily: kFontMedium,
            ),
          ),
        ),
        DataCell(
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...value
                  .map((e) => GestureDetector(
                        onTap: e.url == null
                            ? null
                            : e.type == 'item'
                                ? () => showPdf(e.url!, e.name)
                                : () => showVideo(e),
                        child: Row(
                          children: [
                            e.type == 'yoga'
                                ? GestureDetector(
                                    onTap: () {},
                                    child: Image(
                                      image: const AssetImage(
                                          "assets/images/noun-play-1832840.png"),
                                      height: 2.h,
                                    ),
                                  )
                                : const SizedBox(),
                            if (e.type == 'yoga') SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                " ${e.name.toString()}",
                                maxLines: 3,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height: 1.5,
                                  color: gTextColor,
                                  fontSize: 8.sp,
                                  fontFamily: kFontMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList()
            ],
          ),
          placeholder: true,
        ),
        DataCell(
            // (widget.isCompleted == null) ?
            Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // shrinkWrap: true,
          children: [
            ...value.map((e) {
              return Theme(
                data: Theme.of(context).copyWith(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: oldPopup(e),
              );
            }).toList()
          ],
        )
            // : Text(e.status ?? '',
            //     textAlign: TextAlign.start,
            //     style: TextStyle(
            //       fontFamily: "GothamBook",
            //       color: gTextColor,
            //       fontSize: 8.sp,
            //     ),
            //   ),
            ),
      ]));
    });
    return _data;
  }

  showDataRow1() {
    return shoppingData!
        .map((e) => DataRow(
              cells: [
                DataCell(
                  Text(
                    e.mealTime.toString(),
                    style: TextStyle(
                      height: 1.5,
                      color: gTextColor,
                      fontSize: 8.sp,
                      fontFamily: "GothamBold",
                    ),
                  ),
                ),
                DataCell(
                  GestureDetector(
                    onTap: e.url == null
                        ? null
                        : e.type == 'item'
                            ? () => showPdf(e.url!, e.name)
                            : () => showVideo(e),
                    child: Row(
                      children: [
                        e.type == 'yoga'
                            ? GestureDetector(
                                onTap: () {},
                                child: Image(
                                  image: const AssetImage(
                                      "assets/images/noun-play-1832840.png"),
                                  height: 2.h,
                                ),
                              )
                            : const SizedBox(),
                        if (e.type == 'yoga') SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            " ${e.name.toString()}",
                            maxLines: 3,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              height: 1.5,
                              color: gTextColor,
                              fontSize: 8.sp,
                              fontFamily: "GothamBook",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  placeholder: true,
                ),
                DataCell(
                    // (widget.isCompleted == null) ?
                    Theme(
                  data: Theme.of(context).copyWith(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  ),
                  child: oldPopup(e),
                )
                    // : Text(e.status ?? '',
                    //     textAlign: TextAlign.start,
                    //     style: TextStyle(
                    //       fontFamily: "GothamBook",
                    //       color: gTextColor,
                    //       fontSize: 8.sp,
                    //     ),
                    //   ),
                    ),
              ],
            ))
        .toList();
  }

  Map statusList = {};

  List lst = [];

  showDummyDataRow() {
    return mealPlanData
        .map(
          (s) => DataRow(
            cells: [
              DataCell(
                Text(
                  s["time"].toString(),
                  style: TextStyle(
                    height: 1.5,
                    color: gTextColor,
                    fontSize: 8.sp,
                    fontFamily: "GothamBold",
                  ),
                ),
              ),
              DataCell(
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    s["id"] == 1
                        ? GestureDetector(
                            onTap: () {},
                            child: Image(
                              image: const AssetImage(
                                  "assets/images/noun-play-1832840.png"),
                              height: 2.h,
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        " ${s["title"].toString()}",
                        maxLines: 3,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 1.5,
                          color: gTextColor,
                          fontSize: 8.sp,
                          fontFamily: "GothamBook",
                        ),
                      ),
                    ),
                  ],
                ),
                placeholder: true,
              ),
              DataCell(
                PopupMenuButton(
                  offset: const Offset(0, 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 0.6.h),
                          buildDummyTabView(
                              index: 1, title: list[0], color: gPrimaryColor),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 1.h),
                            height: 1,
                            color: gHintTextColor.withOpacity(0.3),
                          ),
                          buildDummyTabView(
                              index: 2, title: list[1], color: gsecondaryColor),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 1.h),
                            height: 1,
                            color: gHintTextColor.withOpacity(0.3),
                          ),
                          SizedBox(height: 0.6.h),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    width: 20.w,
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.2.h),
                    decoration: BoxDecoration(
                      color: gWhiteColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            buildDummyHeaderText(),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: kFontBook,
                                color: buildDummyTextColor(),
                                fontSize: 8.sp),
                          ),
                        ),
                        Icon(
                          Icons.expand_more,
                          color: gHintTextColor,
                          size: 2.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  void onChangedTab(int index, {int? id, String? title}) {
    print('$id  $title');
    setState(() {
      if (id != null && title != null) {
        if (statusList.isNotEmpty && statusList.containsKey(id)) {
          print("contains");
          statusList.update(id, (value) => title);
        } else if (statusList.isEmpty || !statusList.containsKey(id)) {
          print('new');
          statusList.putIfAbsent(id, () => title);
        }
      }
      print(statusList);
      print(statusList[id].runtimeType);
    });
  }

  getStatusText(int id) {
    print("id: ${id}");
    print('statusList[id]${statusList[id]}');
    return statusList[id];
  }

  getTextColor(int id) {
    setState(() {
      if (statusList.isEmpty) {
        textColor = gWhiteColor;
      } else if (statusList[id] == list[0]) {
        textColor = gPrimaryColor;
      } else if (statusList[id] == list[1]) {
        textColor = gsecondaryColor;
      }
    });
    return textColor;
  }

  void onChangedDummyTab(int index) {
    setState(() {
      planStatus = index;
    });
  }

  Widget buildTabView(
      {required int index,
      required String title,
      required Color color,
      int? itemId}) {
    return GestureDetector(
      onTap: () {
        onChangedTab(index, id: itemId, title: title);
        Get.back();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: "GothamBook",
            // color: (planStatus == index) ? color : gTextColor,
            color: (statusList[itemId] == title) ? color : gTextColor,
            fontSize: 9.5.sp,
          ),
        ),
      ),
    );
  }

  Widget buildDummyTabView(
      {required int index,
      required String title,
      required Color color,
      int? itemId}) {
    return GestureDetector(
      onTap: () {
        onChangedDummyTab(index);
        Get.back();
      },
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "GothamBook",
          color: (planStatus == index) ? color : gTextColor,
          fontSize: 8.sp,
        ),
      ),
    );
  }

  String buildDummyHeaderText() {
    if (planStatus == 0) {
      headerText = "     ";
    } else if (planStatus == 1) {
      headerText = "Followed";
    } else if (planStatus == 2) {
      headerText = "UnFollowed";
    }
    return headerText;
  }

  Color? buildDummyTextColor() {
    if (planStatus == 0) {
      textColor = gWhiteColor;
    } else if (planStatus == 1) {
      textColor = gPrimaryColor;
    } else if (planStatus == 2) {
      textColor = gsecondaryColor;
    } else if (planStatus == 3) {
      textColor = gMainColor;
    } else if (planStatus == 4) {
      textColor = gMainColor;
    }
    return textColor!;
  }

  final ProgramRepository repository = ProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  bool isSent = false;

  void sendData() async {
    setState(() {
      isSent = true;
    });
    ProceedProgramDayModel? model;
    List<PatientMealTracking> tracking = [];

    statusList.forEach((key, value) {
      print('$key---$value');
      tracking.add(PatientMealTracking(
          day: selectedDay,
          userMealItemId: key,
          status: (value == list[1]) ? sendList[1] : sendList[0]));
    });

    print(tracking);
    model = ProceedProgramDayModel(
      patientMealTracking: tracking,
      comment: commentController.text.isEmpty ? null : commentController.text,
      day: selectedDay.toString(),
    );
    List dummy = [];
    model.patientMealTracking!.forEach((element) {
      dummy.add(jsonEncode(element.toJson()));
    });
    print('dummy: $dummy');

    showSymptomsTrackerSheet(context, model);
    // Navigator.push(context, MaterialPageRoute(builder: (_) => DayMealTracerUI(proceedProgramDayModel: model!)));
    // print('ProceedProgramDayModel: ${jsonEncode(model.toJson())}');

    // final result = await ProgramService(repository: repository).proceedDayMealDetailsService(model);
    //
    // print("result: $result");
    // setState(() {
    //   isSent = false;
    // });
    //
    // if(result.runtimeType == GetProceedModel){
    //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DaysProgramPlan()), (route) => route.isFirst);
    // }
    // else{
    //   var model = result as ErrorModel;
    //   AppConfig().showSnackbar(context, model.message ?? '', isError: true);
    // }
  }

  showPdf(String itemUrl, String? receipeName) {
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => MealPdf(
                  pdfLink: url!,
                  heading: receipeName,
                )));
  }

  showVideo(ChildMealPlanDetailsModel e) {
    setState(() {
      isEnabled = !isEnabled;
      videoName = e.name!;
      mealTime = e.mealTime!;
    });
    initVideoView(e.url);
    // Navigator.push(context, MaterialPageRoute(builder: (ctx)=> YogaVideoScreen(yogaDetails: e.toJson(),day: widget.day,)));
  }

  oldPopup(ChildMealPlanDetailsModel e) {
    return IgnorePointer(
      ignoring: isDayCompleted == true,
      child: Container(
        margin: EdgeInsets.only(bottom: 4),
        child: PopupMenuButton(
          offset: const Offset(0, 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 0.6.h),
                  buildTabView(
                      index: 1,
                      title: list[0],
                      color: gPrimaryColor,
                      itemId: e.itemId!),
                  SizedBox(height: 0.6.h),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                    height: 1,
                    color: gHintTextColor.withOpacity(0.3),
                  ),
                  SizedBox(height: 0.6.h),
                  buildTabView(
                      index: 2,
                      title: list[1],
                      color: gsecondaryColor,
                      itemId: e.itemId!),
                  SizedBox(height: 0.6.h),
                ],
              ),
              onTap: null,
            ),
          ],
          child: Container(
            width: 20.w,
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.2.h),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: gMainColor, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    statusList.isEmpty ? '' : getStatusText(e.itemId!) ?? '',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: "GothamBook",
                        color: statusList.isEmpty
                            ? textColor
                            : getTextColor(e.itemId!) ?? textColor,
                        fontSize: 8.sp),
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  color: gHintTextColor,
                  size: 2.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showDropdown(ChildMealPlanDetailsModel e) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: CustomDropdownButton2(
              // buttonHeight: 25,
              buttonWidth: 20.w,
              hint: '',
              dropdownItems: list,
              value: statusList.isEmpty ? null : statusList[e.itemId],
              onChanged: (value) {
                setState(() {
                  statusList[e.itemId] = value ?? -1;
                });
              },
              buttonDecoration: BoxDecoration(
                color: gWhiteColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gMainColor, width: 1),
              ),
              icon: Icon(Icons.keyboard_arrow_down_outlined),
            ),
          ),
        ],
      ),
    );
  }

  bool buttonVisibility() {
    bool isVisible;
    if (isDayCompleted == true) {
      isVisible = false;
    } else if (nextDay == selectedDay) {
      isVisible = false;
    } else {
      isVisible = true;
    }
    print("isVisible: $isVisible");
    return isVisible;
    // widget.isCompleted == null || (widget.nextDay == widget.day)
  }

  getRowHeight() {
    if (mealPlanData1.values.length > 1) {
      return 8.h;
    } else {
      return 6.h;
    }
  }

  showSymptomsTrackerSheet(BuildContext context, ProceedProgramDayModel model) {
    return AppConfig().showSheet(
        context,
        TrackerUI(
          proceedProgramDayModel: model,
          from: ProgramMealType.program.name,
        ),
        circleIcon: bsHeadPinIcon,
        bottomSheetHeight: 90.h);

    return showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        builder: (ctx) {
          return Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TrackerUI(
                  proceedProgramDayModel: model,
                  from: ProgramMealType.program.name,
                ),
              )
            ],
          );
        });
  }
}

class MealPlanData {
  MealPlanData(this.time, this.title, this.id);

  String time;
  String title;
  int id;
}
