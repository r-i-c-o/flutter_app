const adEvent = AdEvent._();

class AdEvent {
  const AdEvent._();
  static const String failedToShowFullscreenContent =
      "failed_to_show_fullscreen_content";
  static const String dismissedFullscreenContent =
      "dismissed_fullscreen_content";
  static const String showedFullscreenContent = "showed_fullscreen_content";
  static const String failedToLoad = "failed_to_load";
  static const String adLoaded = "ad_loaded";
}

const adType = AdType._();

class AdType {
  const AdType._();
  static const String interstitial = "interstitial";
  static const String banner = "banner";
  static const String rewarded = "rewarded";
  static const String native = "native";
}

class AdParam {
  const AdParam._();
  static const String adType = "ad_type";
  static const String adName = "ad_name";
}
