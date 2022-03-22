import 'package:get_it/get_it.dart';
import 'package:tarot/helpers/subscription_manager.dart';
import 'package:tarot/saved_db/saved_dao.dart';
import 'package:tarot/saved_db/saved_database.dart';
import 'package:tarot/models/saved_spread/saved_spread.dart';

class SavedRepository {
  Future<SavedRepository> init() async {
    SavedDatabase db =
        await $FloorSavedDatabase.databaseBuilder('saved.db').build();
    _dao = db.dao;
    spreadStream = _dao.getSaved();
    return this;
  }

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
    final bool subscribed = GetIt.I.get<SubscriptionRepository>().subscribed;
    return subscribed || !limitExceeded;
  }
}
