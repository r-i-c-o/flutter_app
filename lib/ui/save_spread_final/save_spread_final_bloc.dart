import 'dart:async';
import 'dart:convert';

//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:tarot/models/saved_spread/saved_spread_info.dart';
import 'package:tarot/providers/db_save_provider.dart';
import 'package:tarot/saved_db/saved_repository.dart';
import 'package:tarot/models/saved_spread/saved_spread.dart';
import 'package:rxdart/streams.dart';
import 'package:tarot/ui/journal/journal_button_stream.dart';

class SaveSpreadFinalBloc {
  SaveSpreadFinalBloc(this.info, List<String> labels) {
    labels.forEach((element) {
      _labels[element] = false;
    });
    sliderValue.listen((value) {
      _value = value.toInt();
    });
  }
  final SavedRepository _savedRepository = GetIt.I.get();
  final SavedSpreadInfo info;
  StreamController<Map<String, bool>> _labelsController = StreamController();
  Stream<Map<String, bool>> get labels => _labelsController.stream;
  Map<String, bool> _labels = {};

  int _value = 1;
  StreamController<double> _sliderController = StreamController.broadcast();
  Stream<double> get sliderValue =>
      _sliderController.stream.shareValueSeeded(1.0);

  void onTap(String label) {
    final labelState = _labels[label];
    if (labelState != null) _labels[label] = !labelState;
    _labelsController.add(_labels);
  }

  Future<bool> saveSpread(BuildContext context) async {
    bool isCod = info.spread == null;
    List<String> activeLabels = [];
    _labels.forEach(
      (key, value) {
        if (_labels[key] == true) activeLabels.add(key);
      },
    );
    String labelResult = activeLabels.join(',');
    try {
      await _savedRepository.insertSpread(
        SavedSpread(
            isCod ? 4 : info.spread!.spreadCategory,
            info.spread?.title,
            _value,
            DateTime.now().millisecondsSinceEpoch,
            info.question,
            info.note,
            labelResult,
            jsonEncode(info.savedCards)),
      );
      final provider = Provider.of<DBSaveProvider>(context, listen: false);
      if (isCod) {
        provider.codSaved = true;
        JournalButtonStream.instance.getCardsOfDay();
      } else {
        provider.spreadSaved = true;
        JournalButtonStream.instance.getSpreads();
      }
      JournalButtonStream.instance.update();
      return Future.value(true);
    } catch (e, s) {
      //await FirebaseCrashlytics.instance.recordError(e, s);
      print(e);
      return Future.value(false);
    }
  }

  void changeSliderValue(double value) => _sliderController.add(value);

  void dispose() {
    _sliderController.close();
    _labelsController.close();
  }
}
