// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:gwc_customer/screens/dashboard_screen.dart';
import 'package:gwc_customer/screens/evalution_form/personal_details_screen.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:sizer/sizer.dart';
import '../../model/consultation_model/appointment_booking/appointment_book_model.dart';
import '../../model/dashboard_model/get_appointment/child_appintment_details.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'consultation_screens/consultation_success.dart';
import 'doctor_calender_time_screen.dart';

class DoctorSlotsDetailsScreen extends StatefulWidget {
  final AppointmentBookingModel? data;
  final String bookingDate;
  final String bookingTime;
  final bool isFromDashboard;
  final Map? dashboardValueMap;
  const DoctorSlotsDetailsScreen({
    Key? key,
    this.data,
    required this.bookingDate,
    required this.bookingTime,
    this.isFromDashboard = false,
    this.dashboardValueMap
  }) : super(key: key);

  @override
  State<DoctorSlotsDetailsScreen> createState() => _DoctorSlotsDetailsScreenState();
}

class _DoctorSlotsDetailsScreenState extends State<DoctorSlotsDetailsScreen> {
  Timer? timer;

  final _pref = AppConfig().preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isFromDashboard){
      var splited = widget.bookingTime.split(':');
      int hour = int.parse(splited[0]);
      int minute = int.parse(splited[1]);
      int second = int.parse(splited[2]);
      print('$hour $minute');
    }
  }

  getTime(){
    var splited = widget.bookingTime.split(':');
    print("splited:$splited");
    String hour = splited[0];
    String minute = splited[1];
    int second = int.parse(splited[2]);
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 2.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAppBar(() {
                    Navigator.pop(context);
                  }),
                  const Center(
                    child: Image(
                      image: AssetImage("assets/images/Group 4865.png"),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Center(
                    child: Text(
                      "Your Consultation will be with",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "GothamMedium",
                          color: gTextColor,
                          fontSize: 12.sp),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Center(
                    child: Text(
                      "Dr.Anita H,Dr.Anita J",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Gotham-Black",
                          color: gTextColor,
                          fontSize: 12.sp),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage(
                              "assets/images/noun-chat-5153452.png"),
                          height: 2.h,
                        ),
                        SizedBox(width: 2.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DoctorCalenderTimeScreen()),
                            );
                          },
                          child: Text(
                            'Chat Support',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontFamily: "GothamMedium",
                              color: gTextColor,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          top: 5.h,
                          child: Container(
                            color: gsecondaryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 13.w),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Your Slot has been Booked @ ',
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 12.sp,
                                            fontFamily: "GothamBook",
                                            color: gWhiteColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: (widget.isFromDashboard) ? getTime() : widget.bookingTime.toString(),
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 13.sp,
                                            fontFamily: "GothamMedium",
                                            color: gWhiteColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " on the ",
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 12.sp,
                                            fontFamily: "GothamBook",
                                            color: gWhiteColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: widget.bookingDate.toString(),
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 13.sp,
                                            fontFamily: "GothamMedium",
                                            color: gWhiteColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ", Has Been Confirmed",
                                          style: TextStyle(
                                            height: 1.5,
                                            fontSize: 12.sp,
                                            fontFamily: "GothamBook",
                                            color: gWhiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                GestureDetector(
                                  onTap: () {
                                    ChildAppointmentDetails? model;
                                    if(widget.isFromDashboard){
                                      model = ChildAppointmentDetails.fromJson(Map.from(widget.dashboardValueMap!));
                                    }
                                    print("model!.teamPatients!.patient!.user!.name: ${model!.teamPatients!.patient!.user!.name}");
                                    joinZoom(context);
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         DoctorConsultationCompleted(
                                    //       bookingDate: widget.bookingDate,
                                    //       bookingTime: widget.bookingTime,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.h, horizontal: 25.w),
                                    decoration: BoxDecoration(
                                      color: gWhiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: gMainColor, width: 1),
                                    ),
                                    child: Text(
                                      'Join',
                                      style: TextStyle(
                                        fontFamily: "GothamMedium",
                                        color: gMainColor,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const DoctorCalenderTimeScreen(isReschedule: true,)),
                                    );
                                  },
                                  child: Text(
                                    'Reschedule',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontFamily: "GothamMedium",
                                      color: gWhiteColor,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10.w,
                          right: 10.w,
                          child: GestureDetector(
                            onTap:(){
                              getEvaluationReport();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: gWhiteColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(8, 10),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Image(
                                    image: const AssetImage(
                                        "assets/images/Group 3776.png"),
                                    height: 8.h,
                                  ),
                                  SizedBox(width: 5.w),
                                  Expanded(
                                    child: Text(
                                      "My Evaluation",
                                      style: TextStyle(
                                          fontFamily: "GothamMedium",
                                          color: gTextColor,
                                          fontSize: 12.sp),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: gMainColor,
                                    size: 2.h,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  joinZoom(BuildContext context) {
    ChildAppointmentDetails? model;
    if(widget.isFromDashboard){
      model = ChildAppointmentDetails.fromJson(Map.from(widget.dashboardValueMap!));
    }
    String meetingId = widget.isFromDashboard ? model!.zoomId! : widget.data?.zoomId ?? '';
    String meetingPwd = widget.isFromDashboard ? model!.zoomPassword! : widget.data?.zoomPassword ?? '';
    print('$meetingId $meetingPwd');
    bool _isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid) {
        result = status == "MEETING_STATUS_DISCONNECTING" ||
            status == "MEETING_STATUS_FAILED";
      } else {
        result = status == "MEETING_STATUS_IDLE";

      }
      return result;
    }

    if (meetingId.isNotEmpty &&
        meetingPwd.isNotEmpty) {
      ZoomOptions zoomOptions = ZoomOptions(
        domain: "zoom.us",
        appKey:
        "FxjLOPbhuE5ecpjRS7PCKUWSeCo7Xb3bGjEU", //API KEY FROM ZOOM - Sdk API Key
        appSecret:
        "sN2sN5jrXUXzdmBQrGNmdEVzQwBbOlFSas0B", //API SECRET FROM ZOOM - Sdk API Secret
      );
      var meetingOptions = ZoomMeetingOptions(
          userId:
          model!.teamPatients!.patient!.user!.name ?? model.teamPatientId, //pass username for join meeting only --- Any name eg:- EVILRATT.
          meetingId: meetingId
              .toString(), //pass meeting id for join meeting only
          meetingPassword: meetingPwd
              .toString(), //pass meeting password for join meeting only
          disableDialIn: "true",
          disableDrive: "true",
          disableInvite: "true",
          disableShare: "true",
          disableTitlebar: "false",
          viewOptions: "true",
          noAudio: "false",
          noDisconnectAudio: "false");

      var zoom = ZoomView();
      zoom.initZoom(zoomOptions).then((results) {
        if (results[0] == 0) {
          StreamSubscription? stream;
          stream = zoom.onMeetingStatus().listen((status) {
            print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
            if (_isMeetingEnded(status[0])) {
              print("[Meeting Status] :- Ended");
              timer?.cancel();
              stream?.cancel();
              _pref!.setBool(AppConfig.consultationComplete, true);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                      const DashboardScreen()
                    // DoctorConsultationCompleted(
                    //   bookingDate: widget.bookingDate,
                    //   bookingTime: widget.bookingTime,
                    // ),
                  ), (route) => route.isFirst
              );
              // if(status[1].toString().toLowerCase().contains('Disconnect the meeting server, user leaves meeting')){
              //
              // }
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         const ConsultationSuccess()
              //         // DoctorConsultationCompleted(
              //         //   bookingDate: widget.bookingDate,
              //         //   bookingTime: widget.bookingTime,
              //         // ),
              //   ), (route) => route.isFirst
              // );
            }
            if(status[0] == "MEETING_STATUS_INMEETING"){
              zoom.meetinDetails().then((meetingDetailsResult) {
                print("[MeetingDetailsResult] :- " + meetingDetailsResult.toString());
              });
            }
          });
          print("listen on event channel");
          zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
            timer = Timer.periodic(const Duration(seconds: 2), (timer) {
              zoom.meetingStatus(meetingOptions.meetingId!).then((status) {
                print("[Meeting Status Polling] : " +
                    status[0] +
                    " - " +
                    status[1]);
                if(status[0] == 'MEETING_STATUS_IDLE'){
                  stream!.cancel();
                  timer.cancel();
                }
              });
            });
          });
        }
      }).catchError((error) {
        print("[Error Generated] : " + error);
      });
    }
    else {
      if (meetingId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Enter a valid meeting id to continue."),
        ));
      } else if (meetingPwd.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Enter a meeting password to start."),
        ));
      }
    }
  }

  void getEvaluationReport() {
    Navigator.push(context, MaterialPageRoute(builder: (c) => PersonalDetailsScreen(showData: true,)));

  }

}
