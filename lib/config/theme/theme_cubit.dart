import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_defaultTheme) {
    _loadTheme();
  }

  static const String _themeKey = "isDarkMode";
  static const String _colorKey = "primaryColor";

  static final ThemeData _defaultTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    iconTheme: const IconThemeData(color: Colors.blue),
  );

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool(_themeKey) ?? false;
    int colorValue = prefs.getInt(_colorKey) ?? Colors.blue.value;

    emit(ThemeData(
      primaryColor: Color(colorValue),
      brightness: isDark ? Brightness.dark : Brightness.light,
      iconTheme: IconThemeData(color: Color(colorValue)),
    ));
  }

  Future<void> changeTheme(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorKey, color.value);

    emit(ThemeData(
      primaryColor: color,
      brightness: state.brightness,
      iconTheme: IconThemeData(color: color),
    ));
  }

  Future<void> toggleDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);

    emit(ThemeData(
      primaryColor: state.primaryColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
      iconTheme: IconThemeData(color: state.primaryColor),
    ));
  }
}
