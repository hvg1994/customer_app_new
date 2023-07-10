import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart';

import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import '../notification_screen.dart';
import 'bmi/bmi_calculate.dart';
import 'meal_plan_progress.dart';
import 'new_home_screen/water_level_screen.dart';
import 'new_screens/fertility_screen.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final carouselController = CarouselController();
  String? badgeNotification;
  final SharedPreferences _pref = AppConfig().preferences!;
  String? currentUser;
  int _current = 0;

  List reviewList = [
    "assets/images/eval.png",
    "assets/images/slide_start_popup.png",
    "assets/images/Pop up.png",
    "assets/images/meal_popup.png",
    "assets/images/chk_user_report.png",
  ];

  @override
  void initState() {
    super.initState();
    print("_currentUser: ${_pref.getString(AppConfig.User_Name)}");
    currentUser = _pref.getString(AppConfig.User_Name) ?? '';
  }

  String generateAvatarFromName(String string, int limitTo) {
    var buffer = StringBuffer();
    var split = string.split(' ');
    for (var i = 0; i < (limitTo); i++) {
      buffer.write(split[i][0]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 2.w, bottom: 1.h, top: 1.h),
              child: buildAppBar(
                    () {},
                badgeNotification: badgeNotification,
                showNotificationIcon: true,
                isBackEnable: false,
                showLogo: false,
                showChild: true,
                notificationOnTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 2.5.h,
                      backgroundColor: kNumberCircleRed,
                      child: Center(
                        child: Text(
                          generateAvatarFromName("$currentUser", 2),
                          style: TextStyle(
                            color: eUser().threeBounceIndicatorColor,
                            fontFamily: eUser().userFieldLabelFont,
                            fontSize: eUser().userFieldLabelFontSize,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello..!!",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: eUser().mainHeadingColor,
                            fontFamily: eUser().mainHeadingFont,
                            fontSize: eUser().userFieldLabelFontSize,
                          ),
                        ),
                        SizedBox(height: 0.3.h),
                        Text(
                          "$currentUser",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: eUser().mainHeadingColor,
                            fontFamily: eUser().userTextFieldFont,
                            fontSize: eUser().userFieldLabelFontSize,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            buildHomeStory(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: const Divider(
                color: kLineColor,
                thickness: 1,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCards(),
                    buildYourActivity(),
                    buildRecentTips(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildHomeStory() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1.h),
          Text(
            "How your feels today !!",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: eUser().mainHeadingColor,
              fontFamily: eUser().userFieldLabelFont,
              fontSize: eUser().userFieldLabelFontSize,
            ),
          ),
          SizedBox(height: 1.h),
          Stories(
            circlePadding: 2,
            borderThickness: 1,
            displayProgress: true,
            highLightColor: gMainColor,
            spaceBetweenStories: 3.w,
            showThumbnailOnFullPage: true,
            storyStatusBarColor: gWhiteColor,
            showStoryName: true,
            showStoryNameOnFullPage: true,
            fullPagetitleStyle: TextStyle(
                fontFamily: "GothamMedium", color: gWhiteColor, fontSize: 8.sp),
            fullpageVisitedColor: gsecondaryColor,
            fullpageUnisitedColor: gWhiteColor,
            fullpageThumbnailSize: 40,
            autoPlayDuration: const Duration(milliseconds: 3000),
            onPageChanged: () {},
            storyCircleTextStyle: TextStyle(
                fontFamily: "GothamMedium", color: gBlackColor, fontSize: 8.sp),
            storyItemList: [
              StoryItem(
                  name: "Smoothie",
                  thumbnail: const AssetImage(
                    "assets/images/gmg/midDay.png",
                  ),
                  stories: [
                    Scaffold(
                      body: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "assets/images/gmg/midDay.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Scaffold(
                      body: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "assets/images/placeholder.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
              StoryItem(
                name: "Recipes",
                thumbnail: const AssetImage(
                  "assets/images/mini-idli-is.jpg",
                ),
                stories: [
                  Scaffold(
                    body: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            "assets/images/mini-idli-is.jpg",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Scaffold(
                    backgroundColor: gHintTextColor,
                    body: Center(
                      child: Text(
                        "Gut Wellness Club",
                        style: TextStyle(
                            color: gWhiteColor,
                            fontSize: 15.sp,
                            fontFamily: "GothamBold"),
                      ),
                    ),
                  ),
                ],
              ),
              StoryItem(
                  name: "Herbs",
                  thumbnail: const AssetImage(
                    "assets/images/pizza.png",
                  ),
                  stories: [
                    Scaffold(
                      body: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "assets/images/pizza.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Scaffold(
                      body: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "assets/images/placeholder.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
              StoryItem(
                name: "Spices",
                thumbnail: const AssetImage(
                  "assets/images/Mask Group 2171.png",
                ),
                stories: [
                  Scaffold(
                    body: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            "assets/images/Mask Group 2171.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Scaffold(
                    backgroundColor: gHintTextColor,
                    body: Center(
                      child: Text(
                        "Gut Wellness Club",
                        style: TextStyle(
                            color: gWhiteColor,
                            fontSize: 15.sp,
                            fontFamily: "GothamBold"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildCards() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
            width: double.maxFinite,
            child: CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                  viewportFraction: .6,
                  aspectRatio: 1.2,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: reviewList
                  .map(
                    (e) => Container(
                  decoration: BoxDecoration(
                    color: kNumberCircleRed.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        e,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: reviewList.map((url) {
              int index = reviewList.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(
                    vertical: 4.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? gsecondaryColor
                      : kNumberCircleRed.withOpacity(0.3),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  buildYourActivity() {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h, left: 2.w, right: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Text(
              "Your Activity",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: eUser().mainHeadingColor,
                fontFamily: eUser().mainHeadingFont,
                fontSize: eUser().buttonTextSize,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 20.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  height: 20.h,
                  width: 45.w,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: kNumberCircleAmber,
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: gGreyColor.withOpacity(0.1),
                    //     offset: const Offset(2, 3),
                    //     blurRadius: 5,
                    //   )
                    // ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage(
                            "assets/images/faq/challenges_faq.png"),
                        height: 6.h,
                        color: eUser().threeBounceIndicatorColor,
                      ),
                      SizedBox(height: 1.h),
                      // Text(
                      //   "Start to track your meal progress",
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     color: eUser().threeBounceIndicatorColor,
                      //     fontFamily: eUser().userTextFieldFont,
                      //     fontSize: eUser().buttonTextSize,
                      //   ),
                      // ),
                      Text(
                        "Lets click start to calculate Water Level",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: eUser().threeBounceIndicatorColor,
                          fontFamily: eUser().userTextFieldFont,
                          fontSize: eUser().buttonTextSize,
                        ),
                      ),
                      IntrinsicWidth(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return WaterLevelScreen();
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 1.h),
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 5.w),
                            decoration: BoxDecoration(
                              color: kNumberCircleRed,
                              borderRadius: BorderRadius.circular(
                                  eUser().buttonBorderRadius),
                              // border: Border.all(
                              //     color: eUser().buttonBorderColor,
                              //     width: eUser().buttonBorderWidth
                              // ),
                            ),
                            child: Center(
                              child: Text(
                                'START',
                                style: TextStyle(
                                  fontFamily: eUser().buttonTextFont,
                                  color: eUser().buttonTextColor,
                                  fontSize: eUser().resendOtpFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20.h,
                  width: 45.w,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: kNumberCirclePurple,
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: gBlackColor.withOpacity(0.1),
                    //     offset: const Offset(2, 3),
                    //     blurRadius: 5,
                    //   )
                    // ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage(
                              "assets/images/faq/challenges_faq.png"),
                          height: 5.h,
                          color: eUser().threeBounceIndicatorColor,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "Lets click start to calculate your BMI",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: eUser().threeBounceIndicatorColor,
                            fontFamily: eUser().userTextFieldFont,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),
                        IntrinsicWidth(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const BMICalculate();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 1.h),
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: kNumberCircleRed,
                                borderRadius: BorderRadius.circular(
                                    eUser().buttonBorderRadius),
                                // border: Border.all(
                                //     color: eUser().buttonBorderColor,
                                //     width: eUser().buttonBorderWidth
                                // ),
                              ),
                              child: Center(
                                child: Text(
                                  'START',
                                  style: TextStyle(
                                    fontFamily: eUser().buttonTextFont,
                                    color: eUser().buttonTextColor,
                                    fontSize: eUser().resendOtpFontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 20.h,
                  width: 45.w,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: kNumberCircleAmber,
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: gGreyColor.withOpacity(0.1),
                    //     offset: const Offset(2, 3),
                    //     blurRadius: 5,
                    //   )
                    // ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage(
                            "assets/images/faq/challenges_faq.png"),
                        height: 6.h,
                        color: eUser().threeBounceIndicatorColor,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        "Start to track your meal progress",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: eUser().threeBounceIndicatorColor,
                          fontFamily: eUser().userTextFieldFont,
                          fontSize: eUser().buttonTextSize,
                        ),
                      ),
                      IntrinsicWidth(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return MealPlanProgress();
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 1.h),
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 5.w),
                            decoration: BoxDecoration(
                              color: kNumberCircleRed,
                              borderRadius: BorderRadius.circular(
                                  eUser().buttonBorderRadius),
                              // border: Border.all(
                              //     color: eUser().buttonBorderColor,
                              //     width: eUser().buttonBorderWidth
                              // ),
                            ),
                            child: Center(
                              child: Text(
                                'START',
                                style: TextStyle(
                                  fontFamily: eUser().buttonTextFont,
                                  color: eUser().buttonTextColor,
                                  fontSize: eUser().resendOtpFontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20.h,
                  width: 45.w,
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                  margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 1.w),
                  decoration: BoxDecoration(
                    color: kNumberCirclePurple,
                    borderRadius: BorderRadius.circular(10),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: gBlackColor.withOpacity(0.1),
                    //     offset: const Offset(2, 3),
                    //     blurRadius: 5,
                    //   )
                    // ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage(
                              "assets/images/faq/challenges_faq.png"),
                          height: 5.h,
                          color: eUser().threeBounceIndicatorColor,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "Fertility Tracker",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: eUser().threeBounceIndicatorColor,
                            fontFamily: eUser().userTextFieldFont,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),
                        IntrinsicWidth(
                          child: GestureDetector(
                            // onTap: (showLoginProgress) ? null : () {
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return FertilityScreen();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 1.h),
                              padding: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: kNumberCircleRed,
                                borderRadius: BorderRadius.circular(
                                    eUser().buttonBorderRadius),
                                // border: Border.all(
                                //     color: eUser().buttonBorderColor,
                                //     width: eUser().buttonBorderWidth
                                // ),
                              ),
                              child: Center(
                                child: Text(
                                  'START',
                                  style: TextStyle(
                                    fontFamily: eUser().buttonTextFont,
                                    color: eUser().buttonTextColor,
                                    fontSize: eUser().resendOtpFontSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildRecentTips() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Text(
              "Recent Tips",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: eUser().mainHeadingColor,
                fontFamily: eUser().mainHeadingFont,
                fontSize: eUser().buttonTextSize,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 20.h,
            width: double.maxFinite,
            child: CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                  viewportFraction: .6,
                  aspectRatio: 1.2,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: reviewList
                  .map(
                    (e) => Container(
                  decoration: BoxDecoration(
                    color: kNumberCircleRed.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        e,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
          // SizedBox(height: 2.h),
          // Positioned(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: reviewList.map((url) {
          //       int index = reviewList.indexOf(url);
          //       return Container(
          //         width: 8.0,
          //         height: 8.0,
          //         margin: const EdgeInsets.symmetric(
          //             vertical: 4.0, horizontal: 2.0),
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: _current == index
          //               ? gsecondaryColor
          //               : kNumberCircleRed.withOpacity(0.3),
          //         ),
          //       );
          //     }).toList(),
          //   ),
          // ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
