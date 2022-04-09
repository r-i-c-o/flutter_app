/*
import 'package:flutter/material.dart';
import 'package:kado_analytics_module/ad_listeners.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:tarot/app_module.dart';
import 'package:tarot/repositories/ad_manager.dart';

class BannerWidget extends StatefulWidget {
  final bool huge;

  const BannerWidget({Key? key})
      : huge = false,
        super(key: key);
  const BannerWidget.huge({Key? key})
      : huge = true,
        super(key: key);
  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget>
    with SingleTickerProviderStateMixin {
  final _subscriptionsRepository = provideSubscriptionRepository();
  late final KadoBannerAdListener _controller;
  late final AnimationController _anim;
  late Widget _ad;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: Duration());
    _controller = KadoBannerAdListener(
        //TODO add name
        name: "banner",
        loaded: () {
          _anim.forward();
        });
    _controller.initController();
    _ad = widget.huge
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: BannerAd(
              size: BannerSize.MEDIUM_RECTANGLE,
              unitId: AdManager.bigBannerAdUnitId,
              controller: _controller.controller,
            ),
          )
        : BannerAd(
            size: BannerSize.BANNER,
            unitId: AdManager.bannerAdUnitId,
            controller: _controller.controller,
          );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _subscriptionsRepository.subscriptionStream,
      builder: (context, snapshot) {
        final ad = SizeTransition(
          sizeFactor: _anim,
          child: Container(
            child: _ad,
          ),
        );
        if (snapshot.data == true) {
          return SizedBox.shrink();
        }
        return ad;
      },
    );
  }
}
*/
