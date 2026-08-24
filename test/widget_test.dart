import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calculator/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> tapKey(WidgetTester tester, String label) async {
    await tester.tap(find.widgetWithText(AnimatedCalcButton, label));
    await tester.pump();
  }

  Future<void> expectDisplay(WidgetTester tester, String value) async {
    await tester.pump();
    expect(
      find.descendant(of: find.byType(Scaffold), matching: find.text(value)),
      findsWidgets,
    );
  }

  Future<void> switchToAdvanced(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.functions));
    await tester.pumpAndSettle();
  }

  testWidgets('addition: 2 + 3 = 5', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tapKey(tester, '2');
    await tapKey(tester, '+');
    await tapKey(tester, '3');
    await tapKey(tester, '=');

    await expectDisplay(tester, '5');
  });

  testWidgets('subtraction: 9 - 4 = 5', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tapKey(tester, '9');
    await tapKey(tester, '−');
    await tapKey(tester, '4');
    await tapKey(tester, '=');

    await expectDisplay(tester, '5');
  });

  testWidgets('multiplication: 6 x 7 = 42', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tapKey(tester, '6');
    await tapKey(tester, '×');
    await tapKey(tester, '7');
    await tapKey(tester, '=');

    await expectDisplay(tester, '42');
  });

  testWidgets('division: 8 / 2 = 4', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tapKey(tester, '8');
    await tapKey(tester, '÷');
    await tapKey(tester, '2');
    await tapKey(tester, '=');

    await expectDisplay(tester, '4');
  });

  testWidgets('division by zero shows Error', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tapKey(tester, '5');
    await tapKey(tester, '÷');
    await tapKey(tester, '0');
    await tapKey(tester, '=');

    await expectDisplay(tester, 'Error');
  });

  testWidgets('AC clears display', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tapKey(tester, '7');
    await tapKey(tester, 'AC');

    await expectDisplay(tester, '0');
  });

  testWidgets('unary minus: -3 + 5 = 2', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await tapKey(tester, '−');
    await tapKey(tester, '3');
    await tapKey(tester, '+');
    await tapKey(tester, '5');
    await tapKey(tester, '=');

    await expectDisplay(tester, '2');
  });

  testWidgets('power: 2 ^ 3 = 8', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await switchToAdvanced(tester);

    await tapKey(tester, '2');
    await tapKey(tester, '^');
    await tapKey(tester, '3');
    await tapKey(tester, '=');

    await expectDisplay(tester, '8');
  });

  testWidgets('factorial: 5 ! = 120', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await switchToAdvanced(tester);

    await tapKey(tester, '5');
    await tapKey(tester, '!');
    await tapKey(tester, '=');

    await expectDisplay(tester, '120');
  });

  testWidgets('sin(30) = 0.5 in degrees', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await switchToAdvanced(tester);

    await tapKey(tester, 'sin');
    await tapKey(tester, '3');
    await tapKey(tester, '0');
    await tapKey(tester, ')');
    await tapKey(tester, '=');

    await expectDisplay(tester, '0.5');
  });

  testWidgets('cos(60) = 0.5 in degrees', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await switchToAdvanced(tester);

    await tapKey(tester, 'cos');
    await tapKey(tester, '6');
    await tapKey(tester, '0');
    await tapKey(tester, ')');
    await tapKey(tester, '=');

    await expectDisplay(tester, '0.5');
  });

  testWidgets('sqrt(9) = 3', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await switchToAdvanced(tester);

    await tapKey(tester, '√');
    await tapKey(tester, '9');
    await tapKey(tester, ')');
    await tapKey(tester, '=');

    await expectDisplay(tester, '3');
  });

  testWidgets('log(100) = 2', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await switchToAdvanced(tester);

    await tapKey(tester, 'log');
    await tapKey(tester, '1');
    await tapKey(tester, '0');
    await tapKey(tester, '0');
    await tapKey(tester, ')');
    await tapKey(tester, '=');

    await expectDisplay(tester, '2');
  });

  testWidgets('pi constant displays 3.14159265359', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    await switchToAdvanced(tester);

    await tapKey(tester, 'π');
    await tapKey(tester, '=');

    await expectDisplay(tester, '3.14159265359');
  });

  testWidgets('mode toggle switches between simple and advanced', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());

    // Simple mode: no scientific keys.
    expect(find.widgetWithText(AnimatedCalcButton, 'sin'), findsNothing);

    // Switch to advanced.
    await tester.tap(find.byIcon(Icons.functions));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AnimatedCalcButton, 'sin'), findsOneWidget);
    expect(find.widgetWithText(AnimatedCalcButton, 'cos'), findsOneWidget);
    expect(find.widgetWithText(AnimatedCalcButton, 'π'), findsOneWidget);

    // Switch back to simple.
    await tester.tap(find.byIcon(Icons.calculate));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AnimatedCalcButton, 'sin'), findsNothing);
  });

  testWidgets('mode is persisted and restored', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    await switchToAdvanced(tester);
    expect(find.widgetWithText(AnimatedCalcButton, 'sin'), findsOneWidget);

    // Simulate fresh app launch (new widget tree, same stored prefs).
    await tester.pumpWidget(Container());
    await tester.pumpWidget(const CalculatorApp());
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AnimatedCalcButton, 'sin'), findsOneWidget);
  });

  testWidgets('theme menu switches between light and dark', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());

    // Starts in light mode.
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).theme?.brightness,
      Brightness.light,
    );

    // Open theme menu and pick Dark.
    await tester.tap(find.byIcon(Icons.palette));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).theme?.brightness,
      Brightness.dark,
    );

    // Switch back to Light.
    await tester.tap(find.byIcon(Icons.palette));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).theme?.brightness,
      Brightness.light,
    );
  });

  testWidgets('theme mode is persisted and restored', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());

    // Switch to dark mode.
    await tester.tap(find.byIcon(Icons.palette));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).theme?.brightness,
      Brightness.dark,
    );

    // Simulate fresh app launch (new widget tree, same stored prefs).
    await tester.pumpWidget(Container());
    await tester.pumpWidget(const CalculatorApp());
    await tester.pumpAndSettle();

    // Dark mode restored from shared_preferences.
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).theme?.brightness,
      Brightness.dark,
    );
  });
}
