import 'package:flutter/material.dart';
import 'package:tarot/screens/choose_spread_screen.dart';
import 'package:tarot/screens/settings_screen.dart';
import 'package:tarot/ui/card_of_day/card_of_day_screen.dart';
import 'package:tarot/ui/handbook/handbook_screen.dart';
import 'package:tarot/ui/journal/journal_list_screen.dart';

class NavigationHelper {
  static NavigationHelper? _instance;
  NavigationHelper._();
  static NavigationHelper get instance {
    _instance ??= NavigationHelper._();
    return _instance!;
  }

  static List<String> _bottomNavigationMainRoutes = [
    CardOfDayScreen.routeName,
    ChooseSpreadScreen.routeName,
    HandBookScreen.routeName,
    JournalListScreen.routeName,
    SettingsScreen.routeName,
  ];

  final GlobalKey<NavigatorState> _mainNavigatorKey =
      GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get mainNavigatorKey => _mainNavigatorKey;

  int currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _tabNavigationKeys =
      List<GlobalKey<NavigatorState>>.generate(
          _bottomNavigationMainRoutes.length,
          (index) => GlobalKey<NavigatorState>());
  GlobalKey<NavigatorState> get currentTabNavigator =>
      _tabNavigationKeys[currentIndex];

  GlobalKey<NavigatorState> tabNavigatorByIndex(int index) =>
      _tabNavigationKeys[index];

  void bottomNavigationClick(int i) {
    if (i == NavigationHelper.instance.currentIndex)
      NavigationHelper.instance.onBottomBarDoubleClick();
    NavigationHelper.instance.currentIndex = i;
  }

  void onBottomBarDoubleClick() {
    currentTabNavigator.currentState?.popUntil(
        (route) => _bottomNavigationMainRoutes.contains(route.settings.name));
  }

  Future<bool> onBackPressed() {
    if (currentTabNavigator.currentState != null &&
        currentTabNavigator.currentState!.canPop()) {
      currentTabNavigator.currentState!.pop();
      return Future.value(false);
    }
    if (_mainNavigatorKey.currentState!.canPop()) {
      _mainNavigatorKey.currentState!.pop();
      return Future.value(false);
    }
    return Future.value(true);
  }
}
