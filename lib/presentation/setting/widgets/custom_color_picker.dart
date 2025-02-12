import 'package:flutter/material.dart';

class CustomColorPicker extends StatelessWidget {
  final VoidCallback onTap;
  final Color? selectedColor;

  const CustomColorPicker({
    required this.onTap,
    required this.selectedColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selectedColor ?? Colors.grey.shade300, width: 2),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.colorize, color: selectedColor),
      ),
    );
  }
}
