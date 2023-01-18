// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/message_model/get_chat_groupid_model.dart';
import 'package:gwc_customer/repository/consultation_repository/get_slots_list_repository.dart';
import 'package:gwc_customer/screens/chat_support/message_screen.dart';
import 'package:gwc_customer/screens/dashboard_screen.dart';
import 'package:gwc_customer/screens/evalution_form/evaluation_get_details.dart';
import 'package:gwc_customer/screens/evalution_form/personal_details_screen.dart';
import 'package:gwc_customer/services/quick_blox_service/quick_blox_service.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../model/consultation_model/appointment_booking/appointment_book_model.dart';
import '../../model/dashboard_model/get_appointment/child_appintment_details.dart';
import '../../repository/api_service.dart';
import '../../repository/chat_repository/message_repo.dart';
import '../../services/chat_service/chat_service.dart';
import '../../services/consultation_service/consultation_service.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'doctor_calender_time_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorSlotsDetailsScreen extends StatefulWidget {
  /// this will be called from consultation date time screen
  final AppointmentBookingModel? data;
  final String bookingDate;
  final String bookingTime;
  /// this parameter will be called from gutlist screen
  final bool isFromDashboard;
  /// this parameter will be called from gutlist screen
  final Map? dashboardValueMap;
  /// this is for post program
  /// when this all other parameters will null
  final bool isPostProgram;
  const DoctorSlotsDetailsScreen({
    Key? key,
    this.data,
    required this.bookingDate,
    required this.bookingTime,
    this.isFromDashboard = false,
    this.dashboardValueMap,
    this.isPostProgram = false
  }) : super(key: key);

  @override
  State<DoctorSlotsDetailsScreen> createState() => _DoctorSlotsDetailsScreenState();
}

class _DoctorSlotsDetailsScreenState extends State<DoctorSlotsDetailsScreen> {
  Timer? timer;

  final _pref = AppConfig().preferences;

  bool isJoinPressed = false;

  List<String> doctorNames = [];

