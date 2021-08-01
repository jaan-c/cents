import 'package:flutter/material.dart';

class PartitionedBarData {
  final String label;
  final List<double> partitionValues;
  final List<Color> partitionColors;
  final String tooltipText;

  double get value => partitionValues.fold(0.0, (acc, v) => acc + v);

  PartitionedBarData({
    this.partitionValues = const [],
    required this.label,
    this.partitionColors = const [],
    this.tooltipText = '',
  }) : assert(partitionValues.length == partitionColors.length);
}
