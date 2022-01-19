import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarot/providers/shared_preferences_provider.dart';
import 'package:tarot/theme/app_colors.dart';
import 'package:tarot/widgets/inner_shadow.dart';
import 'package:tarot/widgets/settings_radio_tile.dart';

class SettingsTextSizeAnimated extends StatefulWidget {
  @override
  _SettingsTextSizeAnimatedState createState() =>
      _SettingsTextSizeAnimatedState();
}

class _SettingsTextSizeAnimatedState extends State<SettingsTextSizeAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final Tween<double> _sizeTween = Tween<double>(begin: 0.0, end: 1.0);
  final Tween<double> _plaqueTween = Tween<double>(begin: 1.0, end: 0.0);
  late Animation<double> _plaqueAnimation;
  late Animation<double> _sizeAnimation;

  void _expand() {
    _animationController.forward();
  }

  void _shrink() {
    _animationController.reverse();
  }

  void _onChangeSize(SharedPreferencesProvider provider, TextSize size) {
    _shrink();
    provider.setTextSize(size);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    final CurvedAnimation curve = CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn);
    _plaqueAnimation = _plaqueTween.animate(curve);
    _sizeAnimation = _sizeTween.animate(curve);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SharedPreferencesProvider provider =
        Provider.of<SharedPreferencesProvider>(context, listen: false);
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
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _expand(),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/settings_icons/text_size_icon.png',
                        height: 24.0,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Text Size',
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      FadeTransition(
                        opacity: _plaqueAnimation,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Consumer<SharedPreferencesProvider>(
                              builder: (_, prefs, __) {
                                return Text(
                                  prefs.textSize.size,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Image.asset(
                              'assets/images/settings_icons/radio_on.png',
                              width: 20.0,
                              height: 20.0,
                            ),
                            SizedBox(
                              width: 8.0,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizeTransition(
                sizeFactor: _sizeAnimation,
                axisAlignment: 1.0,
                child: FadeTransition(
                  opacity: _animationController,
                  child: Column(
                    children: [
                      SettingsRadioTile(
                        textSize: TextSize.small(),
                        onChanged: (size) => _onChangeSize(provider, size),
                      ),
                      SettingsRadioTile(
                        textSize: TextSize.medium(),
                        onChanged: (size) => _onChangeSize(provider, size),
                      ),
                      SettingsRadioTile(
                        textSize: TextSize.large(),
                        onChanged: (size) => _onChangeSize(provider, size),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
