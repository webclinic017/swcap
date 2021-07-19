import 'package:flutter/material.dart';

class CustomTheme with ChangeNotifier {
    static bool _isDarkTheme = true;
  ThemeMode get currentTheme  => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }
}