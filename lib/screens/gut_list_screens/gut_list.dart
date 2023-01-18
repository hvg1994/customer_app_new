import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gwc_customer/model/dashboard_model/get_appointment/get_appointment_after_appointed.dart';
import 'package:gwc_customer/model/dashboard_model/get_dashboard_data_model.dart';
import 'package:gwc_customer/model/dashboard_model/get_program_model.dart';
import 'package:gwc_customer/model/dashboard_model/gut_model/gut_data_model.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/repository/dashboard_repo/gut_repository/dashboard_repository.dart';
import 'package:gwc_customer/repository/login_otp_repository.dart';
import 'package:gwc_customer/screens/appointment_screens/consultation_screens/consultation_rejected.dart';
import 'package:gwc_customer/screens/appointment_screens/consultation_screens/upload_files.dart';
import 'package:gwc_customer/screens/evalution_form/evaluation_get_details.dart';
import 'package:gwc_customer/screens/evalution_form/personal_details_screen.dart';
import 'package:gwc_customer/screens/gut_list_screens/meal_popup.dart';
import 'package:gwc_customer/screens/notification_screen.dart';
import 'package:gwc_customer/screens/post_program_screens/new_post_program/pp_levels_screen.dart';
import 'package:gwc_customer/screens/post_program_screens/post_program_screen.dart';
import 'package:gwc_customer/screens/profile_screens/call_support_method.dart';
import 'package:gwc_customer/screens/program_plans/meal_plan_screen.dart';
import 'package:gwc_customer/screens/program_plans/program_start_screen.dart';
import 'package:gwc_customer/services/dashboard_service/gut_service/dashboard_data_service.dart';
import 'package:gwc_customer/services/login_otp_service.dart';
import 'package:gwc_customer/services/quick_blox_service/quick_blox_service.dart';
import 'package:gwc_customer/services/shipping_service/ship_track_service.dart';
import 'package:gwc_customer/utils/program_stages_enum.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../model/dashboard_model/shipping_approved/ship_approved_model.dart';
import '../../model/profile_model/user_profile/user_profile_model.dart';
import '../../model/ship_track_model/sipping_approve_model.dart';
import '../../repository/api_service.dart';
import '../../repository/profile_repository/get_user_profile_repo.dart';
import '../../repository/shipping_repository/ship_track_repo.dart';
import '../../services/profile_screen_service/user_profile_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/open_alert_box.dart';
import '../appointment_screens/consultation_screens/consultation_success.dart';
import '../appointment_screens/consultation_screens/medical_report_screen.dart';
import '../appointment_screens/doctor_slots_details_screen.dart';
import '../cook_kit_shipping_screens/cook_kit_tracking.dart';
import '../program_plans/day_program_plans.dart';
import 'List/list_view_effect.dart';
import 'package:gwc_customer/screens/appointment_screens/doctor_calender_time_screen.dart';
import 'package:http/http.dart' as http;
import 'List/program_stages_data.dart';

class GutList extends StatefulWidget {
  GutList({Key? key}) : super(key: key);

  final GutListState myAppState=  GutListState();
  @override
  State<GutList> createState() => GutListState();

}

class GutListState extends State<GutList> {

  String lockedStage = 'assets/images/dashboard_stages/lock.png';
  String currentStage = 'assets/images/dashboard_stages/current_stage.png';
  String openedStage = 'assets/images/dashboard_stages/green_done.png';

