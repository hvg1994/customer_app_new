import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:sizer/sizer.dart';


class PPCalendar extends StatefulWidget {
  const PPCalendar({Key? key}) : super(key: key);

  @override
  State<PPCalendar> createState() => _PPCalendarState();
}

class _PPCalendarState extends State<PPCalendar> {
  final DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.MMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();

//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static const Widget _eventIcon = Image(
    image: AssetImage("assets/images/gmg/Group 11526.png"),
    // height: 1.h,
  );
  static const Widget sadIcon = Image(
    image: AssetImage("assets/images/gmg/Group 11527.png"),
    // height: 3.h,
  );
  static const Widget notCompletedIcon = Image(
    image: AssetImage("assets/images/gmg/Group 11528.png"),
    // height: 3.h,
  );

  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime.now(): [
        Event(
          date: DateTime(2022, 5, 12),
          title: '',
          icon: _eventIcon,
          dot: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            //   color: Colors.red,
            height: 5.0,
            width: 5.0,
          ),
        ),
        // new Event(
        //   date: new DateTime(2019, 2, 10),
        //   title: '',
        //   icon: _eventIcon,
        // ),
        // new Event(
        //   date: new DateTime(2019, 2, 10),
        //   title: '',
        //   icon: _eventIcon,
        // ),
      ],
    },
  );

  @override
  void initState() {
    /// Add more events to _markedDateMap EventList
    _markedDateMap.add(
        DateTime(2022, 12, 3),
        Event(
          date: DateTime(2022, 12, 3),
          title: 'Event 5',
          icon: notCompletedIcon,
        ));
    _markedDateMap.add(
        DateTime(2022, 12, 4),
        Event(
          date: DateTime(2022, 12, 4),
          title: 'Event 5',
          icon: _eventIcon,
        ));
    _markedDateMap.add(
        DateTime(2022, 12, 5),
        Event(
          date: DateTime(2022, 12, 5),
          title: 'Event 5',
          icon: sadIcon,
        ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Example with custom icon
//     final _calendarCarousel = CalendarCarousel<Event>(
//       dayPadding: 20.0,
//       onDayPressed: (date, events) {
//         this.setState(() => _currentDate = date);
//         events.forEach((event) => print(event.title));
//       },
//       weekendTextStyle: TextStyle(
//         color: Colors.red,
//       ),
//       thisMonthDayBorderColor: Colors.grey,
// //          weekDays: null, /// for pass null when you do not want to render weekDays
//       headerText: 'Custom Header',
//       weekFormat: true,
//       markedDatesMap: _markedDateMap,
//       height: 600.0,
//       selectedDateTime: _currentDate2,
//       showIconBehindDayText: true,
// //          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
//       customGridViewPhysics: NeverScrollableScrollPhysics(),
//       markedDateShowIcon: true,
//       markedDateIconMaxShown: 2,
//       selectedDayTextStyle: TextStyle(
//         color: Colors.yellow,
//       ),
//       todayTextStyle: TextStyle(
//         color: Colors.blue,
//       ),
//       markedDateIconBuilder: (event) {
//         return event.icon ?? Icon(Icons.help_outline);
//       },
//       minSelectedDate: _currentDate.subtract(Duration(days: 360)),
//       maxSelectedDate: _currentDate.add(Duration(days: 360)),
//       todayButtonColor: Colors.transparent,
//       todayBorderColor: Colors.green,
//       markedDateMoreShowTotal:
//           true, // null for not showing hidden events indicator
// //          markedDateIconMargin: 9,
// //          markedDateIconOffset: 3,
//     );

    /// Example Calendar Carousel without header and custom prev & next button
    final _calendarCarouselNoHeader = CalendarCarousel<Event>(
      weekDayFormat: WeekdayFormat.narrow,
      dayPadding: 2.0,
      dayMainAxisAlignment: MainAxisAlignment.end,
      dayCrossAxisAlignment: CrossAxisAlignment.end,
      weekDayPadding: EdgeInsets.symmetric(vertical: 5),
      isScrollable: false,
      weekDayBackgroundColor: gsecondaryColor,
      weekdayTextStyle: TextStyle(
        color: gWhiteColor,
        fontSize: 10.sp,
      ),
      //todayBorderColor: Colors.green,
      onDayPressed: (date, events) {
        setState(() => _currentDate2 = date);
        events.forEach(
            (event) {AppConfig().showSnackbar(context, event.title!, isError: true); });
        //  print(event.title));
      },
      daysHaveCircularBorder: false,
      showOnlyCurrentMonthDate: true,
      daysTextStyle: TextStyle(
        fontSize: 9.sp,
        color: gBlackColor,
      ),
      weekendTextStyle: TextStyle(
        color: Colors.red,
        fontSize: 9.sp,
      ),
      thisMonthDayBorderColor: Colors.grey.withOpacity(0.2),
      weekFormat: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      height: 330,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      // markedDateCustomShapeBorder:
      //     CircleBorder(side: BorderSide(color: Colors.yellow)),
      // markedDateCustomTextStyle: TextStyle(
      //   fontSize: 8.sp,
      //   color: Colors.blue,
      // ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: gPrimaryColor,
        fontSize: 9.sp,
      ),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      //  markedDateIconOffset: 0,markedDateIconMargin: 20,
      markedDateMoreShowTotal: true,
      todayButtonColor: Colors.transparent,
      selectedDayButtonColor: Colors.transparent,
      selectedDayTextStyle: TextStyle(
        fontSize: 9.sp,
        color: gBlackColor,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      // prevDaysTextStyle: TextStyle(
      //   fontSize: 8.sp,
      //   color: Colors.pinkAccent,
      // ),

      // inactiveDaysTextStyle: TextStyle(
      //   color: Colors.tealAccent,
      //   fontSize: 16,
      // ),
      onCalendarChanged: (DateTime date) {
        setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.MMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //SizedBox(height: 1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: buildAppBar(
            () {
              Navigator.pop(context);
            },
            isBackEnable: true,
            showNotificationIcon: false,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 0.h,
            bottom: 1.h,
            left: 16.0,
            right: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _targetDateTime = DateTime(
                        _targetDateTime.year, _targetDateTime.month - 1);
                    _currentMonth = DateFormat.MMMM().format(_targetDateTime);
                  });
                },
                child: Container(
                  // padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: gWhiteColor,
                      border: Border.all(color: gBlackColor, width: 1),
                      shape: BoxShape.circle),
                  child: const Icon(
                    Icons.navigate_before_outlined,
                    color: gBlackColor,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              // TextButton(
              //   child: Text('PREV'),
              //   onPressed: () {
              //     setState(() {
              //       _targetDateTime = DateTime(
              //           _targetDateTime.year, _targetDateTime.month - 1);
              //       _currentMonth = DateFormat.yMMM().format(_targetDateTime);
              //     });
              //   },
              // ),
              Text(
                _currentMonth,
                style: TextStyle(
                  fontFamily: "GothamBold",
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _targetDateTime = DateTime(
                        _targetDateTime.year, _targetDateTime.month + 1);
                    _currentMonth = DateFormat.MMMM().format(_targetDateTime);
                  });
                },
                child: Container(
                  // padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: gWhiteColor,
                      border: Border.all(color: gBlackColor, width: 1),
                      shape: BoxShape.circle),
                  child: const Icon(
                    Icons.navigate_next_outlined,
                    color: gBlackColor,
                  ),
                ),
              ),
              // TextButton(
              //   child: Text('NEXT'),
              //   onPressed: () {
              //     setState(() {
              //       _targetDateTime = DateTime(
              //           _targetDateTime.year, _targetDateTime.month + 1);
              //       _currentMonth = DateFormat.yMMM().format(_targetDateTime);
              //     });
              //   },
              // )
            ],
          ),
        ),
        Center(
          child: Text(
            "Tracker summary of your breakfast",
            style: TextStyle(
              fontFamily: "GothamBook",
              fontSize: 10.sp,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          child: _calendarCarouselNoHeader,
        ),
        Expanded(
          child: buildDetails(),
        ),
      ],
    ));
  }

  buildDetails() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Image(
                  image: const AssetImage("assets/images/gmg/Group 11526.png"),
                  height: 2.5.h,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Followed - 80 to 100 %",
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    fontSize: 8.sp,
                  ),
                ),
                SizedBox(width: 5.w),
                Image(
                  image: const AssetImage("assets/images/gmg/Group 11528.png"),
                  height: 2.5.h,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Followed - 30 to 80 %",
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    fontSize: 8.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Image(
                  image: const AssetImage("assets/images/gmg/Group 11527.png"),
                  height: 2.5.h,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Followed - 30 to 0 %",
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    fontSize: 8.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Image(
                  image: const AssetImage("assets/images/gmg/Group 11552.png"),
                  height: 2.5.h,
                  //color: gGreyColor.withOpacity(0.3),
                ),
                SizedBox(width: 2.w),
                Text(
                  "Skipped",
                  style: TextStyle(
                    fontFamily: "GothamBook",
                    fontSize: 8.sp,
                  ),
                ),
              ],
            ),
            buildTile(
              "assets/images/gmg/empty_stomach.png",
              "Empty Stomach",
              // optionSelectedList[0].toString(),
              // model.day,
            ),
            buildTile(
              "assets/images/gmg/breakfast_icon.png",
              "BreakFast",
              // optionSelectedList[0].toString(),
              // model.day,
            ),
            buildTile(
              "assets/images/gmg/midday_icon.png",
              "Mid Day",
              // optionSelectedList[1].toString(),
              // model.day,
            ),
            buildTile(
              "assets/images/gmg/lunch_icon.png",
              "Lunch",
              // optionSelectedList[1].toString(),
              // model.day,
            ),
            buildTile(
              "assets/images/gmg/evening_icon.png",
              "Evening",
              // optionSelectedList[2].toString(),
              // model.day,
            ),
            buildTile(
              "assets/images/gmg/dinner_icon.png",
              "Dinner",
              // optionSelectedList[2].toString(),
              // model.day,
            ),
            buildTile(
              "assets/images/gmg/pp_icon.png",
              "Post Program",
              // optionSelectedList[2].toString(),
              // model.day,
            ),
          ],
        ),
      ),
    );
  }

  buildTile(
    String lottie,
    String title,
    // String value,
    // int? day,
  ) {
    // print(value);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w),
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.w),
      decoration: BoxDecoration(
        color: gWhiteColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: ListTile(
          leading: Image(
            image: AssetImage(lottie),
            color: gBlackColor,
            height: 3.h,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: "GothamBook",
              color: gBlackColor,
              // color: value == '0' ? gBlackColor : gWhiteColor,
              fontSize: 11.sp,
            ),
          ),
          trailing: GestureDetector(
            onTap: () async {
              // print(optionSelectedList[index].runtimeType);
              // await Navigator.of(context)
              //     .push(
              //   MaterialPageRoute(
              //     builder: (context) => GuideStatus(
              //       title: title,
              //       dayNumber: day,
              //       isSelected: value != '0',
              //     ),
              //   ),
              // )
              //     .then((value) {
              //   print("pop value $value");
              //   if (value != null) {
              //     // setState(() {
              //     //   selectedStatus = value;
              //     // });
              //     print("day== $day");
              //     getFuture(dayNumber: day.toString());
              //     setState(() {});
              //   }
              // });
            },
            child: Image(
              image: const AssetImage("assets/images/noun-arrow-1018952.png"),
              height: 2.5.h,
              // color: value == '0' ? gBlackColor : gWhiteColor,
            ),
          )),
    );
  }
}
