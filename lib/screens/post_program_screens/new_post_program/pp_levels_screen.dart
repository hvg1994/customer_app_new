import 'package:flutter/material.dart';
import 'package:gwc_customer/model/post_program_model/protocol_guide_day_score.dart';
import 'package:gwc_customer/screens/post_program_screens/new_post_program/day_breakfast.dart';
import 'package:gwc_customer/screens/post_program_screens/new_post_program/pp_calendar.dart';
import 'package:gwc_customer/screens/post_program_screens/protcol_guide_details.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import 'package:sizer/sizer.dart';
import 'package:gwc_customer/repository/post_program_repo/post_program_repository.dart';
import 'package:gwc_customer/services/post_program_service/post_program_service.dart';
import 'pp_redeem_rewards_popuop.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/post_program_model/post_program_new_model/protocol_calendar_model.dart';
import 'package:http/http.dart' as http;
import 'package:gwc_customer/repository/api_service.dart';


class PPLevelsScreen extends StatefulWidget {
  const PPLevelsScreen({Key? key}) : super(key: key);

  @override
  _PPLevelsScreenState createState() => _PPLevelsScreenState();
}

class _PPLevelsScreenState extends State<PPLevelsScreen> {
  final String greenBg = "assets/images/gmg/Group 11807.png";
  final String yellowBg = "assets/images/gmg/Group 11808.png";
  final String redBg = "assets/images/gmg/Group 11809.png";
  final String missedBg = "assets/images/gmg/Group 11810.png";
  final String notStartedBg = "assets/images/gmg/Group 11811.png";

  // late List<NewStageLevels> levels = [
  //   NewStageLevels(greenBg, "80 pts Earned", '1'),
  //   NewStageLevels("assets/images/gmg/Group 11808.png", "50 pts Earned", '2'),
  //   NewStageLevels("assets/images/gmg/Group 11809.png", "30 pts Earned", '3'),
  //   NewStageLevels(
  //     "assets/images/gmg/Group 11809.png",
  //     "30 pts Earned",
  //     '4',
  //   ),
  //   NewStageLevels("assets/images/gmg/Group 11807.png", "80 pts Earned", '5'),
  //   NewStageLevels("assets/images/gmg/Group 11810.png", "You Have Missed", '6'),
  //   NewStageLevels(
  //     "assets/images/gmg/Group 11808.png",
  //     "50 pts Earned",
  //     '7',
  //   ),
  //   NewStageLevels("assets/images/gmg/Group 11807.png", "80 pts Earned", '8'),
  //   NewStageLevels("assets/images/gmg/Group 11811.png", "Not Yet Started", '9'),
  //   NewStageLevels("assets/images/gmg/Group 11811.png", "Not Yet Started", '10'),
  //   NewStageLevels(
  //     "assets/images/gmg/Group 11811.png",
  //     "Not Yet Started",
  //     '11',
  //   ),
  //   NewStageLevels("assets/images/gmg/Group 11811.png", "Not Yet Started", '12'),
  //   NewStageLevels("assets/images/gmg/Group 11811.png", "Not Yet Started", '13'),
  //   NewStageLevels(
  //     "assets/images/gmg/Group 11811.png",
  //     "Not Yet Started",
  //     '14',
  //   ),
  // ];

  List<NewStageLevels> levels = [];

