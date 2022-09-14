// import 'package:date_picker_timeline/date_picker_timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../../../model/error_model.dart';
// import '../../../repository/api_service.dart';
// import '../../../utils/app_config.dart';
//
// class AyurvedaCalenderTimeScreen extends StatefulWidget {
//   final bool isReschedule;
//   const AyurvedaCalenderTimeScreen({Key? key,
//     this.isReschedule = false
//   }) : super(key: key);
//
//   @override
//   State<AyurvedaCalenderTimeScreen> createState() =>
//       _AyurvedaCalenderTimeScreenState();
// }
//
// class _AyurvedaCalenderTimeScreenState
//     extends State<AyurvedaCalenderTimeScreen> {
//   DatePickerController dateController = DatePickerController();
//
//   final SharedPreferences _pref = AppConfig().preferences!;
//   /// this is for slot selection
//   String isSelected = "";
//   String selectedTimeSlotFullName = "";
//
//   List<String> list = ["09:00", "11:00", "02:00", "04:00"];
//
//   List<ChildSlotModel> slotList = [];
//
//   DateTime selectedDate = DateTime.now();
//
//   bool isLoading = false;
//   bool showBookingProgress = false;
//   String slotErrorText = AppConfig.slotErrorText;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getSlotsList(selectedDate);
//   }
//
//   getSlotsList(DateTime selectedDate) async{
//     setState(() {
//       isLoading = true;
//     });
//     print(_pref.getString(AppConfig.doctorId)! + ' ' + widget.isReschedule.toString());
//     String doctor_id = '';
//     if(widget.isReschedule) doctor_id = _pref.getString(AppConfig.doctorId)!;
//     print(doctor_id);
//     final res = await AyurvedaService(repository: repository).getAppointmentSlotListService(DateFormat('yyyy-MM-dd').format(selectedDate), doctorId: (widget.isReschedule) ? doctor_id : null);
//     print("getSlotlist" + res.runtimeType.toString());
//     if(res.runtimeType == SlotModel){
//       SlotModel result = res;
//       setState(() {
//         slotList = result.data!;
//         isLoading = false;
//         if(slotList.isEmpty){
//           slotErrorText = AppConfig.slotErrorText;
//         }
//       });
//     }
//     else{
//       ErrorModel result = res;
//       slotList.clear();
//       AppConfig().showSnackbar(context, result.message ?? '', isError: true);
//       setState(() {
//         isLoading = false;
//         if(result.message!.toLowerCase().contains("no doctor")){
//           slotErrorText = result.message!;
//         }
//         else if(result.message!.toLowerCase().contains("unauthenticated")){
//           slotErrorText = AppConfig.networkErrorText;
//         }
//         else{
//           slotErrorText = AppConfig.slotErrorText;
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Padding(
//             padding:
//                 EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 5.h),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     buildAppBar(() {
//                       Navigator.pop(context);
//                     }),
//                     Text(
//                       "Ayurveda Consultation",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontFamily: "GothamRoundedBold_21016",
//                           color: gPrimaryColor,
//                           fontSize: 12.sp),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   width: double.maxFinite,
//                   height: 17.h,
//                   margin: EdgeInsets.symmetric(vertical: 3.h),
//                   decoration: BoxDecoration(
//                     color: kPrimaryColor,
//                     borderRadius: BorderRadius.circular(20),
//                     // boxShadow: [
//                     //   BoxShadow(
//                     //     color: Colors.grey.withOpacity(0.5),
//                     //     blurRadius: 20,
//                     //   ),
//                     //],
//                   ),
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         top: 6.h,
//                         left: 8.w,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Appointment Booking",
//                               style: TextStyle(
//                                   fontFamily: "GothamRoundedBold_21016",
//                                   color: gWhiteColor,
//                                   fontSize: 15.sp),
//                             ),
//
//                             // Text(
//                             //   "Dr.Swarnalatha",
//                             //   style: TextStyle(
//                             //       fontFamily: "GothamRoundedBold_21016",
//                             //       color: gWhiteColor,
//                             //       fontSize: 15.sp),
//                             // ),
//                             // SizedBox(height: 1.h),
//                             // Text(
//                             //   "Ayurveda Specialist",
//                             //   style: TextStyle(
//                             //       fontFamily: "GothamBook",
//                             //       color: gWhiteColor,
//                             //       fontSize: 10.sp),
//                             // ),
//                           ],
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 6.w,
//                         child: SizedBox(
//                           height: 14.h,
//                           child: const Image(
//                             image: AssetImage(
//                                 "assets/images/splash_screen/freepik--Character--inject-4.png"),
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Visibility(
//                   visible: false,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       buildDoctorDetails(
//                           "Patient", "10K", "assets/images/Patient.svg"),
//                       buildDoctorDetails("Experience", "12 Years",
//                           "assets/images/Experences.svg"),
//                       buildDoctorDetails(
//                           "Rating", "4.5", "assets/images/star.svg"),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 3.h,
//                 ),
//                 Text(
//                   "Choose Day",
//                   style: TextStyle(
//                       fontFamily: "GothamRoundedBold_21016",
//                       color: gPrimaryColor,
//                       fontSize: 12.sp),
//                 ),
//                 buildChooseDay(),
//                 SizedBox(
//                   height: 1.h,
//                 ),
//                 Text(
//                   "Choose Time",
//                   style: TextStyle(
//                       fontFamily: "GothamRoundedBold_21016",
//                       color: gPrimaryColor,
//                       fontSize: 12.sp),
//                 ),
//                 SizedBox(height: 2.h),
//                 SizedBox(
//                   width: double.infinity,
//                   child: (isLoading) ? Center(
//                     child: buildCircularIndicator(),
//                   ) : (slotList.isEmpty) ? Center(
//                     child:  Text(
//                       slotErrorText,
//                       style: TextStyle(
//                           fontFamily: "GothamRoundedBold_21016",
//                           color: gPrimaryColor,
//                           fontSize: 10.sp),
//                     ),
//                   ) : Wrap(
//                     alignment: WrapAlignment.center,
//                     runSpacing: 20,
//                     spacing: 20,
//                     children: [
//                       // ...list.map((e) => buildChooseTime(e)).toList(),
//                       ...slotList.map((e) => buildChooseTime(e)).toList()
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 6.h,
//                 ),
//                 Center(
//                         child: GestureDetector(
//                           onTap: (isSelected.isEmpty || showBookingProgress) ? null : () {
//                             buildConfirm(DateFormat('yyyy-MM-dd').format(selectedDate), selectedTimeSlotFullName);
//                           },
//                           child: Container(
//                             width: 60.w,
//                             height: 5.h,
//                             // padding: EdgeInsets.symmetric(
//                             //     vertical: 1.h, horizontal: 25.w),
//                             decoration: BoxDecoration(
//                               color: isSelected.isEmpty ? gMainColor : gPrimaryColor,
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: gMainColor, width: 1),
//                             ),
//                             child: (showBookingProgress)
//                                 ? buildThreeBounceIndicator()
//                                 : Center(
//                                   child: Text(
//                               'Confirm',
//                               style: TextStyle(
//                                   fontFamily: "GothamRoundedBold_21016",
//                                   color: isSelected.isEmpty ? gPrimaryColor : gWhiteColor,
//                                   fontSize: 13.sp,
//                               ),
//                             ),
//                                 ),
//                           ),
//                         ),
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   buildDoctorDetails(String title, String subTitle, String image) {
//     return Container(
//       width: 25.w,
//       height: 12.h,
//       padding: EdgeInsets.only(top: 2.h, left: 3.w, right: 3.w),
//       decoration: BoxDecoration(
//         color: kWhiteColor,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: gPrimaryColor, width: 1.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SvgPicture.asset(image),
//           SizedBox(height: 1.5.h),
//           Text(
//             title,
//             style: TextStyle(
//                 fontFamily: "GothamBook", color: gMainColor, fontSize: 9.sp),
//           ),
//           SizedBox(height: 1.h),
//           Text(
//             subTitle,
//             style: TextStyle(
//                 fontFamily: "GothamMedium", color: gMainColor, fontSize: 9.sp),
//           ),
//         ],
//       ),
//     );
//   }
//
//   buildChooseDay() {
//     return Container(
//       padding: const EdgeInsets.all(5),
//       margin: EdgeInsets.symmetric(vertical: 2.h),
//       decoration: BoxDecoration(
//         color: kWhiteColor,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: gMainColor, width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             blurRadius: 1,
//           ),
//         ],
//       ),
//       child: DatePicker(
//         DateTime.now(),
//         controller: dateController,
//         height: 10.h,
//         width: 14.w,
//         daysCount: 60,
//         monthTextStyle: TextStyle(fontSize: 0.sp),
//         dateTextStyle: TextStyle(
//             fontFamily: "GothamRoundedBold_21016",
//             fontSize: 13.sp,
//             color: gPrimaryColor),
//         dayTextStyle: TextStyle(
//             fontFamily: "GothamBook", fontSize: 8.sp, color: gPrimaryColor),
//         initialSelectedDate: DateTime.now(),
//         selectionColor: gPrimaryColor,
//         selectedTextColor: gMainColor,
//         onDateChange: (date) {
//           setState(() {
//             selectedDate = date;
//             isLoading = true;
//             isSelected = "";
//           });
//           getSlotsList(selectedDate);
//         },
//       ),
//     );
//   }
//
//   // /// for String
//   // Widget buildChooseTime(String txt) {
//   //   return GestureDetector(
//   //     onTap: () {
//   //       changedIndex(txt);
//   //     },
//   //     child: Container(
//   //       padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
//   //       decoration: BoxDecoration(
//   //         color: (isSelected != txt) ? gWhiteColor : gPrimaryColor,
//   //         borderRadius: BorderRadius.circular(10),
//   //         border: Border.all(color: gMainColor, width: 1),
//   //         boxShadow: (isSelected != txt)
//   //             ? [
//   //                 BoxShadow(
//   //                   color: Colors.grey.withOpacity(0.5),
//   //                   blurRadius: 1,
//   //                 ),
//   //               ]
//   //             : [
//   //                 BoxShadow(
//   //                   color: Colors.grey.withOpacity(0.5),
//   //                   blurRadius: 20,
//   //                   offset: const Offset(2, 10),
//   //                 ),
//   //               ],
//   //       ),
//   //       child: Text(
//   //         txt,
//   //         style: TextStyle(
//   //           fontSize: 10.sp,
//   //           fontFamily: "GothamBook",
//   //           color: isSelected == txt ? gMainColor : gTextColor,
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   /// for slotmodel
//   Widget buildChooseTime(ChildSlotModel model) {
//     String slotName = model.slot!.substring(0,5);
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isSelected = slotName;
//           selectedTimeSlotFullName = model.slot ?? '';
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
//         decoration: BoxDecoration(
//           border: Border.all(color: gMainColor, width: 1),
//           borderRadius: BorderRadius.circular(8),
//           color: (model.isBooked == '0' && isSelected != slotName) ? gWhiteColor : gPrimaryColor,
//           boxShadow: (model.isBooked == '0' && isSelected != slotName)
//               ? [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               blurRadius: 1,
//             ),
//           ]
//               : [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               blurRadius: 20,
//               offset: const Offset(2, 10),
//             ),
//           ],
//         ),
//         child: Text(
//           slotName,
//           style: TextStyle(
//             // fontSize: 10.sp,
//             fontFamily: "GothamBook",
//             color: (model.isBooked != '0' || isSelected == slotName) ? gMainColor : gTextColor,
//           ),
//         ),
//       ),
//     );
//   }
//
//   void buildConfirm(String slotDate, String slotTime) {
//     String? appointmentId;
//     if(widget.isReschedule){
//       appointmentId = _pref.getString(AppConfig.appointmentId);
//     }
//     bookAppointment(slotDate, slotTime, appointmentId: appointmentId);
//   }
//
//   final AyurvedaRepository repository = AyurvedaRepository(
//     apiClient: ApiClient(
//       httpClient: http.Client(),
//     ),
//   );
//
//   bookAppointment(String date, String slotTime, {String? appointmentId}) async{
//     setState(() {
//       showBookingProgress = true;
//     });
//     final res = await AyurvedaService(repository: repository)
//         .bookAppointmentService(date, slotTime,
//         appointmentId: (widget.isReschedule) ? appointmentId : null
//     );
//     print("bookAppointment : " + res.runtimeType.toString());
//     if(res.runtimeType == AppointmentBookingModel){
//       if(widget.isReschedule){
//         _pref.remove(AppConfig.appointmentId);
//       }
//       AppointmentBookingModel result = res;
//       setState(() {
//         showBookingProgress = false;
//       });
//       _pref.setString(AppConfig.appointmentId, result.appointmentId ?? '');
//       _pref.setString(AppConfig.doctorId, result.doctorId ?? '');
//
//       // AppConfig().showSnackbar(context, result.message ?? '');
//       Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => AyurvedaSlotsDetailsScreen(
//               bookingDate: date,
//               bookingTime: isSelected,
//             ),
//           ),);
//     }
//     else{
//       ErrorModel result = res;
//       AppConfig().showSnackbar(context, result.message ?? '', isError: true);
//       setState(() {
//         showBookingProgress = false;
//       });
//     }
//   }
//
// }
