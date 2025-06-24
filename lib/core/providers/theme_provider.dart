import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(_lightTheme);

  static final _lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
  );

  void toggleTheme() {
    state = state.brightness == Brightness.light
        ? ThemeData.dark()
        : _lightTheme;
  }
}