  List<NewStageLevels> levels = [
    NewStageLevels("assets/images/dashboard_stages/noun-appointment-3615898.png",
        "Enquiry Completed",
        'assets/images/dashboard_stages/green_done.png'
    ),
    NewStageLevels("assets/images/dashboard_stages/noun-appointment-3615898.png",
        "Evaluation Done",
        'assets/images/dashboard_stages/lock.png'
    ),
    NewStageLevels(
        "assets/images/dashboard_stages/noun-appointment-4042317.png",
        "Consultation",
        'assets/images/dashboard_stages/lock.png'
    ),
    NewStageLevels(
        "assets/images/dashboard_stages/noun-shipping-5332930.png",
        "Tracker",
        'assets/images/dashboard_stages/lock.png'
    ),
    NewStageLevels(
        "assets/images/dashboard_stages/noun-appointment-4042317.png",
        "Programs",
        'assets/images/dashboard_stages/lock.png'
    ),
    NewStageLevels(
        "assets/images/dashboard_stages/noun-information-book-1677218.png",
        "Post Program\nConsultation Booked",
        'assets/images/dashboard_stages/lock.png'
    ),
    NewStageLevels(
        "assets/images/dashboard_stages/noun-shipping-5332930.png",
        "Maintenance Guide\nUpdated",
        'assets/images/dashboard_stages/lock.png'
    ),
  ];

  final _pref = AppConfig().preferences;
  String isSelected = "Consultation";

  bool isShown = false;

  final Duration _duration = const Duration(milliseconds: 500);

  late GutDataService _gutDataService;

  late final Future myFuture;

  String? consultationStage, shippingStage, programOptionStage, postProgramStage;

  /// this is used when data=appointment_booked status
  GetAppointmentDetailsModel? _getAppointmentDetailsModel, _postConsultationAppointment;

  /// ths is used when data = shipping_approved status
  ShippingApprovedModel? _shippingApprovedModel;

  GetProgramModel? _getProgramModel;

  /// for other status we use this one(except shipping_approved & appointment_booked)
  GutDataModel? _gutDataModel, _gutShipDataModel, _gutProgramModel, _gutPostProgramModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isConsultationCompleted = _pref?.getBool(AppConfig.consultationComplete) ?? false;

    myFuture = getData();


    getUserProfile();

    if(_pref!.getString(AppConfig().shipRocketBearer) == null || _pref!.getString(AppConfig().shipRocketBearer)!.isEmpty){
      getShipRocketToken();
    }
    else{
      String token = _pref!.getString(AppConfig().shipRocketBearer)!;
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      print('shiprocketToken : $payload');
      var date = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
      if(!DateTime.now().difference(date).isNegative){
        getShipRocketToken();
      }
    }

