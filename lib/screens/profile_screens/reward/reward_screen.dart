import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:gwc_customer/screens/profile_screens/reward/levels_screen.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({Key? key}) : super(key: key);

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  List rewardList = [
    {
      'amount': 250,
      'name':'Lorem Ipsum is simply dummy text of the print and typesetting industry.',
      "time":'09 Nov 22'
    },
    {
      'amount': 10,
      'name':'Lorem Ipsum is simply dummy text of the print and typesetting industry.',
      "time":'09 Nov 22'
    },
    {
      'amount': 100,
      'name':'Lorem Ipsum is simply dummy text of the print and typesetting industry.',
      "time":'09 Nov 22'
    },
    {
      'amount': 400,
      'name':'Lorem Ipsum is simply dummy text of the print and typesetting industry.',
      "time":'09 Nov 22'
    }
  ];
  String rupeeSymbol = '\u{20B9}';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: PageScrollPhysics(),
          child: Container(
            height: 100.h,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 25.h,
                  color: gsecondaryColor,
                  padding:
                  EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex:1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildAppBar(() {
                              Navigator.pop(context);
                            }),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              "Refer your friends",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "GothamBook",
                                  color: gMainColor,
                                  fontSize: 12.sp),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              "Earn $rupeeSymbol 150 Each",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "GothamBold",
                                  color: gMainColor,
                                  fontSize: 11.sp),
                            ),
                          ],
                        ),
                      ),
                      Expanded(flex: 1,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Image.asset('assets/images/reward_coin.png',
                            fit: BoxFit.scaleDown,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.5.h,
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Color(0xFFFAFAFA),
                    height: double.maxFinite,
                    width: double.maxFinite,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              top: 5.h,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Card(
                                      // child: customListTile('12', 'anlnana;kd', '12 Nov 2022'),
                                      elevation: 5,
                                      child: ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: rewardList.length,
                                          itemBuilder: (_, index){
                                          return customListTile(
                                              rewardList[index]['amount'].toString(),
                                              rewardList[index]['name'],
                                              rewardList[index]['time']
                                          );
                                          },
                                        separatorBuilder: (_, index){
                                          if(index != rewardList.length-1){
                                            return Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                              child: Divider(
                                                color: kDividerColor,
                                              ),
                                            );
                                          }
                                          return SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Frequently asked questions",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontFamily: "GothamBold",
                                              color: gTextColor,
                                              fontSize: 12.sp),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 1,
                                            color: Color(0xFFCFCFCF),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: gWhiteColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            blurRadius: 20,
                                            offset: const Offset(8, 10),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text('What is the Refer and Earn program?',
                                              style: TextStyle(
                                                fontSize: 10.5.sp,
                                                fontFamily: 'GothamMedium'
                                              ),
                                            ),
                                          ),
                                          Icon(Icons.keyboard_arrow_down_sharp,
                                          color: gMainColor,)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10.w,
                              right: 10.w,
                              top: -10.w,
                              child: GestureDetector(
                                onTap:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=> LevelsScreen()));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: gWhiteColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(8, 10),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Image(
                                        image: const AssetImage(
                                            "assets/images/reward_coin.png"),
                                        height: 8.h,
                                      ),
                                      SizedBox(width: 5.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "TOTAL REWARD",
                                              style: TextStyle(
                                                  fontFamily: "GothamBook",
                                                  color: gTextColor,
                                                  letterSpacing: 0.4,
                                                  fontSize: 11.sp),
                                            ),
                                            Text(
                                              "$rupeeSymbol 200",
                                              style: TextStyle(
                                                  fontFamily: "GothamBold",
                                                  color: gTextColor,
                                                  height: 1.5,
                                                  fontSize: 11.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: gMainColor,
                                        size: 2.h,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  customListTile(String rupee, String name, String time){
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFE0FFAE)
        ),
          // child: Icon(Icons.card_giftcard)
        child: Image.asset("assets/images/points.png",
          fit: BoxFit.scaleDown,
        ),
      ),
      isThreeLine: true,
      minVerticalPadding: 0,
      dense: true,
      minLeadingWidth: 30,
      title: Text('$rupeeSymbol $rupee',
        style: TextStyle(
          fontFamily: 'GothamMedium',
          fontSize: 11.sp,
            color: gTextColor
        ),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //GothamRoundedBold_21016
          Text(name,
            style: TextStyle(
                fontFamily: 'GothamMedium',
                fontSize: 10.sp,
              color: gTextColor
            ),
          ),
          Text(time,
            style: TextStyle(
                fontFamily: 'GothamLight',
                fontSize: 9.sp,
                color: gTextColor
            ),
          )
        ],
      ),
    );
  }
}
