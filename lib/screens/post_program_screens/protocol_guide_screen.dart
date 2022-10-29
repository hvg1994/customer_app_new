import 'package:flutter/material.dart';
import 'package:gwc_customer/repository/post_program_repo/post_program_repository.dart';
import 'package:gwc_customer/services/post_program_service/post_program_service.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../repository/api_service.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'guide_status.dart';
import 'package:http/http.dart' as http;

class ProtocolGuideScreen extends StatefulWidget {
  const ProtocolGuideScreen({Key? key}) : super(key: key);

  @override
  State<ProtocolGuideScreen> createState() => _ProtocolGuideScreenState();
}

class _ProtocolGuideScreenState extends State<ProtocolGuideScreen> {
  Future? getDayProtocolFuture;
  String selectedStatus = "";
  Color? containerColor;
  List optionSelectedList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFuture();
  }

  getFuture({String? dayNumber}){
    getDayProtocolFuture = PostProgramService(repository: postProgramRepository).getProtocolDayDetailsService(dayNumber: dayNumber);
  }

  PostProgramRepository postProgramRepository = PostProgramRepository(
      apiClient: ApiClient(
        httpClient: http.Client()
      )
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildAppBar(() {
                    Navigator.pop(context);
                  }),
                  SizedBox(
                    height: 3.5.h,
                    child: Lottie.asset('assets/lottie/alert.json'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            FutureBuilder(
              future: getDayProtocolFuture,
                builder: (_, snapshot){
                  if(snapshot.hasData){
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Protocol Guide",
                                style: TextStyle(
                                    fontFamily: "GothamBold",
                                    color: gPrimaryColor,
                                    fontSize: 12.sp),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                "Day 1",
                                style: TextStyle(
                                    fontFamily: "GothamMedium",
                                    color: gPrimaryColor,
                                    fontSize: 9.sp),
                              ),
                              buildReactions(),
                            ],
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
                          margin: EdgeInsets.symmetric(vertical: 1.h),
                          color: gGreyColor.withOpacity(0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Score : ---",
                                style: TextStyle(
                                    fontFamily: "GothamBook",
                                    color: gBlackColor,
                                    fontSize: 9.sp),
                              ),
                              Text(
                                "Lorem Ipsum : ---",
                                style: TextStyle(
                                    fontFamily: "GothamBook",
                                    color: gBlackColor,
                                    fontSize: 9.sp),
                              ),
                            ],
                          ),
                        ),
                        buildTile(
                          "assets/lottie/breakfast.json",
                          "Break Fast",
                        ),
                        buildTile(
                          "assets/lottie/lunch.json",
                          "Lunch",
                        ),
                        buildTile(
                          "assets/lottie/dinner.json",
                          "Dinner",
                        ),
                      ],
                    );
                  }
                  else{
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  return buildCircularIndicator();
                }
            )
          ],
        ),
      ),
    );
  }

  buildTile(String lottie, String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 3.w),
      margin: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: buildTextColor(),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Lottie.asset(lottie, height: 7.h),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: "GothamBook",
                color: selectedStatus.isEmpty ? gBlackColor : gWhiteColor,
                fontSize: 11.sp,
              ),
            ),
          ),
          selectedStatus.isEmpty
              ? GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GuideStatus(title: title, dayNumber: 1,isSelected: true,),
                      ),
                    ).then((value) {
                      if(value != null){
                        setState(() {
                          selectedStatus = value;
                        });
                        getFuture();
                      }
                    });
                  },
                  child: Image(
                    image: const AssetImage(
                        "assets/images/noun-arrow-1018952.png"),
                    height: 2.5.h,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  buildReactions() {
    if (selectedStatus == "Do") {
      print(selectedStatus);
      return Lottie.asset('assets/lottie/happy_boy.json');
    } else if (selectedStatus == "Don't Do") {
      return Lottie.asset('assets/lottie/boy_looking_error.json');
    } else if (selectedStatus == "None") {
      return Lottie.asset('assets/lottie/boy_waiting.json');
    } else {
      return Lottie.asset('assets/lottie/women_saying_hi.json');
    }
  }

  Color? buildTextColor() {
    if (selectedStatus == "Do") {
      return containerColor = gPrimaryColor;
    } else if (selectedStatus == "Don't Do") {
      return containerColor = gsecondaryColor;
    } else if (selectedStatus == "None") {
      return containerColor = gMainColor;
    } else {
      return containerColor = gWhiteColor;
    }
  }
}
