/// A single row of the calculation history.
///
/// Persisted in `shared_preferences` as the plain string
/// `"expression = result||time"` — byte-compatible with the original app.
class HistoryEntry {
  const HistoryEntry({
    required this.expression,
    required this.result,
    required this.time,
  });

  final String expression;
  final String result;
  final String time;

  /// Text shown in the history list, e.g. `2+3 = 5`.
  String get display => '$expression = $result';

  /// Structured string stored via [SettingsRepository].
  String get raw => '$expression = $result||$time';

  /// Parses a stored entry of the form `"expression = result||time"`.
  factory HistoryEntry.fromRaw(String raw) {
    final parts = raw.split('||');
    final calcText = parts[0];
    final time = parts.length > 1 ? parts[1] : '';
    final eqIndex = calcText.indexOf('=');
    if (eqIndex < 0) {
      return HistoryEntry(expression: calcText.trim(), result: '', time: time);
    }
    return HistoryEntry(
      expression: calcText.substring(0, eqIndex).trim(),
      result: calcText.substring(eqIndex + 1).trim(),
      time: time,
    );
  }
}
