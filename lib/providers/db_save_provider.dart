import 'package:flutter/foundation.dart';

class DBSaveProvider with ChangeNotifier {
  bool _codSaved = false;
  bool _spreadSaved = false;
  bool get codSaved => _codSaved;
  set codSaved(bool saved) {
    _codSaved = saved;
    notifyListeners();
  }

  bool get spreadSaved => _spreadSaved;
  set spreadSaved(bool saved) {
    _spreadSaved = saved;
    notifyListeners();
  }
}
