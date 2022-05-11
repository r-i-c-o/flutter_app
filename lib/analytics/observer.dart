import 'package:flutter/widgets.dart';
import 'events/widget_events.dart';

import 'firebase_instance.dart';

class KadoAnalyticsNavigationObserver
    extends RouteObserver<PageRoute<dynamic>> {
  void _logObviousNavigation(Route? newRoute, Route? previousRoute) {
    final String? previousRouteName = previousRoute?.settings.name;
    final String? newRouteName = newRoute?.settings.name;
    final String newName;
    final String previousName;
    previousRouteName == null
        ? previousName = ""
        : previousName = previousRouteName.replaceFirst('/', '');
    newRouteName == null
        ? newName = ""
        : newName = newRouteName.replaceFirst('/', '');

    final String eventName = UserAction.obviousNavigation
        .replaceFirst(
          EventPathParam.currentPage,
          previousName,
        )
        .replaceFirst(
          EventPathParam.destinationPage,
          newName,
        );
    FirebaseInstance.instance.logEvent(
      name: eventName,
      parameters: <String, String>{
        CommonParams.screenName: previousName,
      },
    );
  }

  void _logPop(Route currentRoute) {
    final String? routeName = currentRoute.settings.name;
    final String currentName;
    routeName == null
        ? currentName = "LogPop Error: routeName is null"
        : currentName = routeName.replaceFirst('/', '');
    FirebaseInstance.instance.logEvent(
      name: UserAction.navigateUp,
      parameters: <String, String>{
        'screen_name': currentName,
      },
    );
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _logObviousNavigation(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _logPop(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logObviousNavigation(newRoute, oldRoute);
  }
}
