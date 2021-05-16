import 'package:flutter/material.dart';

import '../ext_widget_list.dart';

class FixedGrid extends StatelessWidget {
  final int crossAxisCount;
  final List<Widget> children;
  final EdgeInsetsGeometry tilePadding;

  FixedGrid({
    this.crossAxisCount = 2,
    this.children = const [],
    this.tilePadding = const EdgeInsets.all(4),
  }) : assert(crossAxisCount >= 2);

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        for (final group in _groupByCount(children, crossAxisCount))
          _row(children: group, count: crossAxisCount),
      ],
    );
  }

  TableRow _row({required List<Widget> children, required int count}) {
    assert(children.length <= count);

    children = [
      ...children,
      for (var i = 0; i < count - children.length; i++) SizedBox.shrink()
    ];

    return TableRow(
      children: children.padEach(padding: tilePadding),
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
