//
//
//
// import 'dart:convert';
//
// import 'package:auto_orientation/auto_orientation.dart';
// import 'package:dropdown_button2/custom_dropdown_button2.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:gwc_customer/model/error_model.dart';
// import 'package:gwc_customer/model/program_model/proceed_model/send_proceed_program_model.dart';
// import 'package:gwc_customer/repository/program_repository/program_repository.dart';
// import 'package:gwc_customer/screens/program_plans/day_tracker_ui/day_tracker.dart';
// import 'package:gwc_customer/widgets/open_alert_box.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
// import 'package:get/get.dart';
// import '../../model/program_model/meal_plan_details_model/child_meal_plan_details_model.dart';
// import '../../model/program_model/meal_plan_details_model/meal_plan_details_model.dart';
// import '../../model/program_model/proceed_model/get_proceed_model.dart';
// import '../../repository/api_service.dart';
// import '../../services/program_service/program_service.dart';
// import '../../services/vlc_service/check_state.dart';
// import '../../utils/app_config.dart';
// import '../../widgets/constants.dart';
// import '../../widgets/pip_package.dart';
// import '../../widgets/vlc_player/vlc_player_with_controls.dart';
// import '../../widgets/widgets.dart';
// import 'day_program_plans.dart';
// import 'meal_pdf.dart';
// import 'meal_plan_data.dart';
// import 'package:http/http.dart' as http;
//
// class MealPlanScreen extends StatefulWidget {
//   /// selected day
//   final String day;
//   final bool? isCompleted;
//   /// present day from api
//   final String presentDay;
//   final String nextDay;
//   const MealPlanScreen({Key? key, required this.day, this.isCompleted, required this.presentDay, required this.nextDay}) : super(key: key);
//
//   @override
//   State<MealPlanScreen> createState() => _MealPlanScreenState();
// }
//
// class _MealPlanScreenState extends State<MealPlanScreen> {
//   final _pref = AppConfig().preferences;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   TextEditingController commentController = TextEditingController();
//   int planStatus = 0;
//   String headerText = "";
//   Color textColor = gWhiteColor;
//
//   bool isLoading = false;
//
//   String errorMsg = '';
//
//   String? proceedToDay;
//
//   List<ChildMealPlanDetailsModel>? shoppingData;
//
//   Map<String, List<ChildMealPlanDetailsModel>> mealPlanData1 = {};
//
//   final tableHeadingBg = gGreyColor.withOpacity(0.4);
//
//   List<String> list = [
//     "Followed",
//     "Unfollowed",
//   ];
//
//   List<String> sendList = [
//     "followed",
//     "unfollowed",
//   ];
//
//   //****************  video player variables  *************
//
//   // for video player
//   VlcPlayerController? _controller;
//   final _key = GlobalKey<VlcPlayerWithControlsState>();
//
//   var checkState;
//
//   /// to check enable / disable
//   bool isEnabled = false;
//
//   String videoName = '';
//   String mealTime = '';
//
//   // *******************************************************
//
//
//   @override
//   void setState(VoidCallback fn) {
//     // TODO: implement setState
//     if(mounted){
//       super.setState(fn);
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getMeals();
//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       commentController.addListener(() {
//         setState(() {});
//       });
//     });
//     proceedToDay = (_pref!.getInt(AppConfig.STORE_LENGTH).toString() == widget.day) ? _pref!.getInt(AppConfig.STORE_LENGTH).toString() : (int.parse(widget.day) + 1).toString();
//   }
//
//
//   getMeals() async{
//     setState(() {
//       isLoading = true;
//     });
//     final result = await ProgramService(repository: repository).getMealPlanDetailsService(widget.day);
//     print("result: $result");
//
//     if(result.runtimeType == MealPlanDetailsModel){
//       print("meal plan");
//       MealPlanDetailsModel model = result as MealPlanDetailsModel;
//       setState(() {
//         isLoading = false;
//       });
//       mealPlanData1.addAll(model.data!);
//
//       print('meal list: ${mealPlanData1}');
//       // when day completed
//       if(widget.isCompleted  != null){
//         mealPlanData1.forEach((key, value) {
//           (value).forEach((element) {
//             statusList.putIfAbsent(element.itemId, () => element.status.toString().capitalize);
//           });
//         });
//         // mealPlanData1.forEach((element) {
//         //   print(element.toJson());
//         //   statusList.putIfAbsent(element.itemId, () => element.status.toString().capitalize);
//         // });
//         commentController.text = model.comment ?? '';
//       }
//       mealPlanData1.values.forEach((element) {
//         element.forEach((item) {
//           lst.add(item);
//         });
//       });
//       print('mealPlanData1.values.length:${mealPlanData1.values.length}, ${lst.length}');
//     }
//     else{
//       ErrorModel model = result as ErrorModel;
//       errorMsg = model.message ?? '';
//       WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//         setState(() {
//           isLoading = false;
//         });
//         showAlert(context, model.status!, isSingleButton: !(model.status != '401'));
//       });
//     }
//     print(result);
//   }
//
//   showAlert(BuildContext context, String status, {bool isSingleButton = true}){
//     return openAlertBox(
//         context: context,
//         barrierDismissible: false,
//         content: errorMsg,
//         titleNeeded: false,
//         isSingleButton: isSingleButton,
//         positiveButtonName: (status == '401') ? 'Go Back' : 'Retry',
//         positiveButton: (){
//           if(status == '401'){
//             Navigator.pop(context);
//             Navigator.pop(context);
//           }
//           else{
//             getMeals();
//             Navigator.pop(context);
//           }
//         },
//         negativeButton: isSingleButton
//             ? null
//             : (){
//           Navigator.pop(context);
//           Navigator.pop(context);
//     },
//       negativeButtonName: isSingleButton ? null : 'Go Back'
//     );
//   }
//
//   initVideoView(String? url){
//     print("init url: $url");
//     _controller = VlcPlayerController.network(
//      // url ??
//       'https://media.w3.org/2010/05/sintel/trailer.mp4',
//       hwAcc: HwAcc.full,
//       options: VlcPlayerOptions(
//         advanced: VlcAdvancedOptions([
//           VlcAdvancedOptions.networkCaching(2000),
//         ]),
//         subtitle: VlcSubtitleOptions([
//           VlcSubtitleOptions.boldStyle(true),
//           VlcSubtitleOptions.fontSize(30),
//           VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
//           VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
//           // works only on externally added subtitles
//           VlcSubtitleOptions.color(VlcSubtitleColor.navy),
//         ]),
//         http: VlcHttpOptions([
//           VlcHttpOptions.httpReconnect(true),
//         ]),
//         rtp: VlcRtpOptions([
//           VlcRtpOptions.rtpOverRtsp(true),
//         ]),
//       ),
//     );
//
//     print("_controller.isReadyToInitialize: ${_controller!.isReadyToInitialize}");
//     _controller!.addOnInitListener(() async {
//       await _controller!.startRendererScanning();
//     });
//
//   }
//   @override
//   void dispose() async{
//     super.dispose();
//     commentController.dispose();
//     await _controller?.dispose();
//     await _controller?.stopRendererScanning();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: SafeArea(
//         child: Scaffold(
//           body: videoPlayerView(),
//         ),
//       ),
//     );
//   }
//
//   Future<bool> _onWillPop() async {
//     final _ori = MediaQuery.of(context).orientation;
//     bool isPortrait = _ori == Orientation.portrait;
//     if(!isPortrait){
//       AutoOrientation.portraitUpMode();
//       // setState(() {
//       //   isEnabled = false;
//       // });
//     }
//     print(isEnabled);
//     return !isEnabled ? true: false;
//     // return false;
//   }
//
//   dayItems(String dayNumber){
//     return Opacity(
//       opacity: 1.0,
//       child: Container(
//         height: 6.5.h,
//         decoration: BoxDecoration(
//           border: Border.all(
//             width: 1,
//             color: gsecondaryColor
//           ),
//           borderRadius: BorderRadius.circular(MealPlanConstants().dayBorderRadius),
//           // color: gsecondaryColor
//         ),
//         margin: EdgeInsets.symmetric(horizontal: 4),
//           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
//           child: Center(
//           child: Text('DAY\n $dayNumber',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontFamily: MealPlanConstants().dayTextFontFamily,
//               color: gTextColor
//             ),
//           ),
//         )
//       ),
//     );
//   }
//
//   backgroundWidgetForPIP(){
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: 1.h, left: 4.w, right: 4.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               buildAppBar(() {
//                 Navigator.pop(context);
//               }),
//               SizedBox(height: 1.h),
//               Text(
//                 // "Day ${widget.day} Meal Plan",
//                 "Day Meal & Yoga Plan",
//                 style: TextStyle(
//                     fontFamily: eUser().mainHeadingFont,
//                     color: eUser().mainHeadingColor,
//                     fontSize: eUser().mainHeadingFontSize
//                 ),
//               ),
//               SizedBox(
//                 height: 1.h,
//               ),
//               SizedBox(
//                 height: 7.h,
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                     scrollDirection: Axis.horizontal,
//                     itemCount: 15,
//                     itemBuilder: (_, index){
//                     return dayItems((index+1).toString());
//                     }
//                 ),
//               )
//             ],
//           ),
//         ),
//         Expanded(
//           child: (isLoading) ? Center(child: buildCircularIndicator(),) :
//           SingleChildScrollView(
//             physics: AlwaysScrollableScrollPhysics(),
//             child: (mealPlanData1 != null)
//                 ? Column(
//               children: [
//                 SizedBox(
//                   height: 8,
//                 ),
//                 buildNewItemList(),
//                 buildNewItemList(),
//                 buildNewItemList(),
//                 buildNewItemList(),
//                 buildNewItemList(),
//
//                 // buildMealPlan(),
//                 Visibility(
//                   visible: (statusList.isNotEmpty && statusList.values.any((element) => element.toString().contains('Unfollowed'))) || widget.isCompleted != null,
//                   child: IgnorePointer(
//                     ignoring: widget.isCompleted != null,
//                     child: Container(
//                       height: 15.h,
//                       margin:
//                       EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
//                       padding: EdgeInsets.symmetric(horizontal: 3.w),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(5),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.3),
//                             blurRadius: 20,
//                             offset: const Offset(2, 10),
//                           ),
//                         ],
//                       ),
//                       child: TextFormField(
//                         controller: commentController,
//                         cursorColor: gPrimaryColor,
//                         style: TextStyle(
//                             fontFamily: "GothamBook",
//                             color: gTextColor,
//                             fontSize: 11.sp),
//                         decoration: InputDecoration(
//                           suffixIcon: commentController.text.isEmpty || widget.isCompleted != null
//                               ? SizedBox()
//                               : InkWell(
//                             onTap: () {
//                               commentController.clear();
//                             },
//                             child: const Icon(
//                               Icons.close,
//                               color: gTextColor,
//                             ),
//                           ),
//                           hintText: "Comments",
//                           border: InputBorder.none,
//                           hintStyle: TextStyle(
//                             fontFamily: "GothamBook",
//                             color: gTextColor,
//                             fontSize: 9.sp,
//                           ),
//                         ),
//                         textInputAction: TextInputAction.next,
//                         textAlign: TextAlign.start,
//                         keyboardType: TextInputType.emailAddress,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Visibility(
//                   visible: buttonVisibility(),
//                   child: Center(
//                     child: GestureDetector(
//                       onTap: (statusList.length != lst.length)
//                           ? () => AppConfig().showSnackbar(context, "Please complete the Meal Plan Status", isError: true)
//                           : (statusList.values.any((element) => element.toString().toLowerCase() == 'unfollowed') && commentController.text.isEmpty)
//                           ? () => AppConfig().showSnackbar(context, "Please Mention the comments why you unfollowed?", isError: true)
//                           : () {
//                         sendData();
//                       },
//                       child: Container(
//                         margin: EdgeInsets.symmetric(vertical: 2.h),
//                         width: 60.w,
//                         height: 5.h,
//                         decoration: BoxDecoration(
//                           color: (statusList.length == lst.length) ? eUser().buttonColor : tableHeadingBg,
//                           borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
//                           // border: Border.all(color: eUser().buttonBorderColor,
//                           //     width: eUser().buttonBorderWidth),
//                         ),
//                         child: Center(
//                           child: Text(
//                             'Proceed to Symptoms Tracker',
//                             // 'Proceed to Day $proceedToDay',
//                             style: TextStyle(
//                               fontFamily: eUser().buttonTextFont,
//                               color: eUser().buttonTextColor,
//                               // color: (statusList.length != lst.length) ? gPrimaryColor : gMainColor,
//                               fontSize: eUser().buttonTextSize,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//                 : SizedBox.shrink(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   videoPlayerView(){
//     return PIPStack(
//       shrinkAlignment: Alignment.bottomRight,
//       backgroundWidget: backgroundWidgetForPIP(),
//       pipWidget: isEnabled
//           ? Consumer<CheckState>(
//         builder: (_, model, __){
//           print("model.isChanged: ${model.isChanged} $isEnabled");
//           return VlcPlayerWithControls(
//             key: _key,
//             controller: _controller!,
//             showVolume: false,
//             showVideoProgress: !model.isChanged,
//             seekButtonIconSize: 10.sp,
//             playButtonIconSize: 14.sp,
//             replayButtonSize: 14.sp,
//             showFullscreenBtn: true,
//           );
//         },
//       )
//       //     ? FutureBuilder(
//       //   future: _initializeVideoPlayerFuture,
//       //   builder: (context, snapshot) {
//       //     if (snapshot.connectionState == ConnectionState.done) {
//       //       // If the VideoPlayerController has finished initialization, use
//       //       // the data it provides to limit the aspect ratio of the video.
//       //       return VlcPlayer(
//       //         controller: _videoPlayerController,
//       //         aspectRatio: 16 / 9,
//       //         placeholder: Center(child: CircularProgressIndicator()),
//       //       );
//       //     } else {
//       //       // If the VideoPlayerController is still initializing, show a
//       //       // loading spinner.
//       //       return const Center(
//       //         child: CircularProgressIndicator(),
//       //       );
//       //     }
//       //   },
//       // )
//       //     ? Container(
//       //   color: Colors.pink,
//       // )
//           : const SizedBox(),
//       pipEnabled: isEnabled,
//       pipExpandedHeight: double.infinity,
//       onClosed: (){
//         // await _controller.stop();
//         // await _controller.dispose();
//         setState(() {
//           isEnabled = !isEnabled;
//         });
//       },
//     );
//   }
//
//   buildMealPlan() {
//     return Container(
//       width: double.maxFinite,
//       margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(2, 10),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           Container(
//             height: 5.h,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(8), topRight: Radius.circular(8)),
//               color: tableHeadingBg
//               // gradient: LinearGradient(colors: [
//               //   Color(0xffE06666),
//               //   Color(0xff93C47D),
//               //   Color(0xffFFD966),
//               // ],
//               //     begin: Alignment.topLeft, end: Alignment.topRight
//               // ),
//             ),
//             // child: Row(
//             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //   children: [
//             //     Container(
//             //       margin: EdgeInsets.only(left:10),
//             //       child: Text(
//             //         'Time',
//             //         style: TextStyle(
//             //           color: gWhiteColor,
//             //           fontSize: 11.sp,
//             //           fontFamily: "GothamMedium",
//             //         ),
//             //       ),
//             //     ),
//             //     Text(
//             //       'Meal/Yoga',
//             //       style: TextStyle(
//             //         color: gWhiteColor,
//             //         fontSize: 11.sp,
//             //         fontFamily: "GothamMedium",
//             //       ),
//             //     ),
//             //     Container(
//             //       margin: EdgeInsets.only(right:10),
//             //       child: Text(
//             //         'Status',
//             //         style: TextStyle(
//             //           color: gWhiteColor,
//             //           fontSize: 11.sp,
//             //           fontFamily: "GothamMedium",
//             //         ),
//             //       ),
//             //     ),
//             //   ],
//             // ),
//           ),
//           DataTable(
//             headingTextStyle: TextStyle(
//               color: gWhiteColor,
//               fontSize: 5.sp,
//               fontFamily: "GothamMedium",
//             ),
//             headingRowHeight: 5.h,
//             horizontalMargin: 2.w,
//             // columnSpacing: 60,
//             dataRowHeight: getRowHeight(),
//             // headingRowColor: MaterialStateProperty.all(const Color(0xffE06666)),
//             columns:  <DataColumn>[
//               DataColumn(
//                 label: Text(' Time',
//                   style: TextStyle(
//                     color: eUser().userFieldLabelColor,
//                     fontSize: 11.sp,
//                     fontFamily: kFontBold,
//                   ),
//                 ),
//               ),
//               DataColumn(
//                 label: Text('Meal/Yoga',
//                   style: TextStyle(
//                     color: eUser().userFieldLabelColor,
//                     fontSize: 11.sp,
//                     fontFamily: kFontBold,
//                   ),
//                 ),
//               ),
//               DataColumn(
//                 label: Text(' Status',
//                   style: TextStyle(
//                     color: eUser().userFieldLabelColor,
//                     fontSize: 11.sp,
//                     fontFamily: kFontBold,
//                   ),
//                 ),
//               ),
//             ],
//             rows: dataRowWidget(),
//           ),
//         ],
//       ),
//     );
//   }
//   buildNewItemList(){
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         children: [
//           Container(
//             height: 120,
//             padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Container(
//                       height: 100,
//                       width: 110,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: Colors.red,
//                       ),
//                       child: Image.asset('assets/images/Mask Group 2171.png',
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                     // Positioned(
//                     //   bottom: -15,
//                     //     left: 10,
//                     //     right: 10,
//                     //     child: Container(
//                     //       margin: EdgeInsets.only(bottom: 4),
//                     //       child: PopupMenuButton(
//                     //         offset: const Offset(0, 30),
//                     //         shape: RoundedRectangleBorder(
//                     //             borderRadius: BorderRadius.circular(5)),
//                     //         itemBuilder: (context) => [
//                     //           // PopupMenuItem(
//                     //           //   child: Column(
//                     //           //     crossAxisAlignment: CrossAxisAlignment.start,
//                     //           //     children: [
//                     //           //       SizedBox(height: 0.6.h),
//                     //           //       buildTabView(
//                     //           //           index: 1,
//                     //           //           title: list[0],
//                     //           //           color: gPrimaryColor,
//                     //           //           itemId: e.itemId!
//                     //           //       ),
//                     //           //       SizedBox(height: 0.6.h),
//                     //           //       Container(
//                     //           //         margin: EdgeInsets.symmetric(vertical: 1.h),
//                     //           //         height: 1,
//                     //           //         color: gGreyColor.withOpacity(0.3),
//                     //           //       ),
//                     //           //       SizedBox(height: 0.6.h),
//                     //           //       buildTabView(
//                     //           //           index: 2,
//                     //           //           title: list[1],
//                     //           //           color: gsecondaryColor,
//                     //           //           itemId: e.itemId!
//                     //           //       ),
//                     //           //       SizedBox(height: 0.6.h),
//                     //           //     ],
//                     //           //   ),
//                     //           //   onTap: null,
//                     //           // ),
//                     //         ],
//                     //         child: GestureDetector(
//                     //           onTap: (){
//                     //             print("tap");
//                     //             openAlertBox(
//                     //               title: 'Did you Follow this item ?',
//                     //                 titleNeeded: true,
//                     //                 context: context,
//                     //                 content: 'Please select any of the following to submit your status',
//                     //                 positiveButtonName: 'Followed',
//                     //                 positiveButton: (){
//                     //                   Navigator.pop(context);
//                     //                 },
//                     //                 negativeButtonName: 'UnFollowed',
//                     //                 negativeButton: (){
//                     //                   Navigator.pop(context);
//                     //                 }
//                     //             );
//                     //           },
//                     //           child: Container(
//                     //             height: 30,
//                     //             padding: EdgeInsets.symmetric(
//                     //                 horizontal: 2.w, vertical: 0.2.h),
//                     //             decoration: BoxDecoration(
//                     //               color: gWhiteColor,
//                     //               borderRadius: BorderRadius.circular(5),
//                     //               border: Border.all(color: gMainColor, width: 1),
//                     //             ),
//                     //             child: Center(
//                     //               child: Text(
//                     //                 'UnFollowed',
//                     //                 textAlign: TextAlign.start,
//                     //                 overflow: TextOverflow.ellipsis,
//                     //                 style: TextStyle(
//                     //                     fontFamily: "GothamMedium",
//                     //                     color: gBlackColor,
//                     //                     fontSize: 8.sp),
//                     //               ),
//                     //             ),
//                     //           ),
//                     //         ),
//                     //       ),
//                     //     )
//                     // )
//                   ],
//                 ),
//                 SizedBox(
//                   width: 8,
//                 ),
//                 Expanded(
//                   child: Column(
//                     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("* Must Have",
//                         style: TextStyle(
//                             fontSize: MealPlanConstants().mustHaveFontSize,
//                             fontFamily: MealPlanConstants().mustHaveFont,
//                           color: MealPlanConstants().mustHaveTextColor,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text('Morning Yoga',
//                         style: TextStyle(
//                             fontSize: MealPlanConstants().mealNameFontSize,
//                             fontFamily: MealPlanConstants().mealNameFont
//                         ),
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Text("B/W 6-8am",
//                         style: TextStyle(
//                           fontSize: 9.sp,
//                           fontFamily: kFontMedium
//                         ),
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Text("- Good for Health and super food\n\n- Very Effective and quick recipe,\n\n- Ready To Cook",
//                         style: TextStyle(
//                             fontSize: MealPlanConstants().benifitsFontSize,
//                             fontFamily: MealPlanConstants().benifitsFont
//                         ),
//                       ),
//                       SizedBox(
//                         height: 4,
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                     onPressed: (){
//                       openAlertBox(
//                           title: 'Did you Follow this item ?',
//                           titleNeeded: true,
//                           context: context,
//                           content: 'Please select any of the following to submit your status',
//                           positiveButtonName: 'Followed',
//                           positiveButton: (){
//                             Navigator.pop(context);
//                           },
//                           negativeButtonName: 'UnFollowed',
//                           negativeButton: (){
//                             Navigator.pop(context);
//                           }
//                       );
//                     },
//                     icon: Icon(Icons.edit))
//               ],
//             ),
//           ),
//           Divider()
//         ],
//       ),
//     );
//   }
//
//   showDataRow(){
//     return mealPlanData1.entries.map((e) {
//       return DataRow(
//           cells: [
//             DataCell(
//               Text(
//                 'e.mealTime.toString()',
//                 style: TextStyle(
//                   height: 1.5,
//                   color: gTextColor,
//                   fontSize: 8.sp,
//                   fontFamily: "GothamBold",
//                 ),
//               ),
//             ),
//             DataCell(
//               GestureDetector(
//                 // onTap: e.url == null ? null : e.type == 'item' ? () => showPdf(e.url!) : () => showVideo(e),
//                 child: Row(
//                   children: [
//                     'e.type' == 'yoga'
//                         ? GestureDetector(
//                       onTap: () {},
//                       child: Image(
//                         image: const AssetImage(
//                             "assets/images/noun-play-1832840.png"),
//                         height: 2.h,
//                       ),
//                     )
//                         : const SizedBox(),
//                     if('e.type '== 'yoga') SizedBox(width: 2.w),
//                     Expanded(
//                       child: Text(
//                         "e.name.toString()",
//                         maxLines: 3,
//                         textAlign: TextAlign.start,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           height: 1.5,
//                           color: gTextColor,
//                           fontSize: 8.sp,
//                           fontFamily: "GothamBook",
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               placeholder: true,
//             ),
//             DataCell(
//               // (widget.isCompleted == null) ?
//                 Theme(
//                   data: Theme.of(context).copyWith(
//                     highlightColor: Colors.transparent,
//                     splashColor: Colors.transparent,
//                   ),
//                   child: oldPopup(e.value.first),
//                 )
//               // : Text(e.status ?? '',
//               //     textAlign: TextAlign.start,
//               //     style: TextStyle(
//               //       fontFamily: "GothamBook",
//               //       color: gTextColor,
//               //       fontSize: 8.sp,
//               //     ),
//               //   ),
//             ),
//             // DataCell(
//             //   Text(
//             //     e.key.toString(),
//             //     style: TextStyle(
//             //       height: 1.5,
//             //       color: gTextColor,
//             //       fontSize: 8.sp,
//             //       fontFamily: "GothamBold",
//             //     ),
//             //   ),
//             // ),
//             // DataCell(
//             //   ListView.builder(
//             //       shrinkWrap: true,
//             //       itemCount: e.value.length,
//             //       itemBuilder: (_, index){
//             //         return GestureDetector(
//             //           onTap: e.value[index].url == null ? null : e.value[index].url == 'item' ? () => showPdf(e.value[index].url!) : () => showVideo(e.value[index]),
//             //           child: Row(
//             //             mainAxisSize: MainAxisSize.min,
//             //             children: [
//             //               e.value[index].type == 'yoga'
//             //                   ? GestureDetector(
//             //                 onTap: () {},
//             //                 child: Image(
//             //                   image: const AssetImage(
//             //                       "assets/images/noun-play-1832840.png"),
//             //                   height: 2.h,
//             //                 ),
//             //               )
//             //                   : const SizedBox(),
//             //               if(e.value[index].type == 'yoga') SizedBox(width: 2.w),
//             //               Expanded(
//             //                 child: Text(
//             //                   "${e.value.map((value) => value.name)}",
//             //                   // " ${e.name.toString()}",
//             //                   maxLines: 3,
//             //                   textAlign: TextAlign.start,
//             //                   overflow: TextOverflow.ellipsis,
//             //                   style: TextStyle(
//             //                     height: 1.5,
//             //                     color: gTextColor,
//             //                     fontSize: 8.sp,
//             //                     fontFamily: "GothamBook",
//             //                   ),
//             //                 ),
//             //               ),
//             //             ],
//             //           ),
//             //         );
//             //       }
//             //   ),
//             //   placeholder: true,
//             // ),
//             // DataCell(
//             //     Theme(
//             //       data: Theme.of(context).copyWith(
//             //         highlightColor: Colors.transparent,
//             //         splashColor: Colors.transparent,
//             //       ),
//             //       child: oldPopup(e.value[0]),
//             //     )
//             //   // (widget.isCompleted == null) ?
//             //   //   ListView.builder(
//             //   //     shrinkWrap: true,
//             //   //       itemBuilder: (_, index){
//             //   //         return ;
//             //   //       }
//             //   //   )
//             //   // : Text(e.status ?? '',
//             //   //     textAlign: TextAlign.start,
//             //   //     style: TextStyle(
//             //   //       fontFamily: "GothamBook",
//             //   //       color: gTextColor,
//             //   //       fontSize: 8.sp,
//             //   //     ),
//             //   //   ),
//             // ),
//           ]
//       );
//     });
//     return shoppingData!.map((e) => DataRow(
//       cells: [
//         DataCell(
//           Text(
//             e.mealTime.toString(),
//             style: TextStyle(
//               height: 1.5,
//               color: gTextColor,
//               fontSize: 8.sp,
//               fontFamily: "GothamBold",
//             ),
//           ),
//         ),
//         DataCell(
//           GestureDetector(
//             onTap: e.url == null ? null : e.type == 'item' ? () => showPdf(e.url!) : () => showVideo(e),
//             child: Row(
//               children: [
//                 e.type == 'yoga'
//                     ? GestureDetector(
//                   onTap: () {},
//                   child: Image(
//                     image: const AssetImage(
//                         "assets/images/noun-play-1832840.png"),
//                     height: 2.h,
//                   ),
//                 )
//                     : const SizedBox(),
//                 if(e.type == 'yoga') SizedBox(width: 2.w),
//                 Expanded(
//                   child: Text(
//                     " ${e.name.toString()}",
//                     maxLines: 3,
//                     textAlign: TextAlign.start,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       height: 1.5,
//                       color: gTextColor,
//                       fontSize: 8.sp,
//                       fontFamily: "GothamBook",
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           placeholder: true,
//         ),
//         DataCell(
//           // (widget.isCompleted == null) ?
//             Theme(
//               data: Theme.of(context).copyWith(
//                 highlightColor: Colors.transparent,
//                 splashColor: Colors.transparent,
//               ),
//               child: oldPopup(e),
//             )
//           // : Text(e.status ?? '',
//           //     textAlign: TextAlign.start,
//           //     style: TextStyle(
//           //       fontFamily: "GothamBook",
//           //       color: gTextColor,
//           //       fontSize: 8.sp,
//           //     ),
//           //   ),
//         ),
//       ],
//     )).toList();
//   }
//
//   List<DataRow> dataRowWidget(){
//     List<DataRow> _data = [];
//     mealPlanData1.forEach((dayTime, value) {
//       _data.add(DataRow(cells: [
//         DataCell(
//           Text(
//             dayTime,
//             style: TextStyle(
//               height: 1.5,
//               color: gTextColor,
//               fontSize: 8.sp,
//               fontFamily: kFontMedium,
//             ),
//           ),
//         ),
//         DataCell(
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               ...value.map((e) => GestureDetector(
//                 onTap: e.url == null ? null : e.type == 'item' ? () => showPdf(e.url!) : () => showVideo(e),
//                 child: Row(
//                   children: [
//                     e.type == 'yoga'
//                         ? GestureDetector(
//                       onTap: () {},
//                       child: Image(
//                         image: const AssetImage(
//                             "assets/images/noun-play-1832840.png"),
//                         height: 2.h,
//                       ),
//                     )
//                         : const SizedBox(),
//                     if(e.type == 'yoga') SizedBox(width: 2.w),
//                     Expanded(
//                       child: Text(
//                         " ${e.name.toString()}",
//                         maxLines: 3,
//                         textAlign: TextAlign.start,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           height: 1.5,
//                           color: gTextColor,
//                           fontSize: 8.sp,
//                           fontFamily: kFontMedium,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )).toList()
//             ],
//           ),
//           placeholder: true,
//         ),
//         DataCell(
//           // (widget.isCompleted == null) ?
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               // shrinkWrap: true,
//               children: [
//                 ...value.map((e) {
//                   return Theme(
//                     data: Theme.of(context).copyWith(
//                       highlightColor: Colors.transparent,
//                       splashColor: Colors.transparent,
//                     ),
//                     child: oldPopup(e),
//                   );
//                 }).toList()
//               ],
//             )
//           // : Text(e.status ?? '',
//           //     textAlign: TextAlign.start,
//           //     style: TextStyle(
//           //       fontFamily: "GothamBook",
//           //       color: gTextColor,
//           //       fontSize: 8.sp,
//           //     ),
//           //   ),
//         ),
//       ]));
//     });
//     return _data;
//   }
//
//   showDataRow1(){
//     return shoppingData!.map((e) => DataRow(
//       cells: [
//         DataCell(
//           Text(
//             e.mealTime.toString(),
//             style: TextStyle(
//               height: 1.5,
//               color: gTextColor,
//               fontSize: 8.sp,
//               fontFamily: "GothamBold",
//             ),
//           ),
//         ),
//         DataCell(
//           GestureDetector(
//             onTap: e.url == null ? null : e.type == 'item' ? () => showPdf(e.url!) : () => showVideo(e),
//             child: Row(
//               children: [
//                 e.type == 'yoga'
//                     ? GestureDetector(
//                   onTap: () {},
//                   child: Image(
//                     image: const AssetImage(
//                         "assets/images/noun-play-1832840.png"),
//                     height: 2.h,
//                   ),
//                 )
//                     : const SizedBox(),
//                 if(e.type == 'yoga') SizedBox(width: 2.w),
//                 Expanded(
//                   child: Text(
//                     " ${e.name.toString()}",
//                     maxLines: 3,
//                     textAlign: TextAlign.start,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       height: 1.5,
//                       color: gTextColor,
//                       fontSize: 8.sp,
//                       fontFamily: "GothamBook",
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           placeholder: true,
//         ),
//         DataCell(
//           // (widget.isCompleted == null) ?
//           Theme(
//             data: Theme.of(context).copyWith(
//               highlightColor: Colors.transparent,
//               splashColor: Colors.transparent,
//             ),
//             child: oldPopup(e),
//           )
//         // : Text(e.status ?? '',
//         //     textAlign: TextAlign.start,
//         //     style: TextStyle(
//         //       fontFamily: "GothamBook",
//         //       color: gTextColor,
//         //       fontSize: 8.sp,
//         //     ),
//         //   ),
//         ),
//       ],
//     )).toList();
//   }
//
//   Map statusList = {};
//
//   List lst = [];
//
//   showDummyDataRow(){
//     return mealPlanData
//         .map(
//           (s) => DataRow(
//         cells: [
//           DataCell(
//             Text(
//               s["time"].toString(),
//               style: TextStyle(
//                 height: 1.5,
//                 color: gTextColor,
//                 fontSize: 8.sp,
//                 fontFamily: "GothamBold",
//               ),
//             ),
//           ),
//           DataCell(
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 s["id"] == 1
//                     ? GestureDetector(
//                   onTap: () {},
//                   child: Image(
//                     image: const AssetImage(
//                         "assets/images/noun-play-1832840.png"),
//                     height: 2.h,
//                   ),
//                 )
//                     : const SizedBox(),
//                 SizedBox(width: 2.w),
//                 Expanded(
//                   child: Text(
//                     " ${s["title"].toString()}",
//                     maxLines: 3,
//                     textAlign: TextAlign.start,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       height: 1.5,
//                       color: gTextColor,
//                       fontSize: 8.sp,
//                       fontFamily: "GothamBook",
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             placeholder: true,
//           ),
//           DataCell(
//             PopupMenuButton(
//               offset: const Offset(0, 30),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5)),
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 0.6.h),
//                       buildDummyTabView(
//                           index: 1,
//                           title: list[0],
//                           color: gPrimaryColor),
//                       Container(
//                         margin: EdgeInsets.symmetric(vertical: 1.h),
//                         height: 1,
//                         color: gGreyColor.withOpacity(0.3),
//                       ),
//                       buildDummyTabView(
//                           index: 2,
//                           title: list[1],
//                           color: gsecondaryColor),
//                       Container(
//                         margin: EdgeInsets.symmetric(vertical: 1.h),
//                         height: 1,
//                         color: gGreyColor.withOpacity(0.3),
//                       ),
//                       SizedBox(height: 0.6.h),
//                     ],
//                   ),
//                 ),
//               ],
//               child: Container(
//                 width: 20.w,
//                 padding: EdgeInsets.symmetric(
//                     horizontal: 2.w, vertical: 0.2.h),
//                 decoration: BoxDecoration(
//                   color: gWhiteColor,
//                   borderRadius: BorderRadius.circular(5),
//                   border: Border.all(color: gMainColor, width: 1),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         buildDummyHeaderText(),
//                         textAlign: TextAlign.start,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             fontFamily: "GothamBook",
//                             color: buildDummyTextColor(),
//                             fontSize: 8.sp),
//                       ),
//                     ),
//                     Icon(
//                       Icons.expand_more,
//                       color: gGreyColor,
//                       size: 2.h,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     )
//         .toList();
//   }
//
//   void onChangedTab(int index,{int? id, String? title}) {
//     print('$id  $title');
//     setState(() {
//       if(id != null && title != null){
//         if(statusList.isNotEmpty && statusList.containsKey(id)){
//           print("contains");
//           statusList.update(id, (value) => title);
//         }
//         else if(statusList.isEmpty || !statusList.containsKey(id)){
//           print('new');
//           statusList.putIfAbsent(id, () => title);
//         }
//       }
//       print(statusList);
//       print(statusList[id].runtimeType);
//     });
//   }
//
//   getStatusText(int id){
//     print("id: ${id}");
//     print('statusList[id]${statusList[id]}');
//     return statusList[id];
//   }
//
//   getTextColor(int id){
//     setState(() {
//       if(statusList.isEmpty){
//         textColor = gWhiteColor;
//       }
//       else if (statusList[id] == list[0]) {
//         textColor = gPrimaryColor;
//       } else if (statusList[id] == list[1]) {
//         textColor = gsecondaryColor;
//       }
//     });
//     return textColor;
//   }
//
//
//   void onChangedDummyTab(int index) {
//     setState(() {
//       planStatus = index;
//     });
//   }
//
//
//   Widget buildTabView({
//     required int index,
//     required String title,
//     required Color color,
//     int? itemId
//   }) {
//     return GestureDetector(
//       onTap: () {
//         onChangedTab(index, id: itemId, title: title);
//         Get.back();
//       },
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
//         child: Text(
//           title,
//           style: TextStyle(
//             fontFamily: "GothamBook",
//             // color: (planStatus == index) ? color : gTextColor,
//             color: (statusList[itemId] == title) ? color : gTextColor,
//             fontSize: 9.5.sp,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildDummyTabView({
//     required int index,
//     required String title,
//     required Color color,
//     int? itemId
//   }) {
//     return GestureDetector(
//       onTap: () {
//         onChangedDummyTab(index);
//         Get.back();
//       },
//       child: Text(
//         title,
//         style: TextStyle(
//           fontFamily: "GothamBook",
//           color: (planStatus == index) ? color : gTextColor,
//           fontSize: 8.sp,
//         ),
//       ),
//     );
//   }
//
//
//   String buildDummyHeaderText() {
//     if (planStatus == 0) {
//       headerText = "     ";
//     } else if (planStatus == 1) {
//       headerText = "Followed";
//     } else if (planStatus == 2) {
//       headerText = "UnFollowed";
//     }
//     return headerText;
//   }
//
//   Color? buildDummyTextColor() {
//     if (planStatus == 0) {
//       textColor = gWhiteColor;
//     } else if (planStatus == 1) {
//       textColor = gPrimaryColor;
//     } else if (planStatus == 2) {
//       textColor = gsecondaryColor;
//     } else if (planStatus == 3) {
//       textColor = gMainColor;
//     } else if (planStatus == 4) {
//       textColor = gMainColor;
//     }
//     return textColor!;
//   }
//
//
//   final ProgramRepository repository = ProgramRepository(
//     apiClient: ApiClient(
//       httpClient: http.Client(),
//     ),
//   );
//
//   bool isSent = false;
//
//
//   void sendData() async{
//     setState(() {
//       isSent = true;
//     });
//     ProceedProgramDayModel? model;
//     List<PatientMealTracking> tracking = [];
//
//     statusList.forEach((key, value) {
//       print('$key---$value');
//       tracking.add(PatientMealTracking(
//           day: int.parse(widget.day),
//         userMealItemId: key,
//         status: (value == list[0]) ? sendList[0] : sendList[1]
//       ));
//     });
//
//     print(tracking);
//     model = ProceedProgramDayModel(patientMealTracking: tracking,
//         comment: commentController.text.isEmpty ? null : commentController.text,
//       day: widget.day,
//     );
//     List dummy = [];
//     model.patientMealTracking!.forEach((element) {
//       dummy.add(jsonEncode(element.toJson()));
//     });
//     print('dummy: $dummy');
//
//     showSymptomsTrackerSheet(context, model);
//     // Navigator.push(context, MaterialPageRoute(builder: (_) => DayMealTracerUI(proceedProgramDayModel: model!)));
//     // print('ProceedProgramDayModel: ${jsonEncode(model.toJson())}');
//
//     // final result = await ProgramService(repository: repository).proceedDayMealDetailsService(model);
//     //
//     // print("result: $result");
//     // setState(() {
//     //   isSent = false;
//     // });
//     //
//     // if(result.runtimeType == GetProceedModel){
//     //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DaysProgramPlan()), (route) => route.isFirst);
//     // }
//     // else{
//     //   var model = result as ErrorModel;
//     //   AppConfig().showSnackbar(context, model.message ?? '', isError: true);
//     // }
//
//   }
//
//
//   showPdf(String itemUrl) {
//     print(itemUrl);
//     String? url;
//     if(itemUrl.contains('drive.google.com')){
//       url = itemUrl;
//       // url = 'https://drive.google.com/uc?export=view&id=1LV33e5XOl0YM8r6AqhU6B4oZniWwXcTZ';
//       // String baseUrl = 'https://drive.google.com/uc?export=view&id=';
//       // print(itemUrl.split('/')[5]);
//       // url = baseUrl + itemUrl.split('/')[5];
//     }
//     else{
//       url = itemUrl;
//     }
//     print(url);
//     Navigator.push(context, MaterialPageRoute(builder: (ctx)=> MealPdf(pdfLink: url! ,)));
//   }
//
//   showVideo(ChildMealPlanDetailsModel e) {
//     setState(() {
//       isEnabled = !isEnabled;
//       videoName = e.name!;
//       mealTime = e.mealTime!;
//     });
//     initVideoView(e.url);
//     // Navigator.push(context, MaterialPageRoute(builder: (ctx)=> YogaVideoScreen(yogaDetails: e.toJson(),day: widget.day,)));
//   }
//
//   oldPopup(ChildMealPlanDetailsModel e){
//     return IgnorePointer(
//       ignoring: widget.isCompleted == true,
//       child: Container(
//         margin: EdgeInsets.only(bottom: 4),
//         child: PopupMenuButton(
//           offset: const Offset(0, 30),
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5)),
//           itemBuilder: (context) => [
//             PopupMenuItem(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 0.6.h),
//                   buildTabView(
//                       index: 1,
//                       title: list[0],
//                       color: gPrimaryColor,
//                       itemId: e.itemId!
//                   ),
//                   SizedBox(height: 0.6.h),
//                   Container(
//                     margin: EdgeInsets.symmetric(vertical: 1.h),
//                     height: 1,
//                     color: gGreyColor.withOpacity(0.3),
//                   ),
//                   SizedBox(height: 0.6.h),
//                   buildTabView(
//                       index: 2,
//                       title: list[1],
//                       color: gsecondaryColor,
//                       itemId: e.itemId!
//                   ),
//                   SizedBox(height: 0.6.h),
//                 ],
//               ),
//               onTap: null,
//             ),
//           ],
//           child: Container(
//             width: 20.w,
//             padding: EdgeInsets.symmetric(
//                 horizontal: 2.w, vertical: 0.2.h),
//             decoration: BoxDecoration(
//               color: gWhiteColor,
//               borderRadius: BorderRadius.circular(5),
//               border: Border.all(color: gMainColor, width: 1),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     statusList.isEmpty ? '' : getStatusText(e.itemId!) ?? '',
//                     textAlign: TextAlign.start,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                         fontFamily: "GothamBook",
//                         color: statusList.isEmpty ? textColor : getTextColor(e.itemId!) ?? textColor,
//                         fontSize: 8.sp),
//                   ),
//                 ),
//                 Icon(
//                   Icons.expand_more,
//                   color: gGreyColor,
//                   size: 2.h,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   showDropdown(ChildMealPlanDetailsModel e){
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         // mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Expanded(
//             child: CustomDropdownButton2(
//               // buttonHeight: 25,
//               buttonWidth: 20.w,
//               hint: '',
//               dropdownItems: list,
//               value: statusList.isEmpty ? null : statusList[e.itemId],
//               onChanged: (value) {
//                 setState(() {
//                   statusList[e.itemId] = value ?? -1;
//                 });
//               },
//               buttonDecoration : BoxDecoration(
//                 color: gWhiteColor,
//                 borderRadius: BorderRadius.circular(5),
//                 border: Border.all(color: gMainColor, width: 1),
//               ),
//               icon: Icon(Icons.keyboard_arrow_down_outlined),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   bool buttonVisibility() {
//     bool isVisible;
//     print('${widget.nextDay}  ${widget.day} ${widget.isCompleted}');
//     if(widget.isCompleted == true){
//       isVisible =  false;
//     }
//     else if(widget.nextDay == widget.day){
//       isVisible = false;
//     }
//     else{
//       isVisible = true;
//     }
//     print("isVisible: $isVisible");
//     return isVisible;
//     // widget.isCompleted == null || (widget.nextDay == widget.day)
//   }
//
//   getRowHeight() {
//     if(mealPlanData1.values.length > 1){
//       return 8.h;
//     }
//     else{
//       return 6.h;
//     }
//   }
//
//   showSymptomsTrackerSheet(BuildContext context, ProceedProgramDayModel model) {
//     return showModalBottomSheet(
//       isDismissible: false,
//       isScrollControlled: true,
//         backgroundColor: Colors.transparent,
//         context: context,
//         enableDrag: false,
//         builder: (ctx) {
//           return Wrap(
//             children: [
//               TrackerUI(proceedProgramDayModel: model,)
//             ],
//           );
//         });
//   }
//
// }
//
// class MealPlanData {
//   MealPlanData(this.time, this.title, this.id);
//
//   String time;
//   String title;
//   int id;
// }
//
//
