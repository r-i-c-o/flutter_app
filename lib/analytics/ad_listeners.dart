import 'package:google_mobile_ads/google_mobile_ads.dart' as gms;
import 'package:native_admob_flutter/native_admob_flutter.dart';

import 'events/ad_events.dart';
import 'firebase_instance.dart';

class KadoInterstitialListener
    extends KadoFullscreenListener<gms.InterstitialAd> {
  KadoInterstitialListener({
    required String name,
    Function(gms.InterstitialAd ad)? dismissedFullscreenContent,
    Function(gms.LoadAdError error)? adFailedToLoad,
    Function(gms.InterstitialAd ad)? failedToShowFullscreenContent,
    Function(gms.InterstitialAd ad)? adLoaded,
    Function(gms.InterstitialAd ad)? showedFullscreenContent,
  }) : super(
          type: AdType.interstitial,
          name: name,
          dismissedFullscreenContent: dismissedFullscreenContent,
          adFailedToLoad: adFailedToLoad,
          failedToShowFullscreenContent: failedToShowFullscreenContent,
          adLoaded: adLoaded,
          showedFullscreenContent: showedFullscreenContent,
        );

  gms.InterstitialAdLoadCallback get interstitialListener =>
      gms.InterstitialAdLoadCallback(
        onAdFailedToLoad: (error) {
          _logAdEvent(AdEvent.failedToLoad);
          print("KADO INTERSTITIAL ERROR ${error.message}");
          adFailedToLoad?.call(error);
        },
        onAdLoaded: (ad) {
          _logAdEvent(AdEvent.adLoaded);
          adLoaded?.call(ad);
        },
      );
}

class KadoRewardedListener extends KadoFullscreenListener<gms.RewardedAd> {
  KadoRewardedListener({
    required String name,
    Function(gms.RewardedAd ad)? dismissedFullscreenContent,
    Function(gms.LoadAdError error)? adFailedToLoad,
    Function(gms.RewardedAd ad)? failedToShowFullscreenContent,
    Function(gms.RewardedAd ad)? adLoaded,
    Function(gms.RewardedAd ad)? showedFullscreenContent,
  }) : super(
          type: AdType.rewarded,
          name: name,
          dismissedFullscreenContent: dismissedFullscreenContent,
          adFailedToLoad: adFailedToLoad,
          failedToShowFullscreenContent: failedToShowFullscreenContent,
          adLoaded: adLoaded,
          showedFullscreenContent: showedFullscreenContent,
        );

  gms.RewardedAdLoadCallback get rewardedListener => gms.RewardedAdLoadCallback(
        onAdFailedToLoad: (error) {
          _logAdEvent(AdEvent.failedToLoad);
          adFailedToLoad?.call(error);
        },
        onAdLoaded: (ad) {
          _logAdEvent(AdEvent.adLoaded);
          adLoaded?.call(ad);
        },
      );
}

abstract class KadoFullscreenListener<T extends gms.AdWithoutView>
    extends KadoGoogleAdListener {
  final Function(T ad)? dismissedFullscreenContent;
  final Function(gms.LoadAdError error)? adFailedToLoad;
  final Function(T ad)? failedToShowFullscreenContent;
  final Function(T ad)? adLoaded;
  final Function(T ad)? showedFullscreenContent;

  KadoFullscreenListener({
    required String name,
    required String type,
    this.dismissedFullscreenContent,
    this.adFailedToLoad,
    this.failedToShowFullscreenContent,
    this.adLoaded,
    this.showedFullscreenContent,
  }) : super(name: name, type: type);

  gms.FullScreenContentCallback<T> get fullScreenCallback =>
      gms.FullScreenContentCallback<T>(
        onAdFailedToShowFullScreenContent: (ad, error) {
          _logAdEvent(AdEvent.failedToShowFullscreenContent);
          failedToShowFullscreenContent?.call(ad);
        },
        onAdDismissedFullScreenContent: (ad) {
          _logAdEvent(AdEvent.dismissedFullscreenContent);
          dismissedFullscreenContent?.call(ad);
        },
        onAdShowedFullScreenContent: (ad) {
          _logAdEvent(AdEvent.showedFullscreenContent);
          showedFullscreenContent?.call(ad);
        },
      );
}

