import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gwc_customer/model/combined_meal_model/combined_meal_model.dart';
import 'package:gwc_customer/screens/combined_meal_plan/new_prep_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../model/combined_meal_model/detox_nourish_model/child_detox_model.dart';
import '../../model/combined_meal_model/detox_nourish_model/child_nourish_model.dart';
import '../../model/combined_meal_model/new_nourish_model.dart';
import '../../model/combined_meal_model/new_prep_model.dart';
import '../../model/error_model.dart';
import '../../repository/api_service.dart';
import '../../repository/program_repository/program_repository.dart';
import '../../services/program_service/program_service.dart';
import '../../services/vlc_service/check_state.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'package:http/http.dart' as http;

import '../home_remedies/home_remedies_screen.dart';
import '../prepratory plan/new/dos_donts_program_screen.dart';
import 'detox_plan_screen.dart';
import 'healing_plan_screen.dart';
import 'new_trans_screen.dart';

class CombinedPrepMealTransScreen extends StatefulWidget {
  int stage;
  /// to know the navigation
  /// wether user came from program start screen or not
  bool fromStartScreen;
  final String? postProgramStage;

  CombinedPrepMealTransScreen({Key? key, this.stage = 0,
    this.fromStartScreen = false,
    this.postProgramStage
  }) : super(key: key);

  @override
  State<CombinedPrepMealTransScreen> createState() => _CombinedPrepMealTransScreenState();
}

class _CombinedPrepMealTransScreenState extends State<CombinedPrepMealTransScreen> with SingleTickerProviderStateMixin {

