import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gwc_customer/model/ship_track_model/shopping_model/get_shopping_model.dart';
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
import '../../widgets/constants.dart';

class CookKitTracking extends StatefulWidget {
  const CookKitTracking({Key? key}) : super(key: key);

  @override
  State<CookKitTracking> createState() => _CookKitTrackingState();
}

class _CookKitTrackingState extends State<CookKitTracking> {
  double gap = 23.0;
  int activeStep = -1;

  Timer? timer;
  int upperBound = -1;

  List<ShipmentTrackActivities> trackerList = [];
  String estimatedDate = '';
  String estimatedDay = '';

  int tabSize = 2;

  List<ChildGetShoppingModel>? shoppingData = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shippingTracker();
    getShoppingList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabSize,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 1.h, left: 4.w, right: 4.w, bottom: 1.w),
          child: Column(
            children: [
              buildAppBar((){
                Navigator.pop(context);
              }),
              Expanded(child: tabView())
            ],
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
                Tab(text: 'Track Shipping',),
                Tab(text: 'Shopping',),
              ],
            ),
          ),
          Flexible(
              child: TabBarView(
                children:  [
                  shipRocketUI(context),
                  dataTableView(),
                ],
              )
          )
        ],
      ),
    );
  }

  shipRocketUI(BuildContext context){
    return SingleChildScrollView(
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
                  fontFamily: "GothamRoundedBold_21016",
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
                  "477/3 Lorem lpsum Diansms,94107,Bangalore",
                  style: TextStyle(
                    height: 1.5,
                    fontFamily: "GothamBook",
                    fontSize: 11.sp,
                    color: gTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  dataTableView(){
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            // width: 85.w,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: gWhiteColor,
              // border: Border.all(color: gsecondaryColor.withOpacity(0.3), width: 1),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child: Stack(
              children: [
                Container(
                  height: 5.h,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)
                    ),
                    gradient: LinearGradient(colors: [
                      Color(0xffE06666),
                      Color(0xff93C47D),
                      Color(0xffFFD966),
                    ], begin: Alignment.topLeft, end: Alignment.topRight),
                  ),
                ),
                Center(
                  child: DataTable(
                      headingTextStyle: TextStyle(
                        color: gWhiteColor,
                        fontSize: 5.sp,
                        fontFamily: "GothamMedium",
                      ),
                      headingRowHeight: 5.h,
                      horizontalMargin: 2.w,
                      columnSpacing: 40.w,
                      dataRowHeight: 6.h,
                      // headingRowColor: MaterialStateProperty.all(const Color(0xffE06666)),
                      columns:  <DataColumn>[
                        DataColumn(
                          label: Text('Meal Name',
                            style: TextStyle(
                              height: 1.5,
                              color: gWhiteColor,
                              fontSize: 11.sp,
                              fontFamily: "GothamBold",
                            ),
                          ),
                        ),
                        DataColumn(
                          label: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 80,
                              minWidth: 20,
                            ),
                            child: Text('Weight',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                height: 1.5,
                                color: gWhiteColor,
                                fontSize: 11.sp,
                                fontFamily: "GothamBold",
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: showDataRow()
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }


  showDataRow(){
    return shoppingData!.map(
            (s) => DataRow(
              cells: [
                DataCell(
                  Text(
                    s.mealItem!.name.toString(),
                    style: TextStyle(
                      height: 1.5,
                      color: gTextColor,
                      fontSize: 8.sp,
                      fontFamily: "GothamBold",
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    " ${s.itemWeight}" ?? '',
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
                  placeholder: true,
                ),
              ],
            ),
    ).toList();
  }
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

  void shippingTracker() async {
    final result = await ShipTrackService(repository: repository).getUserProfileService(awb1);
    //print("shippingTracker: $result");
    //print(result.runtimeType);
    ShippingTrackModel data = result;
    data.trackingData!.shipmentTrackActivities!.forEach((element) {
      trackerList.add(element);
      if(element.srStatusLabel!.toLowerCase() == 'delivered'){
        setState(() {
          isDelivered = true;
        });
      }
    });
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

  void getShoppingList() async {
    final result = await ShipTrackService(repository: repository).getShoppingDetailsListService();
    print("getShoppingList: $result");
    print(result.runtimeType);
    if(result.runtimeType == GetShoppingListModel){
      print("meal plan");
      GetShoppingListModel model = result as GetShoppingListModel;

      shoppingData = model.data!.map((e) => e).toList();
      print('shopping list: $shoppingData');
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