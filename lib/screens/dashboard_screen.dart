import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:gwc_customer/screens/profile_screens/settings_screen.dart';

import 'clap_screens/clap_screen.dart';
import 'feed_screens/feeds_list.dart';
import 'gut_list_screens/gut_list.dart';
import 'home_screens/home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _bottomNavIndex = 2;

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
          return const HomeScreens();
        }
      case 1:
        {
          return const FeedsList();
        }
      case 2:
        {
          return const GutList();
        }
      case 3:
        {
          return const ClapScreen();
        }
      case 4:
        {
          return const SettingsScreen();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageCaller(_bottomNavIndex),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: Colors.white,
        items: [
          TabItem(
            icon: _bottomNavIndex == 0
                ? Image.asset(
                    "assets/images/Group 3241.png",
                  )
                : Image.asset(
                    "assets/images/Group 3844.png",
                  ),
          ),
          TabItem(
            icon: _bottomNavIndex == 1
                ? Image.asset(
                    "assets/images/Group 3240.png",
                  )
                : Image.asset(
                    "assets/images/Group 3846.png",
                  ),
          ),
          TabItem(
              icon: _bottomNavIndex == 2
                  ? Image.asset(
                "assets/images/Group 3331.png",
              )
                  : Image.asset(
                "assets/images/Group 3848.png",
              ),
            ),
          TabItem(
              icon: _bottomNavIndex == 3
                  ? Image.asset(
                "assets/images/Path 14368.png",
              )
                  : Image.asset(
                "assets/images/Group 3847.png",
              ),),
          TabItem(
              icon: _bottomNavIndex == 4
                  ? Image.asset(
                "assets/images/Group 3239.png",
              )
                  : Image.asset(
                "assets/images/Group 3845.png",
              ),),
        ],
        initialActiveIndex: _bottomNavIndex,
        onTap: onChangedTab,
      ),
    );
  }

  void onChangedTab(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }
}
