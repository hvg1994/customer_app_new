/*
Api's used
1. User Profile Api
var getUserProfileUrl = "${AppConfig().BASE_URL}/api/user";

if user details are not stored in local storage then this api will be called

2. FollowUpCall day details list [getFollowUpCallDetails()]
var getUserSlotDaysForScheduleUrl = "${AppConfig().BASE_URL}/api/getData/user_slot_days";

this api is calling to show if any follow up call scheduled for today than we r showing bottom sheet for alert
or if todays date is there in that lst but user still not scheduled than also we r showing bottom sheet to schedule.

3.ShipRocket Api:
* var shippingApiLoginUrl = "${AppConfig().shipRocket_AWB_URL}/auth/login";
this above url called if local storage[AppConfig().shipRocketBearer] has no data or its null
else if there is a data but if its expired

4. Getting Kaleyra Access Token if [AppConfig.KALEYRA_ACCESS_TOKEN] is null or empty
 final endPoint = "https://api.in.bandyer.com";
 final String url = "$endPoint/rest/sdk/credentials
  'apikey': 'ak_live_d2ad6702fe931fbeb2fa9cb4'

 the above mentioned (endPoint & url, apikey) is LIVE Url
 we need to pass kaleyra userId to that api in body with apikey as headers

5. GetDashboardData Api:
var getDashboardDataUrl = "${AppConfig().BASE_URL}/api/getData/get_dashboard_data";

Note for Dashboard Api:-
if stage is pending/evaluation_done -> card2 will open

if stage is consultation_reschedule ->
  * card-2 has 2 btns (Join(disable) & Reschedule(enabled))

if stage is appointment_booked  ->
  * card-2 has 2 btns(join & reschedule(disable))
  join button will enable 5 min before consultation after 15 min of consultation time it will diable again

if stage is consultation_done ->
  * card-2 has 1 btn(Status) [ConsultationHistoryScreen()]

if stage is consultation_waiting -> card-3 will open
   * card-2 will show 1 btn(history)
   * card-3 will show 1btn(Upload Report) [UploadFiles()]

if stage is check_user_reports -> card-3
   * card-2 will show 1 btn(Status) awaiting screen

if stage is consultation_accepted -> card-4
   * card-2 will show 1 btn(Status)

if stage is consultation_rejected & report_upload-> card-5
  * card-5 will show mr report
  if consultation_rejected than card 2 will be red color with reason
  else card-2 will show normal color with status button

if stage is prep_meal_plan_completed -> if isMrRead than card-6 else card-5
once we open view Mr -> isMrRead will becomes 1
  card-6 btn will show ship now text(CookKitTracking(shippingstage))

if stage is shipping_packed,shipping_paused,shipping_approved  -> card-6
  * card-6 btn1-> Track Kit

if stage is shipping_delivered -> card-7
  * card-6 btn1-> Track Kit
  * card-7 btn
    -> if(isPrepratoryStarted == false) than start Prep
    -> else btn name=> Prep

if stage is start_program -> card-7
** once program started current day will starts from 0

  * checking for
    -->isPrepCompleted is true
      -> prep Tracker (PrepTracker Screen)
    -->if isPrepTrackerCompleted is true
      -> start Program (start program screen)

    ** once detox started
      if start_program ==1 and is_detox_completed != 1 and is_detox_completed != null

      than we r showing "day no of Detox"

    ** once Detox Completed
      weed to start healing phase by checking
      isDetoxCompleted ==1 and healingStartProgram != 1

      btn Name is "Day 1 of Healing"

    ** once healing started by checking healingStartProgram==1 and isDetoxCompleted==1
      btn name is "day no of Healing"

    ** once healing completed
     if isTransMealStarted is false than
     buttonName is "Start Nourish"

     else buttonName is "Day no of Nourish"

     once we click on next in nourish screen post_program will open

if stage is Post_program-> card-8
  * if isProgramFeedbackSubmitted != 1
  then feedback button will display and post program consultation will disabled

  * if isProgramFeedbackSubmitted is 1
  than feedback button will hide and only post program consultation will enable

  once user scheduled the post consultaton appointment
  stage becomes post_appointment_booked

if stage is post_appointment_booked -> card-8
here join and reschedule button will come
join button will enable before 15 min after 15min from scheduled time it will disable

if doctor will pressed on internet slow/patient didn't join than
post_appointment_reschedule stage will come

if stage is post_appointment_reschedule-> card-8
in card-8 -> only showing Reschedule button

once rescheduled again stage will becomes post_appointment_booked

if doctor has pressed the completed after consultation then
dashboard ste=age will becomes post_appointment_done

if stage is post_appointment_done-> card-8

till doctor upload gmg and end Reports dashboard stage will be post_appointment_done

once doctor uploaded both gmg and end Reports than dashboard stage becomes->protocol_guide(card-9)


if stage is protocol_guide-> card-9

in card-9 showing 2 buttons gmg and endReports
on click of shwing that respective pdf

evaluation card: -> btn onTap:- [EvaluationGetDetails]

consultation card:
  schedule-> DoctorCalenderTimeScreen()

  join btn-> DoctorSlotsDetailsScreen()

  ReSchedule-> DoctorCalenderTimeScreen()
  ** here we need to pass isReschedule as true and previous appointment details

  After once Next card will open then we r showing
  View History -> ConsultationHistoryScreen()
  ** we need to pass history object details

Request report card->
  Upload Report -> UploadFiles()

  if stage is check_user_reports-> CheckUserReportsScreen();

  Once analysis card opens then
  View User reports btn-> UploadFiles and need to pass isFromSetting as true

Analysis card->
  once consultation accepted -

  status btn-> ConsultationHistoryScreen()

Medical Report card:
  once case approved and mr uploaded-

  view MR-> MedicalReportScreen()
  ** we need to pass the pdf link to that screen

Kt Under Process card:
  once meals till healing doctor has submitted -

  ship Now btn-> CookKitTracking()
  ** we need to pass the current stage as meal_plan_completed

  once customer has submitted date-
  till delivered btn name would be-> Kit Under Process
  once delivered btn name would be -> Track Kit

  on tap of that CookKitTracking() we need to pass awb number

Gut Reset Program:
  if prep not started ->
  btn name will be -> Start Prep ==> ProgramPlanScreen()

  if prep not completed then
  btn name will be -> prep ==> CombinedPrepMealTransScreen()
  ** here we need to pass stage as 0

  if prep tracker not submitted then
  btn name will be -> prep Tracker ==> PrepratoryMealCompletedScreen()

  once prep tracker completed then-
  btn name will be -> Start Program ==> ProgramPlanScreen()

  once detox started ->
  if current day is 0 than btn name will be detox plan once 1,2,3 -> day 1 Detox plan like this
  on tap of button CombinedPrepMealTransScreen()
  ** here we need to pass stage as 1

  once detox completed ->
  checking isDetoxCompleted == 1 and healingStartProgram != 1
  then showing healing plan on tap of that -> ProgramPlanScreen()
  once started Day1 of healing btn --> CombinedPrepMealTransScreen()
  ** here we need to pass stage as 2

  once healing completed-> Nourish will start
  isTransMealStarted is false than need to start program
  btn name-> Start Nourish ==> ProgramPlanScreen()
  once started ->
  if current day is 0 than only Nourish plan will show else Day 1 of Nourish btn showing
  on tap of that button -> CombinedPrepMealTransScreen()
  ** here we need to pass stage as 3

 */

import 'dart:convert';
import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:gwc_customer/screens/prepratory%20plan/schedule_screen.dart';
import 'package:gwc_customer/screens/profile_screens/call_support_method.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import '../../model/dashboard_model/get_appointment/get_appointment_after_appointed.dart';
import '../../model/dashboard_model/get_dashboard_data_model.dart';
import '../../model/dashboard_model/get_program_model.dart';
import '../../model/dashboard_model/gut_model/gut_data_model.dart';
import '../../model/dashboard_model/shipping_approved/ship_approved_model.dart';
import '../../model/error_model.dart';
import '../../model/local_storage_dashboard_model.dart';
import '../../model/profile_model/user_profile/user_profile_model.dart';
import '../../model/program_model/proceed_model/send_proceed_program_model.dart';
import '../../model/ship_track_model/sipping_approve_model.dart';
import '../../model/user_slot_for_schedule_model/user_slot_days_schedule_model.dart';
import '../../repository/api_service.dart';
import '../../repository/dashboard_repo/gut_repository/dashboard_repository.dart';
import '../../repository/login_otp_repository.dart';
import '../../repository/profile_repository/get_user_profile_repo.dart';
import '../../repository/shipping_repository/ship_track_repo.dart';
import '../../repository/user_slot_for_schedule_repository/schedule_slot_repository.dart';
import '../../services/dashboard_service/gut_service/dashboard_data_service.dart';
import '../../services/login_otp_service.dart';
import '../../services/profile_screen_service/user_profile_service.dart';
import '../../services/shipping_service/ship_track_service.dart';
import '../../services/user_slot_for_schedule_service/user_slot_for_schedule_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/video/normal_video.dart';
import '../../widgets/widgets.dart';
import '../appointment_screens/consultation_screens/check_user_report_screen.dart';
import '../appointment_screens/consultation_screens/consultation_history.dart';
import '../appointment_screens/consultation_screens/consultation_rejected.dart';
import '../appointment_screens/consultation_screens/consultation_success.dart';
import '../appointment_screens/consultation_screens/medical_report_screen.dart';
import '../appointment_screens/consultation_screens/upload_files.dart';
import '../appointment_screens/doctor_calender_time_screen.dart';
import '../appointment_screens/doctor_slots_details_screen.dart';
import '../combined_meal_plan/combined_meal_screen.dart';
import '../cook_kit_shipping_screens/cook_kit_tracking.dart';
import '../evalution_form/evaluation_get_details.dart';
import '../evalution_form/personal_details_screen.dart';
import '../help_screens/help_screen.dart';
import 'package:intl/intl.dart';
import '../home_remedies/home_remedies_screen.dart';
import '../medical_program_feedback_screen/final_feedback_form.dart';
import '../medical_program_feedback_screen/medical_feedback_form.dart';
import '../notification_screen.dart';
import '../post_program_screens/new_post_program/pp_levels_demo.dart';
import '../post_program_screens/protcol_guide_details.dart';
import '../prepratory plan/new/new_transition_design.dart';
import '../prepratory plan/new/preparatory_new_screen.dart';
import '../prepratory plan/prepratory_meal_completed_screen.dart';
import '../program_plans/day_tracker_ui/day_tracker.dart';
import '../program_plans/meal_plan_screen.dart';
import '../program_plans/program_start_screen.dart';
import '../program_plans/program_start_screen.dart';
import 'new_stages_data.dart';
import 'package:http/http.dart' as http;

class NewDsPage extends StatefulWidget {
  const NewDsPage({Key? key}) : super(key: key);

  @override
  _NewDsPageState createState() => _NewDsPageState();
}

class _NewDsPageState extends State<NewDsPage> {
  final _scrollController = ScrollController();
  static const newCompletedStageColor = Color(0xff68B881);
  static const newCompletedStageBtnColor = Color(0xFF93C2A2);
  static const newCurrentStageColor = Color(0xffFFD23F);
  // static const newCurrentStageButtonColor = Color(0xffFD8B7B);
  static const newCurrentStageButtonColor = Color(0xffFd10034);

  final _pref = AppConfig().preferences;
  ScrollPhysics physics = const AlwaysScrollableScrollPhysics();

  /// need to add the current stage 1-8
  int current = 1;

  double heightFactor = 0.20;

  // final CategoriesScroller categoriesScroller = const CategoriesScroller();
  // ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  String? badgeNotification;

