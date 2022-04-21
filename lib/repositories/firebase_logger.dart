import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseLogger {
  FirebaseLogger._();
  static FirebaseAnalytics _analytics = FirebaseAnalytics();

  static const String _premiumPopupOpened = 'premium_popup_opened';
  static const String _rewardedWatched = 'premium_video_watched';
  static const String _spreadOpened = 'tarot_reading_opened';
  static const String _spreadDrawn = 'tarot_reading_drawn';
  static const String _subscribed = 'premium_subscribed';
  static const String _viewTarotCard = 'screen_view_tarot_card';
  static const String _clickStartConsultation = 'click_start_consultation';
  static const String _viewTarotExpert = 'screen_view_tarot_expert';
  static const String _viewOops = 'screen_view_oops_screen';
  static const String _clickFreePremium = 'click_on_continue_premium_for_free';
  static const String _grantFreePremium = 'activation_premium_for_free';
  static const String _screenView = 'screen_view_';
  static const String _clickOn = 'click_on_';
  static const String _activate = 'activate_';
  static const String _deactivate = 'deactivate_';
  static const String _codResult = 'cod_';

  static void logCodResult(String key, bool result) async {
    await _analytics.logEvent(
      name: _codResult,
      parameters: {
        key: result,
      },
    );
  }

  static void logScreenView(String screen, String? from) async {
    await _analytics.logEvent(
      name: _screenView + screen,
      parameters: <String, String>{
        'from': from ?? '',
      },
    );
  }

  static void logClick(String element) async {
    await _analytics.logEvent(name: _clickOn + element);
  }

  static void logSubscribe(int subscription) async {
    await _analytics.logEvent(name: "_subscribe_$subscription");
  }

  static void logUnsubscribe(int subscription) async {
    await _analytics.logEvent(name: "_unsubscribe_$subscription");
  }

  static void logActivate(String active) async {
    await _analytics.logEvent(name: _activate + active);
  }

  static void logDeactivate(String deactivated) async {
    await _analytics.logEvent(name: _deactivate + deactivated);
  }

  static void logPremiumPopupOpened() async {
    await _analytics.logEvent(name: _premiumPopupOpened);
  }

  static void logRewardedWatched(String tarotSpreadName) async {
    await _analytics.logEvent(
      name: _rewardedWatched,
      parameters: <String, String>{
        'spread': tarotSpreadName,
      },
    );
  }

  static void logSpreadOpened(String tarotSpreadName) async {
    await _analytics.logEvent(name: _spreadOpened, parameters: <String, String>{
      'spread': tarotSpreadName,
    });
  }

  static void logSpreadDrawn(String tarotSpreadName) async {
    await _analytics.logEvent(name: _spreadDrawn, parameters: <String, String>{
      'spread': tarotSpreadName,
    });
  }

  static void logSubscribed(
      String tarotCategory, String tarotSpreadName) async {
    await _analytics.logEvent(name: _subscribed, parameters: <String, String>{
      'category': tarotCategory,
      'spread': tarotSpreadName,
    });
  }

  static void logViewTarotCard() async {
    await _analytics.logEvent(name: _viewTarotCard);
  }

  static void logClickStartConsultation(String screenName) async {
    await _analytics.logEvent(
      name: _clickStartConsultation,
      parameters: {
        'fromScreen': screenName,
      },
    );
  }

  static void logViewTarotExpert() async {
    await _analytics.logEvent(name: _viewTarotExpert);
  }

  static void logViewOops() async {
    await _analytics.logEvent(name: _viewOops);
  }

  static void logClickFreePremium() async {
    await _analytics.logEvent(name: _clickFreePremium);
  }

  static void logGrantFreePremium() async {
    await _analytics.logEvent(name: _grantFreePremium);
  }
}
