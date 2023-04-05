// import 'package:flutter/material.dart';
//
// void main() {
//   return runApp(_ChartApp());
// }
//
// class _ChartApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: _MyHomePage(),
//     );
//   }
// }
//
// class _MyHomePage extends StatefulWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<_MyHomePage> {
//   List<_SalesData> data = [
//     _SalesData('Jan', 35, Color.fromARGB(255, 247, 174, 151)),
//     _SalesData('Feb', 28, Color.fromARGB(255, 253, 208, 147)),
//     _SalesData('Mar', 64, Color.fromARGB(255, 141, 213, 202)),
//     _SalesData('Apr', 52, Color.fromARGB(255, 167, 211, 251), '90%'),
//     _SalesData(
//       'May',
//       40,
//       Color.fromARGB(255, 194, 202, 222),
//     )
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Syncfusion Flutter chart'),
//       ),
//       body: Center(
//         //Initialize the chart widget
//           child: Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                       blurRadius: 5.0,
//                       color: Colors.grey.withAlpha(60),
//                       spreadRadius: 5.0,
//                       offset: Offset(0.0, 3.0))
//                 ],
//                 gradient: RadialGradient(stops: <double>[
//                   0.9,
//                   0.2,
//                   0.2
//                 ], colors: <Color>[
//                   Color.fromARGB(255, 254, 255, 254),
//                   Color.fromARGB(255, 235, 242, 249),
//                   Color.fromARGB(255, 215, 223, 232),
//                 ], radius: 0.5, center: Alignment.center),
//                 shape: BoxShape.circle,
//               ),
//               child: SfCircularChart(annotations: <CircularChartAnnotation>[
//                 CircularChartAnnotation(
//                   widget: Padding(
//                     padding: EdgeInsets.only(top: 60),
//                     child: Container(
//                         height: 150,
//                         width: 150,
//                         child: Column(children: <Widget>[
//                           Text('BAD',
//                               style:
//                               TextStyle(fontSize: 18, color: Colors.grey)),
//                           Text('23%',
//                               style: TextStyle(
//                                   fontSize: 22, fontWeight: FontWeight.bold)),
//                           Text('7 entries',
//                               style:
//                               TextStyle(fontSize: 14, color: Colors.grey))
//                         ])),
//                   ),
//                   angle: 90,
//                   horizontalAlignment: ChartAlignment.center,
//                 ),
//               ], series: <CircularSeries<_SalesData, String>>[
//                 DoughnutSeries<_SalesData, String>(
//                   innerRadius: '70%',
//                   explodeAll: true,
//                   explode: true,
//                   dataSource: data,
//                   xValueMapper: (_SalesData sales, _) => sales.year,
//                   yValueMapper: (_SalesData sales, _) => sales.sales,
//                   pointColorMapper: (_SalesData sales, _) => sales.color,
//                   pointRadiusMapper: (_SalesData sales, _) => sales.radius,
//                   name: 'Sales',
//                 )
//               ]))),
//     );
//   }
// }
//
// class _SalesData {
//   _SalesData(this.year, this.sales, [this.color, this.radius]);
//
//   final String year;
//   final double sales;
//   final Color? color;
//   final String? radius;
// }


import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DemoSlice extends StatefulWidget {
  const DemoSlice({Key? key}) : super(key: key);

  @override
  State<DemoSlice> createState() => _DemoSliceState();
}

class _DemoSliceState extends State<DemoSlice> {
  double _pointerValue = 92;
  String selectedLabel = "";
  int _segmentsCount = 7;
  late List<LabelDetails> _labels;

