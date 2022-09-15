import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'meal_plan_data.dart';

class MealPlanScreen extends StatefulWidget {
  final String day;
  const MealPlanScreen({Key? key, required this.day}) : super(key: key);

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();
  int _bottomNavIndex = 0;
  String headerText = "";
  Color? textColor;

  List<String> list = [
    "Followed",
    "UnFollowed",
    "Alternative without Doctor",
    "Alternative with Doctor",
  ];

  @override
  void initState() {
    super.initState();
    commentController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3.h, left: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                buildAppBar(() {
                  Navigator.pop(context);
                }),
                SizedBox(height: 1.h),
                Text(
                  "Day ${widget.day} Meal Plan",
                  style: TextStyle(
                      fontFamily: "GothamBold",
                      color: gPrimaryColor,
                      fontSize: 11.sp),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  buildMealPlan(),
                  Container(
                    height: 15.h,
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(2, 10),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: commentController,
                      cursorColor: gPrimaryColor,
                      style: TextStyle(
                          fontFamily: "GothamBook",
                          color: gTextColor,
                          fontSize: 11.sp),
                      decoration: InputDecoration(
                        suffixIcon: commentController.text.isEmpty
                            ? Container(width: 0)
                            : InkWell(
                                onTap: () {
                                  commentController.clear();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: gTextColor,
                                ),
                              ),
                        hintText: "Comments",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontFamily: "GothamBook",
                          color: gTextColor,
                          fontSize: 9.sp,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 2.h),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 5.w),
                        decoration: BoxDecoration(
                          color: gPrimaryColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: gMainColor, width: 1),
                        ),
                        child: Text(
                          'Proceed to Day 2',
                          style: TextStyle(
                            fontFamily: "GothamBook",
                            color: gMainColor,
                            fontSize: 10.sp,
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
    );
  }

  buildMealPlan() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(2, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 5.h,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              gradient: LinearGradient(colors: [
                Color(0xffE06666),
                Color(0xff93C47D),
                Color(0xffFFD966),
              ], begin: Alignment.topLeft, end: Alignment.topRight),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time',
                  style: TextStyle(
                    color: gWhiteColor,
                    fontSize: 11.sp,
                    fontFamily: "GothamMedium",
                  ),
                ),
                Text(
                  'Meal/Yoga',
                  style: TextStyle(
                    color: gWhiteColor,
                    fontSize: 11.sp,
                    fontFamily: "GothamMedium",
                  ),
                ),
                Text(
                  'Status',
                  style: TextStyle(
                    color: gWhiteColor,
                    fontSize: 11.sp,
                    fontFamily: "GothamMedium",
                  ),
                ),
              ],
            ),
          ),
          DataTable(
            headingTextStyle: TextStyle(
              color: gWhiteColor,
              fontSize: 5.sp,
              fontFamily: "GothamMedium",
            ),
            headingRowHeight: 0.h,
            horizontalMargin: 2.w,
            columnSpacing: 35,
            dataRowHeight: 6.h,
            headingRowColor: MaterialStateProperty.all(const Color(0xffE06666)),
            columns: const <DataColumn>[
              DataColumn(
                label: Text('Time'),
              ),
              DataColumn(
                label: Text('Meal/Yoga'),
              ),
              DataColumn(
                label: Text('  Status  '),
              ),
            ],
            rows: mealPlanData
                .map(
                  (s) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          s["time"].toString(),
                          style: TextStyle(
                            height: 1.5,
                            color: gTextColor,
                            fontSize: 8.sp,
                            fontFamily: "GothamBold",
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            s["id"] == 1
                                ? GestureDetector(
                                    onTap: () {},
                                    child: Image(
                                      image: const AssetImage(
                                          "assets/images/noun-play-1832840.png"),
                                      height: 2.h,
                                    ),
                                  )
                                : Container(),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                " ${s["title"].toString()}",
                                maxLines: 3,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height: 1.5,
                                  color: gTextColor,
                                  fontSize: 8.sp,
                                  fontFamily: "GothamBook",
                                ),
                              ),
                            ),
                          ],
                        ),
                        placeholder: true,
                      ),
                      DataCell(
                        PopupMenuButton(
                          offset: const Offset(0, 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 0.6.h),
                                  buildTabView(
                                      index: 1,
                                      title: list[0],
                                      color: gPrimaryColor),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 1.h),
                                    height: 1,
                                    color: gGreyColor.withOpacity(0.3),
                                  ),
                                  buildTabView(
                                      index: 2,
                                      title: list[1],
                                      color: gsecondaryColor),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 1.h),
                                    height: 1,
                                    color: gGreyColor.withOpacity(0.3),
                                  ),
                                  buildTabView(
                                      index: 3,
                                      title: list[2],
                                      color: gMainColor),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 1.h),
                                    height: 1,
                                    color: gGreyColor.withOpacity(0.3),
                                  ),
                                  buildTabView(
                                      index: 4,
                                      title: list[3],
                                      color: gMainColor),
                                  SizedBox(height: 0.6.h),
                                ],
                              ),
                            ),
                          ],
                          child: Container(
                            width: 20.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.2.h),
                            decoration: BoxDecoration(
                              color: gWhiteColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: gMainColor, width: 1),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    buildHeaderText(),
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "GothamBook",
                                        color: buildTextColor(),
                                        fontSize: 8.sp),
                                  ),
                                ),
                                Icon(
                                  Icons.expand_more,
                                  color: gGreyColor,
                                  size: 2.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  void onChangedTab(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget buildTabView({
    required int index,
    required String title,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        onChangedTab(index);
        Get.back();
      },
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "GothamBook",
          color: (_bottomNavIndex == index) ? color : gTextColor,
          fontSize: 8.sp,
        ),
      ),
    );
  }

  String buildHeaderText() {
    if (_bottomNavIndex == 0) {
      headerText = "     ";
    } else if (_bottomNavIndex == 1) {
      headerText = "Followed";
    } else if (_bottomNavIndex == 2) {
      headerText = "UnFollowed";
    } else if (_bottomNavIndex == 3) {
      headerText = "Alternative without Doctor";
    } else if (_bottomNavIndex == 4) {
      headerText = "Alternative with Doctor";
    }
    return headerText;
  }

  Color? buildTextColor() {
    if (_bottomNavIndex == 0) {
      textColor = gWhiteColor;
    } else if (_bottomNavIndex == 1) {
      textColor = gPrimaryColor;
    } else if (_bottomNavIndex == 2) {
      textColor = gsecondaryColor;
    } else if (_bottomNavIndex == 3) {
      textColor = gMainColor;
    } else if (_bottomNavIndex == 4) {
      textColor = gMainColor;
    }
    return textColor!;
  }
}

class MealPlanData {
  MealPlanData(this.time, this.title, this.id);

  String time;
  String title;
  int id;
}
