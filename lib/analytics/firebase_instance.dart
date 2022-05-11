import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseInstance {
  FirebaseInstance._();
  static FirebaseAnalytics _analytics = FirebaseAnalytics();
  static FirebaseAnalytics get instance => _analytics;
}
