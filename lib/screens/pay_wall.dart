import 'dart:async';
import 'dart:io';

import 'package:apphud/apphud.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tarot/helpers/ad_manager.dart';
//import 'package:tarot/helpers/firebase_logger.dart';
import 'package:tarot/helpers/navigation_helper.dart';
import 'package:tarot/helpers/subscription_manager.dart';
import 'package:tarot/models/spread_info.dart';
import 'package:tarot/planets/default_positions.dart';
import 'package:tarot/planets/planet_page_route.dart';
import 'package:tarot/planets/planet_position.dart';
import 'package:tarot/planets/planet_screen.dart';
import 'package:tarot/screens/spread_info.dart';
import 'package:tarot/widgets/subscription_radios.dart';

import 'base_ad_screen.dart';

class PayWall extends StatefulWidget with PlanetScreenMixin {
  static const String routeName = '/paywall';
  final Function? onClose;
  final Function? onSuccessPurchase;
  final SpreadInfo? spreadInfo;
  final String fromScreen;

  const PayWall(
      {Key? key,
      this.onClose,
      this.spreadInfo,
      required this.fromScreen,
      this.onSuccessPurchase})
      : super(key: key);
  @override
  _PayWallState createState() =>
      _PayWallState(AdManager.singleCategoryGridInterstitialAdUnitId);

  @override
  PlanetOffset? get planetOne => paywall_1;

  @override
  PlanetOffset? get planetTwo => paywall_2;

  @override
  String? get screenRouteName => routeName;
}

class _PayWallState extends BaseAdScreenState<PayWall> {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  late StreamSubscription _streamSubscription;

  int _subscriptionIndex = 0;

  List<ProductWrapper> _productsList = [];

  List<PurchaseDetails> _purchases = [];

  _PayWallState(String interstitialAdUnitId) : super(interstitialAdUnitId);

  @override
  void initState() {
    super.initState();
    _initialize();
    _productsList = SubscriptionManager.instance.currentProducts;
    //FirebaseLogger.logScreenView("paywall", widget.fromScreen);
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  void _initialize() async {
    if (await _iap.isAvailable()) {
      _getPurchases();
    }
    _streamSubscription = _iap.purchaseUpdatedStream.listen((event) {
      _purchases.addAll(event);
      _verify();
    });
  }

  void _getPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      final pending = Platform.isIOS
          ? purchase.pendingCompletePurchase
          : !purchase.billingClientPurchase!.isAcknowledged;

      if (pending) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }
    _purchases = response.pastPurchases;
  }

  void _verify() async {
    bool subscribed = false;
    for (PurchaseDetails purchase in _purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        subscribed = true;
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
          await Purchases.syncPurchases();
          await Apphud.syncPurchases();
        }
      }
    }
    if (subscribed) {
      _onSuccessPurchase();
    }
  }

  void _navigateToSpread(SpreadInfo info) {
    //FirebaseLogger.logSubscribed(info.category, info.spread.title);
    Navigator.of(context).pushAndRemoveUntil(
      PlanetMaterialPageRoute(
        widget: SpreadInfoScreen(
          spread: info.spread,
        ),
      ),
      (Route<dynamic> route) => false,
    );
  }

  void _buy() async {
    //FirebaseLogger.logClick("paywall_buy");
    final PurchaseParam param = PurchaseParam(
        productDetails: _productsList[_subscriptionIndex].productDetails);
    _iap.buyNonConsumable(purchaseParam: param);
  }

  void _setSubscription(int newIndex) {
    setState(() {
      _subscriptionIndex = newIndex;
    });
    //FirebaseLogger.logClick("paywall_subscription_$newIndex");
  }

  void _onClose() {
    NavigationHelper.instance.onBackPressed();
  }

  void _onSuccessPurchase() {
    SubscriptionManager.instance.changeSubscriptionStatus(true);
    if (widget.onSuccessPurchase != null) {
      Navigator.of(context).pop();
      widget.onSuccessPurchase!();
    } else
      widget.spreadInfo != null
          ? _navigateToSpread(widget.spreadInfo!)
          : widget.onClose ?? _onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Row(
            children: [
              SizedBox(
                width: 8,
              ),
              TextButton(
                onPressed: _verify,
                child: Text(
                  'Restore purchases',
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => createOnAdClosed(widget.onClose ?? _onClose),
              ),
            ],
          ),
          Container(
            color: Colors.orange,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "PREMIUM",
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 50.0,
                      spreadRadius: -10.0,
                    )
                  ],
                ),
                child: Image.asset('assets/images/paywall_pic.png'),
              ),
            ),
          ),
          SubscriptionRadios(
            onBuy: _buy,
            products: _productsList,
            onChanged: _setSubscription,
            subscriptionIndex: _subscriptionIndex,
          ),
        ],
      ),
    );
  }
}
