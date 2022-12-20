import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../model/post_program_model/protocol_summary_model.dart';
import '../../utils/api_urls.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class PPSummaryScreen extends StatefulWidget {
  const PPSummaryScreen({Key? key}) : super(key: key);

  @override
  State<PPSummaryScreen> createState() => _PPSummaryScreenState();
}

class _PPSummaryScreenState extends State<PPSummaryScreen> {
  ProtocolSummary? protocolSummary;

  @override
  void initState() {
    super.initState();
    getDaySummary();
  }

  Future<ProtocolSummary> getDaySummary() async {
    dynamic res;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(AppConfig().BEARER_TOKEN)!;

    final response = await http.get(Uri.parse("$daySummaryUrl/1"), headers: {
      'Authorization': 'Bearer $token',
    });
    // print("Summary response: ${response.body}");
    if (response.statusCode == 200) {
      res = jsonDecode(response.body);
      protocolSummary = ProtocolSummary.fromJson(res);
    } else {
      throw Exception();
    }
    return ProtocolSummary.fromJson(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: FutureBuilder(
            future: getDaySummary(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 7.h),
                  child: Image(
                    image: const AssetImage("assets/images/Group 5294.png"),
                    height: 35.h,
                  ),
                );
              } else if (snapshot.hasData) {
                var data = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //SizedBox(height: 1.h),
                    buildAppBar(
                      () {
                        Navigator.pop(context);
                      },
                      isBackEnable: true,
                      showNotificationIcon: false,
                    ),
                    Text(
                      "Day 1 Summary",
                      style: TextStyle(
                          fontFamily: "GothamBold",
                          color: gBlackColor,
                          fontSize: 11.sp),
                    ),
                    SizedBox(height: 3.h),
                    buildEmoji(data),

                    SizedBox(height: 3.h),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.summary.length,
                      itemBuilder: ((context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            buildTile(
                              "assets/images/empty_stomach.png",
                              "Early Morning",
                              getMorningColor(data.summary[index].earlyMorning),
                            ),
                            buildTile(
                              "assets/images/breakfast_icon.png",
                              "BreakFast",
                              getBreakfastColor(data.summary[index].breakfast),
                            ),
                            buildTile(
                              "assets/images/midday_icon.png",
                              "Mid Day",
                              getMidDayColor(data.summary[index].midDay),
                            ),
                            buildTile(
                              "assets/images/lunch_icon.png",
                              "Lunch",
                              getLunchColor(data.summary[index].lunch),
                            ),
                            buildTile(
                              "assets/images/evening_icon.png",
                              "Evening",
                              getEveningColor(data.summary[index].evening),
                            ),
                            buildTile(
                              "assets/images/dinner_icon.png",
                              "Dinner",
                              getDinnerColor(data.summary[index].dinner),
                            ),
                            buildTile(
                              "assets/images/pp_icon.png",
                              "Post Dinner",
                              getPostDinnerColor(
                                  data.summary[index].postDinner),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                );
              }
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: buildCircularIndicator(),
              );
            }),
      ),
    );
  }

  buildTile(String lottie, String title, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w),
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Image(
          image: AssetImage(lottie),
          color: gWhiteColor,
          height: 3.h,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: "GothamBook",
            color: gWhiteColor,
            fontSize: 11.sp,
          ),
        ),
      ),
    );
  }

  buildEmoji(data) {
    print("object:${data.score}");
    if (data.score == 1) {
      return const Center(
        child: Image(
          image: AssetImage("assets/images/Group 11526.png"),
        ),
      );
    } else if (data.score == 2) {
      return const Center(
        child: Image(
          image: AssetImage("assets/images/Group 11528.png"),
        ),
      );
    } else if (data.score == 3) {
      return const Center(
        child: Image(
          image: AssetImage("assets/images/Group 11527.png"),
        ),
      );
    } else if (data.score == 4) {
      return const Center(
        child: Image(
          image: AssetImage("assets/images/Group 11552.png"),
        ),
      );
    } else {
      return Container();
    }
  }

  getMorningColor(earlyMorning) {
    if (earlyMorning == "1") {
      return gPrimaryColor;
    } else if (earlyMorning == "2") {
      return gMainColor;
    } else {
      return gWhiteColor;
    }
  }

  getBreakfastColor(breakfast) {
    if (breakfast == "1") {
      return gPrimaryColor;
    } else if (breakfast == "2") {
      return gMainColor;
    } else {
      return gWhiteColor;
    }
  }

  getMidDayColor(midDay) {
    if (midDay == "1") {
      return gPrimaryColor;
    } else if (midDay == "2") {
      return gMainColor;
    } else {
      return gWhiteColor;
    }
  }

  getLunchColor(lunch) {
    if (lunch == "1") {
      return gPrimaryColor;
    } else if (lunch == "2") {
      return gMainColor;
    } else {
      return gWhiteColor;
    }
  }

  getEveningColor(evening) {
    if (evening == "1") {
      return gPrimaryColor;
    } else if (evening == "2") {
      return gMainColor;
    } else {
      return gWhiteColor;
    }
  }

  getDinnerColor(dinner) {
    if (dinner == "1") {
      return gPrimaryColor;
    } else if (dinner == "2") {
      return gMainColor;
    } else {
      return gWhiteColor;
    }
  }

  getPostDinnerColor(postDinner) {
    if (postDinner == "1") {
      return gPrimaryColor;
    } else if (postDinner == "2") {
      return gMainColor;
    } else {
      return gWhiteColor;
    }
  }
}
