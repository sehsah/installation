import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:installation/config/my_config.dart';
import 'package:installation/config/palette.dart';
import 'package:installation/controllers/auth_controller.dart';
import 'package:installation/views/home.dart';
import 'package:installation/views/login.dart';
import 'package:installation/views/notification.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  Get.create(() => GetMaterialApp());
  // Get.create(() => HomeController());
  Get.create(() => AuthController());
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
  OneSignal.shared.setNotificationOpenedHandler((result) {
    var notify = result.notification.additionalData;
    print("notify2222 ${notify}");
    Get.off(NotificationPage());
  });
  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    String? onesignalUserId = changes.to.userId;
    print("onesignalUserId ${onesignalUserId}");
    String? logged = GetStorage().read('login_token') ?? "no";
    print(logged);
    onesignalUserId != null
        ? GetStorage().write('notification_token', onesignalUserId)
        : '';
  });
  OneSignal.shared.setNotificationOpenedHandler((openedResult) {
    print("notify3333 ${openedResult}");
    Get.to(NotificationPage());
  });
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Palette.maincolor, // Change the status bar color here
      ),
    );

    return GetMaterialApp(
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
            appBarTheme: AppBarTheme(
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
        navigatorKey: navigatorKey,
        defaultTransition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 100),
        home: GetStorage().read('login_token') == null ? Login() : Home());
  }
}
