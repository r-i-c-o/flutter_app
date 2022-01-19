import 'dart:async';
import 'package:rxdart/streams.dart';

class JournalButtonStream {
  static JournalButtonStream? _instance;
  static JournalButtonStream get instance {
    _instance ??= JournalButtonStream._();
    return _instance!;
  }

  JournalButtonStream._() {
    _buttonMode = _buttonModeController.stream.shareValueSeeded(true);
    _update = _updateController.stream.shareValueSeeded(true);
  }

  final StreamController<bool> _buttonModeController =
      StreamController<bool>.broadcast();

  final StreamController<bool> _updateController =
      StreamController<bool>.broadcast();

  late final Stream<bool> _buttonMode;
  Stream<bool> get buttonMode => _buttonMode;

  late final Stream<bool> _update;
  Stream<bool> get updateStream => _update;

  void update() => _updateController.add(true);

  void getCardsOfDay() => _buttonModeController.add(true);

  void getSpreads() => _buttonModeController.add(false);
}
