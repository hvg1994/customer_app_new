import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/new_user_model/about_program_model/about_program_model.dart';
import 'package:gwc_customer/model/new_user_model/about_program_model/feeds_model/feedsListModel.dart';
import 'package:gwc_customer/repository/new_user_repository/about_program_repository.dart';
import 'package:gwc_customer/screens/feed_screens/gwc_stories_screen.dart';
import 'package:gwc_customer/screens/notification_screen.dart';
import 'package:gwc_customer/services/new_user_service/about_program_service.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../repository/api_service.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'feeds_details_screen.dart';

class FeedsList extends StatefulWidget {
  const FeedsList({Key? key}) : super(key: key);

  @override
  State<FeedsList> createState() => _FeedsListState();
}

class _FeedsListState extends State<FeedsList> {
  Future? feedsListFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFuture();
    loadAsset('top-view-indian-food-assortment.png');
  }

  getFuture() {
    feedsListFuture =
        AboutProgramService(repository: repository).serverAboutProgramService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() => null,
                  isBackEnable: false,
                  showNotificationIcon: true, notificationOnTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => NotificationScreen()));
              }),
              SizedBox(height: 3.h),
              const GWCStoriesScreen(),
              // Text(
              //   "Feeds",
              //   style: TextStyle(
              //       fontFamily: eUser().mainHeadingFont,
              //       color: eUser().mainHeadingColor,
              //       fontSize: eUser().mainHeadingFontSize
              //   ),
              // ),
              // SizedBox(height: 1.h),
              Expanded(
                child: apiUI(context),
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
                    image: AssetImage(
                        "assets/images/top-view-indian-food-assortment.png"),
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
                          child: Image(
                            image:
                                const AssetImage("assets/images/Union 4.png"),
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
                          child: Image(
                            image: const AssetImage(
                                "assets/images/noun_chat_1079099.png"),
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

  staticUI(BuildContext context) {
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
                    image: AssetImage(
                        "assets/images/top-view-indian-food-assortment.png"),
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
                          child: Image(
                            image:
                                const AssetImage("assets/images/Union 4.png"),
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
                          child: Image(
                            image: const AssetImage(
                                "assets/images/noun_chat_1079099.png"),
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

  ByteData? placeHolderImage;

  void loadAsset(String name) async {
    var data = await rootBundle.load('assets/images/$name');
    setState(() => placeHolderImage = data);
  }

  apiUI(BuildContext context) {
    return FutureBuilder(
        future: feedsListFuture,
        builder: (_, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data.runtimeType is ErrorModel) {
                final model = snapshot.data as ErrorModel;
                return Center(
                  child: Text(model.message ?? ''),
                );
              } else {
                final model = snapshot.data as AboutProgramModel;
                List<FeedsListModel> list = model.data?.feedsList ?? [];
                if (list.isEmpty) {
                  return Center(
                    child: Text("NO Feeds" ?? ''),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ct) => FeedsDetailsScreen(
                                profile: "assets/images/cheerful.png",
                                userName:
                                    "${list[index].feed?.addedBy?.name}" ??
                                        "Mr. Lorem Ipsum",
                                userAddress:
                                    "${list[index].feed?.addedBy?.address}" ??
                                        "Bangalore",
                                reelsImage: '${list[index].image}' ?? "",
                                comments: '${list[index].feed?.title}' ?? "",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 1.h),
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 3.w),
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
                                        image: AssetImage(
                                            "assets/images/cheerful.png"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list[index].feed?.addedBy?.name ??
                                              "Mr. Lorem Ipsum",
                                          style: TextStyle(
                                              fontFamily: "GothamMedium",
                                              color: gPrimaryColor,
                                              fontSize: 11.sp),
                                        ),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                          list[index].feed?.addedBy?.address ??
                                              "Bangalore",
                                          style: TextStyle(
                                              fontFamily: "GothamBook",
                                              color: gMainColor,
                                              fontSize: 9.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: false,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.more_vert,
                                        color: gTextColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 1.h),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: FadeInImage.memoryNetwork(
                                    placeholder:
                                        placeHolderImage!.buffer.asUint8List(),
                                    image: list[index].image ?? ''),
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: false,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Image(
                                            image: const AssetImage(
                                                "assets/images/Union 4.png"),
                                            height: 2.h,
                                          ),
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          list[index].likes.toString() ?? "22",
                                          style: TextStyle(
                                              fontFamily: "GothamMedium",
                                              color: gTextColor,
                                              fontSize: 8.sp),
                                        ),
                                        SizedBox(width: 4.w),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Image(
                                            image: const AssetImage(
                                                "assets/images/noun_chat_1079099.png"),
                                            height: 2.h,
                                          ),
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          list[index]
                                                  .comments
                                                  ?.length
                                                  .toString() ??
                                              "132",
                                          style: TextStyle(
                                              fontFamily: "GothamMedium",
                                              color: gTextColor,
                                              fontSize: 8.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    list[index].ago ?? "2 minutes ago",
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
                                  Expanded(
                                    child: Text(
                                      list[index].feed?.title ?? "Lorem",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 9.sp,
                                          fontFamily: "GothamMedium",
                                          color: gTextColor),
                                    ),
                                  ),
                                  // SizedBox(width: 1.w),
                                  // Container(
                                  //   color: gTextColor,
                                  //   height: 2.h,
                                  //   width: 0.5.w,
                                  // ),
                                  // SizedBox(width: 1.w),
                                  Text(
                                    "See more",
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      color: gPrimaryColor,
                                      fontFamily: "GothamBook",
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
            } else {
              return Center(
                child: Text(snapshot.error.toString() ?? ''),
              );
            }
          }
          return buildCircularIndicator();
        });
  }

  final AboutProgramRepository repository = AboutProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
