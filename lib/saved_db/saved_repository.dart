import 'package:tarot/helpers/subscription_manager.dart';
import 'package:tarot/saved_db/saved_dao.dart';
import 'package:tarot/saved_db/saved_database.dart';
import 'package:tarot/models/saved_spread/saved_spread.dart';

class SavedRepository {
  static SavedRepository? _instance;
  static SavedRepository get instance {
    _instance ??= SavedRepository._();
    return _instance!;
  }

  SavedRepository._() {
    _init();
  }
  void _init() async {
    _database = await $FloorSavedDatabase.databaseBuilder('saved.db').build();
    _dao = _database.dao;
    spreadStream = _dao.getSaved();
    spreadStream.listen((event) {
      print('SAVED SPREAD $event');
    });
  }

  late final SavedDatabase _database;
  late final SavedDao _dao;

  late final Stream<List<SavedSpread>> spreadStream;

  Future<void> insertSpread(SavedSpread spread) {
    return _dao.addToSaved(spread);
  }

  Future<List<SavedSpread>?> getAllSpreads() async {
    return await _dao.getSavedAmount();
  }

  Future<bool> canSaveSpread(bool isCardOfDay) async {
    final List<SavedSpread>? saved = await _dao.getSavedAmount();
    final List<SavedSpread> savedFiltered = saved
            ?.where((spread) =>
                isCardOfDay ? spread.spreadType == 4 : spread.spreadType != 4)
            .toList() ??
        [];
    final bool limitExceeded = savedFiltered.length >= 3;
    final bool subscribed = SubscriptionManager.instance.subscribed;
    return subscribed || !limitExceeded;
  }
}
