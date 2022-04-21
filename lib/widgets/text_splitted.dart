import 'package:flutter/material.dart';
import 'package:tarot/models/tarot_card/tarot_card.dart';
import 'package:tarot/widgets/auto_size_text.dart';
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
        AutoSizeText(
          text: widget.interpretation.first,
        ),
        BannerWidget.huge(),
        AutoSizeText(
          text: widget.interpretation.second,
        ),
      ],
    );
  }
}
