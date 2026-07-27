// lib/viewmodel/theme_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends ChangeNotifier {
  static const String _themeKey = 'is_dark_mode';
  bool _isDarkMode = false;

  // Getter
  bool get isDarkMode => _isDarkMode;

  // Cargar preferencia de tema desde SharedPreferences
  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
      notifyListeners();
    } catch (e) {
      // Si hay error, usar el valor por defecto (false = modo claro)
      _isDarkMode = false;
      notifyListeners();
    }
  }

  // Cambiar tema y guardar preferencia
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
      notifyListeners();
    } catch (e) {
      // Si hay error al guardar, revertir el cambio
      _isDarkMode = !_isDarkMode;
      notifyListeners();
    }
  }

  // Método para establecer un tema específico
  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_themeKey, _isDarkMode);
        notifyListeners();
      } catch (e) {
        // Si hay error al guardar, revertir el cambio
        _isDarkMode = !isDark;
        notifyListeners();
      }
    }
  }
}