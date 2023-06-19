import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'home_widgets/drop_widget.dart';

class WaterLevelScreen extends StatelessWidget {
  const WaterLevelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: PPConstants().bgColor,
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.w, right: 4.w, top: 1.h),
                child: buildAppBar((){
                  Navigator.pop(context);
                }),
              ),
              WaterProgress(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Reminder",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: kFontBold
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Add",
                              style: TextStyle(
                                  fontSize: 10.5.sp,
                                  fontFamily: kFontMedium,
                                color: gsecondaryColor
                              ),
                              textAlign: TextAlign.right,
                            ),
                          )

                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 9),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Set Volume Unit",
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontFamily: kFontBold
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Change",
                              style: TextStyle(
                                  fontSize: 10.5.sp,
                                  fontFamily: kFontMedium,
                                  color: gsecondaryColor
                              ),
                              textAlign: TextAlign.right,
                            ),
                          )

                        ],
                      ),
                    ],
                  ),
                )
              ),
              SizedBox(
                height: 5.h,
              ),
              GlassDesign()
            ],
          ),
        ),
      ),
    );
  }
}


class GlassDesign extends StatefulWidget {
  const GlassDesign({Key? key}) : super(key: key);

  @override
  State<GlassDesign> createState() => _GlassDesignState();
}

class _GlassDesignState extends State<GlassDesign> with TickerProviderStateMixin {

  int totalDays = 7;
  List<DayProgress> _days = [];

  int presentDay = 3;

  String _nofill = "assets/images/gmg/glass.png";
  String _filled = "assets/images/gmg/glass_filled.png";

  AnimationController? animationController;

  @override
  void initState() {
    super.initState();

    for(int i = 1; i<= totalDays; i++){
      _days.add(DayProgress(
          dayNo: i,
          path: presentDay >= i ? _filled :_nofill,
        isCompleted: presentDay >= i ? true : false
      ));
    }

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    animationController!.repeat();
  }

  @override
  void dispose() {
    animationController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Wrap(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ..._days.map((e) => animatedGlassWidget(e)).toList()
        ],
      ),
    );
  }

  animatedGlassWidget(DayProgress dayProgress){
    var current = 40;
    var target = 100;
    var percentage = target > 0 ? current / target * 100 : 100.0;
    var progress = (percentage > 100.0 ? 100.0 : percentage) / 100.0;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        glassWidget(_nofill),
        if(dayProgress.isCompleted)
          AnimatedBuilder(
          animation: CurvedAnimation(
              parent: animationController!,
              curve: Curves.easeInOut),
          builder: (context, child) => ClipPath(
            child: Padding(
              padding: EdgeInsets.only(left: 7),
              child: glassWidget(_filled)
            ),
            clipper: WaveClipper(
                progress,
                (progress > 0.0 && progress < 1.0)
                    ? animationController!.value
                    : 0.0),
          ),
        ),
      ],
    );
  }

  glassWidget(String e){
    return SizedBox(
      height: 80,
      width: 50,
      child: Image.asset(e, fit: BoxFit.cover,),
    );
  }
}


class DayProgress{
  int dayNo;
  String path;
  bool isCompleted;
  DayProgress({
    required this.dayNo,
    required this.path,
    this.isCompleted = false
  });
}