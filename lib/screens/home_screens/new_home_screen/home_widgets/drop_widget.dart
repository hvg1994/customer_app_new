import 'package:flutter/material.dart';
import 'package:gwc_customer/screens/home_screens/new_home_screen/home_widgets/shadow_text.dart';
import 'package:sizer/sizer.dart';


import 'dart:math';
import 'package:vector_math/vector_math.dart' as Vector;

import 'container_wrapper.dart';

class WaterProgress extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WaterProgressState();
  }
}

class _WaterProgressState extends State<WaterProgress>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();

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
    var current = 60;
    var target = 100;
    var percentage = target > 0 ? current / target * 100 : 100.0;
    var progress = (percentage > 100.0 ? 100.0 : percentage) / 100.0;
    progress = 1.0 - progress;

    return ContainerWrapper(
      widthScale: 0.65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Stack(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Center(
                          child: Opacity(
                              opacity: 0.4,
                              child: Image.asset('assets/images/gmg/drop3.png'))
                      ),
                      Center(
                        child: AnimatedBuilder(
                          animation: CurvedAnimation(
                              parent: animationController!,
                              curve: Curves.easeInOut),
                          builder: (context, child) => ClipPath(
                            child: Image.asset('assets/images/gmg/drop3_filled.png'),
                            clipper: WaveClipper(
                                progress,
                                (progress > 0.0 && progress < 1.0)
                                    ? animationController!.value
                                    : 0.0),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          children: <Widget>[
                            // ShadowText(
                            //   '${(target > 0 ? current / target * 100 : 100).toStringAsFixed(0)}%',
                            //   shadowColor: Colors.black.withOpacity(0.5),
                            //   offsetX: 3.0,
                            //   offsetY: 3.0,
                            //   blur: 3.0,
                            //   style: TextStyle(
                            //       color: Colors.white.withAlpha(200),
                            //       fontSize: 40.0,
                            //       fontWeight: FontWeight.bold),
                            // ),
                            ShadowText(
                              '$current ml',
                              shadowColor: Colors.black.withOpacity(0.3),
                              offsetX: 3.0,
                              offsetY: 3.0,
                              blur: 3.0,
                              style: TextStyle(
                                  color: Colors.white.withAlpha(150),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 40,
                      left: 0,
                      right: -100,
                      child: Container(
                        padding: EdgeInsets.all(0.8),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0.5, 0.5),
                                blurRadius: 2,
                              )
                            ]
                        ),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.lightBlueAccent,
                            // boxShadow: [
                            //   BoxShadow(
                            //     offset: Offset(0.5, 0.5),
                            //     blurRadius: 2,
                            //   )
                            // ]
                          ),
                          child: Icon(Icons.add,
                            size: 20,
                            color: Colors.white,
                          )
                          ,
                        ),
                      )
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Remaining',
                        style: TextStyle(
                            color: const Color(0xFF363535),
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        '${(target - current < 0 ? 0 : target - current)} ml',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Target',
                          style: TextStyle(
                              color: const Color(0xFF363535),
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          '$target ml',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w600),
                        )
                      ],
                    ))
              ],
            ),
          ],
        ));
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double progress;
  final double animation;

  WaveClipper(this.progress, this.animation);

  @override
  Path getClip(Size size) {
    final double wavesHeight = size.height * 0.1;

    var path = new Path();

    if (progress == 1.0) {
      return path;
    } else if (progress == 0.0) {
      path.lineTo(0.0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
      path.lineTo(0.0, 0.0);
      return path;
    }

    List<Offset> wavePoints = [];
    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      var extraHeight = wavesHeight * 0.5;
      extraHeight *= i / (size.width / 2 - size.width);
      var dx = i.toDouble();
      var dy = sin((animation * 360 - i) % 360 * Vector.degrees2Radians) * 5 +
          progress * size.height -
          extraHeight;
      if (!dx.isNaN && !dy.isNaN) {
        wavePoints.add(Offset(dx, dy));
      }
    }

    path.addPolygon(wavePoints, false);

    // finish the line
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);

    return path;
  }

  @override
  bool shouldReclip(WaveClipper old) =>
      progress != old.progress || animation != old.animation;
}