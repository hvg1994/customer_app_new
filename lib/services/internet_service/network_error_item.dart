import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sizer/sizer.dart';


class NetworkErrorItem extends StatefulWidget {
  const NetworkErrorItem({Key? key}) : super(key: key);

  @override
  State<NetworkErrorItem> createState() => _NetworkErrorItemState();
}

class _NetworkErrorItemState extends State<NetworkErrorItem> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
          (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        print("Internet : $isDeviceConnected");
        if (!isDeviceConnected && isAlertSet == false) {
          Get.to(()=> const NetworkErrorItem());
          setState(() => isAlertSet = true);
        }
      },
    );
  }

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_statusbar_connected_no_internet_4_sharp,
              // color: newLightGreyColor,
              size: 10.h,
            ),
             SizedBox(height: 2.h),
             Text(
              'Internet connection lost!',
              // style: LoginScreen().textFieldHeadings(),
            ),
            SizedBox(height: 1.h),
             Text(
              'Check your connection and try again.',
              // style: LoginScreen().textFieldHeadings(),
            ),
            SizedBox(height: 2.h),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  Get.to(()=> const NetworkErrorItem());
                  setState(() => isAlertSet = true);
                }
              },
              child:  Text('Retry',
                // style: LoginScreen().buttonText(gSecondaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // showDialogBox() {
  //   return showCupertinoDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: const Text('No Connection'),
  //       content: const Text('Please check your internet connectivity'),
  //       actions: <Widget>[
  //         TextButton(
  //           onPressed: () async {
  //             Navigator.pop(context, 'Cancel');
  //             setState(() => isAlertSet = false);
  //             isDeviceConnected =
  //             await InternetConnectionChecker().hasConnection;
  //             if (!isDeviceConnected && isAlertSet == false) {
  //               showDialogBox();
  //               setState(() => isAlertSet = true);
  //             }
  //           },
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
