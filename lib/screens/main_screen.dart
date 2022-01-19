import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:tarot/helpers/firebase_logger.dart';
import 'package:tarot/helpers/navigation_helper.dart';
import 'package:tarot/planets/default_positions.dart';
import 'package:tarot/planets/planet_position.dart';
import 'package:tarot/planets/planet_screen.dart';
import 'package:tarot/providers/shared_preferences_provider.dart';
import 'package:tarot/screens/bottom_nav_screen.dart';
import 'package:tarot/widgets/main_menu_list_tile.dart';
import 'package:tarot/widgets/recommended_section.dart';

class MainScreen extends StatelessWidget with PlanetScreenMixin {
  static const String routeName = '/main_screen';

  @override
  PlanetOffset? get planetOne => main_1;

  @override
  PlanetOffset? get planetTwo => main_2;

  @override
  String? get screenRouteName => routeName;

  void _navigateTo(int page, BuildContext context) async {
    //FirebaseLogger.logScreenView("main $page", null);
    NavigationHelper.instance.currentIndex = page;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BottomNavScreen(initialPageIndex: page),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Consumer<SharedPreferencesProvider>(
              builder: (_, prefs, __) => RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Hi, ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 32.0,
                  ),
                  children: [
                    TextSpan(
                      text: '${prefs.usernameOrNull ?? ''}!',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'Your daily card is waiting for you',
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 24.0),
            MainMenuListTile(
              title: 'Daily Reading',
              assetImg: 'assets/images/bottom_bar_icons/daily.png',
              onTap: () {
                _navigateTo(0, context);
              },
            ),
            MainMenuListTile(
              title: 'Category',
              assetImg: 'assets/images/bottom_bar_icons/reading.png',
              onTap: () {
                _navigateTo(1, context);
              },
            ),
            MainMenuListTile(
              title: 'Tarot Handbook',
              assetImg: 'assets/images/bottom_bar_icons/handbook.png',
              onTap: () {
                _navigateTo(2, context);
              },
            ),
            MainMenuListTile(
              title: 'My journal',
              assetImg: 'assets/images/bottom_bar_icons/journal.png',
              onTap: () {
                _navigateTo(3, context);
              },
            ),
            MainMenuListTile(
              title: 'Settings',
              assetImg: 'assets/images/bottom_bar_icons/settings.png',
              onTap: () {
                _navigateTo(4, context);
              },
            ),
            SizedBox(height: 24.0),
            RecommendedSection(),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
