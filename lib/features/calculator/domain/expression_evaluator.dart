import 'dart:math' as math;

/// Expression Parser Engine
///
/// Supports: +, −, ×, ÷, %, ^, !, parentheses, unary minus, constants π/e and
/// functions sin, cos, tan, asin, acos, atan, ln, log, √ (all in degrees for
/// the trigonometric functions).
class ExpressionEvaluator {
  final String expression;
  ExpressionEvaluator(this.expression);

  static const Map<String, int> _precedence = {
    '+': 1,
    '−': 1,
    '×': 2,
    '÷': 2,
    '%': 2,
    '^': 3,
    // Unary / prefix operators bind tighter than any binary operator.
    'u−': 5,
    '√': 5,
    'sin': 5,
    'cos': 5,
    'tan': 5,
    'asin': 5,
    'acos': 5,
    'atan': 5,
    'ln': 5,
    'log': 5,
  };

  static const List<String> _functionNames = [
    'asin',
    'acos',
    'atan',
    'sin',
    'cos',
    'tan',
    'ln',
    'log',
  ];

  static const Map<String, String> _constants = {
    'π': '3.141592653589793',
    'e': '2.718281828459045',
  };

  double evaluate() {
    final tokens = _tokenize(expression);
    final rpn = _toRPN(tokens);
    return _evalRPN(rpn);
  }

  List<String> _tokenize(String expr) {
    final List<String> tokens = [];
    String buffer = '';

    int i = 0;
    while (i < expr.length) {
      final char = expr[i];

      if (RegExp(r'[0-9.]').hasMatch(char)) {
        buffer += char;
        i++;
        continue;
      }

      if (buffer.isNotEmpty) {
        tokens.add(buffer);
        buffer = '';
      }

      if (char == ' ') {
        i++;
        continue;
      }

      // Multi-letter function names.
      String? func;
      for (final name in _functionNames) {
        if (expr.startsWith(name, i)) {
          func = name;
          break;
        }
      }
      if (func != null) {
        tokens.add(func);
        i += func.length;
        continue;
      }

      // Constants.
      if (_constants.containsKey(char)) {
        tokens.add(_constants[char]!);
        i++;
        continue;
      }

      // Unary minus: '-' or '−' at the start, after '(' or after an operator.
      if (char == '-' || char == '−') {
        final prev = tokens.isNotEmpty ? tokens.last : null;
        final isUnary =
            prev == null || prev == '(' || _precedence.containsKey(prev);
        tokens.add(isUnary ? 'u−' : '−');
        i++;
        continue;
      }

      tokens.add(char);
      i++;
    }

    if (buffer.isNotEmpty) {
      tokens.add(buffer);
    }
    return tokens;
  }

  List<String> _toRPN(List<String> tokens) {
    final List<String> output = [];
    final List<String> operators = [];

    for (final token in tokens) {
      if (double.tryParse(token) != null) {
        output.add(token);
      } else if (token == '!') {
        // Postfix factorial: emit directly.
        output.add(token);
      } else if (token == '(') {
        operators.add(token);
      } else if (token == ')') {
        while (operators.isNotEmpty && operators.last != '(') {
          output.add(operators.removeLast());
        }
        if (operators.isNotEmpty) {
          operators.removeLast(); // Discard the '('.
        }
      } else if (_precedence.containsKey(token)) {
        final prec = _precedence[token]!;
        final rightAssociative = token == '^';
        while (operators.isNotEmpty &&
            operators.last != '(' &&
            _precedence.containsKey(operators.last)) {
          final topPrec = _precedence[operators.last]!;
          final shouldPop = rightAssociative ? topPrec > prec : topPrec >= prec;
          if (!shouldPop) break;
          output.add(operators.removeLast());
        }
        operators.add(token);
      }
    }

    // Pop remaining operators. Unmatched '(' are treated as auto-closed.
    while (operators.isNotEmpty) {
      if (operators.last == '(') {
        operators.removeLast();
        continue;
      }
      output.add(operators.removeLast());
    }
    return output;
  }

  double _evalRPN(List<String> rpn) {
    final List<double> stack = [];

    for (final token in rpn) {
      final numValue = double.tryParse(token);
      if (numValue != null) {
        stack.add(numValue);
        continue;
      }

      switch (token) {
        case '!':
          final v = stack.removeLast();
          stack.add(_factorial(v.toInt()).toDouble());
          break;
        case 'u−':
          stack.add(-stack.removeLast());
          break;
        case '√':
          stack.add(math.sqrt(stack.removeLast()));
          break;
        case 'sin':
          stack.add(math.sin(_toRadians(stack.removeLast())));
          break;
        case 'cos':
          stack.add(math.cos(_toRadians(stack.removeLast())));
          break;
        case 'tan':
          stack.add(math.tan(_toRadians(stack.removeLast())));
          break;
        case 'asin':
          stack.add(_toDegrees(math.asin(stack.removeLast())));
          break;
        case 'acos':
          stack.add(_toDegrees(math.acos(stack.removeLast())));
          break;
        case 'atan':
          stack.add(_toDegrees(math.atan(stack.removeLast())));
          break;
        case 'ln':
          stack.add(math.log(stack.removeLast()));
          break;
        case 'log':
          stack.add(math.log(stack.removeLast()) / math.ln10);
          break;
        case '+':
          {
            final b = stack.removeLast();
            final a = stack.isNotEmpty ? stack.removeLast() : 0.0;
            stack.add(a + b);
            break;
          }
        case '−':
          {
            final b = stack.removeLast();
            final a = stack.isNotEmpty ? stack.removeLast() : 0.0;
            stack.add(a - b);
            break;
          }
        case '×':
          {
            final b = stack.removeLast();
            final a = stack.isNotEmpty ? stack.removeLast() : 0.0;
            stack.add(a * b);
            break;
          }
        case '÷':
          {
            final b = stack.removeLast();
            if (b == 0) throw Exception('Division by zero');
            final a = stack.isNotEmpty ? stack.removeLast() : 0.0;
            stack.add(a / b);
            break;
          }
        case '%':
          {
            final b = stack.removeLast();
            final a = stack.isNotEmpty ? stack.removeLast() : 0.0;
            stack.add(a % b);
            break;
          }
        case '^':
          {
            final b = stack.removeLast();
            final a = stack.isNotEmpty ? stack.removeLast() : 0.0;
            stack.add(math.pow(a, b).toDouble());
            break;
          }
        default:
          throw Exception('Unknown token: $token');
      }
    }

    if (stack.isEmpty) throw Exception('Empty expression');
    return stack.single;
  }

  static double _toRadians(double deg) => deg * math.pi / 180.0;
  static double _toDegrees(double rad) => rad * 180.0 / math.pi;

  int _factorial(int n) {
    if (n < 0) return 0;
    if (n == 0 || n == 1) return 1;
    int res = 1;
    for (int i = 2; i <= n; i++) {
      res *= i;
    }
    return res;
  }
}
