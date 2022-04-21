import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tarot/app_module.dart';
import 'package:tarot/repositories/subscription_manager.dart';
import 'package:tarot/saved_db/saved_dao.dart';
import 'package:tarot/saved_db/saved_database.dart';
import 'package:tarot/models/saved_spread/saved_spread.dart';

class SavedRepository {
  Future<SavedRepository> init() async {
    SavedDatabase db =
        await $FloorSavedDatabase.databaseBuilder('saved.db').build();
    _dao = db.dao;
    subscriptionRepository = await provideAsync<SubscriptionRepository>();
    return this;
  }

  late final SubscriptionRepository subscriptionRepository;

  late final SavedDao _dao;

  final codSaved = BehaviorSubject.seeded(false);
  final spreadSaved = BehaviorSubject.seeded(false);

  Future<void> insertSpread(SavedSpread spread) {
    return _dao.addToSaved(spread);
  }

  Future<List<SavedSpread>?> getAllSpreads() async {
    return await _dao.getSavedAmount();
  }

  Future<bool> canSaveSpread(bool isCardOfDay) async {
    final List<SavedSpread>? saved = await _dao.getSavedAmount();
    final List<SavedSpread> savedFiltered = saved
            ?.where((spread) => isCardOfDay ^ (!spread.isCardOfDay()))
            .toList() ??
        [];
    final bool limitExceeded = savedFiltered.length >= 3;
    final bool subscribed = subscriptionRepository.subscribed;
    return subscribed || !limitExceeded;
  }
}
