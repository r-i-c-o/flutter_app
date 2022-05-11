import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tarot/app_module.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as gms;
import 'package:native_admob_flutter/native_admob_flutter.dart' as nativeads;
import 'package:tarot/repositories/navigation_helper.dart';
import 'package:tarot/repositories/notifications_manager.dart';
import 'package:tarot/repositories/remote_config.dart';
import 'package:tarot/repositories/settings_repository.dart';
import 'package:tarot/repositories/subscription_manager.dart';
import 'package:tarot/repositories/planets_provider.dart';
import 'package:tarot/repositories/saved_repository.dart';
import 'package:tarot/screens/app_container.dart';
import 'package:tarot/theme/app_colors.dart';
import 'package:tarot/ui/journal/journal_button_stream.dart';

import 'repositories/ad_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //AdManager.setTestMode();
  await gms.MobileAds.instance.initialize();
  await nativeads.MobileAds.initialize();

  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  getIt.registerSingletonAsync(() async => SettingsRepository().init());
  getIt.registerSingletonAsync(() async => NotificationManager().init());
  getIt.registerSingleton(NavigationHelper());
  getIt.registerSingletonAsync(() async => SubscriptionRepository().init());
  getIt.registerSingletonAsync(() async => SavedRepository().init());
  getIt.registerSingleton(PlanetsProvider());
  getIt.registerSingleton(JournalButtonStream());

  final RemoteConfig remoteConfig = RemoteConfig.instance;
  final defaults = <String, dynamic>{
    RemoteConfigManager.onboardingKey: 'scenario_1',
    RemoteConfigManager.priceKey: RemoteConfigManager.price3pm,
    RemoteConfigManager.popupKey: 'rewarded',
    RemoteConfigManager.subscriptionsKey: '1',
  };
  await remoteConfig.setDefaults(defaults);

  try {
    await remoteConfig.fetchAndActivate();
    RemoteConfigManager.scenario =
        remoteConfig.getString(RemoteConfigManager.onboardingKey);
    RemoteConfigManager.chatPrice =
        remoteConfig.getString(RemoteConfigManager.priceKey);
    RemoteConfigManager.popup =
        remoteConfig.getString(RemoteConfigManager.popupKey);
    RemoteConfigManager.offering =
        remoteConfig.getString(RemoteConfigManager.subscriptionsKey);
  } catch (e, s) {
    RemoteConfigManager.scenario = 'scenario_1';
    RemoteConfigManager.chatPrice = RemoteConfigManager.price3pm;
    RemoteConfigManager.popup = 'rewarded';
    RemoteConfigManager.offering = '1';
    await FirebaseCrashlytics.instance.recordError(e, s);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final theme = ThemeData(
    //brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.transparent,
    toggleableActiveColor: AppColors.colorAccent,
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.buttonColor,
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
        secondary: AppColors.colorAccent, brightness: Brightness.dark),
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
      home: FutureBuilder(
          future: getIt.allReady(),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return AppContainer();
            else
              return Container();
          }),
    );
  }
}
