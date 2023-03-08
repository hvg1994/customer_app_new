import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/ship_track_model/shopping_model/get_shopping_model.dart';
import 'package:gwc_customer/screens/gut_list_screens/gut_list.dart';
import 'package:gwc_customer/screens/gut_list_screens/new_dashboard_stages.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../model/ship_track_model/ship_track_activity_model.dart';
import '../../../model/ship_track_model/shipping_track_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/shipping_repository/ship_track_repo.dart';
import '../../../services/shipping_service/ship_track_service.dart';
import '../../../widgets/stepper/another_stepper.dart';
import '../../../widgets/stepper/stepper_data.dart';
import '../../../widgets/widgets.dart';
import '../../model/ship_track_model/shopping_model/child_get_shopping_model.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import 'package:gwc_customer/screens/gut_list_screens/gut_list.dart' as gut;

import '../prepratory plan/prepratory_plan_screen.dart';

class CookKitTracking extends StatefulWidget {
  final String currentStage;
  final String? awb_number;
  final int initialIndex;
  const CookKitTracking({Key? key, this.awb_number, required this.currentStage, this.initialIndex = 0}) : super(key: key);

  @override
  State<CookKitTracking> createState() => _CookKitTrackingState();
}

class _CookKitTrackingState extends State<CookKitTracking>{
  double gap = 23.0;
  int activeStep = -1;

  final tableHeadingBg = gHintTextColor.withOpacity(0.4);

  Timer? timer;
  int upperBound = -1;

  List<ShipmentTrackActivities> trackerList = [];
  String estimatedDate = '';
  String estimatedDay = '';
  String shipAddress = '';

  int tabSize = 2;

  bool showShoppingLoading = false;

  final _pref = AppConfig().preferences;
  // /// oldresponse variable
  // Map<String, List<ChildGetShoppingModel>> shoppingData = {};
  //
  // Map<String, List<ChildGetShoppingModel>> sortedData = {};


