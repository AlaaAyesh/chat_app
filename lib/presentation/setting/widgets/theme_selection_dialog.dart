import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../config/theme/theme_cubit.dart';

class ThemeSelectionDialog extends StatefulWidget {
  @override
  _ThemeSelectionDialogState createState() => _ThemeSelectionDialogState();
}

class _ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  Color? _selectedColor;
  bool _customSelected = false;

  final List<Color> _availableColors = const [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.red,
    Colors.cyan,
    Colors.black,
    Colors.yellow
  ];

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        Color pickedColor = _selectedColor ?? Colors.blue;
        return AlertDialog(
          title: const Text("Choose Accent Color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickedColor,
              onColorChanged: (color) {
                pickedColor = color;
              },
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
                setState(() {
                  _selectedColor = pickedColor;
                  _customSelected = true;
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Theme"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Predefined Theme Options
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _availableColors.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                    _customSelected = false;
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedColor == color ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: _selectedColor == color
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Custom Color Picker
          GestureDetector(
            onTap: _openColorPicker,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _customSelected ? _selectedColor : Colors.grey.shade300,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: _customSelected
                  ? const Icon(Icons.check, color: Colors.white)
                  : const Icon(Icons.palette, color: Colors.black),
            ),
          ),

          const SizedBox(height: 16),

          // Confirm Button
          ElevatedButton(
            onPressed: _selectedColor != null
                ? () {
              context.read<ThemeCubit>().changeTheme(_selectedColor!);
              Navigator.pop(context);
            }
                : null,
            child: const Text("Apply Theme"),
          ),
        ],
      ),
    );
  }
}
