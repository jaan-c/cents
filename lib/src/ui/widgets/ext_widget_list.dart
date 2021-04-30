import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

extension ExtWidgetList on List<Widget> {
  List<Widget> padEach({required EdgeInsetsGeometry padding}) {
    return [
      for (final widget in this) Padding(padding: padding, child: widget)
    ];
  }

  List<Widget> constrainEach({required BoxConstraints constraints}) {
    return [
      for (final widget in this)
        ConstrainedBox(constraints: constraints, child: widget)
    ];
  }

  List<Widget> intersperse({required Widget Function() builder}) {
    final acc = <Widget>[];
    for (final indexedWidget in enumerate(this)) {
      acc.add(indexedWidget.value);

      if (indexedWidget.index != length - 1) {
        acc.add(builder());
      }
    }

    return acc;
  }
}
