import 'package:flutter/material.dart';

class PartitionedBar extends StatelessWidget {
  final double heightFactor;
  final String label;
  final List<double> partitionFactors;
  final List<Color> partitionColors;
  final String tooltipText;

  final double barThickness;
  final Size labelSize;
  final double labelOffset;
  final BorderRadius barBorderRadius;

  PartitionedBar({
    required this.heightFactor,
    required this.label,
    required this.partitionFactors,
    required this.partitionColors,
    required this.tooltipText,
    required this.barThickness,
    required this.barBorderRadius,
    required this.labelSize,
    required this.labelOffset,
  })   : assert(0 <= heightFactor && heightFactor <= 1),
        assert(partitionFactors.isNotEmpty),
        assert(partitionFactors.reduce((a, b) => a + b).roundToDouble() == 1.0),
        assert(partitionColors.length == partitionFactors.length),
        assert(barThickness >= 0),
        assert(labelSize >= Size.zero);

  @override
  Widget build(BuildContext context) {
    final labeledBar = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _bar(
            heightFactor: heightFactor,
            thickness: barThickness,
            partitionFactors: partitionFactors,
            partitionColors: partitionColors,
            borderRadius: barBorderRadius,
          ),
        ),
        SizedBox(height: labelOffset),
        _label(context: context, label: label, size: labelSize),
      ],
    );

    if (tooltipText.isNotEmpty) {
      return Tooltip(
        message: tooltipText,
        preferBelow: false,
        padding: EdgeInsets.all(8),
        child: labeledBar,
      );
    } else {
      return labeledBar;
    }
  }

  Widget _bar({
    required double heightFactor,
    required List<double> partitionFactors,
    required List<Color> partitionColors,
    required double thickness,
    required BorderRadius borderRadius,
  }) {
    final maxPartitionFlex = 1000;
    final partitions = <Widget>[];

    for (var i = 0; i < partitionFactors.length; i++) {
      final factor = partitionFactors[i];
      final color = partitionColors[i];

      final part = Expanded(
        flex: (factor * maxPartitionFlex).round(),
        child: Container(color: color),
      );

      partitions.add(part);
    }

    return Container(
      width: thickness,
      child: FractionallySizedBox(
        heightFactor: heightFactor,
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: partitions,
          ),
        ),
      ),
    );
  }

  Widget _label({
    required BuildContext context,
    required String label,
    required Size size,
  }) {
    final textTheme = Theme.of(context).textTheme;

    final labelStyle = textTheme.subtitle2!.copyWith(fontSize: 12);

    return SizedBox.fromSize(
      size: size,
      child: Text(
        label,
        style: labelStyle,
        maxLines: 1,
        overflow: TextOverflow.fade,
        textAlign: TextAlign.center,
      ),
    );
  }
}
