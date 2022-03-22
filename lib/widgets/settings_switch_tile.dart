import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
//import 'package:kado_analytics_module/buttons.dart';
//import 'package:kado_analytics_module/events/widget_events.dart';
import 'package:provider/provider.dart';
import 'package:tarot/helpers/notifications_manager.dart';
import 'package:tarot/providers/shared_preferences_provider.dart';
import 'package:tarot/theme/app_colors.dart';
import 'package:tarot/widgets/inner_shadow.dart';

class SettingsSwitchTile extends StatefulWidget {
  const SettingsSwitchTile({Key? key}) : super(key: key);

  @override
  _SettingsSwitchTileState createState() => _SettingsSwitchTileState();
}

class _SettingsSwitchTileState extends State<SettingsSwitchTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  bool expanded = false;
  late SharedPreferencesProvider provider;
  late List<String> _times;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    final CurvedAnimation curve =
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    final Tween<double> _sizeTween = Tween<double>(begin: 0.0, end: 1.0);
    _sizeAnimation = _sizeTween.animate(curve);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<SharedPreferencesProvider>(context, listen: false);
    setState(() {
      expanded = provider.enabledNotifications;
    });
    _controller.value = expanded ? 1.0 : 0.0;
    _times = provider.notifications;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _expand() {
    if (expanded)
      _controller.forward();
    else
      _controller.reverse();
  }

  void _setEnabled(bool value) async {
    await provider.setEnabledNotifications(value);
    if (value)
      await GetIt.I
          .get<NotificationManager>()
          .enableNotifications(provider.notifications);
    else
      await GetIt.I.get<NotificationManager>().cancelNotifications();
    setState(() {
      expanded = value;
    });
    _expand();
  }

  void _editNotification(int index, TimeOfDay editedTime) async {
    var newTime =
        await showTimePicker(context: context, initialTime: editedTime);
    if (newTime == null) return;
    String newTimeString =
        "${_formatTime(newTime.hour)}:${_formatTime(newTime.minute)}";
    if (_times.contains(newTimeString)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Notification already exists')));
      return;
    }
    _times[index] = newTimeString;
    _setNewNotifications();
  }

  void _deleteNotification(int index) {
    _times.removeAt(index);
    _setNewNotifications();
  }

  void _addNewNotification() async {
    if (_times.length == 3) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('3 notifications is plenty')));
      return;
    }
    var time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    String newTimeString =
        "${_formatTime(time.hour)}:${_formatTime(time.minute)}";
    if (_times.contains(newTimeString)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Notification already exists')));
      return;
    }
    _times.add("${_formatTime(time.hour)}:${_formatTime(time.minute)}");
    _setNewNotifications();
  }

  void _setNewNotifications() async {
    _times.sort((a, b) => a.compareTo(b));
    await provider.setNotifications(_times);
    await GetIt.I
        .get<NotificationManager>()
        .enableNotifications(provider.notifications);
  }

  String _formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }

  List<Widget> generateTimes() {
    List<String> times = provider.notifications;
    return List.generate(
      times.length,
      (index) => NotificationTimeItem(
        time: times[index],
        onTimeTap: () {
          var hourMinutes = times[index].split(":");
          int hour = int.parse(hourMinutes[0]);
          int minutes = int.parse(hourMinutes[1]);
          _editNotification(index, TimeOfDay(hour: hour, minute: minutes));
        },
        onDeleteTap: () {
          _deleteNotification(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 24.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.settingsTileBackground,
          borderRadius: BorderRadius.circular(8.0),
        ),
        clipBehavior: Clip.hardEdge,
        child: InnerShadow(
          shadowSize: 24.0,
          shadowColor: AppColors.settingsTileInnerShadow,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    _setEnabled(!expanded);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/settings_icons/settings_notifications_icon.png',
                        width: 24.0,
                        height: 24.0,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          child: Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      Consumer<SharedPreferencesProvider>(
                        builder: (_, prefs, __) => Switch(
                            value: prefs.enabledNotifications,
                            onChanged: (value) {
                              _setEnabled(value);
                            }),
                      ),
                    ],
                  ),
                ),
                SizeTransition(
                  sizeFactor: _sizeAnimation,
                  axisAlignment: 1.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<SharedPreferencesProvider>(
                        builder: (context, value, child) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: generateTimes(),
                          );
                        },
                      ),
                      //wrap in consumer
                      //...generateTimes(),
                      TextButton.icon(
                        onPressed: () {
                          _addNewNotification();
                        },
                        label: Text('Add time'),
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationTimeItem extends StatelessWidget {
  final String? time;
  final VoidCallback? onTimeTap;
  final VoidCallback? onDeleteTap;

  const NotificationTimeItem(
      {Key? key, this.time, this.onTimeTap, this.onDeleteTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 16),
        GestureDetector(
          onTap: onTimeTap,
          child: Row(
            children: [
              Text(
                time ?? "",
                style: const TextStyle(decoration: TextDecoration.underline),
              ),
              SizedBox(width: 12),
              Text(
                'tap to edit',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6), fontSize: 12.0),
              ),
            ],
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: onDeleteTap,
          child: Icon(
            Icons.close,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
