import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  AdManager._();

  static bool _testMode = false;

  static void setTestMode() => _testMode = true;

  static Map<String, String> adIds = {
    'splash': 'ca-app-pub-3796853028071527/7578463692',
    'cardOfDay': 'ca-app-pub-3796853028071527/4924380197',
    'spread': 'ca-app-pub-3796853028071527/4732808502',
    'singleCategory': 'ca-app-pub-3796853028071527/5252473247',
  };

  static String get appId {
    if (_testMode) return "ca-app-pub-3940256099942544~3347511713";
    if (Platform.isAndroid) {
      return "ca-app-pub-3796853028071527~7961607079";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544~3347511713";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get splashInterstitialAdUnitId {
    if (_testMode) return InterstitialAd.testAdUnitId;
    if (Platform.isAndroid) {
      return "ca-app-pub-3796853028071527/7578463692";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544~3347511713";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get codInterstitialAdUnitId {
    if (_testMode) return InterstitialAd.testAdUnitId;
    if (Platform.isAndroid) {
      return "ca-app-pub-3796853028071527/4924380197";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get spreadInterstitialAdUnitId {
    if (_testMode) return InterstitialAd.testAdUnitId;
    if (Platform.isAndroid) {
      return "ca-app-pub-3796853028071527/4732808502";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get singleCategoryGridInterstitialAdUnitId {
    if (_testMode) return InterstitialAd.testAdUnitId;
    if (Platform.isAndroid) {
      return "ca-app-pub-3796853028071527/5252473247";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (_testMode) return RewardedAd.testAdUnitId;
    if (Platform.isAndroid) {
      return "ca-app-pub-3796853028071527/6967896085";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (_testMode) return BannerAd.testAdUnitId;
    if (Platform.isAndroid) {
      return "ca-app-pub-3796853028071527/8369271343";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bigBannerAdUnitId {
    if (_testMode) return BannerAd.testAdUnitId;
    if (Platform.isAndroid) {
      return "ca-app-pub-3796853028071527/2679463336";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (_testMode) return NativeAd.testAdUnitId;
    if (Platform.isAndroid) {
      return "ca-app-pub-3796853028071527/6673046295";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
