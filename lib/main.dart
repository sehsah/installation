import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:installation/config/my_config.dart';
import 'package:installation/config/palette.dart';
import 'package:installation/controllers/home_controller.dart';
import 'package:installation/views/home.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage().read('Lang') == null ? GetStorage().write('Lang', 'en') : '';
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId(MyConfig.onesignalAppID);
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    event.complete(event.notification);
    print("event ${event}");
  });
  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    print("result ${result}");
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Palette.maincolor, // Change the status bar color here
      ),
    );
    Get.create(() => HomeController());
    return GetMaterialApp(
      // ignore: prefer_const_literals_to_create_immutables
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // ignore: prefer_const_literals_to_create_immutables
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ar', ''),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily:
              GetStorage().read('Lang') == 'en' ? 'OpenSans' : 'Almarai',
          appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Palette.maincolor,
              ),
              iconTheme: IconThemeData(color: Colors.white),
              color: Palette.maincolor,
              elevation: 0,
              foregroundColor: Colors.white),
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: GetStorage().read('Lang') == 'en'
                      ? 'OpenSans'
                      : 'Almarai'))),
      themeMode: ThemeMode.light,
      locale: Locale(GetStorage().read('Lang')),
      fallbackLocale: const Locale('en'),
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 100),
      home: const Home(),
    );
  }
}