import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarot/planets/planet_position.dart';
import 'package:tarot/providers/planets_provider.dart';
import 'package:tarot/theme/app_colors.dart';
import 'package:tarot/widgets/rotating_planet.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: AppColors.appBackgroundColor,
          ),
        ),
        Positioned.fill(
          child: Image.asset(
            'assets/images/bg.png',
            color: Color.fromRGBO(255, 255, 255, 0.5),
            colorBlendMode: BlendMode.modulate,
            fit: BoxFit.cover,
            repeat: ImageRepeat.repeat,
          ),
        ),
        Consumer<PlanetsProvider>(
          builder: (_, value, child) {
            PlanetPosition planet1 = value.planet1Position;
            return AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top: planet1.top,
              left: planet1.left,
              bottom: planet1.bottom,
              right: planet1.right,
              child: child!,
            );
          },
          child: RotatingPlanet(
            child: Image.asset(
              'assets/images/planet1.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Consumer<PlanetsProvider>(
          builder: (_, value, child) {
            PlanetPosition planet2 = value.planet2Position;
            return AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top: planet2.top,
              left: planet2.left,
              bottom: planet2.bottom,
              right: planet2.right,
              child: child!,
            );
          },
          child: RotatingPlanet(
            child: Image.asset(
              'assets/images/planet2.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0x00142430),
                  Color(0xFF0A1218),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
