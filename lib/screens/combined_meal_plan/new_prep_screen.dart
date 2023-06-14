import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../model/combined_meal_model/new_prep_model.dart';
import '../../widgets/constants.dart';
import '../prepratory plan/new/meal_plan_recipe_details.dart';

class NewPrepScreen extends StatefulWidget {
  final ChildPrepModel prepPlanDetails;
  final int selectedDay;
  String? totalDays;
  final bool viewDay1Details;
  final bool showBlur;
  NewPrepScreen({Key? key, required this.prepPlanDetails,
    this.selectedDay = 1,
    this.viewDay1Details = false,
    this.totalDays,
    this.showBlur = false
  }) : super(key: key);

  @override
  State<NewPrepScreen> createState() => _NewPrepScreenState();
}

class _NewPrepScreenState extends State<NewPrepScreen> with TickerProviderStateMixin{

  AnimationController? _animationController;
  Offset checkedPositionOffset = Offset(0, 0);
  Offset lastCheckOffset = Offset(0, 0);
  Offset animationOffset = Offset(0, 0);
  late Animation _animation;

  TabController? _tabController;

  ChildPrepModel? _childPrepModel;
  Map<String, SubItems> slotNamesForTabs = {};
  int tabSize = 1;

  String selectedSlot = "";
  String selectedItemName = "";

