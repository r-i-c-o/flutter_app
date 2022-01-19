import 'dart:async';

//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
//import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as gms;
import 'package:native_admob_flutter/native_admob_flutter.dart' as nativeads;
import 'package:tarot/helpers/navigation_helper.dart';
import 'package:tarot/helpers/notifications_manager.dart';
import 'package:tarot/helpers/remote_config.dart';
import 'package:tarot/helpers/shared_preferences_manager.dart';
import 'package:tarot/helpers/subscription_manager.dart';
import 'package:tarot/saved_db/saved_repository.dart';
import 'package:tarot/screens/app_container.dart';
import 'package:tarot/theme/app_colors.dart';

import 'helpers/ad_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AdManager.setTestMode();
  _initAdMob();
  nativeads.MobileAds.initialize();

  //await Firebase.initializeApp();
  //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await SharedPreferencesManager.instance.init();
  await NotificationManager.instance.init();
  NavigationHelper.instance;
  SavedRepository.instance;

  SubscriptionManager.instance.init();

  runApp(MyApp());
}

Future<void> _initAdMob() {
  return gms.MobileAds.instance.initialize();
}

class MyApp extends StatelessWidget {
  final theme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.transparent,
    accentColor: AppColors.colorAccent,
    toggleableActiveColor: AppColors.colorAccent,
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.buttonColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'Daily Tarot',
      //checkerboardOffscreenLayers: true,
      //checkerboardRasterCacheImages: true,
      theme: theme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(theme.textTheme),
      ),
      home: AppContainer(),
    );
  }
}