  String accessToken = '';
  String kaleyraUID = "";

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
    if(!widget.isPostProgram && !widget.isFromDashboard){
      widget.data?.team?.teamMember?.forEach((element) {
        if(element.user!.roleId == "2"){
          doctorNames.add(element.user!.name ?? '');
        }
      });
      if(widget.data?.kaleyraSuccessId != null){

      }
      if(widget.data?.kaleyraUserId != null){
        kaleyraUID = widget.data?.kaleyraUserId ?? '';
        getAccessToken(kaleyraUID);
      }
      else if(_pref!.getString(AppConfig.KALEYRA_USER_ID) != null){
        kaleyraUID = _pref?.getString(AppConfig.KALEYRA_USER_ID) ?? '';
        getAccessToken(kaleyraUID);
      }
    }
    ChildAppointmentDetails? model;
    if(widget.isFromDashboard || widget.isPostProgram){
      model = ChildAppointmentDetails.fromJson(Map.from(widget.dashboardValueMap!));
      print("moddd: ${model.teamPatients!.team!.toJson()}");
      model.teamMember?.forEach((element) {
        print('from appoi: ${element.toJson()}');
        if(element.user!.roleId == "2"){
          doctorNames.add(element.user!.name ?? '');
        }
      });
      if(model.teamPatients!.patient!.user!.kaleyraId != null){
        String kaleyraUID = model.teamPatients!.patient!.user!.kaleyraId ?? '';
        getAccessToken(kaleyraUID);
      }
    }
  }

  Future getAccessToken(String kaleyraId) async{
    final res = await ConsultationService(repository: _consultationRepository).getAccessToken(kaleyraId);

    print(res);
    if(res.runtimeType == ErrorModel){
      final model = res as ErrorModel;
      AppConfig().showSnackbar(context, model.message ?? '', isError: true);
    }
    else{
      accessToken = res;
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
                      doctorNames.join(','),
                      // "Dr.Anita H,Dr.Anita J",
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
                            getChatGroupId();
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           const DoctorCalenderTimeScreen()),
                            // );
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
                                          text: 'Your Slot Booked @ ',
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
                                          text: " on ",
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
                                // zoom join
                                Visibility(
                                  visible: false,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isJoinPressed = true;
                                      });
                                      ChildAppointmentDetails? model;
                                      if(widget.isFromDashboard){
                                        model = ChildAppointmentDetails.fromJson(Map.from(widget.dashboardValueMap!));
                                      }
                                      launchZoomUrl();
                                      // joinZoom(context);
                                    },
                                    child: Container(
                                      width: 60.w,
                                      height: 5.h,
                                      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                                      decoration: BoxDecoration(
                                        color: gWhiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: gMainColor, width: 1),
                                      ),
                                      child: Center(
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
                                  ),
                                ),
                                // kaleyra join
                                GestureDetector(
                                  onTap: () {
                                    ChildAppointmentDetails? model;
                                    if(widget.isFromDashboard || widget.isPostProgram){
                                      model = ChildAppointmentDetails.fromJson(Map.from(widget.dashboardValueMap!));
                                    }
                                    // String zoomUrl = model.;

                                    String? kaleyraurl = (widget.isFromDashboard || widget.isPostProgram) ? model?.kaleyraJoinurl : widget.data?.kaleyraJoinurl;

                                    print(_pref!.getString(AppConfig.KALEYRA_USER_ID));
                                    print("kaleyraurl:=>$kaleyraurl");
                                    print('token: $accessToken');
                                    print("kaleyraID: $kaleyraUID");
                                    // send kaleyra id to native
                                    if(kaleyraUID != null || kaleyraurl != null || accessToken.isNotEmpty){
                                      Provider.of<ConsultationService>(context, listen: false).joinWithKaleyra(kaleyraUID, kaleyraurl!, accessToken);
                                    }
                                    else{
                                      AppConfig().showSnackbar(context, "Uid/accessToken/join url not found");
                                    }
                                  },
                                  child: Container(
                                    width: 60.w,
                                    height: 5.h,
                                    padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: gWhiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: gMainColor, width: 1),
                                    ),
                                    child: Center(
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
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Visibility(
                                  visible: !widget.isPostProgram,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DoctorCalenderTimeScreen(
                                                  isReschedule: true,
                                                  prevBookingDate: widget.bookingDate,
                                                  prevBookingTime: widget.bookingTime,
                                                )),
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
    print(widget.data?.patientName);
    print(widget.isPostProgram);
    ChildAppointmentDetails? model;
    if(widget.isFromDashboard || widget.isPostProgram){
      model = ChildAppointmentDetails.fromJson(Map.from(widget.dashboardValueMap!));
    }

    print("model: ${model!.zoomId}");

    String? userId = (widget.isFromDashboard || widget.isPostProgram) ? model?.teamPatients!.patient?.user?.name : widget.data?.patientName ?? _pref?.getString(AppConfig.User_Name) ?? '';
    String meetingId = (widget.isFromDashboard || widget.isPostProgram) ? model!.zoomId! : widget.data?.zoomId ?? '';
    String meetingPwd = (widget.isFromDashboard || widget.isPostProgram) ? model!.zoomPassword! : widget.data?.zoomPassword ?? '';
    print('$meetingId $meetingPwd');

    setState(() {
      isJoinPressed = false;
    });

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
            "FN4n7k0rOGDRf8t8fmhKvbjGLiA98ovbzEjJ",
        // "FxjLOPbhuE5ecpjRS7PCKUWSeCo7Xb3bGjEU", //API KEY FROM ZOOM - Sdk API Key
        appSecret:
          "Hp7Lyy9nD5EjQN2B5aF2S4yogk55mbz0rN9X",
        // "sN2sN5jrXUXzdmBQrGNmdEVzQwBbOlFSas0B", //API SECRET FROM ZOOM - Sdk API Secret
      );
      var meetingOptions = ZoomMeetingOptions(
          userId: userId, //pass username for join meeting only --- Any name eg:- EVILRATT.
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
            print("meeting status: $status");
            print("[Meeting Status Stream] : " + status[0] + " - " + status[1]);
            if (_isMeetingEnded(status[0])) {
              print("[Meeting Status] :- Ended");
              timer?.cancel();
              stream?.cancel();
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(
              //         builder: (context) =>
              //         const DashboardScreen()
              //       // DoctorConsultationCompleted(
              //       //   bookingDate: widget.bookingDate,
              //       //   bookingTime: widget.bookingTime,
              //       // ),
              //     ), (route) => route.isFirst
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
            timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              zoom.meetingStatus(meetingOptions.meetingId!).then((status) {
                print("[Meeting Status Polling] : " +
                    status[0] +
                    " - " +
                    status[1]);
                // if(status[0] == 'MEETING_STATUS_IDLE'){
                //   stream!.cancel();
                //   timer.cancel();
                // }
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
    Navigator.push(context, MaterialPageRoute(builder: (c) =>
        EvaluationGetDetails()));
  }

  final MessageRepository chatRepository = MessageRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final ConsultationRepository _consultationRepository = ConsultationRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  getChatGroupId() async{
    final res = await ChatService(repository: chatRepository).getChatGroupIdService();
    String? chatGroupId;
    if(res.runtimeType == GetChatGroupIdModel){
      GetChatGroupIdModel model = res as GetChatGroupIdModel;
      _pref!.setString(AppConfig.GROUP_ID, model.group ?? '');
      Navigator.push(context, MaterialPageRoute(builder: (c)=> MessageScreen(isGroupId: true,)));
    }
    else{
      ErrorModel model = res as ErrorModel;
      AppConfig().showSnackbar(context, model.message.toString(), isError: true);
    }

  }

  void launchZoomUrl() async{
    print(widget.data?.patientName);
    print(widget.isPostProgram);
    ChildAppointmentDetails? model;
    if(widget.isFromDashboard || widget.isPostProgram){
      model = ChildAppointmentDetails.fromJson(Map.from(widget.dashboardValueMap!));
    }
    // String zoomUrl = model.;

    String? zoomUrl = (widget.isFromDashboard || widget.isPostProgram) ? model?.zoomJoinUrl : widget.data?.zoomJoinUrl;

    print("model: ${zoomUrl}");

    if (await canLaunchUrl(Uri.parse(zoomUrl ?? '')))
      await launch(zoomUrl ?? '');
    else
      // can't launch url, there is some error
      throw "Could not launch ${zoomUrl}";

  }

}
