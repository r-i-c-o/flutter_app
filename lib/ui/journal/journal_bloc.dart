import 'dart:async';

import 'package:rxdart/streams.dart';
import 'package:tarot/saved_db/saved_repository.dart';
import 'package:tarot/models/saved_spread/saved_spread.dart';

import 'journal_button_stream.dart';

class JournalBloc {
  late final Stream<bool> _updateList;

  late final Stream<bool> _buttonMode;
  Stream<bool> get buttonMode => _buttonMode;

  late Stream<Future<List<SavedSpread>>> savedList;

  final JournalButtonStream journalButtonStream;

  JournalBloc(this.journalButtonStream) {
    _buttonMode = journalButtonStream.buttonMode;
    _updateList = journalButtonStream.updateStream;
    _buttonMode.listen((event) {});
    _updateList.listen((event) {});
    savedList =
        CombineLatestStream.combine2<bool, bool, Future<List<SavedSpread>>>(
            _buttonMode, _updateList, (isCod, _) async {
      final list = await SavedRepository.instance.getAllSpreads();
      return list == null
          ? []
          : list
              .where((element) => (element.spreadType == 4) == isCod)
              .toList();
    });
  }

  void getCardsOfDay() => journalButtonStream.getCardsOfDay();

  void getSpreads() => journalButtonStream.getSpreads();

  void dispose() {
    //_buttonModeController.close();
  }
}
