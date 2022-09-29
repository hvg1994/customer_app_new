import 'package:flutter/material.dart';
import 'package:gwc_customer/model/dashboard_model/get_appointment/get_appointment_after_appointed.dart';
import 'package:gwc_customer/model/dashboard_model/gut_model/gut_data_model.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/repository/dashboard_repo/gut_repository/dashboard_repository.dart';
import 'package:gwc_customer/screens/appointment_screens/consultation_screens/consultation_rejected.dart';
import 'package:gwc_customer/screens/appointment_screens/consultation_screens/upload_files.dart';
import 'package:gwc_customer/screens/gut_list_screens/meal_popup.dart';
import 'package:gwc_customer/screens/post_program_screens/post_program_screen.dart';
import 'package:gwc_customer/screens/program_plans/program_plan_screen.dart';
import 'package:gwc_customer/services/dashboard_service/gut_service/dashboard_data_service.dart';
import 'package:gwc_customer/services/shipping_service/ship_track_service.dart';
import 'package:gwc_customer/utils/program_stages_enum.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:sizer/sizer.dart';
import '../../model/ship_track_model/sipping_approve_model.dart';
import '../../repository/api_service.dart';
import '../../repository/shipping_repository/ship_track_repo.dart';
import '../../utils/app_config.dart';
import '../appointment_screens/consultation_screens/consultation_success.dart';
import '../appointment_screens/consultation_screens/medical_report_screen.dart';
import '../appointment_screens/doctor_slots_details_screen.dart';
import '../cook_kit_shipping_screens/cook_kit_tracking.dart';
import 'List/list_view_effect.dart';
import 'package:gwc_customer/screens/appointment_screens/doctor_calender_time_screen.dart';
import 'package:http/http.dart' as http;
import 'List/program_stages_data.dart';

class GutList extends StatefulWidget {
  const GutList({Key? key}) : super(key: key);

  @override
  State<GutList> createState() => _GutListState();
}

class _GutListState extends State<GutList> {

  final _pref = AppConfig().preferences;
  String isSelected = "Consultation";

  bool isShown = false;

  final Duration _duration = const Duration(milliseconds: 500);

  late GutDataService _gutDataService;

  late final Future myFuture;

  bool? isConsultationDone, isShippingDone, isProgramsDone, isPostProgramDone;

  String? consultationStage;

  /// this is used when data=appointment_booked status
  GetAppointmentDetailsModel? model;

  GutDataModel? _gutDataModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isConsultationCompleted = _pref?.getBool(AppConfig.consultationComplete) ?? false;

    myFuture = getData();

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

