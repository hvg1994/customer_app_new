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
import '../../widgets/vlc_player/vlc_player_with_controls.dart';
import '../../widgets/widgets.dart';
import 'feeds_details_screen.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FeedsList extends StatefulWidget {
  const FeedsList({Key? key}) : super(key: key);

  @override
  State<FeedsList> createState() => _FeedsListState();
}

class _FeedsListState extends State<FeedsList> {
  final _key = GlobalKey<VlcPlayerWithControlsState>();
  VlcPlayerController? _videoPlayerController;

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


  addUrlToVideoPlayer(String url) {
    print("url" + url);
    _videoPlayerController = VlcPlayerController.network(
      Uri.parse(url).toString(),
      // "https://gwc.disol.in/dist/img/GMG-Podcast-%20CMN.mp4",
      // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
      //'https://media.w3.org/2010/05/sintel/trailer.mp4',
      hwAcc: HwAcc.disabled,
      autoPlay: false,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(true),
          VlcSubtitleOptions.fontSize(30),
          VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
          VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
          // works only on externally added subtitles
          VlcSubtitleOptions.color(VlcSubtitleColor.navy),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    print('dispose');
    await _videoPlayerController!.stop();
    await _videoPlayerController!.stopRendererScanning();
    await _videoPlayerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(() {},
                    isBackEnable: false,
                    showNotificationIcon: true, notificationOnTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const NotificationScreen()));
                    }),
                // SizedBox(height: 3.h),
                const Visibility(
                  visible: false,
                    child: GWCStoriesScreen()),
                // Text(
                //   "Feeds",
                //   style: TextStyle(
                //       fontFamily: eUser().mainHeadingFont,
                //       color: eUser().mainHeadingColor,
                //       fontSize: eUser().mainHeadingFontSize
                //   ),
                // ),
                // SizedBox(height: 1.h),
                TabBar(
                    labelColor: eUser().userFieldLabelColor,
                    unselectedLabelColor: eUser().userTextFieldColor,
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    isScrollable: true,
                    indicatorColor: gsecondaryColor,
                    labelStyle: TextStyle(
                        fontFamily:kFontMedium,
                        color: gPrimaryColor,
                        fontSize: 12.sp),
                    unselectedLabelStyle: TextStyle(
                        fontFamily: kFontBook,
                        color: gHintTextColor,
                        fontSize: 10.sp),
                    labelPadding: EdgeInsets.only(
                        right: 10.w, left: 2.w, top: 1.h, bottom: 1.h),
                    indicatorPadding: EdgeInsets.only(right: 7.w),
                    tabs: const [
                      Text('Feed'),
                      Text('PodCast'),
                    ]),
                Expanded(
                  child: TabBarView(
                      children: [
                        apiUI(context),
                        buildPodCast(),
                      ]),
                ),
              ],
            ),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 1,
            color: kLineColor.withOpacity(0.3),
            width: double.maxFinite,
          ),
          FutureBuilder(
              future: feedsListFuture,
              builder: (_, snapshot) {
                print(snapshot.connectionState);
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    if (snapshot.data.runtimeType == ErrorModel) {
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
                            final a = list[index].image;
                            final file = a?.split(".").last;
                            String format = file.toString();
                            if (format == "mp4") {
                              addUrlToVideoPlayer(a!);
                            }
                            return GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (ct) => FeedsDetailsScreen(
                                //       profile: "assets/images/cheerful.png",
                                //       userName:
                                //           "${list[index].feed?.addedBy?.name}" ??
                                //               "Mr. Lorem Ipsum",
                                //       userAddress: "${list[index].feed?.addedBy?.address}" ?? "",
                                //       reelsImage: '${list[index].image}' ?? "",
                                //       comments: '${list[index].feed?.title}' ?? "",
                                //     ),
                                //   ),
                                // );
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
                                            borderRadius:
                                            BorderRadius.circular(8),
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
                                                list[index]
                                                    .feed
                                                    ?.addedBy
                                                    ?.name ??
                                                    "Mr. Lorem Ipsum",
                                                style: TextStyle(
                                                    fontFamily: "GothamMedium",
                                                    color: gPrimaryColor,
                                                    fontSize: 11.sp),
                                              ),
                                              SizedBox(height: 0.5.h),
                                              Text(
                                                list[index]
                                                    .feed
                                                    ?.addedBy
                                                    ?.address ??
                                                    "",
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
                                    buildFeedImage("${list[index].image}"),
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
                                                list[index].likes.toString() ??
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
              }),
        ],
      ),
    );
  }

  Widget buildFeedImage(String image) {
    print(image);
    final a = image;
    final file = a.split(".").last;
    String format = file.toString();
    if (format == "mp4") {
      return buildTestimonial();
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: FadeInImage.memoryNetwork(
          placeholder: placeHolderImage!.buffer.asUint8List(),
          image: image ?? '',
          fit: BoxFit.fill,
        ),
      );
    }
  }

  buildTestimonial() {
    if (_videoPlayerController != null) {
      return VisibilityDetector(
        key: ObjectKey(_videoPlayerController),
        onVisibilityChanged: (visibility) {
          if (visibility.visibleFraction == 0 && mounted) {
            _videoPlayerController?.pause(); //pausing  functionality
          } else {
            _videoPlayerController?.play();
          }
        },
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: gPrimaryColor, width: 1),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.3),
              //     blurRadius: 20,
              //     offset: const Offset(2, 10),
              //   ),
              // ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Center(
                child: VlcPlayerWithControls(
                  key: _key,
                  controller: _videoPlayerController!,
                  showVolume: false,
                  showVideoProgress: false,
                  seekButtonIconSize: 10.sp,
                  playButtonIconSize: 14.sp,
                  replayButtonSize: 10.sp,
                ),
                // child: VlcPlayer(
                //   controller: _videoPlayerController!,
                //   aspectRatio: 16 / 9,
                //   virtualDisplay: false,
                //   placeholder: Center(child: CircularProgressIndicator()),
                // ),
              ),
            ),
            // child: Stack(
            //   children: <Widget>[
            //     ClipRRect(
            //       borderRadius: BorderRadius.circular(5),
            //       child: Center(
            //         child: VlcPlayer(
            //           controller: _videoPlayerController!,
            //           aspectRatio: 16 / 9,
            //           virtualDisplay: false,
            //           placeholder: Center(child: CircularProgressIndicator()),
            //         ),
            //       ),
            //     ),
            //     ControlsOverlay(controller: _videoPlayerController,)
            //   ],
            // ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  isPlaying() async {
    if (_videoPlayerController != null) {
      final value = await _videoPlayerController?.isPlaying();
      print("isPlaying: $value");
      return value;
    } else {
      return false;
    }
  }

  buildPodCast() {
    return SingleChildScrollView(child:Column(
      children: [
        Container(
          height: 1,
          color: kLineColor.withOpacity(0.3),
          width: double.maxFinite,
        ),
        Padding(
          padding:  EdgeInsets.symmetric(vertical: 15.h),
          child: const Center(
            child: Image(
              image: AssetImage("assets/images/no_data_found.png"),
            ),
          ),
        ),
      ],
    ),);
  }

  final AboutProgramRepository repository = AboutProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
