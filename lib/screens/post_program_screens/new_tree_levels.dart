import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class NewTreeLevel extends StatefulWidget {
  const NewTreeLevel({Key? key}) : super(key: key);

  @override
  State<NewTreeLevel> createState() => _NewTreeLevelState();
}

class _NewTreeLevelState extends State<NewTreeLevel> {
  List<NewStageLevels> levels = [
    NewStageLevels(
        "assets/images/dashboard_stages/noun-appointment-3615898.png",
        "Enquiry Completed",
        'assets/images/dashboard_stages/green_done.png'),
    NewStageLevels(
        "assets/images/dashboard_stages/noun-appointment-3615898.png",
        "Evaluation Done",
        'assets/images/dashboard_stages/lock.png'),
    NewStageLevels(
        "assets/images/dashboard_stages/noun-appointment-4042317.png",
        "Consultation",
        'assets/images/dashboard_stages/lock.png'),
    NewStageLevels("assets/images/dashboard_stages/noun-shipping-5332930.png",
        "Tracker", 'assets/images/dashboard_stages/lock.png'),
    NewStageLevels(
        "assets/images/dashboard_stages/noun-appointment-4042317.png",
        "Programs",
        'assets/images/dashboard_stages/lock.png'),
    NewStageLevels(
        "assets/images/dashboard_stages/noun-information-book-1677218.png",
        "Post Program\nConsultation Booked",
        'assets/images/dashboard_stages/lock.png'),
    NewStageLevels(
        "assets/images/dashboard_stages/noun-shipping-5332930.png",
        "Maintenance Guide\nUpdated",
        'assets/images/dashboard_stages/lock.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(
                () {
                  Navigator.pop(context);
                },
                isBackEnable: false,
                showNotificationIcon: false,
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: showImage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showImage() {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        shrinkWrap: true,
        reverse: true,
        itemCount: levels.length,
        itemBuilder: (_, index) {
          if (index.isEven) {
            return Positioned(
              bottom: 300,
              child: Padding(
                padding: const EdgeInsets.only(right: 160.0),
                child: Image(
                  image: const AssetImage("assets/images/leftLeaf.png"),
                  height: 20.h,
                ),
              ),
            );
          } else {
            return Positioned(
              top: 300,
              child: Padding(
                padding: const EdgeInsets.only(left: 200.0),
                child: Image(
                  image: const AssetImage("assets/images/rightLeaf.png"),
                  height: 20.h,
                ),
              ),
            );
          }
        });
  }
}

class NewStageLevels {
  String image;
  String title;
  String stage;

  NewStageLevels(this.image, this.title, this.stage);
}
