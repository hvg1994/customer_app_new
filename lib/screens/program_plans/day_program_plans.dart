import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/program_model/program_days_model/child_program_day.dart';
import 'package:gwc_customer/model/program_model/program_days_model/program_day_model.dart';
import 'package:gwc_customer/services/program_service/program_service.dart';
import 'package:gwc_customer/widgets/open_alert_box.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../repository/api_service.dart';
import '../../repository/program_repository/program_repository.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'days_plan_data.dart';
import 'meal_plan_screen.dart';
import 'package:http/http.dart' as http;

class DaysProgramPlan extends StatefulWidget {
  const DaysProgramPlan({Key? key}) : super(key: key);

  @override
  State<DaysProgramPlan> createState() => _DaysProgramPlanState();
}

class _DaysProgramPlanState extends State<DaysProgramPlan> {

  final _pref = AppConfig().preferences;

  Future? _getDaysFuture;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProgramDays();
  }

  getProgramDays(){
    _getDaysFuture = ProgramService(repository: repository).getMealProgramDaysService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(height: 1.h),
              Text(
                "Program",
                style: TextStyle(
                    fontFamily: "GothamRoundedBold_21016",
                    color: gPrimaryColor,
                    fontSize: 12.sp),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: FutureBuilder(
                  future: _getDaysFuture,
                  builder: (_, snapshot){
                    if(snapshot.hasData){
                      print("snapshot.data: ${snapshot.data}");
                      if(snapshot.data.runtimeType == ProgramDayModel){
                        final model = snapshot.data as ProgramDayModel;
                        // model.data!.forEach((element) {
                        //   print('${element.dayNumber} -- ${element.color}');
                        // });
                        _pref!.setInt(AppConfig.STORE_LENGTH, model.data!.length);
                        return buildDaysPlan(model.data!);
                      }
                      else {
                        ErrorModel model = snapshot.data as ErrorModel;
                        print('snapshot.errormodel:${model.message}');
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(model.message!,
                                style: TextStyle(
                                  fontFamily: "GothamMedium",
                                  color: gTextColor,
                                  fontSize: 11.sp,
                                ),
                              ),
                              TextButton(onPressed: (){
                                getProgramDays();
                              },
                                  child: Text('Retry'))
                            ],
                          ),
                        );
                        // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                        //   return openAlertBox(context: context,
                        //     positiveButtonName: 'Retry',
                        //     content: model.message,
                        //       positiveButton: () {
                        //         getProgramDays();
                        //         Navigator.pop(context);
                        //       },
                        //       isSingleButton: true
                        //   );
                        // });
                      }
                    }
                    else if(snapshot.hasError){
                      print('snapshot.error:${snapshot.error}');
                      return openAlertBox(context: context,
                          positiveButtonName: 'Retry',
                          content: snapshot.error.toString(),
                          positiveButton: () {
                            getProgramDays();
                            Navigator.pop(context);
                          }
                      );
                    }
                    return buildCircularIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildDaysPlan(List<ChildProgramDayModel> model) {
    return GridView.builder(
      // this clip none to show check icon full
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 20,
            mainAxisExtent: 15.5.h),
        itemCount: model.length ?? dayPlansData.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (model[index].dayNumber != '1') ? null : () {
              //  buildDayCompleted();
             // buildDayNotCompleted();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealPlanScreen(
                    // day: dayPlansData[index]["day"],
                    day: model[index].dayNumber!
                  ),
                ),
              );
            },
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              overflow: Overflow.visible,
              children: [
                Positioned(
                  top: -7,
                    right: -4,
                    child: Visibility(
                      visible: model[index].isCompleted == 1,
                      child: Icon(Icons.check_circle,
                        color: gPrimaryColor,
                        size: 18,
                      ),
                    )
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          alignment: Alignment(-.2, 0),
                          opacity: (model[index].dayNumber.toString() == '1') ? 1.0 : 0.7,

                          // opacity: (model[index].isCompleted.toString() == '1' || model[index].isCompleted.toString() == '2') ? 1.0 : 0.7,
                          image: CachedNetworkImageProvider(model[index].image!,),
                          // image: AssetImage(dayPlansData[index]["image"]),
                          fit: BoxFit.fill),
                      border: Border.all(
                          color: model[index].color!,
                          // color: dayPlansData[index]["color"],
                          width: 2)),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 0.5.h),
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            // color: dayPlansData[index]["color"],
                            color: model[index].color
                          ),
                          child: Text(
                            " DAY ${model[index].dayNumber!}",
                            // " DAY ${dayPlansData[index]["day"]}",
                            style: TextStyle(
                              fontFamily: "GothamMedium",
                              color: gTextColor,
                              fontSize: 8.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  buildDayNotCompleted() {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(top: 2.h, left: 10.w, right: 10.w),
        decoration: const BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        height: size.height * 0.50,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
                    child: Icon(
                      Icons.clear,
                      color: gMainColor,
                      size: 1.8.h,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gMainColor),
              ),
              child: Image(
                height: 20.h,
                image: const AssetImage("assets/images/Pop up.png"),
              ),
            ),
            SizedBox(height: 1.5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                "Your Day 1 Meal Plan Not yet completed you want to continue the day 2 Meal Plan ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontFamily: "GothamBold",
                  color: gTextColor,
                  fontSize: 10.sp,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: gPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: gMainColor, width: 1),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: "GothamRoundedBold_21016",
                    color: gMainColor,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildDayCompleted() {
    Size size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(top: 2.h, left: 10.w, right: 10.w),
        decoration: const BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        height: size.height * 0.50,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
                    child: Icon(
                      Icons.clear,
                      color: gMainColor,
                      size: 1.8.h,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gMainColor),
              ),
              child: Image(
                height: 20.h,
                image: const AssetImage("assets/images/Image 2.png"),
              ),
            ),
            SizedBox(height: 1.5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Text(
                "Your Have completed the 15 days Meal Plan, Now you can proceed to Post Protocol",
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  fontFamily: "GothamBold",
                  color: gTextColor,
                  fontSize: 10.sp,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  color: gPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: gMainColor, width: 1),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: "GothamRoundedBold_21016",
                    color: gMainColor,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final ProgramRepository repository = ProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