  @override
  void initState() {
    _labels = [];
    _calculateLabelsPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StatefulBuilder(
        builder: (_, setstate){
          return Column(
            children: [
              SfRadialGauge(
                  title: const GaugeTitle(
                      text: 'Speedometer',
                      textStyle:
                      TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: 320,
                      startAngle: 130,
                      endAngle: 50,
                      maximumLabels: 320,
                      interval: 1,
                      onLabelCreated: _handleLabelCreated,
                      canRotateLabels: true,
                      labelsPosition: ElementsPosition.inside,
                      showTicks: false,
                      radiusFactor: 1,
                      canScaleToFit: true,
                      onAxisTapped: (value){
                        print("axis tapped ${value}");

                        _labels.forEach((element) {
                          print("element: ${element.labelPoint}");

                        });
                      },
                      pointers: <GaugePointer>[
                        MarkerPointer(
                          onValueChanging: (dynamic args) {
                            setState(() {
                              _pointerValue = args.value;
                            });
                          },
                          value: _pointerValue,
                          enableDragging: true,
                          color: Colors.white,
                          borderColor: Colors.green,
                          borderWidth: 3,
                          markerType: MarkerType.circle,
                          markerHeight: 15,
                          markerWidth: 15,
                          overlayRadius: 0,
                        )
                      ],
                      ranges: _buildRanges(),
                      annotations: <GaugeAnnotation>[
                        // const GaugeAnnotation(
                        //     angle: 180,
                        //     horizontalAlignment: GaugeAlignment.far,
                        //     positionFactor: 0.75,
                        //     verticalAlignment: GaugeAlignment.near,
                        //     widget: Padding(
                        //       padding: EdgeInsets.only(top: 5),
                        //       child: Text(
                        //         "0",
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 14,
                        //         ),
                        //       ),
                        //     )),
                        // const GaugeAnnotation(
                        //     angle: 0,
                        //     horizontalAlignment: GaugeAlignment.far,
                        //     positionFactor: 0.85,
                        //     verticalAlignment: GaugeAlignment.near,
                        //     widget: Padding(
                        //       padding: EdgeInsets.only(top: 5),
                        //       child: Text(
                        //         "320",
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 14,
                        //         ),
                        //       ),
                        //     )),
                        GaugeAnnotation(
                            widget:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                              Center(
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: '${_pointerValue.round()}\n',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: 'Points earned this month',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    )),
                              )
                            ]))
                      ],
                    ),
                  ]),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _segmentsCount = 7;
                      _calculateLabelsPosition();
                    });
                  },
                  child: const Text('Update Segment count')),
              Center(child: Text("Selected value: ${selectedLabel}"),)
            ],
          );
        },
      ),
    );
  }

  List<String> nameList = ["7AM", "10AM", "12PM", "Lunch", "Snacks", "Dinner", "10PM"];
  void _calculateLabelsPosition() {
    _labels.clear();
    // Length of the each segment.
    double segmentLength = 320 / _segmentsCount;
    double start = segmentLength / 2;
    for (int i = 0; i < _segmentsCount; i++) {
      // _labels.add(LabelDetails(start.toInt(), '£${i * 4} - £${(i + 1) * 4}'));
      _labels.add(LabelDetails(start.toInt(), nameList[i]));
      start += segmentLength;
    }

    _labels.forEach((element) {
      print("${element.labelPoint} -- ${_pointerValue}");
    });
  }

  getClosest(int val1, int val2, int target)
  {
    if (target - val1 >= val2 - target)
      return val2;
    else
      return val1;
  }
  void _handleLabelCreated(AxisLabelCreatedArgs args) {
    for (int i = 0; i < _segmentsCount; i++) {
      LabelDetails details = _labels[i];
      // print("${details.labelPoint}  &&  ${int.parse(args.text)}");
      if (details.labelPoint == int.parse(args.text)) {
        args.text = details.customizedLabel;
        return;
      }
    }

    args.text = '';
  }

  List<GaugeRange> ranges = [];

  // Return the list of gauge range
  List<GaugeRange> _buildRanges() {
    ranges = [];
    // Gap value between two range
    int gap = 2;
    // Length of the each segment without gap.
    double segmentLength =
        (320 - ((_segmentsCount - 1) * gap)) / _segmentsCount;
    double start = 0;
    for (int i = 0; i < _segmentsCount; i++) {
      _buildGaugeRange(start, start + segmentLength, ranges);
      start += segmentLength + gap;
    }

    return ranges;
  }

  // Method to create a GaugeRange based on start, end and pointerValue and assigned
  // color based on active and inactive range.
  void _buildGaugeRange(double start, double end, List<GaugeRange> ranges) {
    if (_pointerValue >= start && _pointerValue <= end) {
      ranges.add(GaugeRange(
          startValue: start, endValue: _pointerValue, color: Colors.green));
      ranges.add(GaugeRange(
        startValue: _pointerValue,
        endValue: end,
        color: const Color.fromARGB(255, 82, 86, 97),
      ));
    } else if (_pointerValue >= end) {
      ranges.add(GaugeRange(
        startValue: start,
        endValue: end,
        color: Colors.green,
      ));
    } else {
      ranges.add(GaugeRange(
        startValue: start,
        endValue: end,
        color: const Color.fromARGB(255, 82, 86, 97),
      ));
    }
  }
}

class LabelDetails {
  LabelDetails(this.labelPoint, this.customizedLabel);
  int labelPoint;
  String customizedLabel;
}