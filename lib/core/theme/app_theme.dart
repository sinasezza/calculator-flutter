import 'package:flutter/material.dart';

enum AppThemeOption { light, dark, solarized, cyberpunk }

class AppThemes {
  static ThemeData getTheme(AppThemeOption option) {
    switch (option) {
      case AppThemeOption.light:
        return ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        );
      case AppThemeOption.dark:
        return ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFD0BCFF),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        );
      case AppThemeOption.solarized:
        return ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFB58900),
            surface: const Color(0xFFFDF6E3),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFFDF6E3),
          useMaterial3: true,
        );
      case AppThemeOption.cyberpunk:
        return ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF007F),
            surface: const Color(0xFF120024),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF120024),
          useMaterial3: true,
        );
    }
  }
}
