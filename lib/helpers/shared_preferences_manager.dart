import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const String textSizeKey = 'text_size';
  static const String userNameKey = 'username';
  static const String notificationsEnabledKey = 'notifications';
  static const String notificationsListKey = 'notifications_list';
  static const String cardOfDayIndex = 'cod';
  static const String cardOfDayUpdateDay = 'cod_day';
  static const String previousSubscriptionState = 'previous_subscription';

  late SharedPreferences _prefs;

  SharedPreferences get prefs => _prefs;

  Future<SharedPreferencesManager> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  void removeKey(String key) => _prefs.remove(key);
}
