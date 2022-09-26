import 'dart:async';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shippingTracker();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: gMainColor,
                          ),
                        ),
                        Text(
                          "Ready to cook Kit Shipping",
                          style: TextStyle(
                            fontFamily: "GothamRoundedBold_21016",
                            fontSize: 12.sp,
                            color: gPrimaryColor,
                          ),
                        ),
                      ],
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
            Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: Column(
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
            ),
          ],
        ),
      ),
    );
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

  void shippingTracker() async {
    final result = await ShipTrackService(repository: repository).getUserProfileService(awb1);
    print("shippingTracker: $result");
    print(result.runtimeType);
    ShippingTrackModel data = result;
    data.trackingData!.shipmentTrackActivities!.forEach((element) {
      trackerList.add(element);
    });
    estimatedDate = data.trackingData!.etd!;
    estimatedDay = DateFormat('EEEE').format(DateTime.parse(estimatedDate));
    print("estimatedDay: $estimatedDay");
    setState(() {
      upperBound = trackerList.length;
      activeStep = 0;
    });


    timer = Timer.periodic(const Duration(milliseconds: 500), (timer1) {
      print(timer1.tick);
      print('activeStep: $activeStep');
      print('upperBound:$upperBound');
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

  getStepper(){
    List<StepperData> stepper = [];
    trackerList.map((e) {
      String txt = 'Location: ${e.location}';
      print("txt.length${txt.length}");
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

  getIcons(){
    print("activeStep==> $activeStep  trackerList.length => ${trackerList.length}");
    List<Widget> widgets = [];
    for(var i = 0; i < trackerList.length; i++){
      print('-i----$i');
      print(trackerList[i].srStatus != '7');
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
