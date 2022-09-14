// // ignore_for_file: deprecated_member_use
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:gut_wellness_app/view/zoom_screen.dart';
// import 'package:gut_wellness_app/widgets/widgets.dart';
// import 'package:sizer/sizer.dart';
//
// import 'package:gut_wellness_app/widgets/constants.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import 'ayurveda_calender_time_screen.dart';
// import 'ayurveda_consultation_completed.dart';
//
// class AyurvedaSlotsDetailsScreen extends StatelessWidget {
//   final String bookingDate;
//   final String bookingTime;
//   const AyurvedaSlotsDetailsScreen({
//     Key? key,
//     required this.bookingDate,
//     required this.bookingTime,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             Padding(
//               padding:
//                   EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 2.h),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       buildAppBar(() {
//                         Navigator.pop(context);
//                       }),
//                       Text(
//                         "Ayurveda Consultation",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontFamily: "GothamRoundedBold_21016",
//                             color: gPrimaryColor,
//                             fontSize: 12.sp),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 8.h,
//                   ),
//                   SizedBox(
//                     height: 15.h,
//                     child: const Center(
//                       child: Image(
//                         image: AssetImage("assets/images/Group 2523.png"),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 4.h,
//                   ),
//                   Center(
//                     child: Text(
//                       "Dr.Swarnalatha",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontFamily: "GothamRoundedBold_21016",
//                           color: gPrimaryColor,
//                           fontSize: 15.sp),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 0.5.h,
//                   ),
//                   Center(
//                     child: Text(
//                       "Ayurveda Specialist",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontFamily: "GothamBook",
//                           color: gSecondaryColor,
//                           fontSize: 10.sp),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: SizedBox(
//                 height: double.maxFinite,
//                 width: double.maxFinite,
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Stack(
//                       fit: StackFit.expand,
//                       children: [
//                         Positioned(
//                           bottom: 0,
//                           left: 0,
//                           right: 0,
//                           top: 5.h,
//                           child: Container(
//                             color: kPrimaryColor,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "Your Slot @ ",
//                                       style: TextStyle(
//                                           fontFamily: "GothamMedium",
//                                           color: gWhiteColor,
//                                           fontSize: 12.sp),
//                                     ),
//                                     Text(
//                                       bookingTime.toString(),
//                                       style: TextStyle(
//                                           fontFamily: "GothamRoundedBold_21016",
//                                           color: gWhiteColor,
//                                           fontSize: 13.sp),
//                                     ),
//                                     Text(
//                                       " on the",
//                                       style: TextStyle(
//                                           fontFamily: "GothamMedium",
//                                           color: gWhiteColor,
//                                           fontSize: 12.sp),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 0.5.h),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       bookingDate.toString(),
//                                       style: TextStyle(
//                                           fontFamily: "GothamRoundedBold_21016",
//                                           color: gWhiteColor,
//                                           fontSize: 13.sp),
//                                     ),
//                                     Text(
//                                       ", Has Been Confirmed",
//                                       style: TextStyle(
//                                           fontFamily: "GothamMedium",
//                                           color: gWhiteColor,
//                                           fontSize: 12.sp),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 2.h,
//                                 ),
//                                 Text(
//                                   "Note:",
//                                   style: TextStyle(
//                                       fontFamily: "GothamMedium",
//                                       color: gWhiteColor,
//                                       fontSize: 12.sp),
//                                 ),
//                                 SizedBox(
//                                   height: 1.h,
//                                 ),
//                                 Text(
//                                   "Please Keep Your Medical Reports \nFrom The Past Handy",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(height: 1.5,
//                                       fontFamily: "GothamMedium",
//                                       color: gWhiteColor,
//                                       fontSize: 12.sp),
//                                 ),
//                                 SizedBox(
//                                   height: 5.h,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () {
//                                         // joinGoogleMeet();
//                                         Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 ZoomScreen(
//                                               bookingDate: bookingDate,
//                                               bookingTime: bookingTime,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 1.h, horizontal: 5.w),
//                                         decoration: BoxDecoration(
//                                           color: gWhiteColor,
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           border: Border.all(
//                                               color: gMainColor, width: 1),
//                                         ),
//                                         child: Text(
//                                           'Join',
//                                           style: TextStyle(
//                                             fontFamily:
//                                                 "GothamRoundedBold_21016",
//                                             color: gPrimaryColor,
//                                             fontSize: 13.sp,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 5.w),
//                                     GestureDetector(
//                                       onTap: () {
//                                         Navigator.of(context).pushReplacement(
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   const AyurvedaCalenderTimeScreen(isReschedule: true,)),
//                                         );
//                                       },
//                                       child: Container(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 1.h, horizontal: 5.w),
//                                         decoration: BoxDecoration(
//                                           color: gWhiteColor,
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           border: Border.all(
//                                               color: gMainColor, width: 1),
//                                         ),
//                                         child: Text(
//                                           'Reschedule',
//                                           style: TextStyle(
//                                             fontFamily:
//                                                 "GothamRoundedBold_21016",
//                                             color: gPrimaryColor,
//                                             fontSize: 13.sp,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           left: 10.w,
//                           right: 10.w,
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 3.w, vertical: 1.h),
//                             decoration: BoxDecoration(
//                               color: kSecondaryColor,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Row(
//                               children: [
//                                 SvgPicture.asset(
//                                     "assets/images/splash_screen/Calendar.svg"),
//                                 SizedBox(width: 5.w),
//                                 Text(
//                                   "Lorem Ipsum Dialmd",
//                                   style: TextStyle(
//                                       fontFamily: "GothamMedium",
//                                       color: gTextColor,
//                                       fontSize: 10.sp),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   joinGoogleMeet() async {
//     const url = 'https://meet.google.com/rxf-uxca-jpx';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }
