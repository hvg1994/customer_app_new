/*
In main.dart we are storing DeviceId to local storage

AppConfig() will be Singleton class so than we can use this as local storage
*/

import 'package:country_code_picker/country_localizations.dart';
import 'package:device_preview/device_preview.dart' hide DeviceType;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer/model/enquiry_status_model.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/services/enquiry_status_service.dart';
import 'package:gwc_customer/splash_screen.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/open_alert_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

import 'repository/api_service.dart';
import 'repository/enquiry_status_repository.dart';
import 'utils/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig().preferences = await SharedPreferences.getInstance();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.black26),
  );
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
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

final EnquiryStatusRepository repository = EnquiryStatusRepository(
  apiClient: ApiClient(
    httpClient: http.Client(),
  ),
);


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getDeviceId() async{
    final _pref = AppConfig().preferences;
    await AppConfig().getDeviceId().then((id) {
      print("deviceId: $id");
      if(id != null){
        _pref!.setString(AppConfig().deviceId, id);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceId();
  }
  @override
  Widget build(BuildContext context) {
    return Sizer(builder:
        (BuildContext context, Orientation orientation, DeviceType deviceType) {
      return const GetMaterialApp(
          supportedLocales: [
            const Locale("en"), /// THIS IS FOR COUNTRY CODE PICKER
          ],
          localizationsDelegates: [
            CountryLocalizations.delegate, /// THIS IS FOR COUNTRY CODE PICKER
          ],
          debugShowCheckedModeBanner: false,
          home: const SplashScreen());
    });
  }
}