  CheckState? _chkState;

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Preparatory'),
    const Tab(text: 'Detox'),
    const Tab(text: 'Healing'),
    const Tab(text: 'Nourish'),
  ];

  TabController? _tabController;

  bool showProgress = false;
  //******* prep stage items ****************

  ChildPrepModel? _childPrepModel;
  bool isPrepTrackerSubmitted = false;

  // ***** end of prep items ****************

  ChildDetoxModel? _childDetoxModel, _childHealingModel;

  ChildNourishModel? _childNourishModel;
  bool isTransStarted = false;

  String? prepDoDontPdfLink, transDoDontPdfLink;

  bool isNourishStarted = false;
  bool isHealingStarted = false;


  String? trackerUrl;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getProgramData();
    _chkState = Provider.of<CheckState>(context, listen: false);
  }

  getProgramData() async {
    setState(() {
      showProgress = true;
    });
    // print(selectedDay);
    // statusList.clear();
    // lst.clear();
    final result = await ProgramService(repository: repository)
        .getCombinedMealService();
    print("result: $result");

    if (result.runtimeType == CombinedMealModel) {
      print("meal plan");
      CombinedMealModel model = result as CombinedMealModel;

      trackerUrl = model.tracker_video_url;

      print('prep.values:${model.prep!.childPrepModel!.details}');
      _childPrepModel = model.prep!.childPrepModel;

      if(_childPrepModel!.doDontPdfLink != null) {
        prepDoDontPdfLink = _childPrepModel?.doDontPdfLink;
      }

      if(_childPrepModel!.isPrepCompleted != null) {
        isPrepCompleted = _childPrepModel!.isPrepCompleted == "1";
      }

      prepPresentDay = _childPrepModel?.currentDay ?? 1;
      print("prepPresentDay: $prepPresentDay");
      if(model.prep != null && model.prep!.totalDays != null) {
        totalPrep = model.prep?.totalDays ?? 2;
      }

      if(model.detox != null){
        _childDetoxModel = model.detox!.value!;
        if(model.detox!.totalDays != null){
          totalDetox = model.detox!.totalDays ?? 5;
        }
        if(model.detox!.isHealingStarted != null){
          isHealingStarted = model.detox!.isHealingStarted ?? false;
        }
        if(_childDetoxModel!.isDetoxCompleted != null) isDetoxCompleted = _childDetoxModel!.isDetoxCompleted == "1";
        print("isDetoxCompleted: ${isDetoxCompleted} ${!isDetoxCompleted}");
        print("${widget.stage}");
      }
      if(model.healing != null){
        _childHealingModel = model.healing!.value!;
        if(model.healing!.totalDays != null){
          totalHealing = model.healing!.totalDays ?? 5;
        }
        if(model.healing!.isNourishStarted != null){
          isNourishStarted = model.healing!.isNourishStarted ?? false;
        }
        if(_childHealingModel!.isHealingCompleted != null) isHealingCompleted = _childHealingModel!.isHealingCompleted == "1";
      }

      if(model.nourish != null){
        _childNourishModel = model.nourish!.value;
        if(model.nourish!.totalDays != null){
          totalNourish = model.nourish?.totalDays ?? 2;
        }
        if(_childNourishModel!.dosDontPdfLink != null) {
          transDoDontPdfLink = _childNourishModel?.dosDontPdfLink;
        }
        nourishPresentDay = model.nourish!.value!.currentDay;
      }


      // print('detox.values:${model.detox!.value!.details!.entries}');
      // model.detox!.value!.details!.forEach((key, value) {
      //   print("day: $key");
      //   print(value.toMap());
      //   value.data!.forEach((k, v1) {
      //    print("$k -- $v1");
      //   });
      // });
      //
      // print('healing.values:${model.healing!.value!.details!.entries}');
      // model.healing!.value!.details!.forEach((key, value) {
      //   print("day: $key");
      //   print(value.toMap());
      //   value.data!.forEach((k, v1) {
      //     print("$k -- $v1");
      //   });
      // });
      // print('nourish.values:${model.nourish!.value!.data}');

    }
    else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
      // errorMsg = model.message ?? '';
      // Future.delayed(Duration(seconds: 0)).whenComplete(() {
      //   setState(() {
      //     showShimmer = false;
      //     isLoading = false;
      //   });
      //   showAlert(context, model.status!,
      //       isSingleButton: !(model.status != '401'), positiveButton: () {
      //         if (model.status == '401') {
      //           Navigator.pop(context);
      //           Navigator.pop(context);
      //         } else {
      //           getMeals();
      //           Navigator.pop(context);
      //         }
      //       });
      // });
    }
    setState(() {
      showProgress = false;
    });
    print(result);
  }


  final ProgramRepository repository = ProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  bool getIsPortrait(){
    final _ori = MediaQuery.of(context).orientation;
    print(_ori.name);
    bool isPortrait = _ori == Orientation.portrait;
    return isPortrait;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length,
        initialIndex: widget.stage);

    selectedTab = widget.stage;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  int selectedTab = 0;

  bool showTabs = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: newDashboardGreenButtonColor.withOpacity(0.6),
        title: buildAppBar(
              () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.help_outline_rounded,
              color: gWhiteColor,
            ),
            onPressed: () {
              print(selectedTab);
              if(selectedTab == 1 || selectedTab == 2){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => HomeRemediesScreen()
                    ));
              }
              else{
                if(selectedTab == 0){
                  if(prepDoDontPdfLink != null){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> DosDontsProgramScreen(pdfLink: prepDoDontPdfLink!,)));
                  }
                }
                else{
                  if(transDoDontPdfLink != null){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> DosDontsProgramScreen(pdfLink: transDoDontPdfLink!,)));
                  }
                }
              }

              // if (planNotePdfLink != null ||
              //     planNotePdfLink!.isNotEmpty) {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (ctx) => MealPdf(
              //             pdfLink: planNotePdfLink!,
              //             heading: "Note",
              //             isVideoWidgetVisible: false,
              //             headCircleIcon: bsHeadPinIcon,
              //             topHeadColor: kBottomSheetHeadGreen,
              //             isSheetCloseNeeded: true,
              //             sheetCloseOnTap: () {
              //               Navigator.pop(context);
              //             },
              //           )));
              // } else {
              //   AppConfig().showSnackbar(
              //       context, "Note Link Not available",
              //       isError: true);
              // }
            },
          )
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        bottom: (showTabs) ? TabBar(
          controller: _tabController,
          labelColor: gBlackColor,
          unselectedLabelColor: gHintTextColor,
          isScrollable: true,
          indicatorColor: gPrimaryColor,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 2.w),
          unselectedLabelStyle: TextStyle(
              fontFamily: kFontBook, color: gHintTextColor, fontSize: 9.sp),
          labelStyle: TextStyle(
              fontFamily: kFontMedium, color: gBlackColor, fontSize: 11.sp),
          tabs: myTabs,
          onTap: (i){
            setState(() {
              selectedTab = i;
              showTabs = true;
            });
          },
        ) : null,
      ),
      body: Column(
       children:[
         // if(selectedTab == 1 || selectedTab == 2) buildDaysView(),
         Expanded(
           child: (showProgress)
               ? Center(
             child: buildCircularIndicator(),
           )
               : mainView(),
         )
       ]
      ),
    );
  }

  tabView(){
    return Container(
      decoration: BoxDecoration(
          color: newDashboardGreenButtonColor.withOpacity(0.5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20)
        )
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 3.w),
            child: buildAppBar(
                    () {
                  Navigator.pop(context);
                },
                showHelpIcon: true,
                helpOnTap: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (_)=> DosDontsProgramScreen(pdfLink: doDontPdfLink!,)));
                }
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            height: 35,
            child: TabBar(
              labelColor: gTextColor,
              unselectedLabelColor: gPrimaryColor,
              // padding: EdgeInsets.symmetric(horizontal: 3.w),
              isScrollable: true,
              indicatorColor: gsecondaryColor,
              labelStyle: TextStyle(
                  fontFamily: kFontMedium,
                  color: gPrimaryColor,
                  fontSize: 12.sp),
              unselectedLabelStyle: TextStyle(
                  fontFamily: kFontBook,
                  color: gHintTextColor,
                  fontSize: 10.sp),
              // labelPadding: EdgeInsets.only(
              //     right: 10.w, left: 2.w, top: 1.h, bottom: 1.h),
              indicatorPadding: EdgeInsets.symmetric(horizontal: 5.w),
              tabs: const [
                Tab(text: 'Prepratory'),
                Tab(text: 'Detox'),
                Tab(text: 'Healing'),
                Tab(text: 'Nourish')
              ],
            ),
          )
        ],
      ),
    );
  }

  int totalPrep = 2;
  int selectedPrepDay = 1;

  int totalDetox = 5;
  int totalHealing = 4;
  int totalNourish = 4;

  bool isPrepCompleted = false;
  int? prepPresentDay;
  bool isDetoxCompleted = false;
  bool isHealingCompleted = false;

  String? nourishPresentDay;
  bool isNourishCompleted = false;

  late List<DaysView> _daysview = [
    // DaysView("Preparatory", totalPrep),
    DaysView("Detox", totalDetox),
    DaysView("Healing", totalHealing),
    // DaysView("Nourish", totalNourish)
  ];

  buildDaysView(){
    return Container(
      height: 9.h,
      // padding: EdgeInsets.only(left: 6),
      margin: EdgeInsets.only(left: 4, right: 4),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _daysview.length,
        itemBuilder: (_, index){
          return customDaysTab(_daysview[index].name, _daysview[index].totalDays);
        },
      ),
    );
  }

  customDaysTab(String stageName, int length){
    return Visibility(
      visible: myTabs[selectedTab].text == stageName,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: 0.5,
                child: Container(
                  // height: 5.h,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: MealPlanConstants().dayBorderColor),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                        color: newDashboardGreenButtonColor
                      // color: (listData[index].dayNumber == selectedDay.toString())
                      //     ? kNumberCircleAmber
                      //     : (listData[index].isCompleted == 1)
                      //     ? MealPlanConstants().dayBgSelectedColor
                      //     : (listData[index].dayNumber == presentDay.toString())
                      //     ? MealPlanConstants().dayBgPresentdayColor
                      //     : MealPlanConstants().dayBgNormalColor
                    ),
                    margin: const EdgeInsets.only(left: 4, top: 5, right: 4),
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6),
                    child: Row(
                      children: List.generate(length,
                              (index) {
                                print("stageName===$stageName  ");
                        return GestureDetector(
                          onTap: (){
                            print(index);
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: getCircleColor(stageName, index)
                                  // Colors.red
                              ),
                              child: Center(
                                child: Text(
                                    '0${index+1}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize:
                                      (selectedPrepDay == 1)
                                          ? MealPlanConstants().presentDayTextSize
                                          : MealPlanConstants().DisableDayTextSize,
                                      fontFamily:
                                      (selectedPrepDay == 1)
                                          ? MealPlanConstants().dayTextFontFamily
                                          : MealPlanConstants().dayUnSelectedTextFontFamily,
                                      color: (selectedPrepDay == 1)
                                          ? MealPlanConstants().dayTextSelectedColor
                                          : MealPlanConstants().dayTextColor),
                                ),
                              ),
                            ),
                        );}
                      ),
                    )
                ),
              ),

            ],
          ),
          Center(child: Text(stageName,
            style: TextStyle(
                fontSize: 8.5.sp,
                fontFamily: kFontMedium,
                color: gTextColor
            ),),)
        ],
      ),
    );
  }

  mainView(){
    return TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          prepView(),
          detoxView(),
          healingView(),
          nourishView(),
        ]
    );
  }

  prepView() {
    return (_childPrepModel != null ) ? NewPrepScreen(
      prepPlanDetails: _childPrepModel!,
    ) : noData();
  }



  detoxView() {
    return (_childPrepModel != null ) ? DetoxPlanScreen(
      // showBlur: showBlur(1),
      viewDay1Details: widget.fromStartScreen || showBlur(1),
      trackerVideoLink: trackerUrl,
      isHealingStarted: isHealingStarted,
      onChanged: (value){
        // if  value is false hide tabs
        showTabs = value;

        // if true show tabs
        print("Combined meal plan value change: $value");
      },
    ) : noData();
  }

  healingView() {
    return (_childHealingModel != null )
        ? HealingPlanScreen(
      // showBlur: showBlur(2),
      viewDay1Details: widget.fromStartScreen || showBlur(2),
      trackerVideoLink: trackerUrl,
      isNourishStarted: isNourishStarted,
      onChanged: (value){
        // if  value is false hide tabs
        showTabs = value;

        // if true show tabs
        print("Combined meal plan value change: $value");
        // SchedulerBinding.instance!.addPostFrameCallback((duration) {
        //   setState(() {});
        // });
      },
    ) : noData();
  }

  nourishView() {
    print("widget.fromStartScreen: ${widget.fromStartScreen}");
    return (_childNourishModel != null ) ? ImageFiltered(
      imageFilter:
      // showBlur(3)
      //     ? ImageFilter.blur(sigmaX: 5, sigmaY: 5)
      //     :
      ImageFilter.blur(sigmaX: 0, sigmaY: 0),
      child: IgnorePointer(
        ignoring: false,
        // ignoring: showBlur(3) ? true : false,
        child: NourishPlanScreen(
          prepPlanDetails: _childNourishModel!,
          selectedDay: int.tryParse(nourishPresentDay ?? '1') ?? 1,
          viewDay1Details: widget.fromStartScreen || showBlur(3),
          totalDays: totalNourish.toString(),
          trackerVideoLink: trackerUrl,
          postProgramStage: widget.postProgramStage,
        ),
      ),
    ) : noData();
    // return NewTransDesign(
    //   childNourishModel: _childNourishModel!,
    //     totalDays: totalNourish.toString(),
    //     dayNumber: '1',
    // );
  }

  noData() {
    return const Center(
      child: Image(
        image: AssetImage("assets/images/no_data_found.png"),
        fit: BoxFit.scaleDown,
      ),
    );
  }

  showBlur(int index){
    print("${!isHealingCompleted}  ${widget.stage} < ${index}}");
    print(widget.stage > index);
    print("==> ${!isHealingCompleted && widget.stage < index}");
    print("..${!isDetoxCompleted && widget.stage != index}");
    bool show;
    switch(widget.stage){
      case 0:
        if(!isPrepCompleted && widget.stage != index){
          return show = true;
        }
        else{
          return show = false;
        }
      case 1:
        if(!isDetoxCompleted && widget.stage != index){
          return show = true;
        }
        else{
          return show = false;
        }
      case 2:
        if(!isHealingCompleted && widget.stage < index){
          return show = true;
        }
        else{
          return show = false;
        }
      case 3:
        return show = false;
    }

  }

  getCircleColor(String stageName, int index) {
    print("$stageName -- $index");
    Color bgColor;
    switch(stageName){
      case 'Preparatory':
        print("isPrepCompleted: $isPrepCompleted");
        if(isPrepCompleted){
          return bgColor = Colors.transparent;
        }
        else {
          if(prepPresentDay != null){
            print("getColor: $index");
            bgColor = (prepPresentDay == index+1) ? gsecondaryColor : newDashboardGreenButtonColor;
          }
        }
        break;
      case 'Detox':

        break;
      case 'Healing':
        break;
      case 'Nourish':
        break;
    }
  }

}

class DaysView {
  String name;
  int totalDays;
  bool isDayCompleted;

  DaysView(this.name, this.totalDays, {this.isDayCompleted = false});

}
