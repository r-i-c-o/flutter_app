import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarot/helpers/shared_preferences_manager.dart';

class SharedPreferencesProvider with ChangeNotifier {
  SharedPreferences _prefs = SharedPreferencesManager.instance.prefs;

  TextSize get textSize =>
      TextSize(_prefs.getInt(SharedPreferencesManager.textSizeKey) ?? 0);

  Future<void> setTextSize(TextSize size) async {
    await _prefs.setInt(SharedPreferencesManager.textSizeKey, size.index);
    notifyListeners();
  }

  String? get usernameOrNull =>
      _prefs.getString(SharedPreferencesManager.userNameKey);

  Future<void> setUsername(String username) async {
    await _prefs.setString(SharedPreferencesManager.userNameKey, username);
    notifyListeners();
  }

  bool get enabledNotifications =>
      _prefs.getBool(SharedPreferencesManager.notificationsEnabledKey) ?? true;

  Future<void> setEnabledNotifications(bool enabled) async {
    await _prefs.setBool(
        SharedPreferencesManager.notificationsEnabledKey, enabled);
    notifyListeners();
  }

  List<String> get notifications =>
      _prefs.getStringList(SharedPreferencesManager.notificationsListKey) ?? [];

  Future<void> setNotifications(List<String> newTimes) async {
    await _prefs.setStringList(
        SharedPreferencesManager.notificationsListKey, newTimes);
    notifyListeners();
  }

  int get cod => _prefs.getInt(SharedPreferencesManager.cardOfDayIndex) ?? 0;
  Future<void> setCod(int newCard) async {
    await _prefs.setInt(SharedPreferencesManager.cardOfDayIndex, newCard);
    notifyListeners();
  }

  int get codDay =>
      _prefs.getInt(SharedPreferencesManager.cardOfDayUpdateDay) ?? 0;
  Future<void> setCodDay(int newDay) async {
    await _prefs.setInt(SharedPreferencesManager.cardOfDayUpdateDay, newDay);
    notifyListeners();
  }
}

class TextSize {
  final String size;
  final int index;
  static const List<String> _sizes = [
    "Small",
    "Medium",
    "Large",
  ];

  TextSize(this.index) : size = _sizes[index];

  TextSize.small() : this(0);
  TextSize.medium() : this(1);
  TextSize.large() : this(2);

  bool equals(TextSize other) {
    return other.index == index;
  }
}
