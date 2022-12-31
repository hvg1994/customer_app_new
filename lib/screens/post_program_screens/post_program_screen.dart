/*
after completing meal plan status will be =>  post_program
after appointment booked => post_appointment_booked
after consultation done => post_appointment_done
post_appointment_done after getting this status doctor will upload protocol guide meal plan
once doctor uploads protocol guide meal plan => protocol_guide
then user can start this protocol guide
 */

import 'package:flutter/material.dart';
import 'package:gwc_customer/screens/appointment_screens/consultation_screens/consultation_success.dart';
import 'package:gwc_customer/screens/appointment_screens/doctor_calender_time_screen.dart';
import 'package:gwc_customer/screens/appointment_screens/doctor_slots_details_screen.dart';
import 'package:gwc_customer/screens/post_program_screens/protocol_guide_screen.dart';
import 'package:sizer/sizer.dart';

import '../../model/dashboard_model/get_appointment/get_appointment_after_appointed.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class PostProgramScreen extends StatefulWidget {
  final String? postProgramStage;
  final dynamic? consultationData;
  const PostProgramScreen({Key? key, this.postProgramStage, this.consultationData}) : super(key: key);

  @override
  State<PostProgramScreen> createState() => _PostProgramScreenState();
}

class _PostProgramScreenState extends State<PostProgramScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            left: 4.w,
            right: 4.w,
            top: 1.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(height: 1.h),
              Text(
                "Post Program",
                style: TextStyle(
                    fontFamily: "GothamBold",
                    color: gPrimaryColor,
                    fontSize: 11.sp),
              ),
              SizedBox(height: 2.h),
              buildPostPrograms(
                "assets/images/medical-staff.png",
                "Consultation",
                () {
                  if(widget.postProgramStage == 'post_program'){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => DoctorCalenderTimeScreen(isPostProgram: true,)));
                  }
                  else if(widget.postProgramStage == 'post_appointment_booked'){
                    GetAppointmentDetailsModel model = widget.consultationData as GetAppointmentDetailsModel;
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => DoctorSlotsDetailsScreen(
                      bookingDate: model.value!.date!,
                      bookingTime: model.value!.slotStartTime!,
                      isPostProgram: true,
                      dashboardValueMap: model.value!.toJson() ,)));
                  }
                  else {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => ConsultationSuccess()));
                  }
                },
                color: kWhiteColor
              ),
              buildPostPrograms(
                "assets/images/information.png",
                "Protocol Guide",
                  (widget.postProgramStage == 'protocol_guide')
                      ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProtocolGuideScreen(),
                    ),
                  );
                } : () => null,
                color: (widget.postProgramStage == 'protocol_guide') ? kWhiteColor : gGreyColor.withOpacity(0.05)
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildPostPrograms(String image, String title, func, {Color? color}) {
    return GestureDetector(
      onTap: func,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
        margin: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
            color: color ?? kWhiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: gMainColor.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 1,
              ),
            ]),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                height: 8.h,
                image: AssetImage(image),
              ),
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: "GothamMedium",
                  color: gTextColor,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
