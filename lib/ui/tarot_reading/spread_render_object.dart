import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tarot/helpers/card_faces_directory.dart';
import 'package:tarot/models/spread.dart';
import 'package:tarot/planets/default_positions.dart';
import 'package:tarot/planets/planet_position.dart';
import 'package:tarot/planets/planet_screen.dart';
import 'package:tarot/theme/app_colors.dart';
import 'package:tarot/ui/tarot_reading/tarot_reading_screen.dart';
import 'package:tarot/widgets/appbar.dart';

class TarotScreen extends StatefulWidget with PlanetScreenMixin {
  const TarotScreen({Key? key, required this.spread, this.question})
      : super(key: key);
  final Spread spread;
  final String? question;

  @override
  _TarotScreenState createState() => _TarotScreenState();

  @override
  PlanetOffset? get planetOne => reading_1;

  @override
  PlanetOffset? get planetTwo => reading_2;

  @override
  String? get screenRouteName => 'routeName';
}

class _TarotScreenState extends State<TarotScreen> {
  Future<ui.Image> getImage(String img) async {
    final data = await rootBundle.load(img);
    final bytes = data.buffer.asUint8List();
    return decodeImageFromList(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppTopBar(title: widget.spread.title),
          Expanded(
            child: FutureBuilder<ui.Image>(
                future:
                    getImage('assets/images/cards/scrollable_card_shirt.png'),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return TarotWidget(snapshot.data!);
                  else
                    return Container();
                }),
          )
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          double topPadding = MediaQuery.of(context).padding.top;
          await showModalBottomSheet(
            backgroundColor: Colors.black.withOpacity(0.8),
            context: context,
            isScrollControlled: true,
            useRootNavigator: true,
            builder: (context) => LegendPopup(
              spread: widget.spread,
              topPadding: topPadding,
            ),
          );
        },
        child: Container(
          width: 48.0,
          height: 48.0,
          decoration: BoxDecoration(
              color: AppColors.mainMenuListBackground,
              border: Border.all(
                color: AppColors.colorAccent,
                width: 2.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(24.0))),
          child: Center(
            child: Image.asset(
              'assets/images/fab/legend.png',
              width: 24.0,
              height: 24.0,
            ),
          ),
        ),
      ),
    );
  }
}

class TarotWidget extends LeafRenderObjectWidget {
  final ui.Image deckCardImage;

  const TarotWidget(this.deckCardImage);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _TarotRenderObject(deckCardImage);
  }
}

class _TarotRenderObject extends RenderBox {
  final ui.Image deckCardImage;

  double wDeckCard = 0.0;
  double hDeckCard = 0.0;

  _TarotRenderObject(this.deckCardImage);

  @override
  void performLayout() {
    size = constraints.biggest;
    hDeckCard = size.height * 0.5;
    wDeckCard = hDeckCard / 1.4;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(offset.dx, offset.dy, wDeckCard, hDeckCard),
      image: deckCardImage,
    );
  }
}
