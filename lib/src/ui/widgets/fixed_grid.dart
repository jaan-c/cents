import 'package:flutter/material.dart';

import 'ext_widget_list.dart';

class FixedGrid extends StatelessWidget {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final List<Widget> children;

  FixedGrid({
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.children = const [],
  }) : assert(crossAxisCount >= 2);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final rowChildren in _groupByCount(children, crossAxisCount))
          _row(children: rowChildren),
      ].intersperse(builder: () => SizedBox(height: mainAxisSpacing)),
    );
  }

  Widget _row({required List<Widget> children}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.intersperse(
          builder: () => SizedBox(width: crossAxisSpacing)),
    );
  }
}

List<List<T>> _groupByCount<T>(List<T> items, int count) {
  assert(count >= 1);

  final acc = <List<T>>[];
  var remaining = items;

  while (remaining.isNotEmpty) {
    final head = remaining.take(count).toList();
    final tail = remaining.skip(count).toList();

    acc.add(head);
    remaining = tail;
  }

  return acc;
}
