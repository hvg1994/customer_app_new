/*
Notification types

meal_plan
enquiry
report
appointment
shopping

API for notification list

https://gwc.disol.in/apidoc/#api-User-notification_list
 */
import 'package:flutter/material.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/notification_model/NotificationModel.dart';
import 'package:gwc_customer/model/notification_model/child_notification_model.dart';
import 'package:gwc_customer/repository/api_service.dart';
import 'package:gwc_customer/repository/notification_repository/notification_repo.dart';
import 'package:gwc_customer/services/notification_service/notification_service.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

enum NotificationTypeEnum{
  meal_plan, enquiry, report, appointment, shopping
}
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {


  Future? notificationFuture;

  String type = "shopping";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotificationList();

  }

  getNotificationList(){
    notificationFuture = NotificationService(repository: repo).getNotificationListService();
    print(NotificationTypeEnum.shopping);
    print(type == NotificationTypeEnum.shopping.name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: const AssetImage("assets/images/eval_bg.png"),
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.lighten)
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h),
                child: buildAppBar((){
                  Navigator.pop(context);
                }),
              ),
              SizedBox(
                height: 4.h,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Text('Notifications',
                              style: TextStyle(
                                fontFamily: 'GothamBold',
                                color: gMainColor,
                                fontSize: 12.sp
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          FutureBuilder(
                            future: notificationFuture,
                              builder: (_, snapshot){
                              print(snapshot.connectionState);
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return buildCircularIndicator();
                              }
                              else if(snapshot.connectionState == ConnectionState.done){
                                if(snapshot.hasData){
                                  print(snapshot.data.runtimeType);
                                  if(snapshot.data.runtimeType == ErrorModel){
                                    return Center(
                                      child: Column(children: [
                                        Text(snapshot.error.toString(),
                                          style: TextStyle(
                                              fontSize: 11.sp,
                                              fontFamily: 'GothamMedium'
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: (){
                                              getNotificationList();
                                            },
                                            child: Text('Retry',
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontFamily: 'GothamMedium'
                                              ),
                                            )
                                        )
                                      ],),
                                    );
                                  }
                                  else{
                                    NotificationModel model = snapshot.data as NotificationModel;
                                    List<ChildNotificationModel> childModel = model.data as List<ChildNotificationModel>;
                                    return ListView.builder(
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: childModel.length,
                                        itemBuilder: (_, index){
                                        return showListItem(getIcons(childModel[index].type) ?? '', childModel[index].subject ?? '', childModel[index].message ?? '', childModel[index].created_at ?? '');
                                        }
                                    );
                                  }
                                }
                                else if(snapshot.hasError){
                                  return Center(
                                    child: Column(children: [
                                      Text(snapshot.error.toString(),
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontFamily: 'GothamMedium'
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: (){
                                            getNotificationList();
                                          },
                                          child: Text('Retry',
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                fontFamily: 'GothamMedium'
                                            ),
                                          )
                                      )
                                    ],),
                                  );
                                }
                              }
                              return buildCircularIndicator();
                              }
                          ),
                          // showListItem('assets/images/notification/pay_done.png', 'Payment is done', 'Your enquiry was successfully verified. Tap to sign in right now!', '1 Month ago'),
                          // showListItem('assets/images/notification/booking.png', 'Booked Appointment', 'Success! Your appointment is scheduled with Gut Wellness Club. Tap to find out more.', '1 Month ago'),
                          // showListItem('assets/images/notification/appoint_reminder.png', 'Reminder of Appointment', 'Reminder: Appointment scheduled for [Date] at [Time]. Tap to join. ', '1 Month ago'),
                          // showListItem('assets/images/notification/appoint_schedule.png', 'Appointment Rescheduled', 'Your appointment was successfully rescheduled. Tap to see more details.', '1 Month ago'),
                          // showListItem('assets/images/notification/appoint_schedule.png', 'MR was uploaded', 'Your Medical Report was uploaded. Tap it to see the details.', '1 Month ago'),
                          // showListItem('assets/images/notification/list_upload.png', 'Shopping List Upload', 'Your Shopping list has been uploaded. Enjoy! Tap to see it. ', '1 Month ago'),
                          // showListItem('assets/images/notification/intransit.png', 'Intransit, Reached Near, Delivered', 'a. Your #(order number) is in transit. Track here: b.Your #(order number) has reached a nearby location. Track here:  c. Success! Your order has been delivered to you. Enjoy your program with tasty, healthy meals!', '1 Month ago'),
                          //
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }

  showListItem(String asset, String title, String subTitle, String lastTitle){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 10,
          leading: Card(
            color: gMainColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(asset,
                fit: BoxFit.scaleDown,
                width: 40,
                // height: 70
              ),
            ),
          ),
          minLeadingWidth: 30,
          title: Text(title,
            style: TextStyle(
                fontFamily: 'GothamBold',
                color: gPrimaryColor,
                fontSize: 11.sp
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(subTitle,
                style: TextStyle(
                    fontFamily: 'GothamMedium',
                    color: gTextColor,
                    fontSize: 10.sp
                ),
              ),
              Text(lastTitle,
                style: TextStyle(
                    fontFamily: 'GothamMedium',
                    color: gTextColor,
                    fontSize: 9.5.sp
                ),
              )
            ],
          ),
          isThreeLine: true,
        ),
        // SizedBox(
        //   child: Row(
        //     children: [
        //       Expanded(
        //           flex: 1,
        //           child: Image.asset(asset)),
        //       Expanded(
        //         flex: 3,
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Text(title,
        //               style: TextStyle(
        //                   fontFamily: 'GothamBold',
        //                   color: gMainColor,
        //                   fontSize: 11.sp
        //               ),
        //             ),
        //             Expanded(
        //               child: Text(subTitle,
        //                 style: TextStyle(
        //                     fontFamily: 'GothamBold',
        //                     color: gMainColor,
        //                     fontSize: 10.sp
        //                 ),
        //               ),
        //             ),
        //             Text(lastTitle,
        //               style: TextStyle(
        //                   fontFamily: 'GothamBold',
        //                   color: gMainColor,
        //                   fontSize: 9.5.sp
        //               ),
        //             )
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        Divider()
      ],
    );
  }

  NotificationRepo repo = NotificationRepo(
      apiClient: ApiClient(
        httpClient: http.Client()
      )
  );

  //meal_plan
  // enquiry
  // report
  // appointment
  // shopping
  String? getIcons(String? type) {
    String? asset;

    if(type == NotificationTypeEnum.meal_plan.name){
      asset = 'assets/images/notification/intransit.png';
    }
    else if(type == NotificationTypeEnum.enquiry.name){
      asset = 'assets/images/notification/pay_done.png';
    }
    else if(type == NotificationTypeEnum.report.name){
      asset = 'assets/images/notification/appoint_schedule.png';
    }
    else if(type == NotificationTypeEnum.appointment.name){
      asset = 'assets/images/notification/appoint_reminder.png';
    }
    else if(type == NotificationTypeEnum.shopping.name){
      asset = 'assets/images/notification/list_upload.png';
    }

    return asset;
  }
}
