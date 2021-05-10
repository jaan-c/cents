import 'dart:math' as math;
import 'package:cents/src/domain/summary.dart';
import 'package:flutter/material.dart';

import 'month_summary_card_content.dart';

typedef TextToColor = Color Function(Brightness, String);

class MonthSummaryCard extends StatelessWidget {
  final MonthSummary monthSummary;
  final EdgeInsetsGeometry margin;

  MonthSummaryCard({required this.monthSummary, EdgeInsetsGeometry? margin})
      : margin = margin ?? EdgeInsets.symmetric(horizontal: 8, vertical: 4);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: MonthSummaryCardContent(
          monthSummary: monthSummary,
          textToColor: _textToColor,
        ),
      ),
    );
  }

  Color _textToColor(Brightness brightness, String text) {
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
}
