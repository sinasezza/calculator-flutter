import 'package:flutter/material.dart';

import 'package:calculator/core/theme/app_theme.dart';
import 'package:calculator/features/calculator/data/settings_repository.dart';
import 'package:calculator/features/calculator/domain/expression_evaluator.dart';
import 'package:calculator/features/calculator/domain/history_entry.dart';
import 'package:calculator/features/calculator/presentation/widgets/calculator_button.dart';
import 'package:calculator/features/calculator/presentation/widgets/display_panel.dart';
import 'package:calculator/features/calculator/presentation/widgets/history_drawer.dart';

/// Presentation layer: keyboard input, expression state and screen layout.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  final AppThemeOption currentTheme;
  final ValueChanged<AppThemeOption> onThemeChanged;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  /// Labels that insert a function call, e.g. "sin(".
  static const Set<String> _functionLabels = {
    'sin',
    'cos',
    'tan',
    'asin',
    'acos',
    'atan',
    'ln',
    'log',
    '√',
  };

  String _expression = '';
  String _result = '';
  List<String> _history = [];
  bool _isAdvanced = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadMode();
  }

  Future<void> _loadHistory() async {
    final savedHistory = await SettingsRepository.loadHistory();
    if (!mounted) return;
    setState(() => _history = savedHistory);
  }

  Future<void> _saveHistory() => SettingsRepository.saveHistory(_history);

  Future<void> _loadMode() async {
    final advanced = await SettingsRepository.loadAdvancedMode();
    if (!mounted) return;
    setState(() => _isAdvanced = advanced);
  }

  Future<void> _saveMode() => SettingsRepository.saveAdvancedMode(_isAdvanced);

  void _toggleMode() {
    setState(() => _isAdvanced = !_isAdvanced);
    _saveMode();
  }

  void _onButtonPressed(String label) {
    setState(() {
      if (label == 'AC') {
        _expression = '';
        _result = '';
      } else if (label == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (label == '=') {
        _evaluateExpression();
      } else if (_functionLabels.contains(label)) {
        _expression = '$label(';
      } else {
        _expression += label;
      }
    });
  }

  /// Format timestamp, e.g. "14:05".
  String _formatTimestamp(DateTime now) {
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _evaluateExpression() {
    if (_expression.isEmpty) return;
    try {
      final evaluator = ExpressionEvaluator(_expression);
      final val = evaluator.evaluate();
      String formattedResult;
      if (val.isNaN || val.isInfinite) {
        formattedResult = 'Error';
      } else {
        // Round to 12 significant digits so e.g. sin(30°) shows "0.5".
        final rounded = double.parse(val.toStringAsPrecision(12));
        if (rounded == rounded.roundToDouble() && rounded.abs() < 1e15) {
          formattedResult = rounded.toInt().toString();
        } else {
          formattedResult = rounded.toString();
        }
      }

      final entry = HistoryEntry(
        expression: _expression,
        result: formattedResult,
        time: _formatTimestamp(DateTime.now()),
      );

      setState(() {
        _result = formattedResult;
        // Newest first, keep at most 20 entries.
        _history.insert(0, entry.raw);
        if (_history.length > 20) {
          _history.removeRange(20, _history.length);
        }
      });
      _saveHistory();
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
    _saveHistory();
  }

  void _restoreFromHistory(HistoryEntry entry) {
    setState(() {
      _expression = entry.expression;
      _result = entry.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAdvanced ? 'Advanced Calculator' : 'Calculator'),
        actions: [
          IconButton(
            icon: Icon(_isAdvanced ? Icons.calculate : Icons.functions),
            tooltip: _isAdvanced
                ? 'Switch to Simple mode'
                : 'Switch to Advanced mode',
            onPressed: _toggleMode,
          ),
          PopupMenuButton<AppThemeOption>(
            icon: const Icon(Icons.palette),
            tooltip: 'Select Theme',
            initialValue: widget.currentTheme,
            onSelected: widget.onThemeChanged,
            itemBuilder: (BuildContext context) {
              return AppThemeOption.values.map((AppThemeOption option) {
                return PopupMenuItem<AppThemeOption>(
                  value: option,
                  child: Text(
                    option.name[0].toUpperCase() + option.name.substring(1),
                  ),
                );
              }).toList();
            },
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'History',
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: HistoryDrawer(
        history: _history.map(HistoryEntry.fromRaw).toList(),
        onClear: _clearHistory,
        onSelect: _restoreFromHistory,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Display area
            Expanded(
              flex: 1,
              child: DisplayPanel(expression: _expression, result: _result),
            ),
            // Keypad
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(children: _buildKeypadRows()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildKeypadRows() {
    if (_isAdvanced) {
      return [
        _buildRow(['sin', 'cos', 'tan', 'π', 'AC']),
        _buildRow(['asin', 'acos', 'atan', 'e', '⌫']),
        _buildRow(['ln', 'log', '√', '(', ')']),
        _buildRow(['^', '^2', '%', '!']),
        _buildRow(['7', '8', '9', '÷']),
        _buildRow(['4', '5', '6', '×']),
        _buildRow(['1', '2', '3', '−']),
        _buildRow(['0', '.', '=', '+']),
      ];
    }
    return [
      _buildRow(['AC', '⌫', '%', '÷']),
      _buildRow(['7', '8', '9', '×']),
      _buildRow(['4', '5', '6', '−']),
      _buildRow(['1', '2', '3', '+']),
      _buildRow(['0', '.', '=', '']),
    ];
  }

  Widget _buildRow(List<String> labels) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: labels.map((label) {
          if (label.isEmpty) {
            return const Expanded(child: SizedBox());
          }

          KeyStyle style = KeyStyle.number;
          if (['+', '−', '×', '÷', '^', '!', '%', '^2'].contains(label)) {
            style = KeyStyle.operator;
          } else if ([
            '(',
            ')',
            'AC',
            '⌫',
            'sin',
            'cos',
            'tan',
            'asin',
            'acos',
            'atan',
            'ln',
            'log',
            '√',
            'π',
            'e',
          ].contains(label)) {
            style = KeyStyle.function;
          } else if (label == '=') {
            style = KeyStyle.equals;
          }

          return Expanded(
            child: AnimatedCalcButton(
              label: label,
              style: style,
              fontSize: label.length > 3 ? 16 : 22,
              onPressed: () => _onButtonPressed(label),
            ),
          );
        }).toList(),
      ),
    );
  }
}
