import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:photo_view/photo_view.dart';

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
                buildAppBar(() {
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
                        fontFamily: kFontBook,
                        color: gHintTextColor,
                        fontSize: 9.sp),
                    labelStyle: TextStyle(
                        fontFamily: kFontMedium,
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
                      physics: const NeverScrollableScrollPhysics(),
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
          Container(
            height: 65.h,
            width: 100.w,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            child: Center(
              child: PhotoView(
                imageProvider:
                    CachedNetworkImageProvider("${Uri.parse(widget.knowMore)}"),
              ),
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
          Container(
            height: 65.h,
            width: 100.w,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            child: Center(
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(
                    "${Uri.parse(widget.healAtHome)}"),
              ),
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
          Container(
            height: 65.h,
            width: 100.w,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            child: Center(
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(
                    "${Uri.parse(widget.healAnywhere)}"),
              ),
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
          Container(
            height: 65.h,
            width: 100.w,
            margin: EdgeInsets.symmetric(vertical: 10.h),
            child: Center(
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(
                    "${Uri.parse(widget.whenToReachUs)}"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
