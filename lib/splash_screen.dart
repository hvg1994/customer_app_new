import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gwc_customer/screens/user_registration/existing_user.dart';
import 'package:gwc_customer/widgets/background_widget.dart';
import 'package:gwc_customer/widgets/will_pop_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 1;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            PageView(
              reverse: false,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              controller: _pageController,
              children: <Widget>[
                splashImage(),
                const ExistingUser(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  splashImage() {
    return const BackgroundWidget(
      assetName: 'assets/images/Group 2657.png',
      child: Center(
        child: Image(
          image: AssetImage("assets/images/Gut welness logo.png"),
        ),
        // SvgPicture.asset(
        //     "assets/images/splash_screen/Splash screen Logo.svg"),
      ),
    );
  }
}
