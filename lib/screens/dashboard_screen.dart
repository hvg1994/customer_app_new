import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:gwc_customer/screens/gut_list_screens/new_dashboard_levels_screen.dart';
import 'package:gwc_customer/screens/profile_screens/settings_screen.dart';
import 'package:gwc_customer/screens/testimonial_list_screen/testimonial_list_screen.dart';
import 'package:gwc_customer/widgets/exit_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:gwc_customer/screens/home_screens/level_status.dart';
import '../utils/app_config.dart';
import '../widgets/constants.dart';
import 'feed_screens/feeds_list.dart';
import 'gut_list_screens/new_dashboard_stages2.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ConvexAppBarState> _appBarKey =
  GlobalKey<ConvexAppBarState>();

  int _bottomNavIndex = 2;

  final int save_prev_index = 2;

  // void _onItemTapped(int index) {
  //   if (index != 3) {
  //     setState(() {
  //       _bottomNavIndex = index;
  //     });
  //   } else {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => const ProfileScreen()),
  //     );
  //   }
  //   if (index != 2) {
  //     setState(() {
  //       _bottomNavIndex = index;
  //     });
  //   } else {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => const QuriesScreen()),
  //     );
  //   }
  //   if (index != 1) {
  //     setState(() {
  //       _bottomNavIndex = index;
  //     });
  //   } else {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => const CustomerStatusScreen()),
  //     );
  //   }
  // }

  pageCaller(int index) {
    switch (index) {
      case 0:
        {
          // return GutListOld();
          // this one
          // return const BetterVideoPlayer();
          return const LevelStatus();

          // return DayMealTracerUI(proceedProgramDayModel: ProceedProgramDayModel(),);
        }
      case 1:
        {
          return const FeedsList();
        }
      case 2:
        {
          return GutList();
          // return const NewDashboardLevelsScreen();
        }
      case 3:
        {
          return const TestimonialListScreen();
        }
      case 4:
        {
          return const SettingsScreen();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: pageCaller(_bottomNavIndex),
        floatingActionButton: FloatingActionButton(
          onPressed: () {  },
          child: ImageIcon(
            AssetImage("assets/images/noun-chat-5153452.png")
          ),
        ),
        bottomNavigationBar: ConvexAppBar(
          key: _appBarKey,
          style: TabStyle.react,
          backgroundColor: Colors.white,
          items: [
            TabItem(
              icon: _bottomNavIndex == 0
                  ? Image.asset(
                "assets/images/Group 3241.png",
                color: gsecondaryColor,
              )
                  : Image.asset(
                "assets/images/Group 3844.png",
              ),
            ),
            TabItem(
              icon: _bottomNavIndex == 1
                  ? Image.asset(
                "assets/images/Group 3240.png",
                color: gsecondaryColor,
              )
                  : Image.asset(
                "assets/images/Group 3846.png",
              ),
            ),
            TabItem(
              icon: _bottomNavIndex == 2
                  ? Image.asset(
                "assets/images/Group 3331.png",
                color: gsecondaryColor,
              )
                  : Image.asset(
                "assets/images/Group 3848.png",
              ),
            ),
            TabItem(
              icon: _bottomNavIndex == 3
                  ? Image.asset(
                "assets/images/Path 14368.png",
                color: gsecondaryColor,
              )
                  : Image.asset(
                "assets/images/Group 3847.png",
              ),
            ),
            TabItem(
              icon: _bottomNavIndex == 4
                  ? Image.asset(
                "assets/images/Group 3239.png",
                color: gsecondaryColor,
              )
                  : Image.asset(
                "assets/images/Group 3845.png",
              ),
            ),
          ],
          initialActiveIndex: _bottomNavIndex,
          onTap: onChangedTab,
        ),
      ),
    );
  }

  void onChangedTab(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Future<bool> _onWillPop() {
    print('back pressed');
    print("_bottomNavIndex: $_bottomNavIndex");
    setState(() {
      if (_bottomNavIndex != 2) {
        if (_bottomNavIndex > save_prev_index ||
            _bottomNavIndex < save_prev_index) {
          _bottomNavIndex = save_prev_index;
          _appBarKey.currentState!.animateTo(_bottomNavIndex);
          setState(() {});
        } else {
          _bottomNavIndex = 2;
          _appBarKey.currentState!.animateTo(_bottomNavIndex);
          setState(() {});
        }
      } else {
        AppConfig()
            .showSheet(context, const ExitWidget(), bottomSheetHeight: 45.h);
      }
    });
    return Future.value(false);
  }
}
