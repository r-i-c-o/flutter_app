import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tarot/helpers/shared_preferences_manager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  static NotificationManager? _instance;
  static NotificationManager get instance {
    _instance ??= NotificationManager._();
    return _instance!;
  }

  late Duration _offset;

  NotificationManager._();

  final NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'TarotChannelId',
      'Tarot',
      'Small notifications to remind you about your destiny',
    ),
  );

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    _offset = DateTime.now().timeZoneOffset;

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        //todo add ios settings later
      },
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    bool isInitialized = await _flutterLocalNotificationsPlugin
            .initialize(initializationSettings) ??
        false;
    if (isInitialized &&
        SharedPreferencesManager.instance.prefs
                .getStringList(SharedPreferencesManager.notificationsListKey) ==
            null) {
      var initialTimes = ["09:00", "19:00"];
      SharedPreferencesManager.instance.prefs.setStringList(
        SharedPreferencesManager.notificationsListKey,
        initialTimes,
      );
      enableNotifications(initialTimes);
    }
  }

  Future<void> cancelNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> enableNotifications(List<String> times) async {
    await cancelNotifications();
    for (int i = 0; i < times.length; i++) {
      await _setDailyNotification(i, _getNextDateFromString(times[i]));
    }
  }

  Future<void> _setDailyNotification(
    int id,
    tz.TZDateTime scheduledDate,
  ) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "Daily Tarot",
        "Cards are going to say something. Get your today's readings now",
        scheduledDate.subtract(_offset),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _getNextDateFromString(String time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final int hour = int.parse(time.split(":")[0]);
    final int minute = int.parse(time.split(":")[1]);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
