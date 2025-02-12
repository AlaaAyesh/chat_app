import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatelessWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerDialog({
    required this.initialColor,
    required this.onColorSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color pickedColor = initialColor;
    return AlertDialog(
      title: const Text("Choose Accent Color"),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickedColor,
          onColorChanged: (color) => pickedColor = color,
          showLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            onColorSelected(pickedColor);
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
