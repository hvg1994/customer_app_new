import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../../model/consultation_model/appointment_booking/appointment_book_model.dart';
import '../../model/consultation_model/appointment_slot_model.dart';
import '../../model/consultation_model/child_slots_model.dart';
import '../../model/error_model.dart';
import '../../repository/api_service.dart';
import '../../repository/consultation_repository/get_slots_list_repository.dart';
import '../../services/consultation_service/consultation_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'doctor_slots_details_screen.dart';
import 'package:http/http.dart' as http;
import 'package:gwc_customer/widgets/dart_extensions.dart';

class DoctorCalenderTimeScreen extends StatefulWidget {
  final bool isReschedule;
  final String? prevBookingDate;
  final String? prevBookingTime;
  /// this is for post program
  /// when this all other parameters will null
  final bool isPostProgram;
  const DoctorCalenderTimeScreen({Key? key,
    this.isReschedule = false,
    this.prevBookingDate,
    this.prevBookingTime,
    this.isPostProgram = false
  }) : super(key: key);

  @override
  State<DoctorCalenderTimeScreen> createState() =>
      _DoctorCalenderTimeScreenState();
}

class _DoctorCalenderTimeScreenState extends State<DoctorCalenderTimeScreen> {
  DatePickerController dateController = DatePickerController();
  final pageController = PageController();
  double rating = 5.0;

  List<String> list = ["09:00", "11:00", "02:00", "04:00"];

  final SharedPreferences _pref = AppConfig().preferences!;
  /// this is for slot selection
  String isSelected = "";
  String selectedTimeSlotFullName = "";

  Map<String, ChildSlotModel>? slotList = {};

  DateTime selectedDate = DateTime.now();

