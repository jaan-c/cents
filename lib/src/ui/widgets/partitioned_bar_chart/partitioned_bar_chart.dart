import 'package:cents/src/ui/widgets/partitioned_bar_chart/magnitude_line.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import 'partitioned_bar.dart';
import 'partitioned_bar_data.dart';

typedef MagnitudeToLabel = String Function(double);

class PartitionedBarChart extends StatelessWidget {
  final double maxValue;
  final List<PartitionedBarData> barDatas;
  final int magnitudePartitionCount;
  final MagnitudeToLabel magnitudeToLabel;

  final double height;
  final double barThickness;
  final BorderRadius barBorderRadius;
  final Size barLabelSize;
  final double barLabelOffset;
  final Size magnitudeLabelSize;
  final double magnitudeLabelOffset;
  final double magnitudeLineWidth;

  PartitionedBarChart({super.key, 
    required this.maxValue,
    required this.barDatas,
    this.magnitudePartitionCount = 2,
    this.magnitudeToLabel = _doubleToString,
    this.height = 150,
    this.barThickness = 24,
    this.barBorderRadius = const BorderRadius.vertical(
        top: Radius.circular(2), bottom: Radius.zero),
    this.barLabelSize = const Size(32, 16),
    this.barLabelOffset = 8,
    this.magnitudeLabelSize = const Size(48, 16),
    this.magnitudeLabelOffset = 8,
    this.magnitudeLineWidth = 1,
  })  : assert(maxValue >= 0),
        assert(barDatas.every((b) => 0 <= b.value && b.value <= maxValue)),
        assert(magnitudePartitionCount >= 2);

  @override
  Widget build(BuildContext context) {
    final barsTopOffset = magnitudeLabelSize.height;
    final barsEndOffset = magnitudeLabelSize.width + magnitudeLabelOffset;
    // Note: Magnitude lines seems to be padded at the bottom 4 pixels up, take
    // that into account when computing magnitude bottom offset. Still can't
    // figure out where it's coming from.
    final magnitudesBottomOffset = (barLabelSize.height + barLabelOffset) -
        (magnitudeLabelSize.height / 2) -
        4;

    return Stack(
      children: [
        Positioned.fill(
          bottom: magnitudesBottomOffset,
          child: _magnitudeLines(
            maxValue: maxValue,
            partitionCount: magnitudePartitionCount,
            magnitudeToLabel: magnitudeToLabel,
            thickness: barThickness,
            labelSize: magnitudeLabelSize,
            labelOffset: magnitudeLabelOffset,
          ),
        ),
        Positioned.fill(
          top: barsTopOffset,
          right: barsEndOffset,
          child: _partitionedBars(
            maxValue: maxValue,
            barDatas: barDatas,
            barThickness: barThickness,
            barBorderRadius: barBorderRadius,
            barLabelSize: barLabelSize,
            barLabelOffset: barLabelOffset,
          ),
        ),
      ],
    );
  }

  Widget _partitionedBars({
    required double maxValue,
    required List<PartitionedBarData> barDatas,
    required double barThickness,
    required BorderRadius barBorderRadius,
    required Size barLabelSize,
    required double barLabelOffset,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final data in barDatas)
          Expanded(
            child: PartitionedBar(
              heightFactor: data.value / maxValue,
              label: data.label,
              partitionFactors: data.value != 0
                  ? data.partitionValues.map((v) => v / data.value).toList()
                  : [1.0],
              partitionColors:
                  data.value != 0 ? data.partitionColors : [Colors.blue],
              tooltipText: data.tooltipText,
              barThickness: barThickness,
              labelSize: barLabelSize,
              labelOffset: barLabelOffset,
              barBorderRadius: barBorderRadius,
            ),
          ),
      ],
    );
  }

  Widget _magnitudeLines({
    required double maxValue,
    required int partitionCount,
    required MagnitudeToLabel magnitudeToLabel,
    required double thickness,
    required Size labelSize,
    required double labelOffset,
  }) {
    final magnitudes = range(partitionCount)
        .map((c) => c * (maxValue / (partitionCount - 1)))
        .toList()
        .reversed;

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final magnitude in magnitudes)
          MagnitudeLine(
            label: magnitudeToLabel(magnitude),
            lineThickness: thickness,
            labelSize: labelSize,
            labelOffset: labelOffset,
          ),
      ],
    );
  }
}

String _doubleToString(double d) {
  return d.toString();
}
