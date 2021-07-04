import 'package:flutter/material.dart';
import 'dart:math' as math;

Color textToColor(Brightness brightness, String text) {
  final swatches = [
    Colors.pink,
    Colors.red,
    Colors.deepOrange,
    Colors.orange,
    Colors.amber,
    Colors.yellow,
    Colors.lime,
    Colors.lightGreen,
    Colors.green,
    Colors.teal,
    Colors.cyan,
    Colors.lightBlue,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.deepPurple,
    Colors.blueGrey,
    Colors.brown,
  ];

  final ix = math.Random(text.hashCode).nextInt(swatches.length);
  final swatch = swatches[ix];
  final shade = brightness == Brightness.light ? 400 : 300;

  return swatch[shade]!;
}