  bool isLoading = false;
  bool showBookingProgress = false;
  String slotErrorText = AppConfig.slotErrorText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSlotsList(selectedDate);
  }

  getSlotsList(DateTime selectedDate) async{
    setState(() {
      isLoading = true;
    });
    String appointment_id = '';
    if(widget.isReschedule) appointment_id = _pref.getString(AppConfig.appointmentId)!;
    print(appointment_id);
    final res = await (() => ConsultationService(repository: repository).getAppointmentSlotListService(DateFormat('yyyy-MM-dd').format(selectedDate), appointmentId: (widget.isReschedule) ? appointment_id : null)).withRetries(3);
    print("getSlotlist" + res.runtimeType.toString());

    if(res.runtimeType == SlotModel){
      SlotModel result = res;
      setState(() {
        slotList = result.data!;
        isLoading = false;
        if(slotList!.isEmpty){
          slotErrorText = AppConfig.slotErrorText;
        }
      });
    }
    else{
      ErrorModel result = res;
      slotList!.clear();
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
      setState(() {
        isLoading = false;
        if(result.message!.toLowerCase().contains("no doctor")){
          slotErrorText = result.message!;
        }
        else if(result.message!.toLowerCase().contains("unauthenticated")){
          slotErrorText = AppConfig.oopsMessage;
        }
        else{
          slotErrorText = AppConfig.slotErrorText;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding:
                EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(() {
                  Navigator.pop(context);
                }),
                SizedBox(height: 2.h),
                buildDoctor(),
                // SizedBox(height: 1.h),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     buildDoctorDetails(
                //         "Patient", "10K", "assets/images/Patient.svg"),
                //     buildDoctorDetails("Experience", "12 Years",
                //         "assets/images/Experences.svg"),
                //     buildDoctorDetails(
                //         "Rating", "4.5", "assets/images/star.svg"),
                //   ],
                // ),
                SizedBox(
                  height: 3.h,
                ),
                Visibility(
                  visible: widget.isReschedule,
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 13.w),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Your Previous Appointment was Booked @ ',
                            style: TextStyle(
                              height: 1.5,
                              fontSize: 12.sp,
                              fontFamily: "GothamBook",
                              color: gBlackColor,
                            ),
                          ),
                          TextSpan(
                            text: '${widget.prevBookingTime} ${widget.prevBookingDate}',
                            style: TextStyle(
                              height: 1.5,
                              fontSize: 12.sp,
                              fontFamily: "GothamMedium",
                              color: gMainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.isReschedule,
                  child: SizedBox(
                    height: 5,
                  ),
                ),
                Text(
                  "Choose Day",
                  style: TextStyle(
                      fontFamily: "GothamRoundedBold_21016",
                      color: gPrimaryColor,
                      fontSize: 11.sp),
                ),
                buildChooseDay(),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  "Choose Time",
                  style: TextStyle(
                      fontFamily: "GothamRoundedBold_21016",
                      color: gPrimaryColor,
                      fontSize: 11.sp),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: (isLoading) ? Center(
                    child: buildCircularIndicator(),
                  ) : (slotList!.isEmpty) ? Center(
                    child:  Text(
                      slotErrorText,
                      style: TextStyle(
                          fontFamily: "GothamRoundedBold_21016",
                          color: gPrimaryColor,
                          fontSize: 10.sp),
                    ),
                  ) : Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 20,
                    spacing: 20,
                    children: [
                      // ...list.map((e) => buildChooseTime(e)).toList(),
                      ...slotList!.values.map((e) => buildChooseTime(e)).toList()
                    ],
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Center(
                  child: GestureDetector(
                    onTap: (isSelected.isEmpty || showBookingProgress) ? (){
                      AppConfig().showSnackbar(context, 'Please select time');
                    } : () {
                      buildConfirm(DateFormat('yyyy-MM-dd').format(selectedDate), selectedTimeSlotFullName);
                    },
                    child: Container(
                      width: 60.w,
                      height: 5.h,
                      // padding: EdgeInsets.symmetric(
                      //     vertical: 1.h, horizontal: 25.w),
                      decoration: BoxDecoration(
                        color: eUser().buttonColor,
                        borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                        border: Border.all(
                            color: eUser().buttonBorderColor,
                            width: eUser().buttonBorderWidth
                        ),
                      ),
                      child: (showBookingProgress)
                          ? buildThreeBounceIndicator(color: eUser().threeBounceIndicatorColor)
                          : Center(
                        child: Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: eUser().buttonTextFont,
                            color: eUser().buttonTextColor,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildDoctor() {
    return Column(
      children: [
        SizedBox(
          height: 22.h,
          child: PageView(
            controller: pageController,
            children: [
              buildFeedbackList(),
              buildFeedbackList(),
              buildFeedbackList(),
            ],
          ),
        ),
        SmoothPageIndicator(
          controller: pageController,
          count: 3,
          axisDirection: Axis.horizontal,
          effect: JumpingDotEffect(
            dotColor: Colors.amberAccent,
            activeDotColor: gsecondaryColor,
            dotHeight: 0.8.h,
            dotWidth: 1.7.w,
            jumpScale: 2,
          ),
        ),
      ],
    );
  }

  buildFeedbackList() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(vertical: 1.h,horizontal: 1.w),
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: gsecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(2, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 3.h,
                  backgroundImage:
                      const AssetImage("assets/images/cheerful.png"),
                ),
              ),
              SizedBox(width: 3.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ms. Lorem Ipsum Daries",
                    style: TextStyle(
                        fontFamily: "GothamMedium",
                        color: gWhiteColor,
                        fontSize: 10.sp),
                  ),
                  SizedBox(height: 0.3.h),
                  buildRating(),
                ],
              ),
            ],
          ),
          Text(
            'Lorem lpsum is simply dummy text of the printing and typesetting industry. Lorem lpsum has been the industry\'s standard dummy text ever since the 1500s,when an unknown printer took a gallery of type and scrambled it to make a type specimen book.',
            style: TextStyle(
              height: 1.7,
              fontFamily: "GothamBook",
              color: gWhiteColor,
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRating() {
    return SmoothStarRating(
      color: Colors.amber,
      borderColor: Colors.amber,
      rating: rating,
      size: 1.5.h,
      filledIconData: Icons.star_sharp,
      halfFilledIconData: Icons.star_half_sharp,
      defaultIconData: Icons.star_outline_sharp,
      starCount: 5,
      allowHalfRating: true,
      spacing: 2.0,
    );
  }

  buildDoctorDetails(String title, String subTitle, String image) {
    return Container(
      width: 25.w,
      height: 12.h,
      padding: EdgeInsets.only(top: 2.h, left: 3.w, right: 3.w),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gPrimaryColor.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(image),
          SizedBox(height: 1.5.h),
          Text(
            title,
            style: TextStyle(
              fontFamily: "GothamBook",
              color: gPrimaryColor,
              fontSize: 9.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            subTitle,
            style: TextStyle(
              fontFamily: "GothamMedium",
              color: gPrimaryColor,
              fontSize: 9.sp,
            ),
          ),
        ],
      ),
    );
  }

  buildChooseDay() {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: gMainColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
          ),
        ],
      ),
      child: DatePicker(
        DateTime.now(),
        controller: dateController,
        height: 10.h,
        width: 14.w,
        monthTextStyle: TextStyle(fontSize: 0.sp),
        dateTextStyle: TextStyle(
            fontFamily: "GothamRoundedBold_21016",
            fontSize: 13.sp,
            color: gPrimaryColor),
        dayTextStyle: TextStyle(
            fontFamily: "GothamBook", fontSize: 8.sp, color: gPrimaryColor),
        initialSelectedDate: DateTime.now(),
        selectionColor: gPrimaryColor,
        selectedTextColor: gMainColor,
        onDateChange: (date) {
          setState(() {
            selectedDate = date;
            isLoading = true;
            isSelected = "";
          });
          getSlotsList(selectedDate);
        },
      ),
    );
  }


  Widget buildChooseTime(ChildSlotModel model) {
    String slotName = model.slot!.substring(0,5);
    return GestureDetector(
      onTap: model.isBooked == '1' ? null : () {
        setState(() {
          isSelected = slotName;
          selectedTimeSlotFullName = model.slot ?? '';
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          border: Border.all(color: gMainColor, width: 1),
          borderRadius: BorderRadius.circular(8),
          color: (model.isBooked == '0' && isSelected != slotName) ? gWhiteColor : model.isBooked == '1' ? gGreyColor : gPrimaryColor,
          boxShadow: (model.isBooked == '0' && isSelected != slotName)
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
        child: Text(
          slotName,
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: "GothamBook",
            color: (model.isBooked != '0' || isSelected == slotName) ? gMainColor : gTextColor,
          ),
        ),
      ),
    );
  }

  void buildConfirm(String slotDate, String slotTime) {
    String? appointmentId;
    if(widget.isReschedule){
      appointmentId = _pref.getString(AppConfig.appointmentId);
    }
    bookAppointment(slotDate, slotTime, appointmentId: appointmentId);
  }

  final ConsultationRepository repository = ConsultationRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  bookAppointment(String date, String slotTime, {String? appointmentId}) async{
    setState(() {
      showBookingProgress = true;
    });
   print(widget.isPostProgram);
    final res = await ConsultationService(repository: repository)
        .bookAppointmentService(date, slotTime,
        appointmentId: (widget.isReschedule) ? appointmentId : null,
        isPostprogram: widget.isPostProgram
    );
    print("bookAppointment : " + res.runtimeType.toString());
    if(res.runtimeType == AppointmentBookingModel){
      if(widget.isReschedule){
        _pref.remove(AppConfig.appointmentId);
      }
      AppointmentBookingModel result = res;
      print("result.zoomJoinUrl: ${result.zoomJoinUrl}");
      print(result.toJson());
      setState(() {
        showBookingProgress = false;
      });
      _pref.setString(AppConfig.appointmentId, result.appointmentId ?? '');
      _pref.setString(AppConfig.KALEYRA_SUCCESS_ID, result.kaleyraSuccessId ?? '');

      // _pref.setString(AppConfig.doctorId, result.doctorId ?? '');

      // AppConfig().showSnackbar(context, result.message ?? '');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DoctorSlotsDetailsScreen(
            bookingDate: date,
            bookingTime: isSelected,
            data: result,
            isPostProgram: widget.isPostProgram,
          ),
        ),).then((value) {
        setState(() {

        });
      });
    }
    else{
      ErrorModel result = res;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
      setState(() {
        showBookingProgress = false;
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


}
