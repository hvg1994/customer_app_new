import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gwc_customer/screens/dashboard_screen.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;
  bool end = false;

  List<Map<String, String>> helpdata = [
    {
      "image": "assets/images/help_screens/1. Login Screen.png"
    },
    {
      "image": "assets/images/help_screens/2. Choose your Program.png"
    },
    {
      "image": "assets/images/help_screens/3. About App.png"
    },
    {
      "image": "assets/images/help_screens/4. Enquiry Form.png"
    },
    {
      "image": "assets/images/help_screens/5. Program Screen.png"
    },
    {
      "image": "assets/images/help_screens/6. Shopping List.png"
    },
    {
      "image": "assets/images/help_screens/7. Meal plan.png"
    },
    {
      "image": "assets/images/help_screens/8. Popup.png"
    },
    {
      "image": "assets/images/help_screens/9. Post Program Question Screen.png"
    },
    {
      "image": "assets/images/help_screens/10. Post Program Answer screen.png"
    },
    {
      "image": "assets/images/help_screens/11. Day 1 Summary.png"
    },
    {
      "image": "assets/images/help_screens/12. Feed screen.png"
    },
    {
      "image": "assets/images/help_screens/13. Testimonial Screen.png"
    },
    {
      "image": "assets/images/help_screens/14. Settings.png"
    },
    {
      "image": "assets/images/help_screens/15. My Profile.png"
    },
    {
      "image": "assets/images/help_screens/16. FAQ.png"
    },
    {
      "image": "assets/images/help_screens/17. Upload your Feedback.png"
    }
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    animatePageview();
  }

  animatePageview()
  {
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPage == helpdata.length -1) {
        end = true;
      } else if (_currentPage == 0) {
        end = false;
      }

      if (end == false) {
        _currentPage++;
      }

      if(_pageController.hasClients)
      {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 1000),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          child: Stack(
            children: <Widget>[
              PageView.builder(

                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: helpdata.length,
                itemBuilder: (context, index) =>
                    Image.asset(
                      helpdata[index]['image'].toString(),
                      fit: BoxFit.fill,
                    ),
              ),
              // Container(
              //   padding: EdgeInsets.all(8),
              //   child: PageView.builder(
              //
              //     controller: _pageController,
              //     onPageChanged: (value) {
              //       setState(() {
              //         _currentPage = value;
              //       });
              //     },
              //     itemCount: helpdata.length,
              //     itemBuilder: (context, index) => HelpContent(
              //       image: helpdata[index]["image"],
              //     ),
              //   ),
              // ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  //   Navigator.pushReplacement(
                  //     context, MaterialPageRoute(
                  //     builder: (ctx) => DashboardScreen())
                  // );
                    },
                  child: Container(
                      height: 10.w,
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
                      alignment: Alignment.centerRight,
                      child: Text('Skip',
                        style: TextStyle(
                            color: gsecondaryColor,
                            fontSize: PPConstants().topViewHeadingFontSize,
                            fontFamily: kFontMedium
                        ),
                      )
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                left: 5,
                right: 5,
                child: Container(
                  height: 15.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.w),
                    child: Column(
                      children: <Widget>[
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            helpdata.length,
                                (index) => buildDot(index: index),
                          ),
                        ),
                        Spacer(),
                        Visibility(
                          visible: (_currentPage == helpdata.length-1) ? true : false,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);

                              // Navigator.pushReplacement(
                              //     context, MaterialPageRoute(
                              //     builder: (ctx) => DashboardScreen())
                              // );
                            },
                            child: Container(
                              width: 60.w,
                              height: 5.h,
                              // padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: gPrimaryColor,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                Border.all(color: gMainColor, width: 1),
                              ),
                              child: Center(
                                child: Text('Done',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontFamily: kFontBold
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //       child: Scaffold(
  //         body: SizedBox(
  //           width: double.infinity,
  //           child: Column(
  //             children: [
  //               Expanded(
  //                 flex: 4,
  //                 child: PageView.builder(
  //                     onPageChanged: (value) {
  //                       setState(() {
  //                         currentPage = value;
  //                       });
  //                     },
  //                     itemCount: helpdata.length,
  //                     itemBuilder: (context, index) =>
  //                         HelpContent(
  //                           text: '1bc',
  //                             image: 'assets/images/Splash_bg.png'
  //                         )
  //                 ),
  //               ),
  //               // Expanded(
  //               //   flex: 2,
  //               //   child: Padding(
  //               //     padding: EdgeInsets.symmetric(
  //               //         horizontal: 10.w
  //               //     ),
  //               //     child: Column(
  //               //       children: [
  //               //         Row(
  //               //           mainAxisAlignment: MainAxisAlignment.center,
  //               //           children: List.generate(
  //               //             3,
  //               //                 (index) => buildDot(index: index),
  //               //           ),
  //               //         ),
  //               //         ElevatedButton(
  //               //           onPressed: (){
  //               //             Navigator.pushReplacement(
  //               //                 context, MaterialPageRoute(
  //               //                 builder: (ctx) => HomeScreen())
  //               //             );
  //               //           },
  //               //           child: Text('Done',
  //               //             style: TextStyle(
  //               //                 color: Colors.white,
  //               //                 fontSize: 20.sp,
  //               //                 fontFamily: Constants.w200
  //               //             ),
  //               //           ),
  //               //           style: ElevatedButton.styleFrom(
  //               //             elevation: 10,
  //               //             primary: MainTheme.button,
  //               //             minimumSize: Size(5.w, 6.h),
  //               //             padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
  //               //             shape: RoundedRectangleBorder(
  //               //                 borderRadius: BorderRadius.circular(30.sp)
  //               //             ),
  //               //
  //               //           ),
  //               //         ),
  //               //
  //               //         Spacer()
  //               //       ],
  //               //     ),
  //               //   ),
  //               // )
  //             ],
  //           ),
  //         ),
  //       )
  //   );
  // }

  AnimatedContainer buildDot({int? index}){
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 3.w),
      height: 6,
      width: _currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
          color: _currentPage == index ? gsecondaryColor : gTapColor,
          borderRadius: BorderRadius.circular(3)
      ),
    );
  }

}