  String? isMrRead;

  late GutDataService _gutDataService;

  /// THIS IS FOR ABC DIALOG MEAL PLAN
  bool isMealProgressOpened = false;

  bool isProgressDialogOpened = true;

  //chewie
  VideoPlayerController? videoPlayerController;
  ChewieController? _chewieController;

  String? consultationStage,
      shippingStage,
      prepratoryMealStage,
      programOptionStage,
      transStage,
      postProgramStage;

  /// this is used when data=appointment_booked status
  GetAppointmentDetailsModel? _getAppointmentDetailsModel,
      _postConsultationAppointment;

  /// ths is used when data = shipping_approved status
  ShippingApprovedModel? _shippingApprovedModel;

  GetProgramModel? _gutProgramModel;

  GetPrePostMealModel? _prepratoryModel, _transModel;

  /// for other status we use this one(except shipping_approved & appointment_booked)
  GutDataModel? _gutDataModel,
      _gutShipDataModel,
      _gutNormalProgramModel,
      _gutPostProgramModel,
      _prepProgramModel,
      _transMealModel;

  static const _bookedCallHeading = "Gut Review Reminder";
  static const _needToBookCallHeading = "Book Gut Review Call";
  static const _needToBookCallContent = "Your doctor would like to connect with you. Please book your call now!";


  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserProfile();

    // getIsTimePassedOrNot("09:00");
    getFollowUpCallDetails();

