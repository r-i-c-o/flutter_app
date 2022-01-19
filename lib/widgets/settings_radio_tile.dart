import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarot/providers/shared_preferences_provider.dart';

class SettingsRadioTile extends StatelessWidget {
  const SettingsRadioTile({
    required this.onChanged,
    required this.textSize,
  });
  final TextSize textSize;
  final void Function(TextSize size) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(textSize),
      child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<SharedPreferencesProvider>(
                builder: (_, prefs, __) {
                  return Image.asset(
                    prefs.textSize.equals(textSize)
                        ? 'assets/images/settings_icons/radio_on.png'
                        : 'assets/images/settings_icons/radio_off.png',
                    width: 20.0,
                    height: 20.0,
                  );
                },
              ),
            ),
            Text(
              textSize.size,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
