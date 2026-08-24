import 'package:shared_preferences/shared_preferences.dart';

import 'package:calculator/core/theme/app_theme.dart';

/// Data layer: the single place that talks to `shared_preferences`.
///
/// Keys and storage formats are kept identical to the original single-file
/// app so already-saved data (theme, mode, history) keeps working.
class SettingsRepository {
  static const String _themeKey = 'app_theme_option';
  static const String _modeKey = 'calculator_mode';
  static const String _historyKey = 'calculator_history';

  // ---- Theme ----

  static Future<AppThemeOption?> loadThemeOption() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt(_themeKey);
    if (savedIndex == null || savedIndex >= AppThemeOption.values.length) {
      return null;
    }
    return AppThemeOption.values[savedIndex];
  }

  static Future<void> saveThemeOption(AppThemeOption theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, theme.index);
  }

  // ---- Mode ----

  static Future<bool> loadAdvancedMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_modeKey) == 1;
  }

  static Future<void> saveAdvancedMode(bool advanced) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_modeKey, advanced ? 1 : 0);
  }

  // ---- History ----

  static Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_historyKey) ?? <String>[];
  }

  static Future<void> saveHistory(List<String> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, history);
  }
}
