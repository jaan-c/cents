import 'package:flutter/material.dart';

class MagnitudeLine extends StatelessWidget {
  final String label;
  final double lineThickness;

  final Size labelSize;
  final double labelOffset;

  MagnitudeLine({
    required this.label,
    required this.lineThickness,
    required this.labelSize,
    required this.labelOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(height: lineThickness),
        ),
        SizedBox(width: labelOffset),
        _label(context: context, label: label, size: labelSize),
      ],
    );
  }

  Widget _label({
    required BuildContext context,
    required String label,
    required Size size,
  }) {
    final textTheme = Theme.of(context).textTheme;

    final labelStyle = textTheme.subtitle2!.copyWith(fontSize: 12);

    return SizedBox(
      width: labelSize.width,
      height: labelSize.height,
      child: Text(
        label,
        style: labelStyle,
        maxLines: 1,
        overflow: TextOverflow.fade,
        textAlign: TextAlign.left,
      ),
    );
  }
}