  List dayList = [];
  List<ChildGetShoppingModel> shoppingList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.currentStage.isNotEmpty){
      getShoppingList();
      if((widget.currentStage == 'shipping_approved' || widget.currentStage == 'shipping_delivered' || widget.currentStage == 'shipping_packed') && widget.awb_number != null){
        shippingTracker();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.initialIndex,
      length: tabSize,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(top: 1.h, left: 4.w, right: 4.w, bottom: 1.w),
            child: Column(
              children: [
                buildAppBar((){
                  Navigator.pop(context);
                },
                    showHelpIcon: true,
                    helpOnTap: (){
                      // if(planNotePdfLink != null || planNotePdfLink!.isNotEmpty){
                      //   Navigator.push(context, MaterialPageRoute(builder: (ctx)=>
                      //       MealPdf(pdfLink: planNotePdfLink! ,
                      //         heading: "Note",
                      //       )));
                      // }
                      // else{
                      //   AppConfig().showSnackbar(context, "Note Link Not available", isError: true);
                      // }
                    }
                ),
                Expanded(child: tabView())
              ],
            ),
          ),
        ),
      ),
    );
  }

  tabView(){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Container(
            height: 35,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15.0)
            ),
            child:  TabBar(
              indicator: BoxDecoration(
                  color: gPrimaryColor,
                  borderRadius:  BorderRadius.circular(15.0)
              ) ,
              labelColor: gMainColor,
              unselectedLabelColor: gPrimaryColor,
              tabs: const  [
                Tab(text: 'Shipping',),
                Tab(text: 'Shopping',),
              ],
            ),
          ),
          Flexible(
              child: TabBarView(
                children:  [
                  (showTrackingProgress) ? buildCircularIndicator() : shipRocketUI(context),
                  (showShoppingLoading) ? buildCircularIndicator() : shoppingUi(),
                ],
              )
          )
        ],
      ),
    );
  }

  shoppingUi(){
    if(shoppingList.isNotEmpty){
      return tableView();
    }
    else{
      return noData();
    }
  }

  tableView(){
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: DataTable(
            headingTextStyle: TextStyle(
              color: gWhiteColor,
              fontSize: 5.sp,
              fontFamily: kFontMedium,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              // color: tableHeadingBg,
            ),
            headingRowHeight: 5.h,
            headingRowColor: MaterialStateProperty.all(tableHeadingBg),
            horizontalMargin: 2.w,
            columnSpacing: 20.w,
            dataRowHeight: 7.h,
            // headingRowColor: MaterialStateProperty.all(const Color(0xffE06666)),
            columns:  <DataColumn>[
              DataColumn(
                label: IntrinsicWidth(
                  child: Text('Item Name',
                    style: TextStyle(
                      height: 1.5,
                      color: eUser().userFieldLabelColor,
                      fontSize: 11.sp,
                      fontFamily: kFontBold,
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 80,
                    minWidth: 20,
                  ),
                  child: Text('Category',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      height: 1.5,
                      color: eUser().userFieldLabelColor,
                      fontSize: 11.sp,
                      fontFamily: kFontBold,
                    ),
                  ),
                ),
              ),
            ],
            rows: [
              ...shoppingList.map((e) => DataRow(
                cells: [
                  DataCell(
                      IntrinsicWidth(
                        child: Text(
                          e.ingredients?.name ?? '',
                          // sortedData.entries.elementAt(index).value[ind].mealItemWeight?.mealItem?.name?.trimLeft() ?? '',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            height: 1.5,
                            color: gTextColor,
                            fontSize: 8.sp,
                            fontFamily: kFontBold,
                          ),
                        ),
                      )
                  ),
                  DataCell(
                    IntrinsicWidth(
                      child: Text(
                        e.ingredients?.childIngredientCategory?.name ?? '',
                        // sortedData.entries.elementAt(index).value[ind].itemWeight?.trim() ?? '',
                        // " ${value[ind].itemWeight}" ?? '',
                        // maxLines: 3,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 1.5,
                          color: gTextColor,
                          fontSize: 8.sp,
                          fontFamily: kFontBook,
                        ),
                      ),
                    ),
                    placeholder: true,
                  ),
                ],
              )).toList()
            ]
        ),
      ),
    );
  }

  // tableWithDayWiseOldView(){
  //   print("len: ${sortedData.entries.length}");
  //   return ListView.builder(
  //     itemCount: sortedData.entries.length,
  //       itemBuilder: (_, index){
  //         // print(shoppingData.entries);
  //         // print(shoppingData.entries.first.key);
  //         // print(index);
  //         // print(shoppingData.entries.elementAt(index).key);
  //         return  Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 8),
  //       child: Container(
  //         // width: 85.w,
  //         margin: EdgeInsets.symmetric(horizontal: 2.w),
  //         decoration: BoxDecoration(
  //           color: gWhiteColor,
  //           // border: Border.all(color: gsecondaryColor.withOpacity(0.3), width: 1),
  //           borderRadius: BorderRadius.circular(8),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(0.4),
  //               blurRadius: 2.0,
  //               spreadRadius: 0.0,
  //               offset: const Offset(2.0, 2.0), // shadow direction: bottom right
  //             )
  //           ],
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
  //               child: Text('Day ${sortedData.entries.elementAt(index).key}',
  //                   style: TextStyle(
  //                     color: gPrimaryColor,
  //                     fontSize: 11.sp,
  //                     fontFamily: "GothamBold",
  //                   )
  //               ),
  //             ),
  //             ListView.builder(
  //                 physics: NeverScrollableScrollPhysics(),
  //                 shrinkWrap: true,
  //                 itemCount: sortedData.entries.elementAt(index).value.length,
  //                 itemBuilder: (_, ind){
  //                   print("meal name");
  //                   // print(sortedData.entries.elementAt(index).value[ind].mealItemWeight?.mealItem?.name);
  //
  //                   print('${sortedData.entries.elementAt(index).key} == ${sortedData.entries.first.key}');
  //                   return Stack(
  //                     children: [
  //                       Container(
  //                         height: (sortedData.entries.elementAt(index).key == sortedData.entries.first.key && ind ==0) ? 5.h : 0,
  //                         decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.only(
  //                                 topLeft: Radius.circular(8), topRight: Radius.circular(8)),
  //                             color: tableHeadingBg,
  //                           // gradient: (sortedData.keys.first == sortedData.entries.first.key || ind ==0) ? LinearGradient(colors: [
  //                           //   Color(0xffE06666),
  //                           //   Color(0xff93C47D),
  //                           //   Color(0xffFFD966),
  //                           // ], begin: Alignment.topLeft, end: Alignment.topRight) : null,
  //                         ),
  //                       ),
  //                       Center(
  //                         child: DataTable(
  //                             headingTextStyle: TextStyle(
  //                               color: gWhiteColor,
  //                               fontSize: 5.sp,
  //                               fontFamily: "GothamMedium",
  //                             ),
  //                             headingRowHeight: (sortedData.entries.elementAt(index).key == sortedData.entries.first.key && ind ==0) ? 5.h : 0,
  //                             horizontalMargin: 2.w,
  //                             columnSpacing: 40.w,
  //                             dataRowHeight: 7.h,
  //                             // headingRowColor: MaterialStateProperty.all(const Color(0xffE06666)),
  //                             columns:  <DataColumn>[
  //                               DataColumn(
  //                                 label: Text('Meal Name',
  //                                   style: TextStyle(
  //                                     height: 1.5,
  //                                     color: eUser().userFieldLabelColor,
  //                                     fontSize: 11.sp,
  //                                     fontFamily: kFontBold,
  //                                   ),
  //                                 ),
  //                               ),
  //                               DataColumn(
  //                                 label: ConstrainedBox(
  //                                   constraints: const BoxConstraints(
  //                                     maxWidth: 80,
  //                                     minWidth: 20,
  //                                   ),
  //                                   child: Text('Quantity',
  //                                     textAlign: TextAlign.right,
  //                                     style: TextStyle(
  //                                       height: 1.5,
  //                                       color: eUser().userFieldLabelColor,
  //                                       fontSize: 11.sp,
  //                                       fontFamily: kFontBold,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                             rows: [
  //                               DataRow(
  //                                 cells: [
  //                                   DataCell(
  //                                       Text(
  //                                         sortedData.entries.elementAt(index).value[ind].mealItemWeight?.mealItem?.name?.trimLeft() ?? '',
  //                                         // sortedData.entries.elementAt(index).value[ind].mealItemWeight?.mealItem?.name?.trimLeft() ?? '',
  //                                         textAlign: TextAlign.left,
  //                                         style: TextStyle(
  //                                           height: 1.5,
  //                                           color: gTextColor,
  //                                           fontSize: 8.sp,
  //                                           fontFamily: "GothamBold",
  //                                         ),
  //                                       )
  //                                   ),
  //                                   DataCell(
  //                                     Text(
  //                                       sortedData.entries.elementAt(index).value[ind].itemWeight?.trim() ?? '',
  //                                       // " ${value[ind].itemWeight}" ?? '',
  //                                       // maxLines: 3,
  //                                       textAlign: TextAlign.start,
  //                                       overflow: TextOverflow.ellipsis,
  //                                       style: TextStyle(
  //                                         height: 1.5,
  //                                         color: gTextColor,
  //                                         fontSize: 8.sp,
  //                                         fontFamily: "GothamBook",
  //                                       ),
  //                                     ),
  //                                     placeholder: true,
  //                                   ),
  //                                 ],
  //                               )
  //                             ]
  //                         ),
  //                       ),
  //                     ],
  //                   );
  //                 }
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

  shipRocketUI(BuildContext context){
    if((widget.currentStage == "shipping_approved" || widget.currentStage == "shipping_delivered" || widget.currentStage == "shipping_packed") && widget.awb_number != null){
      return (!showErrorText)
          ? SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              height: 45.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/Group 2541.png",
                    ),
                    fit: BoxFit.fill
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 3.h, left: 1.5.w),
                    child: Text(
                      "Ready to cook Kit Shipping",
                      style: TextStyle(
                        fontFamily: "GothamRoundedBold_21016",
                        fontSize: 12.sp,
                        color: gPrimaryColor,
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: 25.h,
                      child: const Image(
                        image: AssetImage("assets/images/G.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              // shrinkWrap: true,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                estimatedDateView(),
                Visibility(
                  visible: trackerList.isNotEmpty,
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: AnotherStepper(
                          stepperList: getStepper(),
                          gap:gap,
                          isInitialText: true,
                          initialText: getStepperInitialValue(),
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          stepperDirection: Axis.vertical,
                          horizontalStepperHeight: 5,
                          dotWidget: getIcons(),
                          activeBarColor: gPrimaryColor,
                          inActiveBarColor: Colors.grey.shade200,
                          activeIndex: activeStep,
                          barThickness: 5,
                          titleTextStyle: TextStyle(fontSize: 10.sp,fontFamily: "GothamMedium",),
                          subtitleTextStyle: TextStyle(fontSize: 8.sp,),
                        ),
                      ),
                    ],
                  ),
                ),
                // trackingField(),
                SizedBox(height: 5.h),
                Text(
                  "Delivery Address",
                  style: TextStyle(
                    fontFamily: kFontBold,
                    fontSize: 12.sp,
                    color: gPrimaryColor,
                  ),
                ),
                SizedBox(height: 1.h),
                ListTile(
                  leading: Container(
                    height: 5.h,
                    width: 12.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: gPrimaryColor,
                    ),
                  ),
                  title: Text(
                    shipAddress,
                    // _pref?.getString(AppConfig.SHIPPING_ADDRESS) ??  "",
                    style: TextStyle(
                      height: 1.5,
                      fontFamily: kFontBook,
                      fontSize: 11.sp,
                      color: gTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          : Center(child: Text(
        errorTextResponse,
        style: TextStyle(
          height: 1.5,
          color: gTextColor,
          fontSize: 11.sp,
          fontFamily: "GothamBold",
        ),
      ),);
    }
    else{
      return const Center(
        child: Image(
          image: AssetImage("assets/images/no_data_found.png"),
          fit: BoxFit.scaleDown,
        ),
      );
    }
  }

  noData(){
    return const Center(
      child: Image(
        image: AssetImage("assets/images/no_data_found.png"),
        fit: BoxFit.scaleDown,
      ),
    );
  }

  // dataTableView(index){
  //     return ListView(
  //       shrinkWrap: true,
  //       physics: NeverScrollableScrollPhysics(),
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 8),
  //           child: Container(
  //             // width: 85.w,
  //             margin: EdgeInsets.symmetric(horizontal: 2.w),
  //             decoration: BoxDecoration(
  //               color: gWhiteColor,
  //               // border: Border.all(color: gsecondaryColor.withOpacity(0.3), width: 1),
  //               borderRadius: BorderRadius.circular(8),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.4),
  //                   blurRadius: 2.0,
  //                   spreadRadius: 0.0,
  //                   offset: const Offset(2.0, 2.0), // shadow direction: bottom right
  //                 )
  //               ],
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
  //                   child: Text('Day ${shoppingData}',
  //                     style: TextStyle(
  //                       color: gPrimaryColor,
  //                       fontSize: 11.sp,
  //                       fontFamily: "GothamBold",
  //                     )
  //                   ),
  //                 ),
  //                 Stack(
  //                   children: [
  //                     Container(
  //                       height: (index == 0) ? 5.h : 0,
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.only(
  //                             topLeft: Radius.circular(8),
  //                             topRight: Radius.circular(8)
  //                         ),
  //                         gradient: (index == 0) ? LinearGradient(colors: [
  //                           Color(0xffE06666),
  //                           Color(0xff93C47D),
  //                           Color(0xffFFD966),
  //                         ], begin: Alignment.topLeft, end: Alignment.topRight) : null,
  //                       ),
  //                     ),
  //                     Center(
  //                       child: DataTable(
  //                           headingTextStyle: TextStyle(
  //                             color: gWhiteColor,
  //                             fontSize: 5.sp,
  //                             fontFamily: "GothamMedium",
  //                           ),
  //                           headingRowHeight: (index == 0) ? 5.h : 0,
  //                           horizontalMargin: 2.w,
  //                           columnSpacing: 40.w,
  //                           dataRowHeight: 6.h,
  //                           // headingRowColor: MaterialStateProperty.all(const Color(0xffE06666)),
  //                           columns:  <DataColumn>[
  //                             DataColumn(
  //                               label: Text('Meal Name',
  //                                 style: TextStyle(
  //                                   height: 1.5,
  //                                   color: gWhiteColor,
  //                                   fontSize: 11.sp,
  //                                   fontFamily: "GothamBold",
  //                                 ),
  //                               ),
  //                             ),
  //                             DataColumn(
  //                               label: ConstrainedBox(
  //                                 constraints: const BoxConstraints(
  //                                   maxWidth: 80,
  //                                   minWidth: 20,
  //                                 ),
  //                                 child: Text('Quantity',
  //                                   textAlign: TextAlign.right,
  //                                   style: TextStyle(
  //                                     height: 1.5,
  //                                     color: gWhiteColor,
  //                                     fontSize: 11.sp,
  //                                     fontFamily: "GothamBold",
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                           rows: showDataRow()
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     );
  // }


  // showDataRow(){
  //   return shoppingData1!.map(
  //           (s) => DataRow(
  //             cells: [
  //               DataCell(
  //                 Text(
  //                   s.mealItem!.name.toString(),
  //                   style: TextStyle(
  //                     height: 1.5,
  //                     color: gTextColor,
  //                     fontSize: 8.sp,
  //                     fontFamily: "GothamBold",
  //                   ),
  //                 ),
  //               ),
  //               DataCell(
  //                 Text(
  //                   " ${s.itemWeight}" ?? '',
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
  //                 placeholder: true,
  //               ),
  //             ],
  //           ),
  //   );
  // }
  buildTrackingArea(String title, String image) {
    return ListTile(
      leading: Container(
        height: 4.h,
        width: 10.w,
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: gsecondaryColor.withOpacity(0.3), width: 1),
        ),
        child: Image(
          image: AssetImage(image),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "GothamMedium",
          fontSize: 11.sp,
          color: gTextColor,
        ),
      ),
    );
  }


  final ShipTrackRepository repository = ShipTrackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  String awb1 = '14326322712402';
  String awb2 = '14326322712380';
  String awb3 = '14326322704046';

  bool isDelivered = false;

  bool showErrorText = false;

  String errorTextResponse = '';

  bool showTrackingProgress = false;
  void shippingTracker() async {
    setState(() {
      showTrackingProgress = true;
    });
    final result = await ShipTrackService(repository: repository).getUserProfileService(widget.awb_number ?? '');
    print("shippingTracker: $result");
    //print(result.runtimeType);
    if(result.runtimeType == ShippingTrackModel){
      ShippingTrackModel data = result;
      if(data.trackingData!.error != null){
        setState(() {
          showErrorText = true;
          errorTextResponse = data.trackingData?.error ?? '';
        });
      }
      else{
        print(data.trackingData!.shipmentTrackActivities);
        data.trackingData!.shipmentTrackActivities!.forEach((element) {
          trackerList.add(element);
          if(element.srStatusLabel!.toLowerCase() == 'delivered'){
            setState(() {
              isDelivered = true;
            });
          }
        });
        shipAddress = data.trackingData?.shipmentTrack?.first.deliveredTo ?? '';
        estimatedDate = data.trackingData!.etd!;
        estimatedDay = DateFormat('EEEE').format(DateTime.parse(estimatedDate));
        //print("estimatedDay: $estimatedDay");
        setState(() {
          upperBound = trackerList.length;
          activeStep = 0;
        });


        timer = Timer.periodic(const Duration(milliseconds: 500), (timer1) {
          //print(timer1.tick);
          //print('activeStep: $activeStep');
          //print('upperBound:$upperBound');
          if (activeStep < upperBound) {
            setState(() {
              activeStep++;
            });
          }
          else{
            timer1.cancel();
          }
        });
      }
    }
    else{
      ErrorModel error = result as ErrorModel;

      if(error.message!.contains("Token has expired")){
        print("called shiprocket token from cook kit tracking");
        GutList().myAppState.getShipRocketToken();
      }
    }
    setState(() {
      showTrackingProgress = false;
    });
  }

  void getShoppingList() async {
    setState(() {
      showShoppingLoading = true;
    });
    final result = await ShipTrackService(repository: repository).getShoppingDetailsListService();
    print("getShoppingList: $result");
    print(result.runtimeType);
    if(result.runtimeType == GetShoppingListModel){
      print("meal plan");
      GetShoppingListModel model = result as GetShoppingListModel;

      shoppingList = model.ingredients ?? [];

      print('shopping list: $shoppingData');
      setState(() {
        showShoppingLoading = false;
      });
    }
  }

  getStepper(){
    List<StepperData> stepper = [];
    trackerList.map((e) {
      String txt = 'Location: ${e.location}';
      //print("txt.length${txt.length}");
      stepper.add(StepperData(
        // title: e.srStatusLabel!.contains('NA') ? 'Activity: ${e.activity}' : 'Activity: ${e.srStatusLabel}',
        title: 'Activity: ${e.srStatusLabel}',
        subtitle: 'Location: ${e.location}',
      ));
    }).toList();
    setState(() {
      gap = trackerList.any((element) => element.location!.length > 60) ? 33 : 23;
    });
    return stepper;
  }

  getStepperInitialValue(){
    List<StepperData> stepper = [];
    trackerList.map((e) {
      stepper.add(StepperData(
        title: '${DateFormat('dd MMM').format(DateTime.parse(e.date!))}',
        subtitle: '${DateFormat('hh:mm a').format(DateTime.parse(e.date!))}',
      ));
    }).toList();
    return stepper;
  }

  estimatedDateView() {
    if(!isDelivered){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
              text: 'Estimated Delivery Date: ',
              style: TextStyle(
                  fontFamily: "GothamRoundedBold_21016",
                  color: gPrimaryColor,
                  fontSize: 12.sp),
              children: [
                TextSpan(
                  text: estimatedDate ?? '',
                  style: TextStyle(
                      fontFamily: "GothamBook",
                      color: gPrimaryColor,
                      fontSize: 10.5.sp),
                )
              ]
          ),
        ),
      );
    }
    else{
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                  text: 'Delivered On: ',
                  style: TextStyle(
                      fontFamily: "GothamRoundedBold_21016",
                      color: gPrimaryColor,
                      fontSize: 12.sp),
                  children: [
                    TextSpan(
                      text: estimatedDay ?? '',
                      style: TextStyle(
                          fontFamily: "GothamMedium",
                          color: gMainColor,
                          fontSize: 10.5.sp),
                    )
                  ]
              ),
            ),
            Text(estimatedDate,
              style: TextStyle(
                  fontFamily: "GothamBook",
                  color: gPrimaryColor,
                  fontSize: 10.5.sp),
            )
          ],
        ),
      );
    }
  }

  getIcons(){
    // print("activeStep==> $activeStep  trackerList.length => ${trackerList.length}");
    List<Widget> widgets = [];
    for(var i = 0; i < trackerList.length; i++){
      // print('-i----$i');
      // print(trackerList[i].srStatus != '7');
      if(i == 0 && trackerList[i].srStatus != '7'){

        widgets.add(Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
                color: gPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Icon(Icons.radio_button_checked_sharp, color: Colors.white, size: 15.sp,)
          // (!trackerList.every((element) => element.srStatus!.contains('7')) && trackerList.length-1) ? Icon(Icons.radio_button_checked_sharp, color: Colors.white, size: 15.sp,) : Icon(Icons.check, color: Colors.white, size: 15.sp,),
        ));
      }
      else {
        widgets.add(Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
                color: gPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Icon(Icons.check, color: Colors.white, size: 15.sp,)
          // (!trackerList.every((element) => element.srStatus!.contains('7')) && trackerList.length-1) ? Icon(Icons.radio_button_checked_sharp, color: Colors.white, size: 15.sp,) : Icon(Icons.check, color: Colors.white, size: 15.sp,),
        ));
      }
    }
    return widgets;
  }
}


const shoppingData = [
  {
    "title": "Suryanamaskara",
    "weight": '50gm',
  },
  {
    "title": "Ginger Tea",
    "weight": '40gm',
  },
  {
    "title": "Idli/dhokla with chutney green gram porridge*",
    "weight": '10gm',

  },
  {
    "title": "Cucumber Juice",
    "weight": '50gm',
  },
];