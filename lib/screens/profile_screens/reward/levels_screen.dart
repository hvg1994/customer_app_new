import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:level_map/level_map.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({Key? key}) : super(key: key);

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  @override
  Widget build(BuildContext context) {
    double checkBoxSize = computeCheckBoxSize(context);
    return LevelMap(
      backgroundColor: Colors.white,
      levelMapParams: LevelMapParams(
        levelCount: 6,
        currentLevel: 2,
        pathColor: gMainColor,
        currentLevelImage: ImageParams(
          path: "assets/images/current_stage.png",
          size: Size(40,40),
        ),
        lockedLevelImage: ImageParams(
          path: "assets/images/lock.png",
          size: Size(40,40),
        ),
        completedLevelImage: ImageParams(
          path: "assets/images/green_done.png",
          size: Size(40,40),
        ),
        bgImagesToBePaintedRandomly: [
          ImageParams(
              path: "assets/images/first.png",
              size: Size(80, 80),
              repeatCountPerLevel: 0.1
          ),
          ImageParams(
              path: "assets/images/second.png",
              size: Size(80, 80),
              repeatCountPerLevel: 0.1
          ),
          ImageParams(
              path: "assets/images/third.png",
              size: Size(80, 80),
              repeatCountPerLevel: 0.1
          ),
          ImageParams(
              path: "assets/images/fourth.png",
              size: Size(80, 80),
              repeatCountPerLevel: 0.1
          ),
          ImageParams(
              path: "assets/images/fifth.png",
              size: Size(80, 80),
              repeatCountPerLevel: 0.1
          ),
          ImageParams(
              path: "assets/images/sixth.png",
              size: Size(80, 80),
              repeatCountPerLevel: 0.1
          ),
        ],
      ),
    );
    // return Scaffold(
    //   body: LayoutBuilder(
    //     builder: (context, constraints) {
    //       final height = constraints.biggest.height;
    //       final width = constraints.biggest.width;
    //       return Stack(
    //         children: [
    //           Container(color: Colors.amber.shade100),
    //           Positioned.fill(child: CustomPaint(painter: ArrowPainter())),
    //           ...points
    //               .map(
    //                 (point) => Positioned(
    //               left: point.dx * width - checkBoxSize / 2,
    //               top: point.dy * height - checkBoxSize / 2,
    //               child: Checkbox(
    //                 value: true,
    //                 onChanged: (_) {},
    //               ),
    //             ),
    //           )
    //               .toList(),
    //         ],
    //       );
    //     },
    //   ),
    // );
  }

  Path drawPath(){
    Size size = Size(300,300);
    Path path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height / 2);
    return path;
  }
}

double computeCheckBoxSize(BuildContext context) {
  final ThemeData themeData = Theme.of(context);
  final MaterialTapTargetSize effectiveMaterialTapTargetSize =
      themeData.checkboxTheme.materialTapTargetSize ??
          themeData.materialTapTargetSize;
  final VisualDensity effectiveVisualDensity =
      themeData.checkboxTheme.visualDensity ?? themeData.visualDensity;
  Size size;
  switch (effectiveMaterialTapTargetSize) {
    case MaterialTapTargetSize.padded:
      size = const Size(kMinInteractiveDimension, kMinInteractiveDimension);
      break;
    case MaterialTapTargetSize.shrinkWrap:
      size = const Size(
          kMinInteractiveDimension - 8.0, kMinInteractiveDimension - 8.0);
      break;
  }
  size += effectiveVisualDensity.baseSizeAdjustment;
  print(size);
  return size.longestSide;
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
    points.sublist(1).forEach(
          (point) {
            print(point.dx);
            path.lineTo(
        point.dx * size.width,
        point.dy * size.height,
      );
            canvas.drawLine(Offset(0, point.dy), Offset(0, startY + dashHeight), paint);
          }
    );
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

    path.quadraticBezierTo(size.width * 0.60, size.height * 0.10,
        size.width * 0.35, size.height * 0.14);
    path.quadraticBezierTo(size.width*0.02, size.height*0.20, size.width*0.46,size.height*0.28);
    path.quadraticBezierTo(size.width*0.80, size.height*0.35, size.width*0.66,size.height*0.40);
    path.quadraticBezierTo(size.width*0.32, size.height*0.49, size.width*0.60,size.height*0.53);
    path.quadraticBezierTo(size.width*0.98, size.height*0.61, size.width*0.30,size.height*0.67);
    path.quadraticBezierTo(size.width*0.10, size.height*0.71, size.width*0.30,size.height*0.76);
    path.quadraticBezierTo(size.width*0.90, size.height*0.91, size.width*0.30,size.height);

    // path.quadraticBezierTo(size.width*0.08, size.height*0.45, size.width*0.65,size.height*0.60 );

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
