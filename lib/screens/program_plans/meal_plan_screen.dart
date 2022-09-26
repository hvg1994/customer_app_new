import 'dart:convert';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/program_model/proceed_model/send_proceed_program_model.dart';
import 'package:gwc_customer/repository/program_repository/program_repository.dart';
import 'package:gwc_customer/widgets/open_alert_box.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
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
import 'meal_pdf.dart';
import 'meal_plan_data.dart';
import 'package:http/http.dart' as http;

class MealPlanScreen extends StatefulWidget {
  final String day;
  const MealPlanScreen({Key? key, required this.day}) : super(key: key);

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

  bool isLoading = false;

  String errorMsg = '';

  String? proceedToDay;

  List<ChildMealPlanDetailsModel>? mealPlanData1;

  List<String> list = [
    "Followed",
    "UnFollowed",
    "Alternative without Doctor",
    "Alternative with Doctor",
  ];

  //****************  video player variables  *************

  // for video player
  VlcPlayerController? _controller;
  final _key = GlobalKey<VlcPlayerWithControlsState>();


  bool isEnabled = false;

  String videoName = '';
  String mealTime = '';

  // *******************************************************


  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    getMeals();
    commentController.addListener(() {
      setState(() {});
    });
    proceedToDay = _pref!.getInt(AppConfig.STORE_LENGTH).toString();
  }


  getMeals() async{
    setState(() {
      isLoading = true;
    });
    final result = await ProgramService(repository: repository).getMealPlanDetailsService(widget.day);
    print("result: $result");

    if(result.runtimeType == MealPlanDetailsModel){
      print("meal plan");
      MealPlanDetailsModel model = result as MealPlanDetailsModel;
      setState(() {
        isLoading = false;
      });
      mealPlanData1 = model.data!.map((e) => e).toList();
      print('meal list: $mealPlanData1');
    }
    else{
      ErrorModel model = result as ErrorModel;
      errorMsg = model.message ?? '';
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {
          isLoading = false;
        });
        showAlert(context, model.status!);
      });
    }
    print(result);
  }

  showAlert(BuildContext context, String status, {bool isSingleButton = true}){
    return openAlertBox(
        context: context,
        barrierDismissible: false,
        content: errorMsg,
        titleNeeded: false,
        isSingleButton: isSingleButton,
        positiveButtonName: (status == '401') ? 'Go Back' : 'Retry',
        positiveButton: (){
          if(status == '401'){
            Navigator.pop(context);
            Navigator.pop(context);
          }
          else{
            getMeals();
            Navigator.pop(context);
          }
        },
        negativeButton: isSingleButton
            ? null
            : (){
          Navigator.pop(context);
          Navigator.pop(context);
    },
      negativeButtonName: isSingleButton ? null : 'Go Back'
    );
  }

  initVideoView(String? url){
    _controller = VlcPlayerController.network(
      // url!,
      'https://media.w3.org/2010/05/sintel/trailer.mp4',
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

    print("_controller.isReadyToInitialize: ${_controller!.isReadyToInitialize}");
    _controller!.addOnInitListener(() async {
      await _controller!.startRendererScanning();
    });

  }
  @override
  void dispose() async{
    super.dispose();
    commentController.dispose();
    await _controller!.dispose();
    await _controller!.stopRendererScanning();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          body: videoPlayerView(),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final _ori = MediaQuery.of(context).orientation;
    bool isPortrait = _ori == Orientation.portrait;
    if(!isPortrait){
      AutoOrientation.portraitUpMode();
      setState(() {
        isEnabled = !isEnabled;
      });
    }
    return false;
  }


  backgroundWidgetForPIP(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 1.h, left: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(height: 1.h),
              Text(
                "Day ${widget.day} Meal Plan",
                style: TextStyle(
                    fontFamily: "GothamRoundedBold_21016",
                    color: gPrimaryColor,
                    fontSize: 12.sp),
              ),
            ],
          ),
        ),
        Expanded(
          child: (isLoading) ? Center(child: buildCircularIndicator(),) :
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: (mealPlanData1 != null) ? Column(
              children: [
                buildMealPlan(),
                Container(
                  height: 15.h,
                  margin:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
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
                      suffixIcon: commentController.text.isEmpty
                          ? Container(width: 0)
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
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: (statusList.length != mealPlanData1!.length)
                        ? null
                        : () {
                      sendData();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      padding: EdgeInsets.symmetric(
                          vertical: 1.h, horizontal: 5.w),
                      decoration: BoxDecoration(
                        color: (statusList.length != mealPlanData1!.length) ? gMainColor : gPrimaryColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: gMainColor, width: 1),
                      ),
                      child: Text(
                        'Proceed to Day $proceedToDay',
                        style: TextStyle(
                          fontFamily: "GothamBook",
                          color: (statusList.length != mealPlanData1!.length) ? gPrimaryColor :  gMainColor,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ) : SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  videoPlayerView(){
    return PIPStack(
      shrinkAlignment: Alignment.bottomRight,
      backgroundWidget: backgroundWidgetForPIP(),
      pipWidget: isEnabled
          ? Consumer<CheckState>(
        builder: (_, model, __){
          print("model.isChanged: ${model.isChanged}");
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
      onClosed: (){
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              gradient: LinearGradient(colors: [
                Color(0xffE06666),
                Color(0xff93C47D),
                Color(0xffFFD966),
              ], begin: Alignment.topLeft, end: Alignment.topRight),
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
            dataRowHeight: 6.h,
            // headingRowColor: MaterialStateProperty.all(const Color(0xffE06666)),
            columns:  <DataColumn>[
              DataColumn(
                label: Text(' Time',
                  style: TextStyle(
                    color: gWhiteColor,
                    fontSize: 11.sp,
                    fontFamily: "GothamMedium",
                  ),
                ),
              ),
              DataColumn(
                label: Text('Meal/Yoga',
                  style: TextStyle(
                    color: gWhiteColor,
                    fontSize: 11.sp,
                    fontFamily: "GothamMedium",
                  ),
                ),
              ),
              DataColumn(
                label: Text('   Status',
                  style: TextStyle(
                    color: gWhiteColor,
                    fontSize: 11.sp,
                    fontFamily: "GothamMedium",
                  ),
                ),
              ),
            ],
            rows: showDataRow(),
          ),
        ],
      ),
    );
  }

  showDataRow(){
    return mealPlanData1!.map((e) => DataRow(
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
            onTap: e.url == null ? null : e.type == 'item' ? () => showPdf(e.url!) : () => showVideo(e),
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
                if(e.type == 'yoga') SizedBox(width: 2.w),
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
          Theme(
            data: Theme.of(context).copyWith(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            child: PopupMenuButton(
              offset: const Offset(0, 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
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
                        itemId: e.itemId!
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        height: 1,
                        color: gGreyColor.withOpacity(0.3),
                      ),
                      buildTabView(
                          index: 2,
                          title: list[1],
                          color: gsecondaryColor,
                          itemId: e.itemId!
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        height: 1,
                        color: gGreyColor.withOpacity(0.3),
                      ),
                      buildTabView(
                          index: 3,
                          title: list[2],
                          color: gMainColor,
                          itemId: e.itemId!
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        height: 1,
                        color: gGreyColor.withOpacity(0.3),
                      ),
                      buildTabView(
                          index: 4,
                          title: list[3],
                          color: gMainColor,
                          itemId: e.itemId!
                      ),
                      SizedBox(height: 0.6.h),
                    ],
                  ),
                  onTap: null,
                ),
              ],
              child: Container(
                width: 20.w,
                padding: EdgeInsets.symmetric(
                    horizontal: 2.w, vertical: 0.2.h),
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
                            color: statusList.isEmpty ? textColor : getTextColor(e.itemId!) ?? textColor,
                            fontSize: 8.sp),
                      ),
                    ),
                    Icon(
                      Icons.expand_more,
                      color: gGreyColor,
                      size: 2.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    )).toList();
  }

  Map statusList = {};

  showDummyDataRow(){
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
                          index: 1,
                          title: list[0],
                          color: gPrimaryColor),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        height: 1,
                        color: gGreyColor.withOpacity(0.3),
                      ),
                      buildDummyTabView(
                          index: 2,
                          title: list[1],
                          color: gsecondaryColor),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        height: 1,
                        color: gGreyColor.withOpacity(0.3),
                      ),
                      buildDummyTabView(
                          index: 3,
                          title: list[2],
                          color: gMainColor),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        height: 1,
                        color: gGreyColor.withOpacity(0.3),
                      ),
                      buildDummyTabView(
                          index: 4,
                          title: list[3],
                          color: gMainColor),
                      SizedBox(height: 0.6.h),
                    ],
                  ),
                ),
              ],
              child: Container(
                width: 20.w,
                padding: EdgeInsets.symmetric(
                    horizontal: 2.w, vertical: 0.2.h),
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
                            fontFamily: "GothamBook",
                            color: buildDummyTextColor(),
                            fontSize: 8.sp),
                      ),
                    ),
                    Icon(
                      Icons.expand_more,
                      color: gGreyColor,
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

  void onChangedTab(int index,{int? id, String? title}) {
    print('$id  $title');
    setState(() {
      if(id != null && title != null){
        if(statusList.isNotEmpty && statusList.containsKey(id)){
          print("contains");
          statusList.update(id, (value) => title);
        }
        else if(statusList.isEmpty || !statusList.containsKey(id)){
          print('new');
          statusList.putIfAbsent(id, () => title);
        }
      }
      print(statusList);
      print(statusList[id].runtimeType);
    });
  }

  getStatusText(int id){
    print("id: ${id}");
    print('statusList[id]${statusList[id]}');
    return statusList[id];
  }

  getTextColor(int id){
    setState(() {
      if(statusList.isEmpty){
        textColor = gWhiteColor;
      }
      else if (statusList[id] == list[0]) {
        textColor = gPrimaryColor;
      } else if (statusList[id] == list[1]) {
        textColor = gsecondaryColor;
      } else if (statusList[id] == list[2]) {
        textColor = gMainColor;
      } else if (statusList[id] == list[3]) {
        textColor = gMainColor;
      }
    });
    return textColor;
  }


  void onChangedDummyTab(int index) {
    setState(() {
      planStatus = index;
    });
  }


  Widget buildTabView({
    required int index,
    required String title,
    required Color color,
    int? itemId
  }) {
    return GestureDetector(
      onTap: () {
        onChangedTab(index, id: itemId, title: title);
        Get.back();
      },
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "GothamBook",
          // color: (planStatus == index) ? color : gTextColor,
          color: (statusList[itemId] == title) ? color : gTextColor,
          fontSize: 8.sp,
        ),
      ),
    );
  }

  Widget buildDummyTabView({
    required int index,
    required String title,
    required Color color,
    int? itemId
  }) {
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

  // String buildHeaderText() {
  //  setState(() {
  //    if (statusList.isEmpty) {
  //      headerText = "";
  //    } else if (statusList.containsValue('Followed')) {
  //      print(statusList.containsValue('Followed'));
  //      headerText = "Followed";
  //    } else if (statusList.containsValue('UnFollowed')) {
  //      headerText = "UnFollowed";
  //    } else if (statusList.containsValue('Alternative without Doctor')) {
  //      headerText = "Alternative without Doctor";
  //    } else if (statusList.containsValue('Alternative with Doctor')) {
  //      headerText = "Alternative with Doctor";
  //    }
  //  });
  //   return headerText;
  // }

  String buildDummyHeaderText() {
    if (planStatus == 0) {
      headerText = "     ";
    } else if (planStatus == 1) {
      headerText = "Followed";
    } else if (planStatus == 2) {
      headerText = "UnFollowed";
    } else if (planStatus == 3) {
      headerText = "Alternative without Doctor";
    } else if (planStatus == 4) {
      headerText = "Alternative with Doctor";
    }
    return headerText;
  }

  // Color? buildTextColor() {
  //   setState(() {
  //     if (statusList.isEmpty) {
  //       textColor = gWhiteColor;
  //     }
  //     else if (statusList.containsValue('Followed')) {
  //       textColor = gPrimaryColor;
  //     } else if (statusList.containsValue('UnFollowed')) {
  //       textColor = gsecondaryColor;
  //     } else if (statusList.containsValue('Alternative without Doctor')) {
  //       textColor = gMainColor;
  //     } else if (statusList.containsValue('Alternative with Doctor')) {
  //       textColor = gMainColor;
  //     }
  //   });
  // }

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

  void sendData() async{
    ProceedProgramDayModel? model;
    List<PatientMealTracking> tracking = [];

    statusList.forEach((key, value) {
      print('$key---$value');
      tracking.add(PatientMealTracking(
          day: int.parse(widget.day),
        userMealItemId: key,
        status: value
      ));
    });

    model = ProceedProgramDayModel(patientMealTracking: tracking, comment: commentController.text.isEmpty ? null : commentController.text);

    // print('ProceedProgramDayModel: ${jsonEncode(model.toJson())}');

    final result = await ProgramService(repository: repository).proceedDayMealDetailsService(model);

    print("result: $result");

  }


  showPdf(String itemUrl) {
    print(itemUrl);
    String? url;
    if(itemUrl.contains('drive.google.com')){
      // String url = 'https://drive.google.com/uc?export=view&id=1e_IymVjGgPd9g3goNM27nbUiV2kEJX9g';
      String baseUrl = 'https://drive.google.com/uc?export=view&id=';
      url = baseUrl + itemUrl.split('/')[5];
    }
    else{
      url = itemUrl;
    }
    print(url);
    Navigator.push(context, MaterialPageRoute(builder: (ctx)=> MealPdf(pdfLink: url! ,)));
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
}

class MealPlanData {
  MealPlanData(this.time, this.title, this.id);

  String time;
  String title;
  int id;
}
