import 'package:flutter/material.dart';

class PartitionedBarData {
  final double value;
  final String label;
  final List<double> partitionFactors;
  final List<Color> partitionColors;
  final String tooltipText;

  PartitionedBarData({
    required this.value,
    required this.label,
    this.partitionFactors = const [1.0],
    this.tooltipText = '',
    this.partitionColors = const [Colors.blue],
  });
}