    getData();

  }

  // _showSingleAnimationDialog(BuildContext context) {
  //   BrandLogoLoading.balance(
  //     context: context,
  //     animationType: ,
  //     logo: "assets/images/Gut welness logo (1).png",
  //     logoBackdropColor: Colors.transparent,
  //     durationInMilliSeconds: 900,
  //   );
  // }
  // _hideLoading(BuildContext context) {
  //   BrandLogoLoading.dismissLoading(context: context);
  // }
  /// THIS IS FOR ABC DIALOG MEAL PLAN
  bool isProgressOpened = false;

  bool isProgressDialogOpened = false;
  BuildContext? _progressContext;

  getData() async{
    print("isProgressDialogOpened: $isProgressDialogOpened");
    Future.delayed(Duration(seconds: 0)).whenComplete(() {
      if(mounted) {
        isProgressDialogOpened = true;
        _progressContext = context;
        openProgressDialog(_progressContext!, willPop: true);
      }
    });
    _gutDataService = GutDataService(repository: repository);
    print("isProgressDialogOpened: $isProgressDialogOpened");

    final _getData = await _gutDataService.getGutDataService();
    print("_getData: $_getData");
    if(_getData.runtimeType == ErrorModel){
      if(isProgressDialogOpened){
        Navigator.of(_progressContext!, rootNavigator: true).pop();
      }
      ErrorModel model = _getData;
      print(model.message);
      Future.delayed(Duration(seconds: 0)).whenComplete(() =>
          AppConfig().showSnackbar(context, model.message ?? '', isError: true,
            duration: 50000,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: (){
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                getData();
              },
            )
          )
      );
    }
    else{
      if(isProgressDialogOpened){
        Navigator.of(_progressContext!, rootNavigator: true).pop();
      }
      print("isProgressDialogOpened: $isProgressDialogOpened");
      GetDashboardDataModel _getDashboardDataModel = _getData as GetDashboardDataModel;
      print("_getDashboardDataModel.app_consulation: ${_getDashboardDataModel.app_consulation}");


      // checking for the consultation data if data = appointment_booked
      setState(() {
        if(_getDashboardDataModel.app_consulation != null){
          _getAppointmentDetailsModel = _getDashboardDataModel.app_consulation;
          consultationStage = _getAppointmentDetailsModel?.data ?? '';
        }
        else{
          _gutDataModel = _getDashboardDataModel.normal_consultation;
          consultationStage = _gutDataModel?.data ?? '';
        }
        updateNewStage(consultationStage);
        if(consultationStage != null && (shippingStage != null && shippingStage!.isNotEmpty)){
          isSelected = "Shipping";
        }
        if(_getDashboardDataModel.approved_shipping != null){
          _shippingApprovedModel = _getDashboardDataModel.approved_shipping;
          shippingStage = _shippingApprovedModel?.data ?? '';
          updateNewStage(shippingStage);
        }
        else{
          _gutShipDataModel = _getDashboardDataModel.normal_shipping;
          shippingStage = _gutShipDataModel?.data ?? '';
          updateNewStage(shippingStage);
          // abc();
        }
        if(shippingStage != null && shippingStage == "shipping_delivered"){
          isSelected = "Programs";
        }
        if(_getDashboardDataModel.data_program != null){
          _getProgramModel = _getDashboardDataModel.data_program;
          programOptionStage = _getProgramModel?.data ?? '';
          updateNewStage(programOptionStage);
        }
        else{
          _gutProgramModel = _getDashboardDataModel.normal_program;
          programOptionStage = _getProgramModel?.data ?? '';
          updateNewStage(programOptionStage);
          abc();
        }
        // this is for other postprogram model
        if(_getDashboardDataModel.normal_postprogram != null){
          _gutPostProgramModel = _getDashboardDataModel.normal_postprogram;
          postProgramStage = _gutPostProgramModel?.data ?? '';
          updateNewStage(postProgramStage);
        }
        else{
          _postConsultationAppointment = _getDashboardDataModel.postprogram_consultation;
          print(_getDashboardDataModel.postprogram_consultation?.data);
          postProgramStage = _postConsultationAppointment?.data ?? '';
          updateNewStage(postProgramStage);
        }
        print("postProgramStage: ${postProgramStage}");
        if(postProgramStage != null && postProgramStage!.isNotEmpty){
          isSelected = "Post Program";
          updateNewStage(postProgramStage);
        }

      });
    }
  }


  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }, isBackEnable: false,
                showNotificationIcon: true,
                notificationOnTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationScreen()));
                }
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Program Stages",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: eUser().mainHeadingFont,
                        color: eUser().mainHeadingColor,
                        fontSize: eUser().mainHeadingFontSize
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      openAlertBox(
                          context: context,
                          isContentNeeded: false,
                          titleNeeded: true,
                          title: "Select Call Type",
                          positiveButtonName: "In App Call",
                          positiveButton: (){
                            callSupport();
                            Navigator.pop(context);
                          },
                        negativeButtonName: "Direct Call",
                        negativeButton: (){
                          Navigator.pop(context);
                          if(_pref!.getString(AppConfig.KALEYRA_SUCCESS_ID) == null){
                            AppConfig().showSnackbar(context, "Success Team Not available", isError: true);
                          }
                          else{
                            // // click-to-call
                            // callSupport();

                            if(_pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN) != null){
                              final accessToken = _pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN);
                              final uId = _pref!.getString(AppConfig.KALEYRA_USER_ID);
                              final successId = _pref!.getString(AppConfig.KALEYRA_SUCCESS_ID);
                              // voice- call
                              supportVoiceCall(uId!, successId!, accessToken!);
                            }
                            else{
                              AppConfig().showSnackbar(context, "Something went wrong!!", isError: true);
                            }
                          }
                        }
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/call.png',
                          width: 12,
                          height: 12,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Support",
                          style: TextStyle(
                            color: kTextColor,
                            fontFamily: 'GothamBook',
                            fontSize: 10.sp,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h),
              Expanded(
                child: showImage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  abc(){
    Future.delayed(Duration(seconds: 0)).whenComplete(() {
      if(shippingStage == 'meal_plan_completed'){
        if(!isShown){
          setState(() {
            isShown = true;
          });
        }
        showDialog(
            context: context,
            builder: (BuildContext context) {
              isProgressOpened = true;
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0)), //this right here
                child: MealPopup(
                  yesButton:(isPressed) ? (){} : () {
                    Navigator.pop(context);
                    sendApproveStatus('yes');
                    setState(() {
                      isShown = false;
                    });
                    if(isProgressOpened){
                      Navigator.pop(context);
                    }
                  },
                  noButton:(isPressed) ? (){} : () {
                    sendApproveStatus('no');
                    setState(() {
                      isShown = false;
                    });
                    if(isProgressOpened){
                      Navigator.pop(context);
                    }
                  },
                ),
              );
            });
      }
    });
  }

  void changedIndex(String index) {
    setState(() {
      isSelected = index;
    });
  }

  showShippingScreen(){
    if(shippingStage != null && shippingStage!.isNotEmpty){
      if(_shippingApprovedModel != null){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CookKitTracking(awb_number: _shippingApprovedModel?.value?.awbCode ?? '',currentStage: shippingStage!,),
          ),
        ).then((value) => reloadUI());
      }
      else{
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CookKitTracking(currentStage: shippingStage ?? ''),
          ),
        ).then((value) => reloadUI());
      }
    }
  }
  showProgramScreen(){
    if(shippingStage == "shipping_delivered" && programOptionStage != null){
      if(_getProgramModel!.value!.startProgram == '0'){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ProgramPlanScreen(),
          ),
        ).then((value) => reloadUI());
      }
      else{
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealPlanScreen(postProgramStage: postProgramStage,),
          ),
        ).then((value) => reloadUI());
      }
    }
    else{
      AppConfig().showSnackbar(context, "program stage not getting", isError:  true);
    }
  }
  showPostProgramScreen(){
    if(postProgramStage != null && _postConsultationAppointment != null){
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
          DoctorSlotsDetailsScreen(
        bookingDate: _postConsultationAppointment!.value!.date!,
          bookingTime: _postConsultationAppointment!.value!.slotStartTime!,
          isPostProgram: true,
          dashboardValueMap: _postConsultationAppointment!.value!.toJson() ,)
              // PostProgramScreen(postProgramStage: postProgramStage,
              //   consultationData: _postConsultationAppointment,),
        ),
      ).then((value) => reloadUI());
    }
    else{
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              DoctorCalenderTimeScreen(isPostProgram: true,)
          // PostProgramScreen(postProgramStage: postProgramStage,),
        ),
      ).then((value) => reloadUI());
    }
  }

  Widget _buildWidgetExample(ProgramsData programsData, int index) {
    return GestureDetector(
      onTap: () {
        // changedIndex(programsData.title);
        if(index == 0){
          changedIndex(programsData.title);
        }
        if(index == 1 && shippingStage != null && shippingStage!.isNotEmpty){
          changedIndex(programsData.title);
        }
        else if(index == 2 && shippingStage == 'shipping_delivered'){
          changedIndex(programsData.title);
        }
        else if((postProgramStage != null && postProgramStage!.isNotEmpty)){
          changedIndex(programsData.title);
        }
      },
      child: Container(
          padding:
          EdgeInsets.only(left: 2.w, top: 0.5.h, bottom: 0.5.h, right: 5.w),
          margin: EdgeInsets.symmetric(vertical: 1.5.h),
          decoration: BoxDecoration(
            // color: kWhiteColor,
            color: index == 0 ? kWhiteColor : (index == 1 && shippingStage != null && shippingStage!.isNotEmpty) ? kWhiteColor : (index == 2 && shippingStage == 'shipping_delivered') ? kWhiteColor : (index == 3 && postProgramStage != null && postProgramStage!.isNotEmpty) ? kWhiteColor : gGreyColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: gMainColor.withOpacity(0.3), width: 1),
            boxShadow: (isSelected != programsData.title)
                ? [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 1,
              ),
            ]
                : [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(2, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              (isSelected == programsData.title)
                  ? Container(
                margin:
                EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: gMainColor),
                ),
                child: Image(
                  height: 9.h,
                  image: AssetImage(programsData.image),
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      (programsData.isCompleted) ? Colors.transparent : Colors.grey,
                      BlendMode.darken),
                  child: Image(
                    height: 9.h,
                    image: AssetImage(programsData.image),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  programsData.title,
                  style: TextStyle(
                    fontFamily: "GothamMedium",
                    color: (isSelected == programsData.title)
                        ? gMainColor
                        : (programsData.isCompleted) ? gPrimaryColor : gsecondaryColor,
                    fontSize: 10.sp,
                  ),
                ),
              ),
              (isSelected == programsData.title)
                  ? InkWell(
                  onTap: () {
                    if (programsData.title == "Consultation") {
                      if(consultationStage != null){
                        showConsultationScreenFromStages(consultationStage!);
                      }
                      else{
                        //  show dialog or snackbar
                      }
                    }
                    else if (programsData.title == "Shipping") {
                      print(shippingStage!.isNotEmpty);
                      // Navigator.of(context).push(
                      //   PageRouteBuilder(
                      //     opaque: false, // set to false
                      //     pageBuilder: (_, __, ___) => MealPopup(yesButton: () {
                      //       Navigator.pop(context);
                      //     }),
                      //   ),
                      // );
                      if(shippingStage != null && shippingStage!.isNotEmpty){
                        if(_shippingApprovedModel != null){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CookKitTracking(awb_number: _shippingApprovedModel?.value?.awbCode ?? '',currentStage: shippingStage!,),
                            ),
                          ).then((value) => reloadUI());
                        }
                        else{
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CookKitTracking(currentStage: shippingStage ?? ''),
                            ),
                          ).then((value) => reloadUI());
                        }
                      }
                    }
                    else if (programsData.title == "Programs") {
                      if(shippingStage == "shipping_delivered" && programOptionStage != null){
                        if(_getProgramModel!.value!.startProgram == '0'){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProgramPlanScreen(),
                            ),
                          ).then((value) => reloadUI());
                        }
                        else{
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MealPlanScreen(postProgramStage: postProgramStage,),
                            ),
                          ).then((value) => reloadUI());
                        }
                      }
                      else{
                        AppConfig().showSnackbar(context, "program stage not getting", isError:  true);
                      }
                    }
                    else if (programsData.title == "Post Program") {
                      if(postProgramStage != null && _postConsultationAppointment != null){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PostProgramScreen(postProgramStage: postProgramStage,consultationData: _postConsultationAppointment,),
                          ),
                        ).then((value) => reloadUI());
                      }
                      else{
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PostProgramScreen(postProgramStage: postProgramStage,),
                          ),
                        ).then((value) => reloadUI());
                      }
                    }
                  },
                  child: (programsData.isCompleted) ? Icon(Icons.check_circle_outline) :
                  Image(
                    height: 3.h,
                    image: const AssetImage(
                        "assets/images/noun-arrow-1018952.png"),
                  )
              )
                  : Container(
                margin: EdgeInsets.only(right: 6),
                width: 2.w,
                child: (programsData.isCompleted) ? Icon(Icons.check_circle_outline, color: gPrimaryColor,) : SizedBox(),
              ),
            ],
          )
      ),
    );
  }

  bool isSendApproveStatus = false;
  bool isPressed = false;
  sendApproveStatus(String status, {bool fromNull = false}) async{
    if(!isSendApproveStatus){
      setState(() {
        isSendApproveStatus = true;
        isPressed = true;
      });
      print("isPressed: $isPressed");
      final res = await ShipTrackService(repository: shipTrackRepository).sendSippingApproveStatusService(status);

      if(res.runtimeType == ShippingApproveModel){
        ShippingApproveModel model = res as ShippingApproveModel;
        print('success: ${model.message}');
        AppConfig().showSnackbar(context, model.message!);
        getData();
      }
      else{
        ErrorModel model = res as ErrorModel;
        print('error: ${model.message}');
        AppConfig().showSnackbar(context, model.message!);
      }
      setState(() {
        isPressed = false;
      });
    }
  }

  final GutDataRepository repository = GutDataRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  final ShipTrackRepository shipTrackRepository = ShipTrackRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  void showConsultationScreenFromStages(status) {
    print(status);
    switch(status) {
      case 'evaluation_done'  :
        goToScreen(DoctorCalenderTimeScreen());
        break;
      case 'pending' :
        goToScreen(DoctorCalenderTimeScreen());
        break;
      case 'consultation_reschedule' :
        final model = _getAppointmentDetailsModel;

        // add this before calling calendertimescreen for reschedule
        // _pref!.setString(AppConfig.appointmentId , '');
        goToScreen(DoctorCalenderTimeScreen(
          isReschedule: true,
          prevBookingDate: model!.value!.appointmentDate,
          prevBookingTime: model.value!.appointmentStartTime,

        ));
        break;
      case 'appointment_booked':
        final model = _getAppointmentDetailsModel;
        _pref!.setString(AppConfig.appointmentId, model?.value?.id.toString() ?? '');
        goToScreen(DoctorSlotsDetailsScreen(bookingDate: model!.value!.date!, bookingTime: model.value!.slotStartTime!, dashboardValueMap: model.value!.toJson(),isFromDashboard: true,));
        break;
      case 'consultation_done':
        goToScreen(const ConsultationSuccess());
        break;
      case 'consultation_accepted':
        goToScreen(const ConsultationSuccess());
        break;
      case 'consultation_waiting':
        goToScreen(UploadFiles());
        break;
      case 'consultation_rejected':
        goToScreen(ConsultationRejected());
        break;
      case 'report_upload':
        print(_gutDataModel!.toJson());
        print(_gutDataModel!.value);
        // goToScreen(DoctorCalenderTimeScreen(isReschedule: true,prevBookingTime: '23-09-2022', prevBookingDate: '10AM',));
        goToScreen(MedicalReportScreen(pdfLink: _gutDataModel!.value!,));
        break;
      // case 'check_user_reports':
      //   print(_gutDataModel!.value);
      //   goToScreen(MedicalReportScreen(pdfLink: _gutDataModel!.value!,));
      //   break;
    }
  }

  goToScreen(screenName){
    print(screenName);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => screenName,
        // builder: (context) => isConsultationCompleted ? ConsultationSuccess() : const DoctorCalenderTimeScreen(),
      ),
    ).then((value) {
      print(value);
      setState(() {
        getData();
      });
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("didChangeDependencies");
  }

  void getShipRocketToken() async{
    print("getShipRocketToken called");
    ShipTrackService _shipTrackService = ShipTrackService(repository: shipTrackRepository);
    final getToken = await _shipTrackService.getShipRocketTokenService(AppConfig().shipRocketEmail, AppConfig().shipRocketPassword);
    print(getToken);
  }

  bool getIsCompleted(String name) {
    bool status = false;

    if(name == 'Consultation'){
      status = consultationStage == 'report_upload';
      // if(consultationStage == 'report_upload') isSelected = 'Shipping';
      // print("status of cons $status  ${shippingStage?.isNotEmpty}");
    }
    if(name == 'Shipping'){
      status = shippingStage == 'shipping_delivered';
      // if(shippingStage == 'shipping_approved') {isSelected = 'Programs';}
    }
    if(name == 'Programs'){
      status = postProgramStage?.isNotEmpty ?? false;
    }
    // if(name == 'Shipping'){
    //   status = programOptionStage?.isNotEmpty ?? false;
    // }
    return status;
  }

  getUserProfile() async{
    print("user profile: ${_pref!.getInt(AppConfig.QB_CURRENT_USERID)}");
    // print("user id: ${_pref!.getInt(AppConfig.KALEYRA_USER_ID)}");

    if(_pref!.getString(AppConfig.User_Name) != null || _pref!.getString(AppConfig.User_Name)!.isNotEmpty){
      final profile = await UserProfileService(repository: userRepository).getUserProfileService();
      if(profile.runtimeType == UserProfileModel){
        UserProfileModel model1 = profile as UserProfileModel;
        _pref!.setString(AppConfig.User_Name, model1.data?.name ?? model1.data?.fname ?? '');
        _pref!.setInt(AppConfig.USER_ID, model1.data?.id ?? -1);
        _pref!.setString(AppConfig.QB_USERNAME, model1.data!.qbUsername!);
        _pref!.setInt(AppConfig.QB_CURRENT_USERID, int.tryParse(model1.data!.qbUserId!)!);
        _pref!.setString(AppConfig.KALEYRA_USER_ID, model1.data!.kaleyraUID!);

        if(_pref!.getString(AppConfig.KALEYRA_ACCESS_TOKEN) == null){
          await LoginWithOtpService(repository: loginOtpRepository).getAccessToken(model1.data!.kaleyraUID!);
        }
      }
    }
    // if(_pref!.getInt(AppConfig.QB_CURRENT_USERID) != null && !await _qbService!.getSession() || _pref!.getBool(AppConfig.IS_QB_LOGIN) == null){
    //   String _uName = _pref!.getString(AppConfig.QB_USERNAME)!;
    //   _qbService!.login(_uName);
    // }
  }

  Future<void> reloadUI() async{
    await getData();
    setState(() { });
  }

  final UserProfileRepository userRepository = UserProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  showImage() {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        shrinkWrap: true,
        reverse: true,
        itemCount: levels.length,
        itemBuilder: (_, index) {
          if (index.isEven) {
            return Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Image(
                                  image: AssetImage(levels[index].image),
                                  height: 60),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              levels[index].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "GothamBook",
                                  height: 1.3,
                                  color: gsecondaryColor,
                                  fontSize: 10.sp),
                            )
                          ],
                        ),
                        SizedBox(width: 80),
                        GestureDetector(
                          onTap: () {
                            print(index);
                            // print("right");
                            print(levels[index].title);
                            // print(levels[index].stage == openedStage);
                            // goToScreen(screenName)
                            if(levels[index].stage == openedStage || levels[index].stage == currentStage){
                              if(index == 1){
                                goToScreen(EvaluationGetDetails());
                              }
                              else if(index == 2){
                                showConsultationScreenFromStages(consultationStage);
                              }
                              else if(index == 3){
                                showShippingScreen();
                              }
                              else if(index == 4){
                                showProgramScreen();
                              }
                              else if(index == 5){
                                showPostProgramScreen();
                              }
                              else if(index == 6){
                                goToScreen(PPLevelsScreen());
                              }

                            }
                            else{
                              AppConfig().showSnackbar(context, "Can't access Locked Stage");
                            }
                          },
                          child: Image(
                              image: AssetImage(levels[index].stage),
                              height: 60),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Image(
                        image: AssetImage("assets/images/dashboard_stages/Mask Group 8.png"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else {
            return Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 00,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print(index);
                            print(levels[index].title);
                            if(levels[index].stage == openedStage || levels[index].stage == currentStage){
                              if(index == 1){
                                goToScreen(EvaluationGetDetails());
                              }
                              else if(index == 2){
                                showConsultationScreenFromStages(consultationStage);
                              }
                              else if(index == 3){
                                showShippingScreen();
                              }
                              else if(index == 4){
                                showProgramScreen();
                              }
                              else if(index == 5){
                                showPostProgramScreen();
                              }
                              else if(index == 6){
                                goToScreen(PPLevelsScreen());
                              }
                            }
                            else{
                              AppConfig().showSnackbar(context, "Can't access Locked Stage");
                            }
                          },
                          child: Image(
                              image: AssetImage(levels[index].stage),
                              height: 60),
                        ),
                        SizedBox(width: 80),
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Image(
                                  image: AssetImage(levels[index].image),
                                  height: 60),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              levels[index].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "GothamBook",
                                  height: 1.3,
                                  color: gsecondaryColor,
                                  fontSize: 10.sp),
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 30),
                      child: Image(
                        image: AssetImage("assets/images/dashboard_stages/Mask Group 9.png"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  showOldProgramStages(){
    return ListViewEffect(
      duration: _duration,
      children: programStage.map((s) => _buildWidgetExample(
          ProgramsData(s['title']!, s['image']!,
              isCompleted: getIsCompleted(s['title']!)
          ),
          programStage.indexWhere((element) => element.containsValue(s['title']!)))).toList(),
    );
  }

  String showStageImage(int index) {
    String asset = '';
    String title = levels[index].title.toString().toLowerCase().trim();
    if(consultationStage == 'evaluation_done' || consultationStage == 'pending'){
      asset = currentStage;
    }
    else if(consultationStage == 'consultation_reschedule'){
      asset = lockedStage;
    }

    return asset;
  }

  void updateNewStage(String? stage) {
    print("consultationStage: ==> ${stage}");
    switch(stage){
      case 'evaluation_done'  :
        levels[1].stage = openedStage;
        levels[2].stage = currentStage;
        break;
      case 'pending' :
        levels[1].stage = openedStage;
        levels[2].stage = currentStage;
        break;
      case 'consultation_reschedule' :
        levels[1].stage = openedStage;
        levels[2].stage = currentStage;
        break;
      case 'appointment_booked':
        levels[1].stage = openedStage;
        levels[2].stage = currentStage;
        break;
      case 'consultation_done':
        levels[1].stage = openedStage;
        levels[2].stage = currentStage;
        break;
      case 'consultation_accepted':
        levels[1].stage = openedStage;
        levels[2].stage = currentStage;
        break;
      case 'consultation_waiting':
        levels[1].stage = openedStage;
        levels[2].stage = currentStage;
        break;
      case 'consultation_rejected':
        levels[1].stage = openedStage;
        levels[2].stage = currentStage;
        break;
      case 'report_upload':
        levels[1].stage = openedStage;
        levels[2].stage = openedStage;
        break;
      case 'shipping_packed':
        levels[1].stage = openedStage;
        levels[2].stage = openedStage;
        levels[3].stage = currentStage;
        break;
      case 'shipping_delivered':
        levels[1].stage = openedStage;
        levels[2].stage = openedStage;
        levels[3].stage = currentStage;
        break;
      case 'shipping_approved':
        levels[1].stage = openedStage;
        levels[2].stage = openedStage;
        levels[3].stage = currentStage;
        break;
      case 'start_program':
        levels[1].stage = openedStage;
        levels[2].stage = openedStage;
        levels[3].stage = openedStage;
        levels[4].stage = currentStage;
        levels[5].stage = lockedStage;
        break;
      case 'post_program':
        levels[1].stage = openedStage;
        levels[2].stage = openedStage;
        levels[3].stage = openedStage;
        levels[4].stage = openedStage;
        levels[5].stage = currentStage;
        break;
      case 'post_appointment_booked':
        levels[1].stage = openedStage;
        levels[2].stage = openedStage;
        levels[3].stage = openedStage;
        levels[4].stage = openedStage;
        levels[5].stage = currentStage;
        break;
      case 'protocol_guide':
        levels[1].stage = openedStage;
        levels[2].stage = openedStage;
        levels[3].stage = openedStage;
        levels[4].stage = openedStage;
        levels[5].stage = openedStage;
        levels[6].stage = currentStage;
        break;
    }
  }

  final LoginOtpRepository loginOtpRepository = LoginOtpRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}

class ProgramsData {
  String title;
  String image;
  bool isCompleted;

  ProgramsData(this.title, this.image, {this.isCompleted = false});
}

class NewStageLevels{
  String image;
  String title;
  String stage;

  NewStageLevels(this.image, this.title, this.stage);
}