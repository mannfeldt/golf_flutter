import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:testgolf/models/swing.dart';
import 'package:sensors/sensors.dart';
import 'package:testgolf/resources/custom_golf_icons.dart';

class Utility {
  static final int PHYSICS_SPEED_FACTOR = 3;

  static Swing getSwing(var club, double power) {
    var xFactor = (90 - club['loft']) / 90;
    var yFactor = club['loft'] / 90;

    Swing swing = new Swing(
        min((power * xFactor * club['powerFactor']).ceil(), club['max']),
        min((power * yFactor * club['powerFactor']).ceil(), club['max']));
    return swing;
  }

  static bool isValidSwing(List<AccelerometerEvent> swingPoints) {
    print("len: " + swingPoints.length.toString());
    // if (swingPoints.length < 3000) {
    //   return false;
    // }
    return true;
  }

  static String getScoreName(int strokes, int par) {
    if (strokes == 1) return 'Hole in one!';
    int score = strokes - par;
    var term = SCORE_TERMS.singleWhere((term) => term["score"] == score,
        orElse: () => null);
    if (term != null) return term["name"];
    return score.toString() + " over par";
  }

  static final clubIcons = {
    'wood': CustomGolf.drivericon,
    'iron': CustomGolf.ironicon,
    'putt': CustomGolf.puttericon,
  };

  static final CLUBS = [
    {
      'name': 'Wood',
      'type': 'wood',
      'index': 0,
      'loft': 22,
      'powerFactor': 3.8,
      'max': 800,
    },
    {
      'name': 'Hybrid',
      'type': 'iron',
      'index': 1,
      'loft': 26,
      'powerFactor': 3.6,
      'max': 800,
    },
    {
      'name': '3 Iron',
      'type': 'iron',
      'index': 2,
      'loft': 31,
      'powerFactor': 3.2,
      'max': 700,
    },
    {
      'name': '4 Iron',
      'type': 'iron',
      'index': 3,
      'loft': 34,
      'powerFactor': 3.15,
      'max': 700,
    },
    {
      'name': '5 Iron',
      'type': 'iron',
      'index': 4,
      'loft': 37,
      'powerFactor': 3.1,
      'max': 700,
    },
    {
      'name': '6 Iron',
      'type': 'iron',
      'index': 5,
      'loft': 40,
      'powerFactor': 3.05,
      'max': 700,
    },
    {
      'name': '7 Iron',
      'type': 'iron',
      'index': 6,
      'loft': 43,
      'powerFactor': 3,
      'max': 700,
    },
    {
      'name': '8 Iron',
      'type': 'iron',
      'index': 7,
      'loft': 46,
      'powerFactor': 2.95,
      'max': 700,
    },
    {
      'name': '9 Iron',
      'type': 'iron',
      'index': 8,
      'loft': 49,
      'powerFactor': 2.9,
      'max': 700,
    },
    {
      'name': 'Wedge',
      'type': 'iron',
      'index': 9,
      'loft': 62,
      'powerFactor': 2.75,
      'max': 700,
    },
    {
      'name': 'Chipper',
      'type': 'iron',
      'index': 10,
      'loft': 78,
      'powerFactor': 2.6,
      'max': 700,
    },
    {
      'name': 'Putter',
      'type': 'putt',
      'index': 11,
      'loft': 1,
      'powerFactor': 1.6,
      'max': 400,
    },
  ];
  static final SCORE_TERMS = [
    {
      'name': 'Albatross',
      'score': -3,
    },
    {
      'name': 'Eagle',
      'score': -2,
    },
    {
      'name': 'Birdie',
      'score': -1,
    },
    {
      'name': 'Par',
      'score': 0,
    },
    {
      'name': 'Bogey',
      'score': 1,
    },
    {
      'name': 'Double bogey',
      'score': 2,
    },
    {
      'name': 'Triple bogey',
      'score': 3,
    },
    {
      'name': 'Quadruple bogey',
      'score': 4,
    },
  ];
}