  int? presentDay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrepItemsAndStore(widget.prepPlanDetails);

  }

  void getPrepItemsAndStore(ChildPrepModel childPrepModel) {
    _childPrepModel = childPrepModel;
    print("prep--");
    print(_childPrepModel!.toJson());
    if(_childPrepModel != null){
      slotNamesForTabs.addAll(_childPrepModel!.details!);

      print(slotNamesForTabs);

      if(slotNamesForTabs.isNotEmpty){
        selectedSlot = slotNamesForTabs.keys.first;
        selectedItemName = slotNamesForTabs.values.first.subItems!.keys.first;
      }
      tabSize = slotNamesForTabs.length;

      presentDay = _childPrepModel!.currentDay;
    }
    _tabController = TabController(vsync: this, length: tabSize);
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabSize,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 3.w,top: 2.h,bottom: 1.h),
              child: Text(
                'Preparatory Phase',
                style: TextStyle(
                    fontFamily: eUser().mainHeadingFont,
                    color: eUser().mainHeadingColor,
                    fontSize: eUser().mainHeadingFontSize),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: Text(
                'Day ${presentDay} of Day ${2}',
                style: TextStyle(
                    fontFamily: kFontMedium,
                    color: eUser().mainHeadingColor,
                    fontSize: 10.sp),
              ),
            ),
            // SizedBox(height: 1.h),
            // Padding(
            //   padding: EdgeInsets.only(left: 3.w),
            //   child: Text(
            //     '2 Days Remaining',
            //     style: TextStyle(
            //         fontFamily: eUser().userTextFieldFont,
            //         color: eUser().userTextFieldColor,
            //         fontSize: eUser().userTextFieldHintFontSize),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      decoration: BoxDecoration(
                        color: Color(0xffC8DE95).withOpacity(0.6),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: TabBar(
                        isScrollable: true,
                        unselectedLabelColor: Colors.black,
                        labelColor: gWhiteColor,
                        controller: _tabController,
                        unselectedLabelStyle: TextStyle(
                            fontFamily: kFontBook,
                            color: gHintTextColor,
                            fontSize: 9.sp),
                        labelStyle: TextStyle(
                            fontFamily: kFontMedium,
                            color: gBlackColor,
                            fontSize: 11.sp),
                        indicator: BoxDecoration(
                          color: newDashboardGreenButtonColor,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        onTap: (index) {
                          print("ontap: $index");
                          // print(slotNamesForTabs.keys.elementAt(index));
                          selectedSlot =
                              slotNamesForTabs.keys.elementAt(index);
                          setState(() {
                            selectedItemName = slotNamesForTabs[selectedSlot]!.subItems!.keys.first;
                            print(selectedItemName);
                          });
                          // _buildList(index);
                        },
                        tabs: slotNamesForTabs.keys
                            .map((e) => Tab(
                          text: e,
                        ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ...slotNamesForTabs.values
                      .map(
                        (e) => buildTabView(e),
                  )
                      .toList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  buildTabView(SubItems mealNames) {
    List<MealSlot> meals = [];
    List<String> subItems = [];
    slotNamesForTabs.entries.map((e) {
      print("compare");
      print(e.value.subItems == mealNames.subItems);
      if(e.value.subItems == mealNames.subItems){
        mealNames.subItems!.forEach((key, element) {
          subItems.add(key);
          print("$key -- $element");
          if (key == selectedItemName) {
            meals.addAll(element);
          }
        });
      }
    }).toList();
    // print("meals.length: ${meals.length}");
    return Row(
      children: [
        Stack(
          children: <Widget>[
            Container(
              width: 50,
              decoration: BoxDecoration(
                color: Color(0xffC8DE95).withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  // topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _buildList(subItems),
              ),
            ),
            // Positioned(
            //   top: animationOffset.dy,
            //   left: animationOffset.dx,
            //   child: CustomPaint(
            //     painter: CheckPointPainter(Offset(10, 0)),
            //   ),
            // )
          ],
        ),
        Expanded(
          child: SizedBox(
            height: 65.h,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        width: 300,
                        margin: EdgeInsets.only(
                            left: 3.w, right: 3.w, top: 5.h, bottom: 5.h),
                        padding: EdgeInsets.only(bottom: 2.h),
                        decoration: BoxDecoration(
                          color: gBackgroundColor,
                          borderRadius: BorderRadius.circular(40),

                          // boxShadow:  [
                          //   BoxShadow(
                          //     color: gWhiteColor,
                          //     offset: Offset(0.0, 0.75),
                          //     blurRadius: 5,
                          //   )
                          // ],
                        ),
                        child: buildReceipeDetails(meals[index]),
                      ),
                      if(meals.length > 1)orFiled(index),
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }

  buildReceipeDetails(MealSlot? meal) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          bottom: 0,
          left: 2.w,
          right: 0,
          top: 6.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(40),
              border:
              Border.all(color: kLineColor.withOpacity(0.2), width: 0.9),
              // boxShadow:  [
              //   BoxShadow(
              //     color: gBlackColor.withOpacity(0.1),
              //     offset: Offset(2, 3),
              //     blurRadius: 5,
              //   )
              // ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    meal?.name ?? '',
                    style: TextStyle(
                        fontFamily: eUser().mainHeadingFont,
                        color: eUser().mainHeadingColor,
                        fontSize: eUser().mainHeadingFontSize),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  (meal?.benefits != null)
                      ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...meal!.benefits!.split('-').map((element) {
                        if(element.isNotEmpty) return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.circle_sharp,
                              color: gGreyColor,
                              size: 1.h,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                element ?? '',
                                style: TextStyle(
                                    fontFamily: eUser().userTextFieldFont,
                                    height: 1.5,
                                    color: eUser().userTextFieldColor,
                                    fontSize: eUser()
                                        .userTextFieldHintFontSize),
                              ),
                            ),
                          ],
                        );
                        else return SizedBox();

                      })
                    ],
                  )
                      : const SizedBox(),
                  SizedBox(height: 5.h),
                  (meal!.howToPrepare != null)
                      ? GestureDetector(
                    onTap: () {
                      // Get.to(
                      //       () => MealPlanRecipeDetails(
                      //     meal: meal,
                      //   ),
                      // );
                    },
                    child: Center(
                      child: Container(
                        // margin: EdgeInsets.symmetric(horizontal: 5.w),
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 5.w),
                        decoration: const BoxDecoration(
                          color: newDashboardGreenButtonColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kLineColor,
                              offset: Offset(2, 3),
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: Text(
                          "Recipe",
                          style: TextStyle(
                            color: gWhiteColor,
                            fontFamily: kFontBook,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ),
                  )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0.h,
          left: 0,
          // right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: newDashboardGreenButtonColor,
              boxShadow: [
                BoxShadow(
                  color: gBlackColor.withOpacity(0.1),
                  offset: const Offset(2, 5),
                  blurRadius: 5,
                )
              ],
            ),
            child: Center(
              child: CircleAvatar(
                  radius: 8.h,
                  backgroundImage:
                  CachedNetworkImageProvider(meal.itemPhoto ?? '')
                // AssetImage("assets/images/Group 3252.png"),
              ),
            ),
          ),
        ),
      ],
    );
  }

  orFiled(int index) {
    if (index.isEven) {
      return const Center(
        child: Text(
          'OR',
          style: TextStyle(fontFamily: kFontBold, color: gBlackColor),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  List<Widget> _buildList(List<String>? subItems) {
    List<Widget> WidgetList = [];

    if (subItems != null) {
      print("subItems: $subItems");
      subItems.forEach((key) {
        WidgetList.add(
            GestureDetector(
            onTap: () {
              print(key);
              indexChecked(key);
            },
            child: RotatedBox(
              quarterTurns: 3,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                decoration: selectedItemName == key
                    ? const BoxDecoration(
                  color: gWhiteColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                )
                    : const BoxDecoration(),
                child: Text(
                  key,
                  style: TextStyle(
                    color: selectedItemName == key ? gBlackColor : gWhiteColor,
                    fontSize: 16,
                  ),
                ),
              ),
            )));
      });
    }
    print(WidgetList);
    return WidgetList;
  }

  void indexChecked(String selected) {
    print("${selectedItemName} == $selected");
    // if (selectedItemName == selected) return;

    selectedItemName = "";
    setState(() {
      selectedItemName = selected;
      // calcuteCheckOffset();
      addAnimation();
    });
  }

  void addAnimation() {
    _animationController =
    AnimationController(duration: Duration(milliseconds: 300), vsync: this)
      ..addListener(() {
        setState(() {
          animationOffset =
              Offset(checkedPositionOffset.dx, _animation.value);
        });
      });

    _animation = Tween(begin: lastCheckOffset.dy, end: checkedPositionOffset.dy)
        .animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.easeInOutBack));
    _animationController!.forward();
  }


}

