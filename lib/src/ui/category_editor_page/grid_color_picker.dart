import 'package:flutter/material.dart';

typedef SelectColorCallback = void Function(Color);

class GridColorPicker extends StatelessWidget {
  final List<Color> colors;
  final Color? selectedColor;
  final SelectColorCallback onSelectColor;

  GridColorPicker({
    required this.colors,
    required this.selectedColor,
    required this.onSelectColor,
  }) : assert(selectedColor == null || colors.contains(selectedColor));

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final color in colors)
          _colorTile(
            context: context,
            color: color,
            isSelected: color == selectedColor,
            onSelectColor: onSelectColor,
          ),
      ],
    );
  }

  Widget _colorTile({
    required BuildContext context,
    required Color color,
    required bool isSelected,
    required SelectColorCallback onSelectColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onSelectColor(color),
      child: Container(
        width: kMinInteractiveDimension,
        height: kMinInteractiveDimension,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: colorScheme.onSurface),
        ),
        child: isSelected ? Icon(Icons.check_rounded) : null,
      ),
    );
  }
}
