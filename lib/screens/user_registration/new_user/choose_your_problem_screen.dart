import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'about_the_program.dart';
import 'choose_problems_data.dart';

class ChooseYourProblemScreen extends StatefulWidget {
  const ChooseYourProblemScreen({Key? key}) : super(key: key);

  @override
  State<ChooseYourProblemScreen> createState() =>
      _ChooseYourProblemScreenState();
}

class _ChooseYourProblemScreenState extends State<ChooseYourProblemScreen> {
  HashSet selectItems = HashSet();
  bool isMultiSelectionEnabled = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h, bottom: 1.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Choose Your Problem",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "GothamRoundedBold_21016",
                    color: gPrimaryColor,
                    fontSize: 11.sp),
              ),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                child: buildChooseProblem(),
              ),
              isMultiSelectionEnabled
                  ? Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 25.w),
                        decoration: BoxDecoration(
                          color: gMainColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: gMainColor, width: 1),
                        ),
                        child: Text(
                          'NEXT',
                          style: TextStyle(
                            fontFamily: "GothamRoundedBold_21016",
                            color: gPrimaryColor,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AboutTheProgram(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 15.w),
                          decoration: BoxDecoration(
                            color: gPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: gMainColor, width: 1),
                          ),
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontFamily: "GothamRoundedBold_21016",
                              color: gWhiteColor,
                              fontSize: 11.sp,
                            ),
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

  buildChooseProblem() {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 13,
          mainAxisExtent: 15.h,
        ),
        itemCount: chooseProblemsData.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              doMultiSelection(chooseProblemsData[index]["title"]);
            },
            onLongPress: () {
              isMultiSelectionEnabled = true;
              doMultiSelection(chooseProblemsData[index]["title"]);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: gWhiteColor,
                image: const DecorationImage(
                    image: AssetImage("assets/images/Group 4855.png"),
                    fit: BoxFit.cover),
                border: Border.all(color: gMainColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(2, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 2.h),
                        Image(
                          height: 8.h,
                          image: AssetImage(chooseProblemsData[index]["image"]),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          chooseProblemsData[index]["title"],
                          style: TextStyle(
                            fontFamily: "GothamMedium",
                            color: gTextColor,
                            fontSize: 9.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Visibility(
                      visible: selectItems
                          .contains(chooseProblemsData[index]["title"]),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Icon(
                          Icons.check,
                          color: gsecondaryColor,
                          size: 10.h,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void doMultiSelection(String path) {
    if (isMultiSelectionEnabled) {
      setState(() {
        if (selectItems.contains(path)) {
          selectItems.remove(path);
        } else {
          selectItems.add(path);
        }
      });
    } else {
      //
    }
  }
}
