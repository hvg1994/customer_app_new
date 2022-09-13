import 'package:country_code_picker/country_localizations.dart';
import 'package:device_preview/device_preview.dart' hide DeviceType;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer/splash_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

// void main() {
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
//   );
//   runApp(
//     DevicePreview(
//       enabled: !kReleaseMode,
//       builder: (context) => const MyApp(), // Wrap your app
//     ),
//   );
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return const GetMaterialApp(
          supportedLocales: [
            Locale("en"), /// THIS IS FOR COUNTRY CODE PICKER
          ],
          localizationsDelegates: [
            CountryLocalizations.delegate, /// THIS IS FOR COUNTRY CODE PICKER
          ],
          debugShowCheckedModeBanner: false, home: SplashScreen());
    });
  }
}
