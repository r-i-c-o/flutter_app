import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tarot/models/spread/spread.dart';
import 'package:tarot/planets/default_positions.dart';
import 'package:tarot/planets/planet_position.dart';
import 'package:tarot/planets/planet_screen.dart';
import 'package:tarot/theme/app_colors.dart';
import 'package:tarot/ui/tarot_reading/scrollable_cards.dart';
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

class _TarotScreenState extends State<TarotScreen>
    with SingleTickerProviderStateMixin {
  Future<ui.Image> getImage(String img) async {
    final data = await rootBundle.load(img);
    final bytes = data.buffer.asUint8List();
    return decodeImageFromList(bytes);
  }

  late ScrollableCardsState state;

  @override
  void initState() {
    super.initState();
    state = ScrollableCardsState(this);
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
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragUpdate: (details) {
                        //if (controller.canScroll) {
                        state.scrollValue -= details.primaryDelta ?? 0.0;
                        //}
                      },
                      onHorizontalDragEnd: (details) {
                        state.onScrollEnd(-details.velocity.pixelsPerSecond.dx);
                      },
                      child: TarotWidget(snapshot.data!, state),
                    );
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
  final ScrollableCardsState state;

  TarotWidget(this.deckCardImage, this.state);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _TarotRenderObject(deckCardImage, state);
  }
}

class _TarotRenderObject extends RenderBox {
  _TarotRenderObject(this._deckCardImage, ScrollableCardsState state) {
    this.state = state;
  }

  ScrollableCardsState get state => _state;
  late ScrollableCardsState _state;
  set state(ScrollableCardsState newState) {
    _state = newState;
    _state.needPaint = markNeedsPaint;
  }

  final ui.Image _deckCardImage;

  double wDeckCard = 0.0;
  double hDeckCard = 0.0;
  double minY = 0.0;
  double referencePosition = 0.0;

  @override
  void performLayout() {
    size = constraints.biggest;
    hDeckCard = size.height * 0.5;
    wDeckCard = hDeckCard / 1.4;
    minY = size.height * 0.6;
    referencePosition = (size.width - wDeckCard) * 0.5;
    _state.setSize(size, wDeckCard);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    //STATES
    //scroll state - draw deck and spread
    //drawn state - draw spread
    for (int i = 0; i < state.numberOfCards; i++) {
      canvas.save();
      canvas.translate(wDeckCard * 0.5, hDeckCard * 0.5);
      canvas.rotate(0.0005 *
          ((wDeckCard * 0.5 * i - state.scrollValue) - referencePosition));
      canvas.translate(-wDeckCard * 0.5, -hDeckCard * 0.5);
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(offset.dx + wDeckCard * 0.5 * i - state.scrollValue,
            offset.dy + minY, wDeckCard, hDeckCard),
        image: _deckCardImage,
        isAntiAlias: true,
      );
      canvas.restore();
    }
  }

  /*bool _isVisible(int i, Offset offset) {
    return offset.dx + wDeckCard * 0.5 * i;
  }*/
}
