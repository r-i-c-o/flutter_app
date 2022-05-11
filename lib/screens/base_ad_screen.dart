import 'package:flutter/material.dart';
import 'package:tarot/app_module.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../analytics/ad_listeners.dart';
import '../repositories/ad_manager.dart';

class BaseAdScreenState<T extends StatefulWidget> extends State<T> {
  static const int _maxFailedLoadAttempts = 10;
  int _numInterstitialLoadAttempts = 0;
  final String? _interstitialAdUnitId;
  InterstitialAd? interstitialAd;
  Function? onAdClosed;
  bool _showAd = true;
  bool get showAd => _showAd;
  final subscriptionRepository = provideSubscriptionRepository();

  late KadoInterstitialListener listener;
  BaseAdScreenState(this._interstitialAdUnitId) : super();

  @override
  void initState() {
    super.initState();
    _showAd = !subscriptionRepository.subscribed;
    subscriptionRepository.subscriptionStream.listen((subscribed) {
      _showAd = !subscribed;
    });
    listener = KadoInterstitialListener(
      name: AdManager.adIds.keys.firstWhere(
        (key) => AdManager.adIds[key] == _interstitialAdUnitId,
        orElse: () => 'error',
      ),
      adLoaded: (ad) {
        interstitialAd = ad;
        _numInterstitialLoadAttempts = 0;
      },
      adFailedToLoad: (error) {
        _numInterstitialLoadAttempts += 1;
        interstitialAd = null;
        if (_numInterstitialLoadAttempts <= _maxFailedLoadAttempts) {
          _createInterstitial();
        }
      },
      failedToShowFullscreenContent: (ad) {
        ad.dispose();
        _createInterstitial();
      },
      dismissedFullscreenContent: (ad) {
        ad.dispose();
        _adClosedCallback();
        _createInterstitial();
      },
    );
    _createInterstitial();
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

  void _adClosedCallback() async {
    if (onAdClosed != null) {
      await Future.delayed(Duration(milliseconds: 100));
      onAdClosed!();
    }
  }

  void _createInterstitial() {
    if (!_showAd || _interstitialAdUnitId == null) return;
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId!,
      request: AdRequest(),
      adLoadCallback: listener.interstitialListener,
    );
  }

  void createOnAdClosed(Function callback) {
    onAdClosed = callback;
    if (interstitialAd == null) {
      onAdClosed!();
      return;
    }
    if (_showAd) {
      interstitialAd?.fullScreenContentCallback = listener.fullScreenCallback;
      interstitialAd?.show();
      interstitialAd = null;
    } else
      onAdClosed!();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
