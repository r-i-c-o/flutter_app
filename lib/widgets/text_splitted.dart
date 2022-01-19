import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarot/models/tarot_card.dart';
import 'package:tarot/providers/shared_preferences_provider.dart';
import 'package:tarot/theme/app_colors.dart';
import 'package:tarot/widgets/banner_widget.dart';

class TextSplitted extends StatefulWidget {
  final TwoStringsSplitByNewline interpretation;

  const TextSplitted({Key? key, required this.interpretation})
      : super(key: key);

  @override
  _TextSplittedState createState() => _TextSplittedState();
}

class _TextSplittedState extends State<TextSplitted> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<SharedPreferencesProvider>(
          builder: (_, value, __) => Text(
            widget.interpretation.first,
            style: TextStyle(
              color: AppColors.semiTransparentWhiteText,
              fontSize: 14.0 + 5.0 * value.textSize.index,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        BannerWidget.huge(),
        Consumer<SharedPreferencesProvider>(
          builder: (_, value, __) => Text(
            widget.interpretation.second,
            style: TextStyle(
              color: AppColors.semiTransparentWhiteText,
              fontSize: 14.0 + 5.0 * value.textSize.index,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
