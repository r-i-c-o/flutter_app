import 'dart:async';
import 'dart:io';

import 'package:apphud/apphud.dart';
import 'package:flutter/material.dart';
//import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../repositories/subscription_manager.dart';
import 'base_ad_screen.dart';

class BaseSubscribeState<T extends StatefulWidget>
    extends BaseAdScreenState<T> {
  //InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  //InAppPurchase _iap = InAppPurchase.instance;
  //late StreamSubscription _purchaseUpdateSubscription;

  int subscriptionIndex = 0;

  //List<ProductWrapper> productsList = [];
  List<SubscriptInfo> productsList = [];

  //List<PurchaseDetails> purchases = [];

  BaseSubscribeState(String? interstitialAdUnitId)
      : super(interstitialAdUnitId);

  @override
  void initState() {
    super.initState();
    //_initialize();
    //productsList = subscriptionRepository.currentProducts;
    productsList = subscriptionRepository.currentSubscriptInfo;
  }

  @override
  void dispose() {
    super.dispose();
    //_purchaseUpdateSubscription.cancel();
  }

  /*void _initialize() async {
    if (await _iap.isAvailable()) {
      _getPurchases();
    }
    _purchaseUpdateSubscription = _iap.purchaseStream.listen((event) {
      purchases.addAll(event);
      verify();
    });
  }*/

  /*void _getPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      final pending = Platform.isIOS
          ? purchase.pendingCompletePurchase
          : !purchase.billingClientPurchase!.isAcknowledged;

      if (pending) {
        _iap.completePurchase(purchase);
      }
    }
    purchases = response.pastPurchases;
  }*/

  void verify() async {
    final subscribed = await Apphud.hasActiveSubscription();
    if (subscribed) {
      subscriptionRepository.changeSubscriptionStatus(true);
      await Purchases.syncPurchases();
      onSuccessPurchase();
    }
  }

  /*void verify() async {
    bool subscribed = false;
    for (PurchaseDetails purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        subscribed = true;
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
          await Purchases.syncPurchases();
          await Apphud.syncPurchases();
        }
      }
    }
    final subscribed = await Apphud.hasActiveSubscription();
    if (subscribed) {
      subscriptionRepository.changeSubscriptionStatus(true);
      onSuccessPurchase();
    }
  }*/

  void buy() async {
    /*final PurchaseParam param = PurchaseParam(
        productDetails: productsList[subscriptionIndex].productDetails);
    _iap.buyNonConsumable(purchaseParam: param);*/
    await Apphud.purchase(productId: productsList[subscriptionIndex].productId);
    verify();
  }

  void setSubscription(int newIndex) {
    setState(() {
      subscriptionIndex = newIndex;
    });
  }

  void onClose() {}

  void onSuccessPurchase() {}

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
