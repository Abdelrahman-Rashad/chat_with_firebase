import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'theme_mode';

  ThemeCubit(this._prefs) : super(const ThemeState()) {
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme != null) {
      emit(ThemeState(
        themeMode: savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light,
      ));
    }
  }

  void toggleTheme() {
    final newThemeMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    emit(state.copyWith(themeMode: newThemeMode));
    _prefs.setString(
        _themeKey, newThemeMode == ThemeMode.dark ? 'dark' : 'light');
  }
}
