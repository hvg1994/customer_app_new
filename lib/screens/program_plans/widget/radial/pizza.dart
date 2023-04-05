import 'package:flutter/material.dart';
import 'dart:math' as math;

class PizzaSlice extends StatefulWidget {
  const PizzaSlice({Key? key}) : super(key: key);

  @override
  State<PizzaSlice> createState() => _PizzaSliceState();
}

class _PizzaSliceState extends State<PizzaSlice> {

  bool isSelected = true;
  showCircle(){
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(300, 300),
            painter: CircleCustomPainer(
              stroke: isSelected ? 1.2 : 0.5
            ),
          ),
          Center(child: getWidgets(7, Size(300, 300)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              showCircle()

              //     Card(
          //       clipBehavior: Clip.antiAlias,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(60.0),
          //       ),
          //       child: SizedBox(
          //         width: 120,
          //         height: 120,
          //         child: Center(
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Expanded(
          //                 child: Row(
          //                   children: [
          //                     Expanded(
          //                       child: InkWell(
          //                           onTap: () {},
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(16.0),
          //                             child: Text("1"),
          //                           )),
          //                     ),
          //                     Expanded(
          //                       child: InkWell(
          //                           onTap: () {},
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(16.0),
          //                             child: Text("2"),
          //                           )),
          //                     )
          //                   ],
          //                 ),
          //               ),
          //               Expanded(
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.min,
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     Expanded(
          //                       child: InkWell(
          //                           onTap: () {},
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(16.0),
          //                             child: Text("1"),
          //                           )),
          //                     ),
          //                     Expanded(
          //                       child: InkWell(
          //                           onTap: () {},
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(16.0),
          //                             child: Text("2"),
          //                           )),
          //                     )
          //                   ],
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //
          // Column(
          //   children: [
          //     Row(
          //       children: [
          //         QuarterButton(position: QuarterPosition.topLeft, size: 100, text: "1"),
          //         QuarterButton(position: QuarterPosition.topRight, size: 100, text: "2"),
          //       ],
          //     ),
          //     Row(
          //       children: [
          //         QuarterButton(position: QuarterPosition.bottomLeft, size: 100, text: "3"),
          //         QuarterButton(position: QuarterPosition.bottomRight, size: 100, text: "4"),
          //       ],
          //     ),
          //   ],
          // )
            ],
          ),
        ));
  }
}


enum QuarterPosition { topLeft, topRight, bottomLeft, bottomRight }

class QuarterButton extends StatelessWidget {
  const QuarterButton({Key? key, required this.position, this.size = 100, this.text = ""}) : super(key: key);

  final QuarterPosition position;
  final double size;
  final String text;

  BorderRadiusGeometry _generateBorderRadius() {
    switch (position) {
      case QuarterPosition.topLeft:
        return BorderRadius.only(
          topLeft: Radius.circular(size),
        );
      case QuarterPosition.topRight:
        return BorderRadius.only(
          topRight: Radius.circular(size),
        );
      case QuarterPosition.bottomLeft:
        return BorderRadius.only(
          bottomLeft: Radius.circular(size),
        );
      case QuarterPosition.bottomRight:
        return BorderRadius.only(
          bottomRight: Radius.circular(size),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text(text, style: TextStyle(fontSize: 30, color: Colors.white)),
          style: ElevatedButton.styleFrom(
              primary: Colors.black54,
              fixedSize: Size(size, size),
              shape: RoundedRectangleBorder(
                borderRadius: _generateBorderRadius(),
              ),
              side: BorderSide(color: Colors.white)),
        ),
      ],
    );
  }


}

Widget getWidgets(int count, Size size) {
  List<Widget> list = [];

  for (var i = 0; i < count; i++) {
    var o = (2 * i * math.pi) / count;
    o = o + ((360 / count) / 57.2958) / 2;
    var x = (size.width / 3) * math.cos(o) + (size.width / 2);
    var y = (size.width / 3) * math.sin(o) + (size.height / 2);

    list.add(Positioned.fromRect(
      rect: Rect.fromCenter(center: Offset(x, y), height: 60, width: 60),
      child: Column(
        children: [
          Container(
            color: Colors.black,
            width: 60,
            height: 60,
          ),
        ],
      ),
    ));
  }

  return Container(
    width: 300,
    height: 300,
    alignment: Alignment.center,
    child: Stack(
      children: list,
    ),
  );
}




//**********************


class CircleCustomPainer extends CustomPainter {
  double? stroke;
  var count = 7;
  CircleCustomPainer({this.stroke});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.red;
    Paint paint1 = Paint();
    paint1.color = Colors.white;
    paint1.strokeWidth = stroke ?? 0.5;
    paint1.style = PaintingStyle.stroke;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.height / 2, paint);

    Path path = Path();
    path.moveTo(size.width / 2, size.height / 2);
    for (var i = 0; i < count; i++) {
      var o = (2 * i * math.pi) / count;
      var x = 150 * math.cos(o) + (size.width / 2);
      var y = 150 * math.sin(o) + (size.height / 2);
      path.lineTo(x, y);
      path.moveTo(size.width / 2, size.height / 2);
    }
    canvas.drawPath(path, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}