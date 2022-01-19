//import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
//import 'package:kado_analytics_module/observer.dart';
import 'package:provider/provider.dart';
import 'package:tarot/helpers/navigation_helper.dart';
import 'package:tarot/planets/planet_observer.dart';
import 'package:tarot/planets/planet_page_route.dart';
import 'package:tarot/planets/planet_screen.dart';
import 'package:tarot/providers/db_save_provider.dart';
import 'package:tarot/providers/planets_provider.dart';
import 'package:tarot/providers/shared_preferences_provider.dart';
import 'package:tarot/screens/main_screen.dart';
import 'package:tarot/screens/onboarding.dart';
import 'package:tarot/screens/splash.dart';
import 'package:tarot/screens/username_screen.dart';
import 'package:tarot/widgets/background.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SharedPreferencesProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => PlanetsProvider(size),
        ),
        ChangeNotifierProvider(
          create: (context) => DBSaveProvider(),
        ),
      ],
      child: Stack(
        children: [
          Background(),
          MainPopScope(),
        ],
      ),
    );
  }
}

class MainPopScope extends StatelessWidget {
  const MainPopScope({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => NavigationHelper.instance.onBackPressed(),
      child: MainNavigator(),
    );
  }
}

class MainNavigator extends StatelessWidget {
  const MainNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationHelper.instance.mainNavigatorKey,
      observers: [
        PlanetObserver(Provider.of<PlanetsProvider>(context, listen: false)),
        //FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        //KadoAnalyticsNavigationObserver(),
      ],
      initialRoute: '/',
      onGenerateRoute: (settings) {
        PlanetScreenMixin widget;
        switch (settings.name) {
          case Navigator.defaultRouteName:
            widget = Splash();
            break;
          case UsernameScreen.routeName:
            widget = UsernameScreen();
            break;
          case MainScreen.routeName:
            widget = MainScreen();
            break;
          case OnBoarding.routeName:
            widget = OnBoarding();
            break;
          default:
            widget = MainScreen();
        }
        return PlanetMaterialPageRoute(widget: widget);
      },
    );
  }
}