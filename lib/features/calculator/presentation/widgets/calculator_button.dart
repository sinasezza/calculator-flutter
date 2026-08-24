import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum KeyStyle { number, operator, function, equals }

class AnimatedCalcButton extends StatefulWidget {
  const AnimatedCalcButton({
    super.key,
    required this.label,
    required this.style,
    required this.onPressed,
    this.fontSize = 22,
  });

  final String label;
  final KeyStyle style;
  final VoidCallback onPressed;
  final double fontSize;

  @override
  State<AnimatedCalcButton> createState() => _AnimatedCalcButtonState();
}

class _AnimatedCalcButtonState extends State<AnimatedCalcButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Color background;
    Color foreground;

    switch (widget.style) {
      case KeyStyle.operator:
        background = colors.primaryContainer;
        foreground = colors.onPrimaryContainer;
      case KeyStyle.function:
        background = colors.secondaryContainer;
        foreground = colors.onSecondaryContainer;
      case KeyStyle.equals:
        background = colors.primary;
        foreground = colors.onPrimary;
      case KeyStyle.number:
        background = colors.surfaceContainerHighest;
        foreground = colors.onSurface;
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            final scale = 1.0 - _controller.value;
            return Transform.scale(scale: scale, child: child);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              widget.label,
              style: TextStyle(
                color: foreground,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
