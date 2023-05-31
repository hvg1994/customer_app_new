import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../model/dashboard_model/gut_model/gut_data_model.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'package:intl/intl.dart';


class ConsultationHistoryScreen extends StatelessWidget {
  final ConsultationHistory? consultationHistory;
  ConsultationHistoryScreen({Key? key, this.consultationHistory}) : super(key: key);

  String? consultationDateAndTime;

  getTime(String time){
    var splited = time.split(':');
    print("splited:$splited");
    String hour = splited[0];
    String minute = splited[1];
    int second = int.parse(splited[2]);
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    print("consultationHistory: ${consultationHistory!.toJson()}");
    final conDate = DateTime.parse(consultationHistory!.consultationDate!);
    final date = DateFormat('dd').format(conDate);
    final month = DateFormat('MMM yy').format(conDate);
    String formattedDate = getDayOfMonthSuffix(int.parse(date));
    print("$date$formattedDate $month");
    final formatedDateString = "$date$formattedDate $month";
    consultationDateAndTime = "$formatedDateString, ${getTime(consultationHistory!.consultationStartTime!)} - ${getTime(consultationHistory!.consultationEndTime!)}";

    return SafeArea(
      child: Scaffold(
        backgroundColor: gBackgroundColor,
        body: Column(
          children: [
            Expanded(child: buildUserDetails(context),),
          ],
        ),
      ),
    );
  }

  buildUserDetails(BuildContext context) {
    String? doctorName = consultationHistory!.appointDoctor!.name;
    String? designation = consultationHistory!.appointDoctor!.doctor!.specialization!.name;
    String? profilePic = consultationHistory!.appointDoctor!.profile;

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                image: (profilePic == null)
                    ? DecorationImage(
                    image: AssetImage(
                      "assets/images/new_ds/history_doctor.png",
                    ),
                    fit: BoxFit.fill)
                    : DecorationImage(
                    image: CachedNetworkImageProvider(
                      profilePic!,
                    ),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            left: 0,
            right: 0,
            child: Container(
              height: 66.h,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                color: gWhiteColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),

              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      "Consultation History",
                      style: TextStyle(
                        color: gBlackColor,
                        fontFamily: kFontBold,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "About",
                      style: TextStyle(
                        color: gBlackColor,
                        fontFamily: kFontBold,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Text(
                      "${consultationHistory?.appointDoctor?.doctor?.experience}Yrs of Experience\n""${consultationHistory?.appointDoctor?.doctor?.desc}" ?? '',
                      style: TextStyle(
                        color: gBlackColor,
                        fontFamily: kFontBook,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "Consultation Date & Time",
                      style: TextStyle(
                        color: gBlackColor,
                        fontFamily: kFontBold,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/images/new_ds/history_timer.png",
                        width: 15.sp,height: 15.sp,),
                        SizedBox(width: 10,),
                        Text(
                          consultationDateAndTime ?? '',
                          style: TextStyle(
                            color: gBlackColor,
                            fontFamily: kFontBook,
                            fontSize: 10.sp,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5.h,),
                    Center(
                      child: GestureDetector(
                        // onTap: (showLoginProgress) ? null : () {
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: IntrinsicWidth(
                          child: Container(
                            margin:
                            EdgeInsets.symmetric(vertical: 4.h),
                            padding: EdgeInsets.symmetric(
                                vertical: 1.5.h, horizontal: 8.w),
                            decoration: BoxDecoration(
                              color: kNumberCircleRed,
                              borderRadius: BorderRadius.circular(10),
                              // border: Border.all(
                              //     color: eUser().buttonBorderColor,
                              //     width: eUser().buttonBorderWidth
                              // ),
                            ),
                            child: Center(
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  fontFamily: eUser().buttonTextFont,
                                  color: gWhiteColor,
                                  fontSize: eUser().buttonTextSize,
                                ),
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
          // center card widget
          Positioned(
            top: 36.h,
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: 8.h,
              // padding:
              //     EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: gSitBackBgColor,
                boxShadow: [
                  BoxShadow(
                    color: kLineColor.withOpacity(0.5),
                    offset: const Offset(2, 5),
                    blurRadius: 5,
                  )
                ],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    doctorName ?? '',
                    style: TextStyle(
                      color: gBlackColor,
                      fontFamily: kFontBold,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    designation ?? '',
                    style: TextStyle(
                      color: gTextColor,
                      height: 1.3,
                      fontFamily: kFontBook,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      );
    });
  }

  Widget showNameWidget(){
    return Container(
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
                  fontFamily: kFontMedium,
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
    );
  }
}