  String protocolGuidePdfLink = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPPCalendar();
    getPPGuidePdfLink();
  }

  getPPGuidePdfLink() async{
    final res = await PostProgramService(repository: repository).getProtocolDayDetailsService();

    if(res.runtimeType != ErrorModel){
      ProtocolGuideDayScoreModel model = res as ProtocolGuideDayScoreModel;
      protocolGuidePdfLink = model.protocolGuidePdf ?? '';
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xffFAFAFA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 7.h,
                  child: const Image(
                    image: AssetImage("assets/images/Gut welness logo.png"),
                  ),
                  //SvgPicture.asset("assets/images/splash_screen/Inside Logo.svg"),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PPCalendar(),
                          ),
                        );
                      },
                      child: Image(
                        image: const AssetImage(
                            "assets/images/gmg/noun-calendar-5347015.png"),
                        height: 2.7.h,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                              opaque: false, // set to false
                              pageBuilder: (_, __, ___) => Container(
                                child: PPRewardsPopup(),
                                // width: 70,
                                // height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                                  ],
                                ),
                              )),
                        );
                      },
                      child: Image(
                        image: const AssetImage(
                            "assets/images/gmg/noun-percentage-3119037.png"),
                        height: 3.h,
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProtocolGuideDetails(pdfLink: protocolGuidePdfLink,),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 3.5.h,
                        child: Lottie.asset('assets/lottie/alert.json'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Text(
              "Gut Maintenance  Indicator",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'GothamBold',
                  color: gPrimaryColor,
                  fontSize: 10.sp),
            ),
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: levels.isEmpty ? Center(child: buildCircularIndicator(),) : showLevels(),
          ),
        ],
      ),
    );
  }


  showLevels() {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        shrinkWrap: true,
        reverse: true,
        scrollDirection: Axis.vertical,
        itemCount: levels.length,
        itemBuilder: (_, index) {
          if (index.isEven) {
            return Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // GestureDetector(
                            //   onTap: () {},
                            //   child: Image(
                            //       image: AssetImage(levels[index]["images"]),
                            //       height: 60),
                            // ),
                            // SizedBox(height: 1.h),
                            Text(
                              levels[index].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "GothamBook",
                                  height: 1.3,
                                  color: gsecondaryColor,
                                  fontSize: 10.sp),
                            )
                          ],
                        ),
                        SizedBox(width: 5.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => PPDailyTasksUI(day: levels[index].stage,)));
                          },
                          child: Container(
                            height: 8.h,
                            width: 15.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(levels[index].image),
                              ),
                            ),
                            child: Center(
                              child: Text(
                               "Day\n${levels[index].stage}",
                                textAlign: TextAlign.center,
                                style: TextStyle(height: 1.3,
                                    fontFamily: 'GothamBook',
                                    color: gWhiteColor,
                                    fontSize: 10.sp),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Image(
                        image: AssetImage("assets/images/gmg/Mask Group 7.png"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else if (index.isOdd) {
            return Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 00,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => PPDailyTasksUI(day: levels[index].stage,)));
                          },
                          child: Container(
                            height: 8.h,
                            width: 15.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(levels[index].image),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Day\n${levels[index].stage}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'GothamBook',
                                    color: gWhiteColor,
                                    fontSize: 10.sp),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // GestureDetector(
                            //   onTap: () {},
                            //   child: Image(
                            //       image: AssetImage(levels[index]["images"]),
                            //       height: 60),
                            // ),
                            // SizedBox(height: 1.h),
                            Text(
                              levels[index].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "GothamBook",
                                  height: 1.3,
                                  color: gsecondaryColor,
                                  fontSize: 10.sp),
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 30),
                      child: Image(
                        image: AssetImage("assets/images/gmg/Mask Group 5.png"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else {
            return Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 00,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => PPDailyTasksUI(day: levels[index].stage,)));
                          },
                          child: Container(
                            height: 8.h,
                            width: 15.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(levels[index].image),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Day\n${levels[index].stage}",
                                textAlign: TextAlign.center,
                                style: TextStyle(height: 1.3,
                                    fontFamily: 'GothamBook',
                                    color: gWhiteColor,
                                    fontSize: 10.sp),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // GestureDetector(
                            //   onTap: () {},
                            //   child: Image(
                            //       image: AssetImage(levels[index]["images"]),
                            //       height: 60),
                            // ),
                            // SizedBox(height: 1.h),
                            Text(
                              levels[index].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "GothamBook",
                                  height: 1.3,
                                  color: gsecondaryColor,
                                  fontSize: 10.sp),
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 30),
                      child: Image(
                        image: AssetImage("assets/images/gmg/Mask Group 5.png"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  bool isError = false;
  String errorText = '';
  bool isLoading = false;

  String? currentDay;


  Future getPPCalendar() async {
    setState(() {
      isLoading = true;
    });
    final res = await PostProgramService(repository: repository).getPPDayCalenderService();

    if(res.runtimeType == ErrorModel){
      final model = res as ErrorModel;
      setState(() {
        isLoading = false;
        isError = true;
        errorText = model.message ?? '';
      });
    }
    else{
      final model = res as ProtocolCalendarModel;
      List<ProtocolCalendar> arrData = model.protocolCalendar!;

      setState(() {
        isLoading = false;
        currentDay = model.presentDay;
      });
      addLevels(arrData);
    }
  }

  addLevels(List<ProtocolCalendar> data){
    levels.clear();
    data.forEach((protocolCalender) {
      if(protocolCalender.day.toString() == currentDay){
        levels.add(NewStageLevels(notStartedBg, "", currentDay!));
      }
      else if(protocolCalender.day.toString() != currentDay){
        print(protocolCalender.score);
        if(protocolCalender.score == "1"){
          levels.add(NewStageLevels(greenBg, "", protocolCalender.day.toString()));
        }
        else if(protocolCalender.score == "2"){
          levels.add(NewStageLevels(yellowBg, "", protocolCalender.day.toString()));
        }
        else if(protocolCalender.score == "3"){
          levels.add(NewStageLevels(redBg, "", protocolCalender.day.toString()));
        }
        else if(protocolCalender.score == "4" || protocolCalender.score == ""){
          levels.add(NewStageLevels(missedBg, "Missed", protocolCalender.day.toString()));
        }
      }
    });
  }


  PostProgramRepository repository = PostProgramRepository(
      apiClient: ApiClient(
          httpClient: http.Client()
      )
  );

}

class TestPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.black;

    final path = Path()
      ..moveTo(
        points[0].dx * size.width,
        points[0].dy * size.height,
      );
    points.sublist(1).forEach((point) {
      print(point.dx);
      path.lineTo(
        point.dx * size.width,
        point.dy * size.height,
      );
      canvas.drawLine(
          Offset(0, point.dy), Offset(0, startY + dashHeight), paint);
    });
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TestPathPainter oldDelegate) => false;
}

