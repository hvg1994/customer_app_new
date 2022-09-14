import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'doctor_slots_details_screen.dart';

class DoctorCalenderTimeScreen extends StatefulWidget {
  const DoctorCalenderTimeScreen({Key? key}) : super(key: key);

  @override
  State<DoctorCalenderTimeScreen> createState() =>
      _DoctorCalenderTimeScreenState();
}

class _DoctorCalenderTimeScreenState extends State<DoctorCalenderTimeScreen> {
  DatePickerController dateController = DatePickerController();
  final pageController = PageController();
  String isSelected = "";
  double rating = 5.0;

  List<String> list = ["09:00", "11:00", "02:00", "04:00"];

  DateTime selectedValue = DateTime.now();

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
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildDoctorDetails(
                        "Patient", "10K", "assets/images/Patient.svg"),
                    buildDoctorDetails("Experience", "12 Years",
                        "assets/images/Experences.svg"),
                    buildDoctorDetails(
                        "Rating", "4.5", "assets/images/star.svg"),
                  ],
                ),
                SizedBox(
                  height: 3.h,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildChooseTime(list[0]),
                    buildChooseTime(list[1]),
                    buildChooseTime(list[2]),
                    buildChooseTime(list[3]),
                  ],
                ),
                SizedBox(
                  height: 6.h,
                ),
                isSelected.isEmpty
                    ? Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: gMainColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: gMainColor, width: 1),
                          ),
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontFamily: "GothamRoundedBold_21016",
                              color: gPrimaryColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: GestureDetector(
                          onTap: () {
                            buildConfirm();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 10.w),
                            decoration: BoxDecoration(
                              color: gPrimaryColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: gMainColor, width: 1),
                            ),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontFamily: "GothamRoundedBold_21016",
                                color: gMainColor,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
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
            selectedValue = date;
          });
        },
      ),
    );
  }

  void changedIndex(String index) {
    setState(() {
      isSelected = index;
    });
  }

  Widget buildChooseTime(String txt) {
    return GestureDetector(
      onTap: () {
        changedIndex(txt);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: (isSelected != txt) ? gWhiteColor : gPrimaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: gMainColor, width: 1),
          boxShadow: (isSelected != txt)
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
          txt,
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: "GothamBook",
            color: isSelected == txt ? gMainColor : gTextColor,
          ),
        ),
      ),
    );
  }

  void buildConfirm() {
    DateTime now = DateTime.parse('$selectedValue');
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    if (isSelected.isEmpty) {
      // buildSnackBar("Failed", "Please Choose Time");
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DoctorSlotsDetailsScreen(
            bookingDate: formatted,
            bookingTime: isSelected,
          ),
        ),
      );
    }
  }
}
