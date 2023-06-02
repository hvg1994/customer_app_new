import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gwc_customer/model/home_remedy_model/home_remedies_model.dart';
import 'package:gwc_customer/repository/api_service.dart';
import 'package:gwc_customer/repository/home_remedy_repo/home_remedies_repository.dart';
import 'package:gwc_customer/services/home_remedy_service/home_remedies_service.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'new_know_more_screen.dart';

class HomeRemediesScreen extends StatefulWidget {
  const HomeRemediesScreen({Key? key}) : super(key: key);

  @override
  State<HomeRemediesScreen> createState() => _HomeRemediesScreenState();
}

class _HomeRemediesScreenState extends State<HomeRemediesScreen> {
  HomeRemediesService? homeRemediesService;

  Future? homeRemediesFuture;

  Future getDaySummary() async {
    homeRemediesFuture =
        HomeRemediesService(repository: repository).getHomeRemediesService();
  }

  @override
  void initState() {
    super.initState();
    getDaySummary();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                    labelColor: eUser().userFieldLabelColor,
                    unselectedLabelColor: gHintTextColor,
                    isScrollable: false,
                    indicatorColor: gsecondaryColor,
                    labelPadding:
                    EdgeInsets.only(right: 0.w, top: 1.h, bottom: 1.h),
                    // indicatorPadding: EdgeInsets.only(right: 5.w, left: 5.w),
                    unselectedLabelStyle: TextStyle(
                        fontFamily: kFontBook,
                        color: gHintTextColor,
                        fontSize: 9.sp),
                    labelStyle: TextStyle(
                        fontFamily: kFontMedium,
                        color: gBlackColor,
                        fontSize: 11.sp),
                    tabs: const [
                      Text('General'),
                      Text("Program Phase Remedies"),
                    ]),
                Expanded(
                  child: TabBarView(
                    // physics: const NeverScrollableScrollPhysics(),
                      children: [
                        buildGeneralProblems(),
                        buildProgramProblems(),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildGeneralProblems() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(height: 2.h),
          FutureBuilder(
              future: homeRemediesFuture,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.runtimeType == HomeRemediesModel) {
                    HomeRemediesModel model =
                    snapshot.data as HomeRemediesModel;
                    List<HomeRemedy>? totalList = model.data.homeRemedies;
                    List<HomeRemedy> problemList = [];
                    totalList.forEach((element) {
                      if (element.isGeneral == "0") {
                        problemList.add(element);
                      }
                    });
                    return GridView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          crossAxisCount: 3,
                          mainAxisExtent: 20.h,
                          // childAspectRatio: MediaQuery.of(context).size.width /
                          //     (MediaQuery.of(context).size.height / 1.4),
                        ),
                        // gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                        itemCount: problemList.length,
                        itemBuilder: (context, index) {
                          // print("thumbnail : ${problemList[index].thumbnail}");
                          return problemList[index].isGeneral == "0"
                              ? Column(
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  Get.to(
                                        () => NewKnowMoreScreen(
                                      knowMore:
                                      problemList[index].knowMore,
                                      healAtHome:
                                      problemList[index].healAtHome,
                                      healAnywhere:
                                      problemList[index].healAnywhere,
                                      whenToReachUs: problemList[index]
                                          .whenToReachUs,
                                      title: problemList[index]
                                          .name
                                          .toString(),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  overlayColor: getColor(Colors.white,
                                      newDashboardGreenButtonColor),
                                  backgroundColor: getColor(Colors.white,
                                      newDashboardGreenButtonColor),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  height: 15.h,
                                  width: 30.w,
                                  imageUrl:
                                  "${Uri.parse(problemList[index].thumbnail)}",
                                  placeholder: (__, _) {
                                    return Image.asset(
                                        "assets/images/placeholder.png");
                                  },
                                  errorWidget: (_, __, ___) {
                                    return Image.asset(
                                        "assets/images/placeholder.png");
                                  },
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                problemList[index].name.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: kFontBold,
                                  color: gBlackColor,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ],
                          )
                              : const SizedBox();
                        });
                  }
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: buildCircularIndicator(),
                );
              }),
        ],
      ),
    );
  }

  buildProgramProblems() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(height: 2.h),
          FutureBuilder(
              future: homeRemediesFuture,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.runtimeType == HomeRemediesModel) {
                    HomeRemediesModel model =
                    snapshot.data as HomeRemediesModel;
                    List<HomeRemedy>? totalList = model.data.homeRemedies;
                    List<HomeRemedy> problemList = [];
                    totalList.forEach((element) {
                      if (element.isGeneral == "1") {
                        problemList.add(element);
                      }
                    });

                    return GridView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 10,
                          crossAxisCount: 3,
                          // childAspectRatio: MediaQuery.of(context).size.width /
                          //     (MediaQuery.of(context).size.height / 1.4),
                        ),
                        // gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                        itemCount: problemList.length,
                        itemBuilder: (context, index) {
                          return problemList[index].isGeneral == "1"
                              ? Column(
                            children: [
                              Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Get.to(
                                            () => NewKnowMoreScreen(
                                          knowMore:
                                          problemList[index].knowMore,
                                          healAtHome:
                                          problemList[index].healAtHome,
                                          healAnywhere:
                                          problemList[index].healAnywhere,
                                          whenToReachUs: problemList[index]
                                              .whenToReachUs,
                                          title: problemList[index]
                                              .name
                                              .toString(),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      overlayColor: getColor(Colors.white,
                                          newDashboardGreenButtonColor),
                                      backgroundColor: getColor(Colors.white,
                                          newDashboardGreenButtonColor),
                                    ),
                                    child: CachedNetworkImage(
                                      height: 12.h,
                                      width: 23.w,
                                      imageUrl:
                                      "${Uri.parse(problemList[index].thumbnail)}",
                                      placeholder: (_, __) {
                                        return Image.asset(
                                            "assets/images/placeholder.png");
                                      },
                                      errorWidget: (_, __, ___) {
                                        return Image.asset(
                                            "assets/images/placeholder.png");
                                      },
                                    ),
                                  )),
                              // GestureDetector(
                              //   onTap: () {
                              //
                              //
                              //   },
                              //   child: Container(
                              //     height: 12.h,
                              //     width: 23.w,
                              //     padding: const EdgeInsets.all(8),
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(8),
                              //       color: gWhiteColor,
                              //       // selectedProblems
                              //       //         .contains(problemList?[index].id)
                              //       //     ? newDashboardGreenButtonColor
                              //       //     : gWhiteColor,
                              //       border: Border.all(
                              //           color: eUser().buttonBorderColor,
                              //           width: eUser().buttonBorderWidth),
                              //     ),
                              //     child: Center(
                              //       child: Image(
                              //         image: CachedNetworkImageProvider(
                              //             problemList?[index].image ?? ''),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(height: 1.h),
                              Text(
                                problemList[index].name.toString(),
                                style: TextStyle(
                                  fontFamily: kFontBold,
                                  color: gBlackColor,
                                  fontSize: 9.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                              : const SizedBox();
                        });
                  }
                }
                return buildCircularIndicator();
              }),
        ],
      ),
    );
  }

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    // ignore: prefer_function_declarations_over_variables
    final getColor = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };
    return MaterialStateProperty.resolveWith(getColor);
  }

  final HomeRemediesRepository repository = HomeRemediesRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
