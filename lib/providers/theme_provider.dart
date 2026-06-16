import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _themeKey = 'devpulse_theme_mode';

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.dark;
  }

  bool get isDarkMode => state == ThemeMode.dark;

  Future<void> toggleTheme() async {
    state = isDarkMode ? ThemeMode.light : ThemeMode.dark;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? true;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeNotifierProvider =
    NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);

final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(themeNotifierProvider) == ThemeMode.dark;
});