  getData() async{
    _gutDataService = GutDataService(repository: repository);
    final _getData = await _gutDataService.getGutDataService();
    print("_getData: $_getData");
    if(_getData.runtimeType == ErrorModel){
      ErrorModel model = _getData;
      print(model.message);
    }
    else if(_getData.runtimeType == GutDataModel){
      _gutDataModel = _getData as GutDataModel;
      consultationStage = _gutDataModel!.data;
      abc();
    }
    else if(_getData.runtimeType == GetAppointmentDetailsModel)
    {
      model = _getData;

      ProgramStatus.values.forEach((element) {
        if(model!.data == element.name){
          consultationStage = element.name;
        }
      });
      // isConsultationDone = ProgramStatus.medical_report.name == model.data;
      // isShippingDone = ProgramStatus.shipping.name == model.data;
      // if(isShippingDone! && isShippingDone != null) isConsultationDone = true;
      // isProgramsDone = ProgramStatus.programs.name == model.data;
      // if(isProgramsDone! && isProgramsDone != null) {
      //   isConsultationDone = true;
      //   isShippingDone = true;
      // }
      // isPostProgramDone = ProgramStatus.post_program.name == model.data;
      // if(isPostProgramDone! && isPostProgramDone != null) {
      //   isConsultationDone = true;
      //   isShippingDone = true;
      //   isProgramsDone = true;
      // }
      // List l = [isConsultationDone, isShippingDone, isProgramsDone, isPostProgramDone];
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
              }, isBackEnable: false),
              SizedBox(height: 3.h),
              Text(
                "Program Stages",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "GothamRoundedBold_21016",
                    color: gPrimaryColor,
                    fontSize: 12.sp),
              ),
              SizedBox(height: 1.h),
              Expanded(
                child: ListViewEffect(
                  duration: _duration,
                  children: programStage.map((s) => _buildWidgetExample(
                      ProgramsData(s['title']!, s['image']!, s['isCompleted']!), programStage.indexWhere((element) => element.containsValue(s['title']!)))).toList(),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  abc(){
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        //shipping_approved  shipping_packed
        if(consultationStage == 'shipping_packed'){
          if(!isShown){
            setState(() {
              isShown = true;
            });
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false, // set to false
                pageBuilder: (_, __, ___) => MealPopup(
                  yesButton: () {
                    sendApproveStatus('yes');
                    setState(() {
                      isShown = false;
                    });
                  },
                  noButton: () {
                    sendApproveStatus('no');
                    setState(() {
                      isShown = false;
                    });
                  },
                ),
              ),
            ).then((value) {
              if(value == null){
                setState(() {
                  isShown = false;
                });
                sendApproveStatus('no', fromNull: true);
                print("pop: $value");
              }
            });
          }
        }
    });
  }

  void changedIndex(String index) {
    setState(() {
      isSelected = index;
    });
  }

  Widget _buildWidgetExample(ProgramsData programsData, int index) {
    return GestureDetector(
      onTap: () {
        changedIndex(programsData.title);
      },
      child: Container(
          padding:
              EdgeInsets.only(left: 2.w, top: 0.5.h, bottom: 0.5.h, right: 5.w),
          margin: EdgeInsets.symmetric(vertical: 1.5.h),
          decoration: BoxDecoration(
            color: kWhiteColor,
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
                        colorFilter: const ColorFilter.mode(
                            Colors.grey, BlendMode.darken),
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
                        : gsecondaryColor,
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
                          // Navigator.of(context).push(
                          //   PageRouteBuilder(
                          //     opaque: false, // set to false
                          //     pageBuilder: (_, __, ___) => MealPopup(yesButton: () {
                          //       Navigator.pop(context);
                          //     }),
                          //   ),
                          // );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CookKitTracking(),
                            ),
                          );
                        } else if (programsData.title == "Programs") {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ProgramPlanScreen(),
                            ),
                          );
                        }
                        else if (programsData.title == "Post Program") {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PostProgramScreen(),
                            ),
                          );
                        }
                      },
                      // child: (programsData.isCompleted == 'true') ? Icon(Icons.check_circle_outline) :
                      child: Image(
                        height: 3.h,
                        image: const AssetImage(
                            "assets/images/noun-arrow-1018952.png"),
                      )
                    )
                  : Container(
                      width: 2.w,
                    ),
            ],
          )
      ),
    );
  }

  sendApproveStatus(String status, {bool fromNull = false}) async{
    final res = await ShipTrackService(repository: shipTrackRepository).sendSippingApproveStatusService(status);

    if(res.runtimeType == ShippingApproveModel){
      ShippingApproveModel model = res as ShippingApproveModel;
      print('success: ${model.message}');
      AppConfig().showSnackbar(context, model.message!);
    }
    else{
      ErrorModel model = res as ErrorModel;
      print('error: ${model.message}');
      AppConfig().showSnackbar(context, model.message!);
    }
    if(!fromNull) Navigator.pop(context);
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
      case 'appointment_booked':
        goToScreen(DoctorSlotsDetailsScreen(bookingDate: model!.value!.date!, bookingTime: model!.value!.slotStartTime!, dashboardValueMap: model!.value!.toJson(),isFromDashboard: true,));
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
    getData();
  }

  void getShipRocketToken() async{
    print("getShipRocketToken called");
    ShipTrackService _shipTrackService = ShipTrackService(repository: shipTrackRepository);
    final getToken = await _shipTrackService.getShipRocketTokenService(AppConfig().shipRocketEmail, AppConfig().shipRocketPassword);
    print(getToken);
  }
}

class ProgramsData {
  ProgramsData(this.title, this.image, this.isCompleted);

  String title;
  String image;
  String isCompleted;
}
