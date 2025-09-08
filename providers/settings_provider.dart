import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

enum AppLanguage {
  french,
  english,
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';

  SettingsNotifier(this._prefs)
      : super(SettingsState(
          themeMode: AppThemeMode.values[_prefs.getInt(_themeKey) ?? 0],
          language: AppLanguage.values[_prefs.getInt(_languageKey) ?? 0],
        ));

  Future<void> setThemeMode(AppThemeMode mode) async {
    await _prefs.setInt(_themeKey, mode.index);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLanguage(AppLanguage language) async {
    await _prefs.setInt(_languageKey, language.index);
    state = state.copyWith(language: language);
  }

  ThemeMode get themeMode {
    switch (state.themeMode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  String get languageName {
    switch (state.language) {
      case AppLanguage.french:
        return 'Français';
      case AppLanguage.english:
        return 'English';
    }
  }
}

class SettingsState {
  final AppThemeMode themeMode;
  final AppLanguage language;

  const SettingsState({
    required this.themeMode,
    required this.language,
  });

  SettingsState copyWith({
    AppThemeMode? themeMode,
    AppLanguage? language,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  throw UnimplementedError(
      'SettingsProvider must be initialized with SharedPreferences');
});

final settingsNotifierProvider = Provider<SettingsNotifier>((ref) {
  throw UnimplementedError(
      'SettingsNotifierProvider must be initialized with SharedPreferences');
});
