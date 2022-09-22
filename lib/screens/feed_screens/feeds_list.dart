import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class FeedsList extends StatefulWidget {
  const FeedsList({Key? key}) : super(key: key);

  @override
  State<FeedsList> createState() => _FeedsListState();
}

class _FeedsListState extends State<FeedsList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(height: 3.h),
              Text(
                "Feeds",
                style: TextStyle(
                    fontFamily: "GothamRoundedBold_21016",
                    color: gPrimaryColor,
                    fontSize: 12.sp),
              ),
              SizedBox(height: 1.h),
              Expanded(
                child: buildFeedList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildFeedList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: ((context, index) {
        return GestureDetector(
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (ct) => const YogaPlanDetails(),
            //   ),
            // );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: gWhiteColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(2, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 5.h,
                      width: 10.w,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const Image(
                          image: AssetImage("assets/images/cheerful.png"),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mr. Lorem Ipsum",
                            style: TextStyle(
                                fontFamily: "GothamMedium",
                                color: gPrimaryColor,
                                fontSize: 11.sp),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            "Bangalore",
                            style: TextStyle(
                                fontFamily: "GothamBook",
                                color: gMainColor,
                                fontSize: 9.sp),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.more_vert,
                        color: gTextColor,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 1.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: const Image(
                    image: AssetImage("assets/images/top-view-indian-food-assortment.png"),
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child:  Image(
                            image:const AssetImage("assets/images/Union 4.png"),
                            height: 2.h,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          "22",
                          style: TextStyle(
                              fontFamily: "GothamMedium",
                              color: gTextColor,
                              fontSize: 8.sp),
                        ),
                        SizedBox(width: 4.w),
                        GestureDetector(
                          onTap: () {},
                          child:  Image(
                            image: const AssetImage("assets/images/noun_chat_1079099.png"),
                            height: 2.h,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          "132",
                          style: TextStyle(
                              fontFamily: "GothamMedium",
                              color: gTextColor,
                              fontSize: 8.sp),
                        ),
                      ],
                    ),
                    Text(
                      "2 minutes ago",
                      style: TextStyle(
                          fontFamily: "GothamMedium",
                          color: gTextColor,
                          fontSize: 8.sp),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Text(
                      "Lorem",
                      style: TextStyle(
                          fontSize: 9.sp,
                          fontFamily: "GothamMedium",
                          color: gTextColor),
                    ),
                    SizedBox(width: 1.w),
                    Container(
                      color: gTextColor,
                      height: 2.h,
                      width: 0.5.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      "Lorem lpsum is simply dummy text",
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: gTextColor,
                        fontFamily: "GothamMedium",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