    if (_pref!.getString(AppConfig().shipRocketBearer) == null ||
        _pref!.getString(AppConfig().shipRocketBearer)!.isEmpty) {
      getShipRocketToken();
    } else {
      String token = _pref!.getString(AppConfig().shipRocketBearer)!;
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      print('shiprocketToken : $payload');
      var date = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
      if (!DateTime.now().difference(date).isNegative) {
        getShipRocketToken();
      }
    }
  }

  /// once we got data from api
  /// if any date is today than we r showing showFollowUpDetailsInPopup
  /// showFollowUpDetailsInPopup has isBook-> if already booked than true and we need to pass element in details param
  /// else isBook: as false
  getFollowUpCallDetails() {
    print("-----getFollowUpCallDetails --------");
    final today = DateTime.now();
    GetUserScheduleSlotsForService(repository: followUpRepository)
        .getSlotsDaysForScheduleService()
        .then((value) {
      print("getFollowUpCallDetails: value: ${value}");
      if (value.runtimeType == GetUserSlotDaysForScheduleModel) {
        final _slotsData = value as GetUserSlotDaysForScheduleModel;

        if (_slotsData.data != null) {
          for (var element in _slotsData.data!) {
            if (element.date != null) {
              print("getFollowUpCallDetails date: ${element.date}");
              print(DateFormat('dd-MM-yyyy')
                      .parse(element.date ?? '')
                      .difference(today)
                      .inDays ==
                  0);
              if (DateFormat('dd-MM-yyyy')
                      .parse(element.date ?? '')
                      .difference(today)
                      .inDays ==
                  0) {
                if (element.booked != null && element.booked!) {
                  showFollowUpDetailsInPopup(isBook: true, details: element);
                } else {
                  showFollowUpDetailsInPopup(isBook: false);
                }
              }
            }
          }
        }
      }
    });
  }

  /// enable this when we need to hide followup sheet after consultation
  getIsTimePassedOrNot(String date) {
    final today = DateTime.now();
    print("getIsTimePassedOrNot");
    print(DateFormat('hh:mm').parse(date));
    final getT = DateFormat('hh:mm').parse(date);
    final time = DateFormat('hh:mm').parse("10:15");
    final diff = getT.difference(time).inMinutes;
    print(time);
    print(diff);
    // print("days: ${today.difference(DateFormat('hh:mm').parse(date)).inMinutes}");
    // if(today.difference(DateFormat('dd-MM-yyyy').parse(date)).inDays > 0){
    //   return true;
    // }
    // else{
    //   return false;
    // }
  }


  /// if any date is today than we r showing showFollowUpDetailsInPopup
  /// showFollowUpDetailsInPopup has isBook-> if already booked than true and we need to pass element in details param
  /// else isBook: as false
  showFollowUpDetailsInPopup(
      {required bool isBook, ChildUserSlotDaysForScheduleModel? details}) {
    return AppConfig().showSheet(
        context,
        StatefulBuilder(builder: (_, setstate) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  isBook ? _bookedCallHeading
                      : _needToBookCallHeading,
                  style: TextStyle(
                      fontSize: bottomSheetHeadingFontSize,
                      fontFamily: bottomSheetHeadingFontFamily,
                      height: 1.4),
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
              SizedBox(height: 1.5.h),
              Center(
                child: Text(
                  isBook
                      ? "You have a call booked at @ ${details?.slot?.split('-').first ?? ''} with your doctor"
                      : _needToBookCallContent,
                  style: TextStyle(
                      fontSize: bottomSheetSubHeadingXFontSize,
                      fontFamily: bottomSheetSubHeadingMediumFont,
                      height: 1.4
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 1.h),
              if(!isBook) Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NewScheduleScreen()));
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                    decoration: BoxDecoration(
                        color: gsecondaryColor,
                        border: Border.all(color: kLineColor, width: 0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "Schedule",
                      style: TextStyle(
                        fontFamily: kFontMedium,
                        color: gWhiteColor,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 1.h),
            ],
          );
        }),
        bottomSheetHeight: 45.h,
        isDismissible: true,
        isSheetCloseNeeded: true,
        sheetCloseOnTap: () {
          Navigator.pop(context);
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getData();
  }

  void getShipRocketToken() async {
    print("getShipRocketToken called");
    ShipTrackService _shipTrackService =
        ShipTrackService(repository: shipTrackRepository);
    final getToken = await _shipTrackService.getShipRocketTokenService(
        AppConfig().shipRocketEmail, AppConfig().shipRocketPassword);
    print(getToken);
  }

  /// calling of getdashboard api
  Future getData() async {
    isProgressDialogOpened = true;
    print("isProgressDialogOpened: $isProgressDialogOpened");

    _gutDataService = GutDataService(repository: repository);
    print("isProgressDialogOpened: $isProgressDialogOpened");

    final _getData = await _gutDataService.getGutDataService();
    print("_getData: $_getData");
    if (_getData.runtimeType == ErrorModel) {
      ErrorModel model = _getData;
      print(model.message);
      isProgressDialogOpened = false;
      // if we get connection closed message again we calling this function
      if (model.message!.toLowerCase().contains("connection closed")) {
        getData();
      } else {
        String errorMsg = "";
        if (model.message!.contains("Failed host lookup")) {
          errorMsg = AppConfig.networkErrorText;
        } else {
          errorMsg = AppConfig.oopsMessage;
        }
        Future.delayed(Duration(seconds: 0)).whenComplete(
            () => AppConfig().showSnackbar(context, errorMsg ?? '',
                isError: true,
                duration: 50000,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    getData();
                  },
                )));
      }
    } else {
      isProgressDialogOpened = false;
      print("isProgressDialogOpened: $isProgressDialogOpened");
      GetDashboardDataModel _getDashboardDataModel =
          _getData as GetDashboardDataModel;

      print(
          "_getDashboardDataModel.notification: ${_getDashboardDataModel.notification}");
      badgeNotification = _getDashboardDataModel.notification;
      print("mrread: ${_getDashboardDataModel.isMrRead}");
      isMrRead = _getDashboardDataModel.isMrRead;

      print(
          "_getDashboardDataModel.app_consulation: ${_getDashboardDataModel.app_consulation}");

      // checking for the consultation data if data = appointment_booked
      // else we will keep it in normal_consultation
      setState(() {
        if (_getDashboardDataModel.app_consulation != null) {
          _getAppointmentDetailsModel = _getDashboardDataModel.app_consulation;
          consultationStage = _getAppointmentDetailsModel?.data ?? '';
        } else {
          print("consultation else");
          _gutDataModel = _getDashboardDataModel.normal_consultation;
          consultationStage = _gutDataModel?.data ?? '';
          print(consultationStage);
        }
        updateNewStage(consultationStage);

        // if prep stage has empty string than normal program else
        // if its in object than prepratory_program
        if (_getDashboardDataModel.prepratory_normal_program != null) {
          _prepProgramModel = _getDashboardDataModel.prepratory_normal_program;
          prepratoryMealStage = _prepProgramModel?.data ?? '';
        } else if (_getDashboardDataModel.prepratory_program != null) {
          _prepratoryModel = _getDashboardDataModel.prepratory_program;
          print("_prepratoryModel: $_prepratoryModel");
          print(_prepratoryModel!.value!.toJson());
          prepratoryMealStage = _prepratoryModel?.data ?? '';
        }
        updateNewStage(prepratoryMealStage);

        // if shipping stage has empty string than normal_shipping else
        // if its in object than approved_shipping
        if (_getDashboardDataModel.approved_shipping != null) {
          _shippingApprovedModel = _getDashboardDataModel.approved_shipping;
          shippingStage = _shippingApprovedModel?.data ?? '';
        } else {
          _gutShipDataModel = _getDashboardDataModel.normal_shipping;
          shippingStage = _gutShipDataModel?.data ?? '';
        }
        updateNewStage(shippingStage);

        // if program stage has empty string than normal_program else
        // if its in object than data_program
        if (_getDashboardDataModel.data_program != null) {
          _gutProgramModel = _getDashboardDataModel.data_program;
          print("programOptionStage if: ${programOptionStage}");
          programOptionStage = _gutProgramModel!.data;
        } else {
          _gutNormalProgramModel = _getDashboardDataModel.normal_program;
          print("programOptionStage else: ${programOptionStage}");
          programOptionStage = _gutNormalProgramModel!.data;
          // mealPlanCompleteSheet();
        }
        updateNewStage(programOptionStage);

        // if transition stage has empty string than trans_program else
        // if its in object than transition_meal_program
        if (_getDashboardDataModel.transition_meal_program != null) {
          _transMealModel = _getDashboardDataModel.transition_meal_program;
          transStage = _transMealModel?.data;
        } else if (_getDashboardDataModel.trans_program != null) {
          _transModel = _getDashboardDataModel.trans_program;
          transStage = _transModel!.data;
        }
        updateNewStage(transStage);

        // post program will open once transition meal plan is completed
        // this is for other postprogram model
        if (_getDashboardDataModel.normal_postprogram != null) {
          _gutPostProgramModel = _getDashboardDataModel.normal_postprogram;
          postProgramStage = _gutPostProgramModel?.data;
        } else {
          _postConsultationAppointment =
              _getDashboardDataModel.postprogram_consultation;
          _pref!.setString(AppConfig.appointmentId,
              _postConsultationAppointment?.value?.id.toString() ?? '');
          print(
              "RESCHEDULE : ${_getDashboardDataModel.postprogram_consultation?.data}");
          postProgramStage = _postConsultationAppointment?.data;
        }

        updateNewStage(postProgramStage);
      });

      LocalStorageDashboardModel _localStorageDashboardModel =
          LocalStorageDashboardModel(
        consultStage: consultationStage,
        appointmentModel: jsonEncode(_getAppointmentDetailsModel),
        consultStringModel: jsonEncode(_gutDataModel),
        mrReport: (consultationStage == "report_upload")
            ? _gutDataModel?.historyWithMrValue?.mr ?? ''
            : "",
        prepStage: prepratoryMealStage,
        prepMealModel: jsonEncode(_prepratoryModel),
        prepStringModel: jsonEncode(_prepProgramModel),
        shippingStage: shippingStage,
        shippingModel: jsonEncode(_shippingApprovedModel),
        shippingStringModel: jsonEncode(_gutShipDataModel),
        mealProgramStage: programOptionStage,
        mealModel: jsonEncode(_gutProgramModel),
        mealStringModel: jsonEncode(_gutNormalProgramModel),
        transStage: transStage,
        transModel: jsonEncode(_transModel),
        transStringModel: jsonEncode(_transMealModel),
        postProgramStage: postProgramStage,
        postModel: jsonEncode(_postConsultationAppointment),
        postStringModel: jsonEncode(_gutPostProgramModel),
      );
      _pref!.setString(AppConfig.LOCAL_DASHBOARD_DATA,
          jsonEncode(_localStorageDashboardModel));
    }
  }

  checkAllUserDataIsAdded() {
    _pref!.getBool(AppConfig.IS_ALL_USER_DATA_AVAILABLE);
  }

  getUserProfile() async {
    // print("user id: ${_pref!.getInt(AppConfig.KALEYRA_USER_ID)}");

    final profile = await UserProfileService(repository: userRepository)
        .getUserProfileService();
    if (profile.runtimeType == UserProfileModel) {
      UserProfileModel model1 = profile as UserProfileModel;
      _pref!.setString(
          AppConfig.User_Name, model1.data?.name ?? model1.data?.fname ?? '');
      _pref!.setInt(AppConfig.USER_ID, model1.data?.id ?? -1);
      _pref!
          .setString(AppConfig.KALEYRA_USER_ID, model1.data!.kaleyraUID ?? '');
      _pref!.setString(AppConfig.User_age, model1.data?.age ?? "");
      _pref!.setString(AppConfig.User_gender, model1.data?.gender ?? "");
      _pref!.setString(AppConfig.User_height, model1.height ?? "");
      _pref!.setString(AppConfig.User_weight, model1.weight ?? "");

      if (_pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN) == null) {
        await LoginWithOtpService(repository: loginOtpRepository)
            .getAccessToken(model1.data!.kaleyraUID!);
      }
      if (_pref!.getString(AppConfig.KALEYRA_CHAT_SUCCESS_ID) == null ||
          _pref!.getString(AppConfig.KALEYRA_CHAT_SUCCESS_ID) == "") {
        _pref!.setString(AppConfig.KALEYRA_CHAT_SUCCESS_ID,
            model1.associatedSuccessMemberKaleyraId ?? '');
      }
      print(
          "user profile: ${_pref!.getString(AppConfig.KALEYRA_CHAT_SUCCESS_ID)}");
    }
  }

  Future<void> reloadUI() async {
    await getData();
    setState(() {});
  }

  final UserProfileRepository userRepository = UserProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final GutDataRepository repository = GutDataRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
  final LoginOtpRepository loginOtpRepository = LoginOtpRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
  final ShipTrackRepository shipTrackRepository = ShipTrackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final ScheduleSlotsRepository followUpRepository = ScheduleSlotsRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  goToScreen(screenName) {
    print(screenName);
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => screenName,
        // builder: (context) => isConsultationCompleted ? ConsultationSuccess() : const DoctorCalenderTimeScreen(),
      ),
    )
        .then((value) {
      print(value);
      setState(() {
        getData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build called");
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: size.height,
          child: (isProgressDialogOpened)
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.3),
                  highlightColor: Colors.grey.withOpacity(0.7),
                  child: IgnorePointer(child: cards()),
                )
              : RefreshIndicator(
                  child: cards(),
                  onRefresh: () {
                    getData();
                    return Future.value();
                  }),
        ),
      ),
    );
  }

  cards() {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(left: 1.w, right: 2.5.w, bottom: 1.w, top: 1.h),
          child: buildAppBar(
            () {
              Navigator.pop(context);
            },
            badgeNotification: badgeNotification,
            isBackEnable: false,
            showNotificationIcon: true,
            notificationOnTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const NotificationScreen()))
                  .then((value) => reloadUI());
            },
            showHelpIcon: false,
            helpOnTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HelpScreen()));
            },
            showSupportIcon: true,
            supportOnTap: () {
              showSupportCallSheet(context);
            },
          ),
        ),
        Expanded(
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/dashboard_stages/Mask Group 43505.png"),
                        opacity: 0.5,
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 2.h),
                        SizedBox(height: 1.h),
                        GestureDetector(
                          onTap: handleTrackerRemedyOnTap,
                          child: IntrinsicWidth(
                            child: Container(
                              // height: 3.h,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.7.h),
                              margin: EdgeInsets.symmetric(
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withAlpha(100),
                                      blurRadius: 10.0),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/home_remedies.png",
                                    height: 2.5.h,
                                    fit: BoxFit.scaleDown,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    "Instant Remedies",
                                    style: TextStyle(
                                      height: 1.3,
                                      fontFamily: eUser().userFieldLabelFont,
                                      color: eUser().mainHeadingColor,
                                      fontSize: bottomSheetSubHeadingSFontSize,
                                    ),
                                  ),
                                  // Icon(
                                  //   Icons.arrow_forward,
                                  //   color: gMainColor,
                                  //   size: 10.sp,
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const NewScheduleScreen()));
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ImageIcon(
                                    const AssetImage(
                                        "assets/images/new_ds/follow_up.png"),
                                    size: 11.sp,
                                    color: gHintTextColor,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    'Follow-up call',
                                    style: TextStyle(
                                      color: gHintTextColor,
                                      fontSize: headingFont,
                                      decoration: TextDecoration.underline,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: stageData.length,
                      itemBuilder: (_, index) {
                        print("index---> $index $current $selected");

                        if (index < current && selected != index) {
                          print("if");
                          return AnimatedAlign(
                            duration: const Duration(milliseconds: 800),

                            /// added this for click event to the yellow card
                            /// (index+1 == current) ? 0.95
                            heightFactor:
                                (index + 1 == current) ? 0.95 : heightFactor,
                            alignment: Alignment.topCenter,
                            child: bigCard(
                              title: stageData[index].title,
                              subText: stageData[index].subTitle,
                              image: stageData[index].rightImage,
                              steps: stageData[index].step,
                              index: index,
                              btn1Name: stageData[index].btn1Name,
                              btn2Name: stageData[index].btn2Name,
                              btn3Name: stageData[index].btn3Name,
                              type: stageData[index].type,
                              bgColor: stageData[index].bgColor,
                              btn1Color: stageData[index].btn1Color,
                              btn2Color: stageData[index].btn2Color,
                              btn3Color: stageData[index].btn3Color,
                            ),
                          );
                        } else if (index == current) {
                          print("else if1");
                          print("${stageData[index].title}");
                          return Column(
                            children: [
                              /// up arrow when drag
                              /// this is not using
                              AnimatedSize(
                                duration: const Duration(milliseconds: 500),
                                child: SizedBox(
                                  height: (selected == current - 1 &&
                                          heightFactor == 0.20)
                                      ? 0
                                      : 40,
                                  child: Visibility(
                                    visible: heightFactor == 1.0,
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            heightFactor = 0.20;
                                          });
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.amber),
                                          child: Center(
                                            child: SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: Image.asset(
                                                  "assets/images/dashboard_stages/up_arrow.png",
                                                  fit: BoxFit.scaleDown,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              /// bottom 1st card after yellow card
                              Visibility(
                                visible: heightFactor != 1.0,
                                child: Align(
                                  heightFactor: 0.7,
                                  alignment: Alignment.topRight,
                                  child: smallCard(
                                    stageData[index].title,
                                    stageData[index].subTitle,
                                    stageData[index].rightImage,
                                    stageData[index].step,
                                  ),
                                ),
                              )
                            ],
                          );
                        } else if (index == selected) {
                          print("else if2");
                          return AnimatedAlign(
                            duration: const Duration(milliseconds: 800),
                            heightFactor: 1,
                            alignment: Alignment.topCenter,
                            child: bigCard(
                                title: stageData[index].title,
                                subText: stageData[index].subTitle,
                                image: stageData[index].rightImage,
                                steps: stageData[index].step,
                                index: index,
                                btn1Name: stageData[index].btn1Name,
                                btn2Name: stageData[index].btn2Name,
                                btn3Name: stageData[index].btn3Name,
                                type: stageData[index].type,
                                bgColor: stageData[index].bgColor,
                                btn1Color: stageData[index].btn1Color,
                                btn2Color: stageData[index].btn2Color,
                                btn3Color: stageData[index].btn3Color,
                                showCard: stageData[index].showCard),
                          );
                        } else if (index > selected && index < current) {
                          print("else if3");
                          return AnimatedAlign(
                            duration: const Duration(milliseconds: 800),
                            heightFactor: 0.7,
                            alignment: Alignment.topRight,
                            child: bigCard(
                                title: stageData[index].title,
                                subText: stageData[index].subTitle,
                                image: stageData[index].rightImage,
                                steps: stageData[index].step,
                                index: index,
                                btn1Name: stageData[index].btn1Name,
                                btn2Name: stageData[index].btn2Name,
                                btn3Name: stageData[index].btn3Name,
                                type: stageData[index].type,
                                showCard: stageData[index].showCard),
                          );
                        } else {
                          /// last item
                          print(
                              "else small index: $index ${stageData[index].title}");
                          return Visibility(
                            // visible: heightFactor != 1.0,
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 800),
                              heightFactor: 0.7,
                              alignment: Alignment.topCenter,
                              child: smallCard(
                                stageData[index].title,
                                stageData[index].subTitle,
                                stageData[index].rightImage,
                                stageData[index].step,
                              ),
                            ),
                          );
                        }
                      })
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  bool isInAppCallPressed = false;

  /// this will be showing when support call icon pressed
  showSupportCallSheet(BuildContext context) {
    return AppConfig().showSheet(
        context,
        StatefulBuilder(builder: (_, setstate) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Please Select Call Type",
                  style: TextStyle(
                      fontSize: bottomSheetHeadingFontSize,
                      fontFamily: bottomSheetHeadingFontFamily,
                      height: 1.4),
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
              SizedBox(height: 1.5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (isInAppCallPressed)
                        ? null
                        : () async {
                            setstate(() {
                              isInAppCallPressed = true;
                            });
                            final res = await callSupport();
                            if (res.runtimeType != ErrorModel) {
                              AppConfig().showSnackbar(context,
                                  "Call Initiated. Our success Team will call you soon.");
                            } else {
                              final result = res as ErrorModel;
                              AppConfig().showSnackbar(context,
                                  "You can call your Success Team Member once you book your appointment",
                                  isError: true, bottomPadding: 50);
                            }
                            setState(() {
                              isInAppCallPressed = false;
                            });
                            Navigator.pop(context);
                          },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
                      decoration: BoxDecoration(
                          color: gsecondaryColor,
                          border: Border.all(color: kLineColor, width: 0.5),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "In App Call",
                        style: TextStyle(
                          fontFamily: kFontMedium,
                          color: gWhiteColor,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Visibility(
                    visible: false,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        if (_pref!.getString(AppConfig.KALEYRA_SUCCESS_ID) ==
                            null) {
                          AppConfig().showSnackbar(
                              context, "Success Team Not available",
                              isError: true);
                        } else {
                          // // click-to-call
                          // callSupport();

                          if (_pref!
                                  .getString(AppConfig.KALEYRA_ACCESS_TOKEN) !=
                              null) {
                            final accessToken = _pref!
                                .getString(AppConfig.KALEYRA_ACCESS_TOKEN);
                            final uId =
                                _pref!.getString(AppConfig.KALEYRA_USER_ID);
                            final successId =
                                _pref!.getString(AppConfig.KALEYRA_SUCCESS_ID);
                            // voice- call
                            supportVoiceCall(uId!, successId!, accessToken!);
                          } else {
                            AppConfig().showSnackbar(
                                context, "Something went wrong!!",
                                isError: true);
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                            color: gWhiteColor,
                            border: Border.all(color: kLineColor, width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "Voice Call",
                          style: TextStyle(
                            fontFamily: kFontMedium,
                            color: gsecondaryColor,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h)
            ],
          );
        }),
        bottomSheetHeight: 40.h,
        isDismissible: true,
        isSheetCloseNeeded: true,
        sheetCloseOnTap: () {
          Navigator.pop(context);
        });
  }

  int selected = -1;

  /// opened and current stage cards
  bigCard(
      {required String title,
      required String subText,
      required String image,
      required String steps,
      required int index,
      String? btn1Name,
      String? btn2Name,
      String? btn3Name,
      required StageType type,
      Color? bgColor,
      Color? btn1Color,
      Color? btn2Color,
      Color? btn3Color,
      bool? showCard}) {
    print("INDEX : $index == $current  ${heightFactor}");
    return GestureDetector(
      onTap: (heightFactor == 1.0)
          ? null
          : () {
              print("ontap $index");
              setState(() {
                selected = index;
              });
            },
      child: Stack(
        children: [
          GestureDetector(
            // onVerticalDragUpdate: (heightFactor == 1.0)
            //     ? null
            //     : (details) {
            //   print("drag");
            //   print(details.delta);
            //   print(details.localPosition);
            //
            //   heightFactor = 1.0;
            //   setState(() {});
            // },
            child: IntrinsicHeight(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 150,
                ),
                width: double.maxFinite,
                // height: MediaQuery.of(context).size.width <= 400 ? 180 : 220,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: (bgColor != null)
                        ? bgColor
                        : index == current - 1
                            ? newCurrentStageColor
                            : newCompletedStageColor,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(100), blurRadius: 10)
                    ]),
                margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 1.5.h),
                                Text(
                                  title,
                                  style: TextStyle(
                                      height: 1.2,
                                      fontFamily: eUser().mainHeadingFont,
                                      color: eUser().mainHeadingColor,
                                      fontSize: 13.sp),
                                ),
                                SizedBox(height: 0.5.h),
                                Flexible(
                                  child: Text(
                                    subText,
                                    style: TextStyle(
                                        height: 1.3,
                                        fontFamily: kFontBook,
                                        color: eUser().mainHeadingColor,
                                        fontSize: 10.5.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (btn1Name != null)
                                buildButton(
                                    btn1Name ?? '',
                                    (btn1Color != null)
                                        ? btn1Color
                                        : index == current - 1
                                            ? newCurrentStageButtonColor
                                            : newCompletedStageBtnColor,
                                    1,
                                    type),
                              SizedBox(
                                width: 8,
                              ),
                              if (btn2Name != null)
                                buildButton(
                                    btn2Name,
                                    (btn2Color != null)
                                        ? btn2Color
                                        : index == current - 1
                                            ? newCurrentStageButtonColor
                                            : newCompletedStageBtnColor,
                                    2,
                                    type),
                              SizedBox(
                                width: 8,
                              ),
                              if (btn3Name != null)
                                buildButton(
                                    btn3Name,
                                    (btn3Color != null)
                                        ? btn3Color
                                        : index == current - 1
                                            ? newCurrentStageButtonColor
                                            : newCompletedStageBtnColor,
                                    3,
                                    type)
                            ],
                          ),
                          if (btn1Name == null &&
                              btn2Name == null &&
                              btn3Name == null)
                            SizedBox(
                              height: 20,
                            )
                        ],
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Image.asset(
                      image,
                      height: 7.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 8.w,
            top: 1.1.h,
            child: Container(
              height: 3.h,
              width: 15.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: index == current - 1
                      ? const AssetImage(
                          "assets/images/dashboard_stages/Group 76451.png")
                      : const AssetImage(
                          "assets/images/dashboard_stages/Group 76452.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: Text(
                  "Step $steps",
                  style: TextStyle(
                    fontFamily: (index == current - 1)
                        ? kFontSensaBrush
                        : eUser().userFieldLabelFont,
                    color: eUser().threeBounceIndicatorColor,
                    fontSize: (index == current - 1) ? 10.sp : 7.sp,
                  ),
                ),
              ),
            ),
          ),
          index == current - 1
              ? Positioned(
                  left: 35.w,
                  right: 35.w,
                  top: 1.2.h,
                  child: Container(
                    height: 3.h,
                    // width: 2.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: index == current - 1
                            ? const AssetImage(
                                "assets/images/dashboard_stages/Group 76450.png")
                            : const AssetImage(
                                "assets/images/dashboard_stages/Group 76453.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Your Current Stage",
                        style: TextStyle(
                          fontFamily: eUser().userFieldLabelFont,
                          color: eUser().threeBounceIndicatorColor,
                          fontSize: 7.sp,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  /// locked bottom cards
  smallCard(
    String title,
    String subText,
    String image,
    String steps,
  ) {
    return Stack(
      children: [
        Container(
          height: 130,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
            ],
          ),
          child: Opacity(
            opacity: 0.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 1.5.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                height: 1.2,
                                fontFamily: eUser().mainHeadingFont,
                                color: eUser().mainHeadingColor,
                                fontSize: 11.sp),
                          ),
                          SizedBox(width: 2.w),
                          Image(
                            image: const AssetImage(
                              newDashboardLockIcon,
                            ),
                            color: newCurrentStageButtonColor,
                            height: 1.8.h,
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: RichText(
                          textAlign: TextAlign.start,
                          textScaleFactor: 0.85,
                          maxLines: 2,
                          text: TextSpan(children: [
                            TextSpan(
                              text: subText.substring(
                                      0,
                                      int.parse(
                                          "${(subText.length * 0.308).toInt()}")) +
                                  "...",
                              style: TextStyle(
                                  height: 1.3,
                                  fontFamily: kFontBook,
                                  color: eUser().mainHeadingColor,
                                  fontSize: bottomSheetSubHeadingSFontSize),
                            ),
                            WidgetSpan(
                              child: InkWell(
                                  mouseCursor: SystemMouseCursors.click,
                                  onTap: () {},
                                  child: Text(
                                    "more",
                                    style: TextStyle(
                                        height: 1.3,
                                        fontFamily: kFontBook,
                                        color: gsecondaryColor,
                                        fontSize:
                                            bottomSheetSubHeadingSFontSize),
                                  )),
                            )
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                Image.asset(
                  image,
                  height: 5.h,
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 8.w,
          top: 0.2.h,
          child: Container(
            height: 3.h,
            width: 15.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/dashboard_stages/Group 75370.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: Text(
                "Step $steps",
                style: TextStyle(
                  fontFamily: eUser().userFieldLabelFont,
                  color: eUser().threeBounceIndicatorColor,
                  fontSize: 7.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// button widget
  buildButton(String title, Color color, int buttonId, StageType stageType) {
    return Flexible(
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: () {
          handleButtonOnTapByType(stageType, buttonId);
        },
        child: Container(
          constraints: BoxConstraints(maxWidth: 40.w, minWidth: 28.w),
          height: 5.h,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.7.h),
          margin: EdgeInsets.symmetric(
            vertical: 1.4.h,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: color,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
            ],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: kFontMedium,
                color: gWhiteColor,
                fontSize: 9.5.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isShown = false;

  /*
   start ****  Meal Ready sheet functions which r not using Now
   */
  // this is used to show on meal_plan_completed stage to get accept from customer
  // now we r not using this
  mealPlanCompleteSheet() {
    Future.delayed(Duration(seconds: 0)).whenComplete(() {
      if (shippingStage == 'meal_plan_completed') {
        if (!isShown) {
          setState(() {
            isShown = true;
          });
        }
        mealReadySheet();
      }
    });
  }
  // this is used to show on meal_plan_completed stage to get accept from customer
  // now we r not using this
  mealReadySheet() {
    // addUrlToVideoPlayer(_gutShipDataModel?.value ?? '');
    addUrlToVideoPlayerChewie(_gutShipDataModel?.stringValue ?? '');
    return AppConfig().showSheet(
        context,
        WillPopScope(
            child: Column(
              children: [
                Text(
                  'Hooray!\nYour food prescription is ready',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.4,
                      fontSize: bottomSheetSubHeadingXLFontSize,
                      fontFamily: bottomSheetSubHeadingBoldFont,
                      color: gTextColor),
                ),
                // need ot show Video
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: buildMealVideo(),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 8),
                //   child: Image.asset('assets/images/meal_popup.png',
                //     fit: BoxFit.scaleDown,
                //     width: 60.w,
                //     filterQuality: FilterQuality.high,
                //   ),
                // ),
                Text(
                  "You've Unlocked The Next Step!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.2,
                      fontSize: bottomSheetSubHeadingXLFontSize,
                      fontFamily: bottomSheetSubHeadingMediumFont,
                      color: gTextColor),
                ),
                Text(
                  "The Product Kit Is Ready. Shall We Ship It For You?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.2,
                      fontSize: bottomSheetSubHeadingXLFontSize,
                      fontFamily: bottomSheetSubHeadingBookFont,
                      color: gTextColor),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (isPressed)
                          ? () {}
                          : () {
                        Navigator.pop(context);
                        sendApproveStatus('yes');
                        setState(() {
                          isShown = false;
                        });
                        disposePlayer();
                        if (isMealProgressOpened) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.5.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                            color: gsecondaryColor,
                            border: Border.all(color: kLineColor, width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "YES",
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
                      onTap: (isPressed)
                          ? () {}
                          : () {
                        Navigator.pop(context);
                        sendApproveStatus('no');
                        setState(() {
                          isShown = false;
                        });
                        disposePlayer();
                        if (isMealProgressOpened) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.5.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                            color: gWhiteColor,
                            border: Border.all(color: kLineColor, width: 0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "NO",
                          style: TextStyle(
                            fontFamily: kFontMedium,
                            color: gsecondaryColor,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
            onWillPop: () async {
              disposePlayer();
              return Future.value(true);
            }),
        isDismissible: true,
        bottomSheetHeight: 75.h);
  }

  bool isSendApproveStatus = false;
  bool isPressed = false;

  sendApproveStatus(String status) async {
    if (!isSendApproveStatus) {
      setState(() {
        isSendApproveStatus = true;
        isPressed = true;
      });
      print("isPressed: $isPressed");
      final res = await ShipTrackService(repository: shipTrackRepository)
          .sendSippingApproveStatusService(status);

      if (res.runtimeType == ShippingApproveModel) {
        ShippingApproveModel model = res as ShippingApproveModel;
        print('success: ${model.message}');
        AppConfig().showSnackbar(context, model.message!);
        getData();
      } else {
        ErrorModel model = res as ErrorModel;
        print('error: ${model.message}');
        AppConfig().showSnackbar(context, model.message!);
      }
      setState(() {
        isPressed = false;
      });
    }
  }

  addUrlToVideoPlayerChewie(String url) async {
    print("url" + url);
    videoPlayerController =
        VideoPlayerController.network(Uri.parse(url).toString());
    _chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        showOptions: false,
        autoPlay: true,
        // customControls: Center(
        //   child: FittedBox(
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         IconButton(
        //           onPressed: () => _seekRelative(_seekStepBackward),
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: Icon(Icons.replay_10),
        //         ),
        //         IconButton(
        //           onPressed: (){
        //             if(videoPlayerController!.value.isPlaying){
        //               videoPlayerController!.pause();
        //             }
        //             else{
        //               videoPlayerController!.play();
        //             }
        //             setState(() {
        //
        //             });
        //           },
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: (videoPlayerController!.value.isPlaying) ? Icon(Icons.pause)  : Icon(Icons.play_arrow),
        //         ),
        //         IconButton(
        //           onPressed: () => _seekRelative(_seekStepForward),
        //           color: Colors.white,
        //           iconSize: 16,
        //           icon: Icon(Icons.forward_10),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        hideControlsTimer: Duration(seconds: 3),
        showControls: false);
    if (!await Wakelock.enabled) {
      Wakelock.enable();
    }
  }

  buildMealVideo() {
    if (_chewieController != null) {
      return AspectRatio(
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
              child: OverlayVideo(
                isControlsVisible: false,
                controller: _chewieController!,
              ),
            ),
          ),
          // child: Stack(
          //   children: <Widget>[
          //     ClipRRect(
          //       borderRadius: BorderRadius.circular(5),
          //       child: Center(
          //         child: VlcPlayer(
          //           controller: _videoPlayerController!,
          //           aspectRatio: 16 / 9,
          //           virtualDisplay: false,
          //           placeholder: Center(child: CircularProgressIndicator()),
          //         ),
          //       ),
          //     ),
          //     ControlsOverlay(controller: _videoPlayerController,)
          //   ],
          // ),
        ),
      );
    }
    // else if (_mealPlayerController != null) {
    //   return AspectRatio(
    //     aspectRatio: 16 / 9,
    //     child: Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(5),
    //         border: Border.all(color: gPrimaryColor, width: 1),
    //         // boxShadow: [
    //         //   BoxShadow(
    //         //     color: Colors.grey.withOpacity(0.3),
    //         //     blurRadius: 20,
    //         //     offset: const Offset(2, 10),
    //         //   ),
    //         // ],
    //       ),
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.circular(5),
    //         child: Center(
    //           child: VlcPlayerWithControls(
    //             key: _key,
    //             controller: _mealPlayerController!,
    //             showVolume: false,
    //             showVideoProgress: false,
    //             seekButtonIconSize: 10.sp,
    //             playButtonIconSize: 14.sp,
    //             replayButtonSize: 10.sp,
    //           ),
    //           // child: VlcPlayer(
    //           //   controller: _videoPlayerController!,
    //           //   aspectRatio: 16 / 9,
    //           //   virtualDisplay: false,
    //           //   placeholder: Center(child: CircularProgressIndicator()),
    //           // ),
    //         ),
    //       ),
    //       // child: Stack(
    //       //   children: <Widget>[
    //       //     ClipRRect(
    //       //       borderRadius: BorderRadius.circular(5),
    //       //       child: Center(
    //       //         child: VlcPlayer(
    //       //           controller: _videoPlayerController!,
    //       //           aspectRatio: 16 / 9,
    //       //           virtualDisplay: false,
    //       //           placeholder: Center(child: CircularProgressIndicator()),
    //       //         ),
    //       //       ),
    //       //     ),
    //       //     ControlsOverlay(controller: _videoPlayerController,)
    //       //   ],
    //       // ),
    //     ),
    //   );
    // }
    else {
      return SizedBox.shrink();
    }
  }
  // till here
  /*

  ******* end of meal ready sheet functions **************
   */

  disposePlayer() async {
    if (_chewieController != null) _chewieController!.dispose();
    if (videoPlayerController != null) videoPlayerController!.dispose();

    // if (_mealPlayerController != null) {
    //   _mealPlayerController!.dispose();
    // }
    if (await Wakelock.enabled) {
      Wakelock.disable();
    }

    if (videoPlayerController != null) videoPlayerController!.dispose();
    if (_chewieController != null) _chewieController!.dispose();
  }

  /// used to update if there is new stage
  /// once its updated cards will change in ui
  /// Cards-> Total 9 Cards
  /// 0-> Evaluation, 1-> Consultation, 2-> Request Report, 3-> Analysis,
  /// 4-> Medical Report, 5-> Kit Under Process(shipping), 6-> Programs(prep, detox, healing, nourish),
  /// 7-> Post Program consultaion(with feedback), 8-> GMG(Reports)
  void updateNewStage(String? stage) {
    print("consultationStage: ==> ${stage}");
    switch (stage) {
      case 'evaluation_done':
        current = 2;
        stageData[0].subTitle = stageCompletedSubText;

        break;
      case 'pending':
        current = 2;
        stageData[0].subTitle = stageCompletedSubText;
        break;
      case 'consultation_reschedule':
        current = 2;

        final model = _getAppointmentDetailsModel;
        final prevBookingDate = model!.value!.date;
        final prevBookingTime = model!.value!.appointmentStartTime;
        stageData[1].subTitle =
            "You missed your scheduled slot at $prevBookingDate:$prevBookingTime  \n$consultationRescheduleStageSubText";
        stageData[1].btn1Name = "Join";
        stageData[1].btn1Color = newCurrentStageButtonColor.withOpacity(0.6);
        stageData[1].btn2Name = "Reschedule";

        stageData[0].subTitle = stageCompletedSubText;

        break;
      case 'appointment_booked':
        current = 2;

        stageData[0].subTitle = stageCompletedSubText;

        stageData[1].btn1Name = "Join";
        stageData[1].btn2Name = "Reschedule";
        final model = _getAppointmentDetailsModel;

        if (model!.value!.date != null && model.value!.slotStartTime != null) {
          final bookingDate = model!.value!.date;
          final bookingTime = model.value!.slotStartTime!;

          final curTime = DateTime.now();
          var res = DateFormat("yyyy-MM-dd HH:mm:ss")
              .parse("${bookingDate} ${bookingTime}:00");

          if (res.difference(curTime).inMinutes > 5 ||
              res.difference(curTime).inMinutes < -15) {
            stageData[1].btn1Color =
                newCurrentStageButtonColor.withOpacity(0.6);
            print(
                "res.difference(curTime).inMinutes: ${res.difference(curTime).inMinutes}");
            print(res.difference(curTime).inMinutes < -15);

            if (res.difference(curTime).inMinutes < -15) {
              stageData[1].subTitle =
                  "You missed your scheduled slot at $bookingDate:$bookingTime  \n$consultationRescheduleStageSubText";
            } else if (res.difference(curTime).inMinutes > 5) {
              stageData[1].subTitle =
                  "Your consultation has been booked for $bookingDate:$bookingTime \n$consultationStage2SubText";
            }
          } else {
            stageData[1].btn1Color = newCurrentStageButtonColor;
            stageData[1].subTitle =
                "Your consultation has been booked for $bookingDate:$bookingTime \n$consultationStage2SubText";
          }
        }
        break;
      case 'consultation_done':
        current = 2;

        stageData[0].subTitle = stageCompletedSubText;

        stageData[1].btn1Name = "Status";
        stageData[1].btn2Name = null;
        stageData[1].subTitle = consultationStage3SubText;

        break;
      case 'consultation_waiting':
        current = 3;
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;

        stageData[1].btn1Name = "Status";
        // stageData[1].subTitle = consultationStage3SubText;
        stageData[1].btn1Color = newCompletedStageBtnColor;
        stageData[1].btn2Name = null;

        stageData[2].btn1Name = "Upload Report";
        stageData[2].subTitle = requestedReportStage1SubText;
        stageData[2].bgColor = newCurrentStageColor;

        break;
      case 'consultation_accepted':
        // no button for accepted and rejected
        current = 4;

        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;

        stageData[1].btn1Name = "Status";
        // stageData[1].subTitle = consultationStage3SubText;
        stageData[1].btn2Name = null;

        stageData[2].btn1Name = "View User Reports";
        stageData[2].bgColor = newCompletedStageColor;

        stageData[3].btn1Name = "Status";
        stageData[3].subTitle = consultationStage3SubText;

        break;
      case 'check_user_reports':
        current = 3;
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;

        // stageData[1].subTitle = consultationStage3SubText;

        //awaiting-> status
        stageData[2].btn1Name = "Status";
        stageData[2].bgColor = newCurrentStageColor;
        stageData[2].subTitle = requestedReportStage2SubText;

        break;
      case 'consultation_rejected':
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;

        // no button for accepted and rejected
        // stageData[1].subTitle = consultationStage3SubText;
        stageData[1].btn2Name = null;

        current = 5;

        stageData[2].btn1Name = null;
        stageData[2].bgColor = gsecondaryColor;
        stageData[2].subTitle = _gutDataModel?.rejectedCase?.reason ?? '';

        stageData[4].btn1Name = "View MR";
        break;
      case 'report_upload':
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;
        stageData[2].subTitle = requestedReportStage3SubText;

        current = 5;
        print("stageData: ${stageData[2].subTitle}");
        // stageData[0].btn1Name = null;

        stageData[1].btn1Name = "Status";

        stageData[2].btn1Name = "View User Reports";
        stageData[4].btn1Name = "View MR";
        stageData[2].bgColor = newCompletedStageColor;

        break;

      case 'prep_meal_plan_completed':
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;

        if (isMrRead != null && isMrRead == "0") {
          current = 5;
        } else if (isMrRead != null && isMrRead == "1") {
          current = 6;
        }
        stageData[1].btn1Name = "Status";
        stageData[2].btn1Name = "View User Reports";
        stageData[2].subTitle = requestedReportStage3SubText;

        // stageData[3].btn1Name = "Status";
        // stageData[3].subTitle = consultationStage3SubText;

        if (_prepratoryModel!.value!.isPrepratoryStarted == false) {
          // stageData[5].btn1Name = "Prep Plan";
          stageData[5].btn1Name = null;
          stageData[5].btn2Name = null;
        } else {
          stageData[5].btn1Name = null;
          // stageData[5].btn1Name = "Prep";
          stageData[5].subTitle = prepStage2SubText;
          stageData[5].btn2Color = newCurrentStageButtonColor.withOpacity(0.6);
        }

        stageData[3].subTitle = stageCompletedSubText;
        stageData[3].btn1Name = null;

        if (stage == "shipping_delivered") {
          stageData[5].btn1Name = null;
        }

        break;
      case 'meal_plan_completed':
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;

        if (isMrRead != null && isMrRead == "0") {
          current = 5;
        } else if (isMrRead != null && isMrRead == "1") {
          current = 6;
        }
        // current = 6;
        stageData[1].btn1Name = "View History";
        stageData[2].btn1Name = "View User Reports";
        stageData[2].subTitle = requestedReportStage3SubText;
        // stageData[3].btn1Name = "Status";
        // stageData[3].subTitle = consultationStage3SubText;

        // if (_prepratoryModel!.value!.isPrepratoryStarted == false) {
        //   stageData[5].btn1Name = "Start Prep";
        // }

        stageData[5].subTitle = prepStage2SubText;
        stageData[5].btn2Color = newCurrentStageButtonColor;
        stageData[5].btn2Name = "Ship Now";

        break;

      case 'shipping_packed':
        current = 6;
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;

        stageData[1].btn1Name = "View History";
        stageData[2].btn1Name = "View User Reports";
        stageData[2].subTitle = requestedReportStage3SubText;

        // stageData[3].btn1Name = "Status";
        // stageData[3].subTitle = consultationStage3SubText;

        stageData[5].title = "Kit Under Process";
        final _consultationHistory =
            _gutDataModel!.historyWithMrValue!.consultationHistory;
        stageData[5].subTitle =
            "$shippingProcess1 ${_consultationHistory?.shippingDeliveryDate}." +
                '\n' +
                shippingProcess2;

        // stageData[5].subTitle = prepStage3SubText;
        stageData[5].btn2Color = newCurrentStageButtonColor;
        stageData[5].btn2Name = "Track Kit";

        break;
      case 'shipping_paused':
        current = 6;
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;

        stageData[1].btn1Name = "View History";
        stageData[2].btn1Name = "View User Reports";
        stageData[2].subTitle = requestedReportStage3SubText;

        // stageData[3].btn1Name = "Status";
        // stageData[3].subTitle = consultationStage3SubText;

        stageData[5].title = "Kit Under Process";
        final _consultationHistory =
            _gutDataModel!.historyWithMrValue!.consultationHistory;
        stageData[5].subTitle =
            "$shippingProcess1 ${_consultationHistory?.shippingDeliveryDate}." +
                '\n' +
                shippingProcess2;

        // stageData[5].subTitle = prepStage3SubText;
        stageData[5].btn2Color = newCurrentStageButtonColor;
        stageData[5].btn2Name = "Track Kit";

        break;
      case 'shipping_approved':
        current = 6;
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;

        stageData[1].btn1Name = "View History";
        stageData[2].btn1Name = "View User Reports";
        stageData[2].subTitle = requestedReportStage3SubText;

        // stageData[3].btn1Name = "Status";
        // stageData[3].subTitle = consultationStage3SubText;

        stageData[5].title = "Kit Under Process";
        final _consultationHistory =
            _gutDataModel!.historyWithMrValue!.consultationHistory;
        stageData[5].subTitle =
            "$shippingProcess1 ${_consultationHistory?.shippingDeliveryDate}." +
                '\n' +
                shippingProcess2;

        // stageData[5].subTitle = prepStage3SubText;
        stageData[5].btn2Color = newCurrentStageButtonColor;
        stageData[5].btn2Name = "Track Kit";

        break;
      case 'shipping_delivered':
        current = 7;
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;

        stageData[1].btn1Name = "View History";
        stageData[2].btn1Name = "View User Reports";
        stageData[2].subTitle = requestedReportStage3SubText;

        // stageData[3].btn1Name = "Status";
        // stageData[3].subTitle = consultationStage3SubText;

        stageData[5].title = "Kit Under Process";

        // final _consultationHistory = _gutDataModel!.historyWithMrValue!.consultationHistory;
        // stageData[5].subTitle = "$shippingProcess1${_consultationHistory?.shippingDeliveryDate}" + '\n' + shippingProcess2;

        stageData[5].btn1Name = null;
        // stageData[5].subTitle = prepStage3SubText;
        stageData[5].btn2Color = newCurrentStageButtonColor;
        stageData[5].btn2Name = "Track Kit";

        if (_prepratoryModel!.value!.isPrepratoryStarted == false) {
          stageData[6].btn1Name = "Start Prep";
        } else if (_prepratoryModel!.value!.isPrepratoryStarted == true) {
          stageData[6].btn1Name = "Prep";
        }
        stageData[6].btn2Name = null;
        // stageData[6].btn2Name = "Start Program";
        stageData[6].btn1Color = newCurrentStageButtonColor;
        stageData[6].btn2Color = newCurrentStageButtonColor.withOpacity(0.6);

        break;
      case 'start_program':
        current = 7;

        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;
        stageData[5].subTitle = stageCompletedSubText;

        stageData[1].btn1Name = "View History";
        stageData[2].btn1Name = "View User Reports";
        stageData[2].subTitle = requestedReportStage3SubText;

        // stageData[3].btn1Name = "Status";
        // stageData[3].subTitle = consultationStage3SubText;

        stageData[5].btn1Name = null;

        stageData[5].btn2Color = null;

        if (_prepratoryModel!.value!.isPrepCompleted == true) {
          stageData[6].btn1Name = null;
          stageData[6].btn2Name = "Prep Tracker";
          stageData[6].btn2Color = newCurrentStageButtonColor;
          stageData[6].subTitle = prepTrackerText;
        }

        _pref!.setBool(AppConfig.isPrepTrackerCompleted,
            _prepratoryModel!.value!.isPrepTrackerCompleted ?? false);

        if (_prepratoryModel!.value!.isPrepTrackerCompleted == true) {
          stageData[6].btn1Name = null;
          stageData[6].btn2Name = "Start Program";
          stageData[6].btn2Color = newCurrentStageButtonColor;
          stageData[6].subTitle = mealStartText;
        }

        print(
            "_gutProgramModel!.value!.startProgram != '0': ${_gutProgramModel!.value!.startProgram != '0'}");

        print(
            "_gutProgramModel!.value!.isDetoxCompleted != '1': ${_gutProgramModel!.value!.isDetoxCompleted != '1'}");

        print(_gutProgramModel!.value!.isDetoxCompleted);

        /// start program text will come 1st time
        /// once started start day1, day2, day3......
        if (_gutProgramModel!.value!.startProgram == '1' &&
            _gutProgramModel!.value!.isDetoxCompleted != '1' &&
            _gutProgramModel!.value!.isDetoxCompleted != 'null') {
          final currentday = _gutProgramModel?.value?.mealCurrentDay;
          stageData[6].btn1Name = (currentday == "0" || currentday == "null") ? "Detox Plan" : "Day $currentday of Detox";
          stageData[6].btn2Name = null;
          stageData[6].subTitle = afterStartProgramText;
        }

        // healing phase
        if (_gutProgramModel!.value!.isDetoxCompleted == "1" &&
            _gutProgramModel!.value!.healingStartProgram != "1") {
          print('callinggg');
          // stageData[6].btn1Name = "Day 1 of Healing";
          stageData[6].btn1Name = "Healing Plan";
          stageData[6].btn2Name = null;
          stageData[6].subTitle = afterStartProgramText;
        }

        if (_gutProgramModel!.value!.healingStartProgram == '1' &&
            _gutProgramModel!.value!.isDetoxCompleted == "1") {
          print("this also called");
          final currentday = _gutProgramModel?.value?.healingCurrentDay;
          stageData[6].btn1Name = (currentday == "0" || currentday == "null") ? "Healing Plan" : "Day $currentday of Healing";
          stageData[6].btn2Name = null;
          stageData[6].subTitle = afterStartProgramText;
        }

        // if (_gutProgramModel!.value!.isHealingCompleted == '1'){
        //   print("this also called");
        //   stageData[6].btn1Name = "Start Nourish";
        //   stageData[6].btn2Name = null;
        //   stageData[6].subTitle = mealTransText;
        // }

        break;
      case 'trans_program':
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;
        stageData[5].subTitle = stageCompletedSubText;

        print("case : trans_program");
        if (_prepratoryModel!.value!.isPrepTrackerCompleted != null &&
            _prepratoryModel!.value!.isPrepTrackerCompleted == true) {
          current = 7;

          final dayNumber = _transModel?.value?.currentDay ?? '';

          if (_transModel!.value!.isTransMealStarted == false) {
            stageData[6].btn1Name = "Start Nourish";
            stageData[6].subTitle = mealTransText;
          } else {
            stageData[6].btn1Name = (dayNumber == "0" || dayNumber == "") ? "Nourish Plan" : "Day $dayNumber of Nourish";
            stageData[6].subTitle = afterStartProgramText;
          }
          stageData[6].btn2Name = null;
        }
        // else {
        //   current = 6;
        //   stageData[5].btn1Name = "Submit Prep Tracker";
        // }
        stageData[1].btn1Name = "View History";
        stageData[2].btn1Name = "View User Reports";
        stageData[2].subTitle = requestedReportStage3SubText;

        // stageData[3].btn1Name = "Status";
        // stageData[3].subTitle = consultationStage3SubText;

        stageData[5].btn1Name = null;

        stageData[5].btn2Color = null;

        break;
      case 'post_program':
        print("post pro");
        current = 8;
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;
        stageData[5].subTitle = stageCompletedSubText;
        stageData[6].subTitle = stageCompletedSubText;

        stageData[1].btn1Name = "View History";
        stageData[2].btn1Name = "View User Reports";
        stageData[2].subTitle = requestedReportStage3SubText;

        // stageData[3].btn1Name = "Status";
        // stageData[3].subTitle = consultationStage3SubText;

        stageData[6].btn1Name = "Completed";
        stageData[6].btn1Color = newCompletedStageBtnColor;

        print(
            "_gutPostProgramModel!.isProgramFeedbackSubmitted: ${_gutPostProgramModel!.isProgramFeedbackSubmitted}");
        if (_gutPostProgramModel!.isProgramFeedbackSubmitted != "1") {
          stageData[7].btn2Color = newCurrentStageButtonColor.withOpacity(0.6);
        } else {
          stageData[7].btn1Name = null;
          stageData[7].btn2Color = newCurrentStageButtonColor;
          stageData[7].subTitle = PpcScheduleText;
        }

        stageData[5].btn2Color = null;
        stageData[5].btn1Name = null;

        break;
      case 'post_appointment_booked':
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;
        stageData[5].subTitle = stageCompletedSubText;
        stageData[6].subTitle = stageCompletedSubText;

        current = 8;
        stageData[1].btn1Name = "View History";
        stageData[2].btn1Name = "View User Reports";
        stageData[2].subTitle = requestedReportStage3SubText;

        // stageData[3].btn1Name = "Status";
        // stageData[3].subTitle = consultationStage3SubText;
        stageData[4].btn1Name = "View MR";

        stageData[5].btn1Name = "Completed";

        stageData[6].btn1Name = "Completed";
        stageData[6].btn1Color = newCompletedStageBtnColor;

        stageData[7].btn1Name = "Join";
        stageData[7].btn2Name = "Reschedule";

        stageData[5].btn2Color = null;
        stageData[5].btn1Name = null;

        final slotDate = _postConsultationAppointment!.value!.date!;
        final slotTime = _postConsultationAppointment!.value!.slotStartTime!;

        final curTime = DateTime.now();
        var res = DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse("${slotDate} ${slotTime}:00");

        stageData[7].subTitle =
            "Your consultation has been booked for $slotDate $slotTime.\n" +
                PpcBookedText;

        if (res.difference(curTime).inMinutes > 5 ||
            res.difference(curTime).inMinutes < -15) {
          stageData[7].btn1Color = newCurrentStageButtonColor.withOpacity(0.6);

          if (res.difference(curTime).inMinutes < -15) {
            stageData[7].subTitle =
                "You missed your scheduled slot at $slotDate:$slotTime";
          }
        } else {
          stageData[7].btn1Color = newCurrentStageButtonColor;
          stageData[7].subTitle =
              "Your consultation has been booked for $slotDate $slotTime.\n" +
                  PpcBookedText;
        }

        break;
      case 'post_appointment_reschedule':
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;
        stageData[5].subTitle = stageCompletedSubText;
        stageData[6].subTitle = stageCompletedSubText;

        current = 8;
        stageData[1].btn1Name = "View History";
        stageData[2].btn1Name = "View User Reports";
        stageData[2].subTitle = requestedReportStage3SubText;

        // stageData[3].btn1Name = "Status";
        // stageData[3].subTitle = consultationStage3SubText;
        stageData[4].btn1Name = "View MR";

        stageData[5].btn1Name = null;

        stageData[6].btn1Name = "Completed";
        stageData[6].btn1Color = newCompletedStageBtnColor;

        stageData[7].btn1Name = null;
        stageData[7].btn2Name = "Reschedule";

        break;
      case 'post_appointment_done':
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;
        stageData[5].subTitle = stageCompletedSubText;
        stageData[6].subTitle = stageCompletedSubText;
        // stageData[7].subTitle = stageCompletedSubText;

        current = 8;

        stageData[1].btn1Name = "View History";
        stageData[2].btn1Name = "View User Reports";
        stageData[2].subTitle = requestedReportStage3SubText;

        stageData[4].btn1Name = "View MR";

        stageData[6].btn1Name = "Completed";
        stageData[6].btn1Color = newCompletedStageBtnColor;

        stageData[7].btn1Name = null;
        stageData[7].btn2Name = null;
        stageData[7].subTitle = ppcAfterConsultationText;

        stageData[5].btn1Name = null;

        stageData[5].btn2Color = null;

        break;
      case 'protocol_guide':
        print("Protcol guide called");
        stageData[0].subTitle = stageCompletedSubText;
        stageData[1].subTitle = stageCompletedSubText;
        stageData[3].subTitle = stageCompletedSubText;
        stageData[5].subTitle = stageCompletedSubText;
        stageData[6].subTitle = stageCompletedSubText;
        stageData[7].subTitle = stageCompletedSubText;

        current = 9;
        stageData[1].btn1Name = "View History";
        stageData[2].btn1Name = "View User Reports";
        stageData[2].subTitle = requestedReportStage3SubText;

        // stageData[3].btn1Name = "Status";
        // stageData[3].subTitle = consultationStage3SubText;
        stageData[4].btn1Name = "View MR";

        stageData[6].btn1Name = "Completed";
        stageData[6].btn1Color = newCompletedStageBtnColor;

        stageData[5].btn2Color = null;
        stageData[5].btn1Name = null;

        stageData[7].btn1Name = null;
        stageData[7].btn2Name = null;

        break;
    }
    setState(() {
      selected = current - 1;
    });
  }

  /// kept 3 buttons on each card
  /// buttonId willgive 1,2,3 onClick of each buttons respectively
  /// based on the buttonId we r adding the click events
  /// type will gives the clicked card stage
  handleButtonOnTapByType(StageType type, int buttonId) {
    print(type);
    switch (type) {
      case StageType.evaluation:
        goToScreen(EvaluationGetDetails());
        break;
      //******* Medical consultation stage Card 2 ******************
      case StageType.med_consultation:
        print("Medical consultation ${buttonId} $consultationStage");
        if (buttonId == 1) {
          switch (consultationStage) {
            case 'evaluation_done':
              goToScreen(DoctorCalenderTimeScreen());
              break;
            case 'pending':
              goToScreen(DoctorCalenderTimeScreen());
              break;
            case 'appointment_booked':
              final model = _getAppointmentDetailsModel;
              _pref!.setString(
                  AppConfig.appointmentId, model?.value?.id.toString() ?? '');
              final curTime = DateTime.now();
              var res = DateFormat("yyyy-MM-dd HH:mm:ss").parse(
                  "${model!.value!.date!} ${model.value!.slotStartTime!}:00");

              /// join button click will work before 5 min to 15 min
              /// after 15min join button will not work
              if (res.difference(curTime).inMinutes > 5 ||
                  res.difference(curTime).inMinutes < -15) {
              } else {
                goToScreen(DoctorSlotsDetailsScreen(
                  bookingDate: model!.value!.date!,
                  bookingTime: model.value!.slotStartTime!,
                  dashboardValueMap: model.value!.toJson(),
                  isFromDashboard: true,
                ));
              }

              break;
            case 'consultation_reschedule':
              AppConfig().showSnackbar(context, "Please Reschedule Appointment",
                  isError: true);
              break;
            case 'consultation_done':
              final _consultationHistory =
                  _gutDataModel!.historyWithMrValue!.consultationHistory;
              goToScreen(ConsultationHistoryScreen(
                consultationHistory: _consultationHistory,
              ));
              break;
            // goToScreen(const ConsultationSuccess());
            // break;
            case 'consultation_accepted':
              final _consultationHistory =
                  _gutDataModel!.historyWithMrValue!.consultationHistory;
              goToScreen(ConsultationHistoryScreen(
                consultationHistory: _consultationHistory,
              ));
              break;
            // goToScreen(const ConsultationSuccess());
            // break;
            case 'consultation_waiting':
              final _consultationHistory =
                  _gutDataModel!.historyWithMrValue!.consultationHistory;
              goToScreen(ConsultationHistoryScreen(
                consultationHistory: _consultationHistory,
              ));
              break;
            case 'consultation_rejected':
              final _consultationHistory =
                  _gutDataModel!.historyWithMrValue!.consultationHistory;
              goToScreen(ConsultationHistoryScreen(
                consultationHistory: _consultationHistory,
              ));
              break;
            // goToScreen(ConsultationRejected(
            //   reason: _gutDataModel?.rejectedCase?.reason ?? '',
            // ));
            // break;
            case 'check_user_reports':
              //   goToScreen(const ConsultationSuccess());
              final _consultationHistory =
                  _gutDataModel!.historyWithMrValue!.consultationHistory;
              goToScreen(ConsultationHistoryScreen(
                consultationHistory: _consultationHistory,
              ));
              break;
            case 'report_upload':
              // show history screen
              final _consultationHistory =
                  _gutDataModel!.historyWithMrValue!.consultationHistory;
              goToScreen(ConsultationHistoryScreen(
                consultationHistory: _consultationHistory,
              ));
              break;
          }
        } else {
          print(consultationStage);
          switch (consultationStage) {
            case 'consultation_reschedule':
              final model = _getAppointmentDetailsModel;

              print(model!.value!.date);
              List<String> doctorNames = [];
              String? doctorName;
              String? doctorImage;

              model.value?.teamMember?.forEach((element) {
                if (element.user != null) {
                  if (element.user!.roleId == "2") {
                    doctorNames.add('Dr. ${element.user!.name}' ?? '');
                    doctorName = 'Dr. ${element.user!.name}';
                    doctorImage = element.user?.profile ?? '';
                  }
                }
              });

              print(model.value!.doctor!.toJson());

              goToScreen(DoctorCalenderTimeScreen(
                isReschedule: true,
                prevBookingDate: model.value!.date,
                prevBookingTime: model.value!.appointmentStartTime,
                doctorDetails: model.value!.doctor,
                doctorName: doctorName,
                doctorPic: doctorImage,
              ));
              break;
            case 'appointment_booked':
              final model = _getAppointmentDetailsModel;

              print(model!.value!.date);
              List<String> doctorNames = [];
              String? doctorName;
              String? doctorImage;

              model.value?.teamMember?.forEach((element) {
                if (element.user != null) {
                  if (element.user!.roleId == "2") {
                    doctorNames.add('Dr. ${element.user!.name}' ?? '');
                    doctorName = 'Dr. ${element.user!.name}';
                    doctorImage = element.user?.profile ?? '';
                  }
                }
              });

              // add this before calling calendertimescreen for reschedule
              // _pref!.setString(AppConfig.appointmentId , '');
              goToScreen(DoctorCalenderTimeScreen(
                isReschedule: true,
                prevBookingDate: model.value!.date,
                prevBookingTime: model.value!.appointmentStartTime,
                doctorDetails: model.value!.doctor,
                doctorName: doctorName,
                doctorPic: doctorImage,
              ));
              break;
            default:
              AppConfig().showSnackbar(context, "Can't access Locked Stage",
                  isError: true);
          }
        }
        break;
      //******* End Medical consultation stage card 2 ******************

      //******* Requested Report stage Card3 ******************

      case StageType.requested_report:
        // print(consultationStage);
        switch (consultationStage) {
          case 'consultation_waiting':
            goToScreen(UploadFiles());
            break;
          case 'check_user_reports':
            goToScreen(CheckUserReportsScreen());
            // goToScreen(UploadFiles(isFromSettings: true,));

            break;
          case 'consultation_accepted':
            goToScreen(UploadFiles(
              isFromSettings: true,
            ));
            break;
          case 'report_upload':
            // new ui need to add here
            goToScreen(UploadFiles(
              isFromSettings: true,
            ));

          // // show history screen
          //   final _consultationHistory = _gutDataModel!.historyWithMrValue!.consultationHistory;
          //   goToScreen(ConsultationHistoryScreen(consultationHistory: _consultationHistory,));
          //   break;
        }
        break;
      //******* End Requested Report stage Card3 ******************

      // ****** there is no buttons in Analysis stage card4 *********

      //******* Medical Report stage Card5******************

      case StageType.medical_report:
        switch (consultationStage) {
          case 'consultation_rejected':
            goToScreen(MedicalReportScreen(
              pdfLink:
                  _gutDataModel?.rejectedCase?.historyWithMrValue?.mr ?? '',
            ));
            break;
          case 'report_upload':
            // print(_gutDataModel!.toJson());
            // print(_gutDataModel!.value);
            // goToScreen(goToScreen(UploadFiles()));
            goToScreen(MedicalReportScreen(
              isMrRead: isMrRead ?? '1',
              pdfLink: _gutDataModel!.historyWithMrValue!.mr!,
            ));
            break;
        }
        break;
      //*******End Medical Report stage Card5******************

      //******* Kit Under Process stage Card6 ******************

      case StageType.prep_meal:
        if (buttonId == 1) {
          showPrepratoryMealScreen(isFromPrepCard: true);
        } else {
          if (shippingStage != null && shippingStage!.isNotEmpty) {
            if (shippingStage == 'meal_plan_completed') {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CookKitTracking(currentStage: shippingStage ?? ''),
                    ),
                  )
                  .then((value) => reloadUI());
            } else if (_shippingApprovedModel != null) {
              print("else if");
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => CookKitTracking(
                        awb_number:
                            _shippingApprovedModel?.value?.awbCode ?? '',
                        currentStage: shippingStage!,
                      ),
                    ),
                  )
                  .then((value) => reloadUI());
            } else {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CookKitTracking(currentStage: shippingStage ?? ''),
                    ),
                  )
                  .then((value) => reloadUI());
            }
          } else {
            AppConfig().showSnackbar(context, "Can't access Locked Stage",
                isError: true);
          }
        }
        break;

      //******* End Kit Under Process stage Card6 ******************

      //******* Gut Reset Program(Prep, detox,healing, Nourish) stage Card7 ******************

      case StageType.normal_meal:
        if (buttonId == 1) {
          if (shippingStage == "shipping_delivered" &&
              _prepratoryModel!.value!.isPrepTrackerCompleted == false) {
            return showPrepratoryMealScreen();
          }
          if (transStage != null && transStage!.isNotEmpty) {
            // showProgramScreen();
            return showTransitionMealScreen();
          } else if (programOptionStage != null &&
              programOptionStage!.isNotEmpty &&
              (_prepratoryModel!.value!.isPrepTrackerCompleted != null &&
                  _prepratoryModel!.value!.isPrepTrackerCompleted == true)) {
            print("called");
            return showProgramScreen();
          } else {
            AppConfig().showSnackbar(context, "Can't access Locked Stage",
                isError: true);
          }
        } else {
          if (shippingStage == "shipping_delivered" &&
              _prepratoryModel!.value!.isPrepTrackerCompleted == false) {
            return showPrepratoryMealScreen();
          } else if (programOptionStage != null &&
              programOptionStage!.isNotEmpty &&
              (_prepratoryModel!.value!.isPrepTrackerCompleted != null &&
                  _prepratoryModel!.value!.isPrepTrackerCompleted == true)) {
            print("called");
            return showProgramScreen();
          }
        }
        break;
      //******* Gut Reset Program(Prep, detox,healing, Nourish) stage Card7 ******************

      //******* Post program Consultation(with Feedback) stage Card8 ******************

      case StageType.post_consultation:
        switch (postProgramStage) {
          case 'post_program':
            if (buttonId == 1) {
              if (postProgramStage == "post_program") {
                if (_gutPostProgramModel!.isProgramFeedbackSubmitted == "1") {
                  AppConfig()
                      .showSnackbar(context, "Feedback Already Submitted");
                } else {
                  goToScreen(MedicalFeedbackForm());
                }
              } else {
                // goToScreen(FinalFeedbackForm());

                AppConfig().showSnackbar(context, "Can't access Locked Stage",
                    isError: true);
              }
            } else {
              if (_gutPostProgramModel!.isProgramFeedbackSubmitted == "1") {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                          builder: (context) => DoctorCalenderTimeScreen(
                                isPostProgram: true,
                              )
                          // PostProgramScreen(postProgramStage: postProgramStage,),
                          ),
                    )
                    .then((value) => reloadUI());
              } else {
                AppConfig().showSnackbar(
                    context, "Please complete the Feedback",
                    isError: true);
              }
            }

            break;
          case 'check_user_reports':
            goToScreen(CheckUserReportsScreen());
            break;
          case 'post_appointment_booked':
            if (buttonId == 1) {
              final curTime = DateTime.now();
              final bookingDate = _postConsultationAppointment!.value!.date!;
              final bookingTime =
                  _postConsultationAppointment!.value!.slotStartTime!;
              var res = DateFormat("yyyy-MM-dd HH:mm:ss")
                  .parse("${bookingDate} ${bookingTime!}:00");

              if (res.difference(curTime).inMinutes > 5 ||
                  res.difference(curTime).inMinutes < -15) {
              } else {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                          builder: (context) => DoctorSlotsDetailsScreen(
                                bookingDate:
                                    _postConsultationAppointment!.value!.date!,
                                bookingTime: _postConsultationAppointment!
                                    .value!.slotStartTime!,
                                isPostProgram: true,
                                dashboardValueMap: _postConsultationAppointment!
                                    .value!
                                    .toJson(),
                              )
                          // PostProgramScreen(postProgramStage: postProgramStage,
                          //   consultationData: _postConsultationAppointment,),
                          ),
                    )
                    .then((value) => reloadUI());
              }
            } else {
              final model = _postConsultationAppointment;
              print(model!.value!.date);
              List<String> doctorNames = [];
              String? doctorName;
              String? doctorImage;

              model.value?.teamMember?.forEach((element) {
                if (element.user != null) {
                  if (element.user!.roleId == "2") {
                    doctorNames.add('Dr. ${element.user!.name}' ?? '');
                    doctorName = 'Dr. ${element.user!.name}';
                    doctorImage = element.user?.profile ?? '';
                  }
                }
              });

              // add this before calling calendertimescreen for reschedule
              // _pref!.setString(AppConfig.appointmentId , '');
              goToScreen(DoctorCalenderTimeScreen(
                isReschedule: true,
                isPostProgram: true,
                prevBookingDate: model.value!.date,
                prevBookingTime: model.value!.appointmentStartTime,
                doctorDetails: model.value!.doctor,
                doctorName: doctorName,
                doctorPic: doctorImage,
              ));
            }
            break;
          case 'post_appointment_done':
            break;
          case 'post_appointment_reschedule':
            if (buttonId == 1) {
              //none
              AppConfig().showSnackbar(context, "Can't access Locked Stage",
                  isError: true);
            } else if (buttonId == 2) {
              final model = _postConsultationAppointment;
              print(model);
              // if(model.value != null){
              //   print(model!.value!.date);
              // }
              List<String> doctorNames = [];
              String? doctorName;
              String? doctorImage;

              model?.value?.teamMember?.forEach((element) {
                if (element.user != null) {
                  if (element.user!.roleId == "2") {
                    doctorNames.add('Dr. ${element.user!.name}' ?? '');
                    doctorName = 'Dr. ${element.user!.name}';
                    doctorImage = element.user?.profile ?? '';
                  }
                }
              });

              _pref!.setString(
                  AppConfig.appointmentId, model?.value?.id.toString() ?? '');

              // add this before calling calendertimescreen for reschedule
              // _pref!.setString(AppConfig.appointmentId , '');
              goToScreen(DoctorCalenderTimeScreen(
                isReschedule: true,
                isPostProgram: true,
                prevBookingDate: model?.value!.date,
                prevBookingTime: model?.value!.appointmentStartTime,
                doctorDetails: model?.value!.doctor,
                doctorName: doctorName,
                doctorPic: doctorImage,
              ));
            }
            break;
        }
        break;
      //******* End Post program Consultation(with Feedback) stage Card8 ******************

      //******* GMG stage Card9 ******************
      // showing gmg and wnd report
      case StageType.gmg:
        if (buttonId == 1) {
          if (postProgramStage == "protocol_guide") {
            if (_postConsultationAppointment!.value != null) {
              if (_postConsultationAppointment!.value!.gmgPdfUrl != null &&
                  _postConsultationAppointment!.value!.gmgPdfUrl!.isNotEmpty) {
                goToScreen(ProtocolGuideDetails(
                  pdfLink: _postConsultationAppointment!.value!.gmgPdfUrl!,
                  heading: "GMG",
                  headCircleIcon: bsHeadPinIcon,
                  isSheetCloseNeeded: true,
                ));
              } else {
                AppConfig()
                    .showSnackbar(context, "GMG Url is Empty", isError: true);
              }
            }
          } else {
            // goToScreen(FinalFeedbackForm());

            AppConfig().showSnackbar(context, "Can't access Locked Stage",
                isError: true);
          }
        }
        else if (buttonId == 2) {
          if (postProgramStage == "protocol_guide") {
            if (_postConsultationAppointment!.value != null) {
              if (_postConsultationAppointment!.value!.programEndReportUser !=
                      null &&
                  _postConsultationAppointment!
                      .value!.programEndReportUser!.isNotEmpty) {
                goToScreen(ProtocolGuideDetails(
                  pdfLink: _postConsultationAppointment!
                      .value!.programEndReportUser!,
                  heading: "User EndReport",
                  headCircleIcon: bsHeadPinIcon,
                  isSheetCloseNeeded: true,
                ));
              } else {
                AppConfig().showSnackbar(context, "User EndReport is Empty",
                    isError: true);
              }
            }
          } else {
            // goToScreen(FinalFeedbackForm());

            AppConfig().showSnackbar(context, "Can't access Locked Stage",
                isError: true);
          }
        }
        else {
          showPostProgramScreen();
        }
        break;
      case StageType.analysis:
        // TODO: Handle this case.
        print(consultationStage);
        if (buttonId == 1) {
          switch (consultationStage) {
            case 'consultation_accepted':
              final _consultationHistory =
                  _gutDataModel!.historyWithMrValue!.consultationHistory;
              goToScreen(ConsultationHistoryScreen(
                consultationHistory: _consultationHistory,
                stageType: type,
              ));
              break;
            // goToScreen(const ConsultationSuccess());
            // break;
            case 'consultation_waiting':
              final _consultationHistory =
                  _gutDataModel!.historyWithMrValue!.consultationHistory;
              goToScreen(ConsultationHistoryScreen(
                consultationHistory: _consultationHistory,
              ));
              break;
            case 'consultation_rejected':
              final _consultationHistory =
                  _gutDataModel!.historyWithMrValue!.consultationHistory;
              goToScreen(ConsultationHistoryScreen(
                consultationHistory: _consultationHistory,
              ));
              break;
            // goToScreen(ConsultationRejected(
            //   reason: _gutDataModel?.rejectedCase?.reason ?? '',
            // ));
            // break;
            case 'check_user_reports':
              //   goToScreen(const ConsultationSuccess());
              final _consultationHistory =
                  _gutDataModel!.historyWithMrValue!.consultationHistory;
              goToScreen(ConsultationHistoryScreen(
                consultationHistory: _consultationHistory,
              ));
              break;
            case 'report_upload':
              // show history screen
              final _consultationHistory =
                  _gutDataModel!.historyWithMrValue!.consultationHistory;
              goToScreen(ConsultationHistoryScreen(
                consultationHistory: _consultationHistory,
              ));
              break;
          }
        }

        break;
    }
  }



  showPrepratoryMealScreen({bool isFromPrepCard = false}) {
    if (_prepratoryModel != null) {
      print(_prepratoryModel!.value!.toJson());
      print("BOOL : ${_prepratoryModel!.value!.isPrepratoryStarted}");

      // slide to program  if not started
      if (_prepratoryModel!.value!.isPrepratoryStarted == false &&
          !isFromPrepCard) {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => ProgramPlanScreen(
                  from: ProgramMealType.prepratory.name,
                  videoLink: _prepratoryModel?.value?.startVideo ?? "",
                ),
              ),
            )
            .then((value) => reloadUI());
      }
      else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => (_prepratoryModel!.value!.isPrepCompleted!)
                  ? const PrepratoryMealCompletedScreen()
                  : CombinedPrepMealTransScreen(stage: 0)),
        ).then((value) => reloadUI());
      }
    }
  }

  /// ProgramPlanScreen-> start program screen
  /// we r showing ProgramPlanScreen when isTransMealStarted is false
  showTransitionMealScreen() {
    if (_transModel != null) {
      if (_transModel!.value!.isTransMealStarted == false) {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => ProgramPlanScreen(
                  from: ProgramMealType.transition.name,
                  videoLink: _transModel?.value?.startVideo ?? "",
                ),
              ),
            )
            .then((value) => reloadUI());
      }
      else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CombinedPrepMealTransScreen(
                    stage: 3,
                    postProgramStage: postProgramStage,
                  )
              ),
        ).then((value) => reloadUI());
      }
    }
  }

  /// when user click on meal plan if still prep not completed than
  /// in meal slide to start need to show prep form submit
  /// in meal slide to start need to show prep form submit
  /// if already submitted than normal ui
  showProgramScreen() {
    print("func called");
    if (shippingStage == "shipping_delivered" && programOptionStage != null) {
      // to slide to start the program
      if (_gutProgramModel!.value!.recipeVideo != null) {
        _pref!.setString(
            AppConfig().receipeVideoUrl, _gutProgramModel!.value!.recipeVideo!);
      }
      if (_gutProgramModel!.value!.tracker_video_url != null) {
        _pref!.setString(AppConfig().trackerVideoUrl,
            _gutProgramModel!.value!.tracker_video_url!);
      }
      if (_gutProgramModel!.value!.startProgram != '1' ||
          (_gutProgramModel!.value!.healingStartProgram == '0' ||
              _gutProgramModel!.value!.healingStartProgram == 'null' &&
                  _gutProgramModel!.value!.isDetoxCompleted == '1')) {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (context) => ProgramPlanScreen(
                  from: (_gutProgramModel!.value!.startProgram == "1" &&
                          _gutProgramModel!.value!.isDetoxCompleted == "1")
                      ? ProgramMealType.healing.name
                      : ProgramMealType.detox.name,
                  // videoLink: _gutProgramModel?.value?.startVideoUrl ?? "",
                  isPrepCompleted: _prepratoryModel!.value!.isPrepCompleted,
                ),
              ),
            )
            .then((value) => reloadUI());
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CombinedPrepMealTransScreen(
                  stage: (_gutProgramModel!.value!.startProgram == "1" &&
                          _gutProgramModel!.value!.isDetoxCompleted == "1")
                      ? 2
                      : 1)
              // MealPlanScreen(
              // transStage: transStage,
              // receipeVideoLink: _gutProgramModel!.value!.recipeVideo,
              // trackerVideoLink: _gutProgramModel!.value!.tracker_video_url
              // ),
              ),
        ).then((value) => reloadUI());
      }
    } else {
      AppConfig()
          .showSnackbar(context, "program stage not getting", isError: true);
    }
  }

  // PPLevelsDemo not using Now
  showPostProgramScreen() {
    if (postProgramStage != null) {
      if (postProgramStage == "protocol_guide") {
        // goToScreen(PPLevelsScreen());
        goToScreen(PPLevelsDemo());
      } else {
        AppConfig()
            .showSnackbar(context, "Can't access Locked Stage", isError: true);
      }
    }
  }

  handleTrackerRemedyOnTap() {
    goToScreen(HomeRemediesScreen());
  }
}
