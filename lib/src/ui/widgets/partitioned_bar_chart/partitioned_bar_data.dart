import 'package:flutter/material.dart';

class PartitionedBarData {
  final double value;
  final String label;
  final List<double> partitionValues;
  final List<Color> partitionColors;
  final String tooltipText;

  PartitionedBarData({
    required this.value,
    required this.label,
    List<double> partitionValues = const [],
    List<Color> partitionColors = const [],
    this.tooltipText = '',
  })  : partitionValues =
            partitionValues.isNotEmpty ? partitionValues : [value],
        partitionColors =
            partitionColors.isNotEmpty ? partitionColors : [Colors.blue],
        assert(partitionValues.reduce((a, b) => a + b) == value),
        assert(partitionValues.length == partitionColors.length);
}
