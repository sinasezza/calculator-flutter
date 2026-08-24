import 'package:flutter/material.dart';

/// Shows the current expression (top) and live result (bottom).
class DisplayPanel extends StatelessWidget {
  const DisplayPanel({
    super.key,
    required this.expression,
    required this.result,
  });

  final String expression;
  final String result;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: Theme.of(context).textTheme.headlineLarge!,
              child: Text(expression.isEmpty ? '0' : expression),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.bottomRight,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                child: Text(result),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
