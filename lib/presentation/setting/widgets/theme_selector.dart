import 'package:flutter/material.dart';

import 'color_option.dart';
import 'custom_color_picker.dart';

class ThemeSelector extends StatelessWidget {
  final List<Color> availableColors;
  final Color? selectedColor;
  final ValueChanged<Color> onColorSelected;
  final VoidCallback onCustomColorTap;

  const ThemeSelector({
    required this.availableColors,
    required this.selectedColor,
    required this.onColorSelected,
    required this.onCustomColorTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...availableColors.map((color) => ColorOption(
            color: color,
            isSelected: selectedColor == color,
            onTap: () => onColorSelected(color),
          )),
          CustomColorPicker(onTap: onCustomColorTap, selectedColor: selectedColor),
        ],
      ),
    );
  }
}
