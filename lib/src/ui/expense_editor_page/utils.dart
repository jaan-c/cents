import 'package:flutter/material.dart';
import 'dart:math' as math;

final _colors = [
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
].map((e) => e[300]!).toList();

Color textToColor(Brightness brightness, String text) {
  final ix = math.Random(text.hashCode).nextInt(_colors.length);
  return _colors[ix];
}
