import 'package:flutter/material.dart';

import 'package:calculator/core/theme/app_theme.dart';
import 'package:calculator/features/calculator/data/settings_repository.dart';
import 'package:calculator/features/calculator/presentation/calculator_screen.dart';

/// Root widget: owns the selected theme and persists it.
class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  AppThemeOption _currentTheme = AppThemeOption.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final saved = await SettingsRepository.loadThemeOption();
    if (!mounted) return;
    if (saved != null) {
      setState(() => _currentTheme = saved);
    }
  }

  void _changeTheme(AppThemeOption theme) {
    setState(() => _currentTheme = theme);
    SettingsRepository.saveThemeOption(theme);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = AppThemes.getTheme(_currentTheme);

    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: AnimatedTheme(
        data: themeData,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        child: CalculatorScreen(
          currentTheme: _currentTheme,
          onThemeChanged: _changeTheme,
        ),
      ),
    );
  }
}
