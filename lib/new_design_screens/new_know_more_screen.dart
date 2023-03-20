import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../widgets/constants.dart';
import '../widgets/widgets.dart';

class NewKnowMoreScreen extends StatefulWidget {
  final String knowMore;
  final String healAtHome;
  final String healAnywhere;
  final String whenToReachUs;
  const NewKnowMoreScreen(
      {Key? key,
      required this.knowMore,
      required this.healAtHome,
      required this.healAnywhere,
      required this.whenToReachUs})
      : super(key: key);

  @override
  State<NewKnowMoreScreen> createState() => _NewKnowMoreScreenState();
}

class _NewKnowMoreScreenState extends State<NewKnowMoreScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                buildNewAppBar(() {
                  Navigator.pop(context);
                }),
                TabBar(
                    // padding: EdgeInsets.symmetric(horizontal: 3.w),
                    labelColor: gBlackColor,
                    unselectedLabelColor: gHintTextColor,
                    isScrollable: true,
                    indicatorColor: gsecondaryColor,
                    labelPadding:
                        EdgeInsets.only(right: 8.w, top: 1.h, bottom: 1.h),
                    indicatorPadding: EdgeInsets.only(right: 5.w),
                    unselectedLabelStyle: TextStyle(
                        fontFamily: "GothamBook",
                        color: gHintTextColor,
                        fontSize: 9.sp),
                    labelStyle: TextStyle(
                        fontFamily: "GothamMedium",
                        color: gBlackColor,
                        fontSize: 11.sp),
                    tabs: const [
                      Text('Know More'),
                      Text("Heal At Home"),
                      Text('Heal Anywhere'),
                      Text("When To Reach Us?"),
                    ]),
                Expanded(
                  child: TabBarView(
                      // physics: const NeverScrollableScrollPhysics(),
                      children: [
                        buildKnowMoreDetails(),
                        buildHealAtHomeDetails(),
                        buildHealAnywhereDetails(),
                        buildWhenToReachUsDetails(),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildKnowMoreDetails() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(height: 2.h),
          Center(
            child: Image(
              image: CachedNetworkImageProvider(widget.knowMore),
            ),
          ),
        ],
      ),
    );
  }

  buildHealAtHomeDetails() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(height: 2.h),
          Center(
            child: Image(
              image: CachedNetworkImageProvider(widget.healAtHome),
            ),
          ),
        ],
      ),
    );
  }

  buildHealAnywhereDetails() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(height: 2.h),
          Center(
            child: Image(
              image: CachedNetworkImageProvider(widget.healAnywhere),
            ),
          ),
        ],
      ),
    );
  }

  buildWhenToReachUsDetails() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(height: 2.h),
          Center(
            child: Image(
              image: CachedNetworkImageProvider(widget.whenToReachUs),
            ),
          ),
        ],
      ),
    );
  }
}
