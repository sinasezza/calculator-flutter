import 'package:flutter/material.dart';

import 'app.dart';

// Re-export the app's public API so `package:calculator/main.dart` stays the
// single entry point (the widget tests import it).
export 'app.dart';
export 'core/theme/app_theme.dart';
export 'features/calculator/data/settings_repository.dart';
export 'features/calculator/domain/expression_evaluator.dart';
export 'features/calculator/domain/history_entry.dart';
export 'features/calculator/presentation/calculator_screen.dart';
export 'features/calculator/presentation/widgets/calculator_button.dart';
export 'features/calculator/presentation/widgets/display_panel.dart';
export 'features/calculator/presentation/widgets/history_drawer.dart';

void main() {
  runApp(const CalculatorApp());
}