final random = Random();
final List<Offset> points = List.generate(
  6,
  (index) => Offset(.1 + random.nextDouble() * .8, .1 + index * .8 / 9),
);

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var paint = Paint();
    var path = Path();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;
    paint.color = Colors.black;
    path.moveTo(size.width * 0.5, 0);

    path.quadraticBezierTo(size.width * 0.90, size.height * 0.50,
        size.width * 0.35, size.height * 0.14);
    path.quadraticBezierTo(size.width * 0.02, size.height * 0.20,
        size.width * 0.46, size.height * 0.28);
    path.quadraticBezierTo(size.width * 0.80, size.height * 0.35,
        size.width * 0.66, size.height * 0.40);
    path.quadraticBezierTo(size.width * 0.32, size.height * 0.49,
        size.width * 0.60, size.height * 0.53);
    path.quadraticBezierTo(size.width * 0.98, size.height * 0.61,
        size.width * 0.30, size.height * 0.67);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.71,
        size.width * 0.30, size.height * 0.76);
    path.quadraticBezierTo(
        size.width * 0.90, size.height * 0.91, size.width * 0.30, size.height);

    // path.quadraticBezierTo(size.width*0.08, size.height*0.45, size.width*0.65,size.height*0.60 );
    //
    // path.moveTo(size.width*0.09, size.height*0.67);
    // path.quadraticBezierTo(size.width*0.14, size.height*0.68, size.width*0.17, size.height*0.75);
    // path.quadraticBezierTo(size.width*0.22,size.height*0.68, size.width*0.28, size.height*0.67);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

// import 'dart:math' as math;
// import 'dart:ui';
// import 'package:flutter/material.dart';
//
// class SplinePainter extends CustomPainter {  @override  void paint(Canvas canvas, Size size) {    canvas.drawPaint(Paint()..color = Colors.white);    const controlWidthSingle = 50;    final random = math.Random();    /// This method generates control points, the x = 50*index(+1)    /// the y is set to random values between half of the screen and bottom of the screen    final controlPoints = List.generate(      size.width ~/ controlWidthSingle,      (index) => Offset(        controlWidthSingle * (index + 1),        random.nextDouble() * (size.height - size.height / 2) + size.height / 2,      ),    ).toList();    final spline = CatmullRomSpline(controlPoints);    final bezierPaint = Paint()      // set the edges of stroke to be rounded      ..strokeCap = StrokeCap.round      ..strokeWidth = 12      // apply a gradient      ..shader = const LinearGradient(colors: [        Colors.purple,        Colors.teal,      ]).createShader(Offset(0, size.height) & size);    // This method accepts a list of offsets and draws points for all offset    canvas.drawPoints(      PointMode.points,      spline.generateSamples().map((e) => e.value).toList(),      bezierPaint,    );  }  @override  bool shouldRepaint(SplinePainter oldDelegate) => false;}
//

class NewStageLevels {
  String image;
  String title;
  String stage;

  NewStageLevels(this.image, this.title, this.stage);
}
