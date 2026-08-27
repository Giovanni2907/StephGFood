import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier {
  ThemeNotifier() : super(ThemeMode.system);

  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  void setThemeMode(ThemeMode mode) => state = mode;
}

final themeNotifierProvider = StateNotifierProvider(
  (ref) => ThemeNotifier(),
);