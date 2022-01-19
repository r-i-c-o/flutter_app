import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:tarot/planets/default_positions.dart';
import 'package:tarot/planets/planet_position.dart';

class PlanetsProvider with ChangeNotifier {
  late PlanetPosition _planetOne, _planetTwo;
  final Size _screenSize;

  PlanetPosition get planet1Position => _planetOne;

  PlanetPosition get planet2Position => _planetTwo;

  void setPlanets(
    PlanetOffset? planetOne,
    PlanetOffset? planetTwo,
  ) {
    if (planetOne != null) {
      _planetOne = PlanetPosition(
        screenSize: _screenSize,
        offset: planetOne,
      );
    }
    if (planetTwo != null) {
      _planetTwo = PlanetPosition(
        screenSize: _screenSize,
        offset: planetTwo,
      );
    }
    notifyListeners();
  }

  void dispose() {
    super.dispose();
  }

  PlanetsProvider(this._screenSize) {
    _planetOne = PlanetPosition(screenSize: _screenSize, offset: main_1);
    _planetTwo = PlanetPosition(screenSize: _screenSize, offset: main_2);
  }
}
