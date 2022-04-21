import 'dart:async';
import 'dart:io';

import 'package:apphud/apphud.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tarot/repositories/remote_config.dart';

class SubscriptionRepository {
  static const String _revenuecatApiKey = "fhbnZanRslQQfdPlXHElULRSRRqpfOnY";
  static const String _apphudApiKey = 'app_tbvBXRQzMRaPnH3oXriDQbwhxaHcCx';

  List<ProductWrapper> currentProducts = [];

  BehaviorSubject<bool> _subscriptionController = BehaviorSubject.seeded(false);
  bool get subscribed => _subscriptionController.value;
  Stream<bool> get subscriptionStream => _subscriptionController.stream;

  void changeSubscriptionStatus(bool isSubscribed) {
    _subscriptionController.add(isSubscribed);
  }

  Future<SubscriptionRepository> init() async {
    InAppPurchaseConnection.enablePendingPurchases();
    try {
      await Purchases.setDebugLogsEnabled(false);
      await Purchases.setup(_revenuecatApiKey, observerMode: true);
      await Apphud.start(apiKey: _apphudApiKey, observerMode: true);

      InAppPurchaseConnection iap = InAppPurchaseConnection.instance;
      if (await iap.isAvailable()) {
        // get products
        List<SubscriptInfo> offeringList;
        switch (RemoteConfigManager.offering) {
          case '1':
            offeringList = [
              SubscriptInfo.weekly5(),
              SubscriptInfo.monthly5(),
              SubscriptInfo.annual5(),
            ];
            break;
          case '2':
            offeringList = [SubscriptInfo.monthlySpecial()];
            break;
          default:
            offeringList = [
              SubscriptInfo.weekly5(),
              SubscriptInfo.monthly5(),
              SubscriptInfo.annual5(),
            ];
        }
        await Future.forEach(offeringList, (SubscriptInfo info) async {
          Set<String> singleElementSet = {info.productId};
          final pdr = await iap.queryProductDetails(singleElementSet);
          final pdList = pdr.productDetails;
          currentProducts.add(
            ProductWrapper(pdList.first, info),
          );
        });

        //check purchases
        QueryPurchaseDetailsResponse response = await iap.queryPastPurchases();

        for (PurchaseDetails purchase in response.pastPurchases) {
          final bool pending = Platform.isIOS
              ? purchase.pendingCompletePurchase
              : !purchase.billingClientPurchase!.isAcknowledged;

          if (pending) {
            await InAppPurchaseConnection.instance.completePurchase(purchase);
          }
        }

        for (PurchaseDetails purchase in response.pastPurchases) {
          if (purchase.status == PurchaseStatus.purchased) {
            changeSubscriptionStatus(true);
          }
        }
      }
      _subscriptionController.add(subscribed);
    } catch (e, s) {
      changeSubscriptionStatus(false);
      await FirebaseCrashlytics.instance.recordError(e, s);
    }
    return this;
  }
}

class ProductWrapper {
  final ProductDetails productDetails;
  final SubscriptInfo info;

  ProductWrapper(this.productDetails, this.info);
}

class SubscriptInfo {
  final String productId;
  final String label;
  final String? plaque;
  const SubscriptInfo.weekly5()
      : productId = 'weekly_tarot_5',
        label = 'Weekly - 8,99\$ / week',
        plaque = null;
  const SubscriptInfo.monthly5()
      : productId = 'monthly_tarot_5',
        label = 'Monthly - 19,99\$ / month',
        plaque = 'Save 44%';
  const SubscriptInfo.annual5()
      : productId = 'yearly_tarot_5',
        label = 'Yearly - 49,99\$ / year',
        plaque = 'Save 89%';
  const SubscriptInfo.monthlySpecial()
      : productId = 'monthly_tarot_special',
        label = '19,99\$/month',
        plaque = null;
}
