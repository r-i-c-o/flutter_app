//import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
//import 'package:kado_analytics_module/kado_analytics_module.dart';
import 'package:provider/provider.dart';
import 'package:tarot/helpers/navigation_helper.dart';
import 'package:tarot/planets/planet_observer.dart';
import 'package:tarot/planets/planet_page_route.dart';
import 'package:tarot/planets/planet_screen.dart';
import 'package:tarot/providers/planets_provider.dart';
import 'package:tarot/ui/card_of_day/card_of_day_screen.dart';
import 'package:tarot/screens/choose_spread_screen.dart';
import 'package:tarot/screens/settings_screen.dart';
import 'package:tarot/theme/app_colors.dart';
import 'package:tarot/ui/handbook/handbook_screen.dart';
import 'package:tarot/ui/journal/journal_list_screen.dart';
import 'package:tarot/widgets/ad_tab_scaffold.dart';

class BottomNavScreen extends StatefulWidget {
  final int initialPageIndex;

  BottomNavScreen({Key? key, required this.initialPageIndex}) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final List<PlanetScreenMixin> routes = [
    CardOfDayScreen(),
    ChooseSpreadScreen(),
    HandBookScreen(),
    JournalListScreen(),
    SettingsScreen(),
  ];

  List<PlanetObserver> _observers = [];
  NavigationHelper _navigationHelper = GetIt.I.get<NavigationHelper>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_observers.isEmpty)
      _observers = List.generate(
        routes.length,
        (index) => PlanetObserver(
          Provider.of<PlanetsProvider>(context, listen: false),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AdTabScaffold(
      tabBar: CupertinoTabBar(
        onTap: (i) {
          _navigationHelper.bottomNavigationClick(i);
          _observers[i].notifyProvider();
        },
        currentIndex: widget.initialPageIndex,
        activeColor: Colors.white,
        inactiveColor: Colors.white.withOpacity(0.4),
        backgroundColor: AppColors.bottomBarColor,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
                'assets/images/bottom_bar_icons/daily_inactive.png'),
            activeIcon: Image.asset(
              'assets/images/bottom_bar_icons/daily.png',
            ),
            label: 'DAILY',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bottom_bar_icons/reading_inactive.png',
            ),
            activeIcon: Image.asset(
              'assets/images/bottom_bar_icons/reading.png',
            ),
            label: 'CATEGORY',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bottom_bar_icons/handbook_inactive.png',
            ),
            activeIcon: Image.asset(
              'assets/images/bottom_bar_icons/handbook.png',
            ),
            label: 'HANDBOOK',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bottom_bar_icons/journal_inactive.png',
            ),
            activeIcon: Image.asset(
              'assets/images/bottom_bar_icons/journal.png',
            ),
            label: 'JOURNAL',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/bottom_bar_icons/settings_inactive.png',
            ),
            activeIcon: Image.asset(
              'assets/images/bottom_bar_icons/settings.png',
            ),
            label: 'SETTINGS',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        PlanetScreenMixin route = routes[index];
        return CupertinoTabView(
          navigatorKey: _navigationHelper.tabNavigatorByIndex(index),
          navigatorObservers: [
            _observers[index],
            //FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
            //KadoAnalyticsNavigationObserver(),
          ],
          onGenerateRoute: (settings) {
            if (settings.name == Navigator.defaultRouteName) {
              return PlanetMaterialPageRoute(widget: route);
            }
            return null;
          },
        );
      },
    );
  }
}
