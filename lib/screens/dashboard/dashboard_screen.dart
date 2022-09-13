import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import '../feeds_sceens/feeds_list.dart';
import 'clap.dart';
import 'list.dart';
import 'track.dart';

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
          return const Track();
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
          return const Clap();
        }
      case 4:
        {
          return const Track();
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
            icon: Image.asset(
              "assets/images/Group 3844.png",
              color: _bottomNavIndex == 0 ? Colors.green : Colors.grey,
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
              icon: Image.asset(
            "assets/images/Group 3848.png",
            color: _bottomNavIndex == 2 ? Colors.green : Colors.grey,
          )),
          TabItem(
              icon: Image.asset(
            "assets/images/Group 3847.png",
            color: _bottomNavIndex == 3 ? Colors.green : Colors.grey,
          )),
          TabItem(
              icon: Image.asset(
            "assets/images/Group 3845.png",
            color: _bottomNavIndex == 4 ? Colors.green : Colors.grey,
          )),
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