class KadoBannerAdmobListener extends KadoGoogleAdListener {
  KadoBannerAdmobListener({
    required String name,
    this.adLoaded,
    this.adFailedToLoad,
  }) : super(type: AdType.banner, name: name);

  final Function(gms.Ad ad)? adLoaded;
  final Function(gms.LoadAdError error)? adFailedToLoad;

  gms.BannerAdListener get listener => gms.BannerAdListener(
        onAdLoaded: (gms.Ad ad) {
          _logAdEvent(AdEvent.adLoaded);
          adLoaded?.call(ad);
        },
        onAdFailedToLoad: (gms.Ad ad, gms.LoadAdError error) {
          _logAdEvent(AdEvent.failedToLoad);
          ad.dispose();
          adFailedToLoad?.call(error);
        },
      );
}

class KadoGoogleAdListener {
  @adType
  final String type;
  final String name;

  KadoGoogleAdListener({
    required this.type,
    required this.name,
  });

  void _logAdEvent(@adEvent String event) {
    final String eventName = "${event}_$name";
    FirebaseInstance.instance.logEvent(
      name: eventName,
      parameters: {
        AdParam.adType: type,
        AdParam.adName: name,
      },
    );
  }
}

abstract class KadoNativeAdmobListener<T extends LoadShowAd> {
  late final T _controller;

  final Function? loaded;
  final Function? loadFailed;
  final String name;
  @adType
  final String type;

  KadoNativeAdmobListener({
    this.loaded,
    this.loadFailed,
    required this.name,
    required this.type,
  });

  T get controller => _controller;

  void initController();

  void dispose() {
    _controller.dispose();
  }

  void _logAdEvent(@adEvent String event) {
    final String eventName = "${event}_$name";
    FirebaseInstance.instance.logEvent(
      name: eventName,
      parameters: {
        AdParam.adType: type,
        AdParam.adName: name,
      },
    );
  }
}

class KadoBannerAdListener extends KadoNativeAdmobListener<BannerAdController> {
  KadoBannerAdListener({
    Function? loaded,
    Function? loadFailed,
    required String name,
  }) : super(
          loaded: loaded,
          loadFailed: loadFailed,
          name: name,
          type: AdType.banner,
        );

  void initController() {
    _controller = BannerAdController();
    _controller.onEvent.listen((event) {
      final e = event.keys.first;
      switch (e) {
        case BannerAdEvent.loaded:
          _logAdEvent(AdEvent.adLoaded);
          loaded?.call();
          break;
        case BannerAdEvent.loadFailed:
          _logAdEvent(AdEvent.failedToLoad);
          loadFailed?.call();
          break;
        default:
          break;
      }
    });
    _controller.load();
  }
}

class KadoNativeAdListener extends KadoNativeAdmobListener<NativeAdController> {
  final String unitId;
  KadoNativeAdListener({
    Function? loaded,
    Function? loadFailed,
    required String name,
    required this.unitId,
  }) : super(
          loaded: loaded,
          loadFailed: loadFailed,
          name: name,
          type: AdType.native,
        );

  void initController() {
    _controller = NativeAdController();
    _controller.onEvent.listen((event) {
      final e = event.keys.first;
      switch (e) {
        case NativeAdEvent.loaded:
          _logAdEvent(AdEvent.adLoaded);
          loaded?.call();
          break;
        case NativeAdEvent.loadFailed:
          _logAdEvent(AdEvent.failedToLoad);
          loadFailed?.call();
          break;
        default:
          break;
      }
    });
    _controller.load(unitId: unitId);
  }
}
