import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// Circular rolling-dial time picker, derived from the Electrify Figma
/// (`Ajastin kellotaululla` / `TimerCombined`, node `160:1502`).
///
/// Drag anywhere on the dial to rotate it: the selected duration changes in
/// 1-minute steps with a haptic tick on every minute boundary. The current
/// value is displayed under the dial. Tapping the green center button fires
/// [onPlayTap] (typically used to navigate to the next step in the charging
/// flow). One full rotation = 60 minutes; the dial supports multiple
/// rotations up to [maxMinutes] (default 180).
class LocationDial extends StatefulWidget {
  const LocationDial({
    super.key,
    this.size = 320,
    this.initialMinutes = 30,
    this.minMinutes = 0,
    this.maxMinutes = 180,
    this.onTimeChanged,
    this.onPlayTap,
  })  : assert(initialMinutes >= minMinutes && initialMinutes <= maxMinutes),
        assert(minMinutes >= 0 && maxMinutes > minMinutes);

  final double size;
  final int initialMinutes;
  final int minMinutes;
  final int maxMinutes;
  final ValueChanged<int>? onTimeChanged;
  final VoidCallback? onPlayTap;

  @override
  State<LocationDial> createState() => _LocationDialState();
}

class _LocationDialState extends State<LocationDial> {
  /// Cumulative rotation in radians from the 12 o'clock origin.
  /// Can exceed 2π for multi-rotation values.
  late double _totalRadians;

  /// Currently selected duration, in whole minutes. Derived from
  /// [_totalRadians] but stored separately so we can fire haptic feedback
  /// only when the rounded value crosses a minute boundary.
  late int _minutes;

  /// Pointer angle (radians from 12 o'clock) recorded on the previous
  /// pan event, used to compute the per-frame angular delta.
  double? _lastPointerAngle;

  static const double _twoPi = math.pi * 2;

  @override
  void initState() {
    super.initState();
    _minutes = widget.initialMinutes;
    _totalRadians = _radiansForMinutes(widget.initialMinutes);
  }

  double _radiansForMinutes(int minutes) => (minutes / 60) * _twoPi;

  /// Angle from the dial center to [local], measured clockwise from
  /// the 12 o'clock position (so 0 = top, π/2 = right, etc).
  double _angleFromCenter(Offset local) {
    final dx = local.dx - widget.size / 2;
    final dy = local.dy - widget.size / 2;
    // atan2(y, x) returns the angle from +x axis, counter-clockwise.
    // Add π/2 so 12 o'clock (negative y in screen coords) maps to 0.
    return math.atan2(dy, dx) + math.pi / 2;
  }

  void _onPanStart(DragStartDetails details) {
    _lastPointerAngle = _angleFromCenter(details.localPosition);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final current = _angleFromCenter(details.localPosition);
    var delta = current - (_lastPointerAngle ?? current);
    // Keep delta in (-π, π] so a small move that crosses the 12 o'clock
    // line registers as a small rotation, not a near-full one.
    if (delta > math.pi) delta -= _twoPi;
    if (delta < -math.pi) delta += _twoPi;

    final maxRad = _radiansForMinutes(widget.maxMinutes);
    final minRad = _radiansForMinutes(widget.minMinutes);
    final next = (_totalRadians + delta).clamp(minRad, maxRad);
    final nextMinutes = (next / _twoPi * 60).round();

    if (nextMinutes != _minutes) {
      HapticFeedback.selectionClick();
      widget.onTimeChanged?.call(nextMinutes);
    }
    setState(() {
      _totalRadians = next;
      _minutes = nextMinutes;
      _lastPointerAngle = current;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _lastPointerAngle = null;
  }

  String _formatMinutes(int m) {
    if (m < 60) return '$m min';
    final hours = m ~/ 60;
    final mins = m % 60;
    return '${hours}h ${mins}min';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          slider: true,
          label: 'Latauksen kesto',
          value: _formatMinutes(_minutes),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _DialPainter(progressRadians: _totalRadians),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onPlayTap,
                  child: Container(
                    width: widget.size * 0.4,
                    height: widget.size * 0.4,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryContainer,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _formatMinutes(_minutes),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({required this.progressRadians});

  /// Cumulative selected rotation. Only the modulo-2π portion drives the
  /// arc/thumb position; the absolute value is the source of truth held by
  /// the parent widget for the displayed time text.
  final double progressRadians;

  static const double _twoPi = math.pi * 2;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final ringRadius = radius - 8;

    // Background ring
    final ringPaint = Paint()
      ..color = AppColors.surfaceContainer
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(center, ringRadius, ringPaint);

    // Progress arc — sweep from 12 o'clock clockwise by the modulo of
    // progressRadians, so each new full rotation visually restarts.
    final sweep = progressRadians % _twoPi;
    if (sweep > 0) {
      final arcPaint = Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: ringRadius),
        -math.pi / 2, // start at 12 o'clock
        sweep,
        false,
        arcPaint,
      );
    }

    // Tick marks + labels (5, 10, … 60 — 5-minute increments)
    final tickPaint = Paint()
      ..color = AppColors.onSurface
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const labelStyle = TextStyle(
      color: AppColors.onSurface,
      fontSize: 18,
      fontFamily: 'Roboto',
    );

    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30 - 90) * math.pi / 180;
      final inner = center +
          Offset(
            (radius - 28) * math.cos(angle),
            (radius - 28) * math.sin(angle),
          );
      final outer = center +
          Offset(
            (radius - 16) * math.cos(angle),
            (radius - 16) * math.sin(angle),
          );
      canvas.drawLine(inner, outer, tickPaint);

      final labelPos = center +
          Offset(
            (radius - 44) * math.cos(angle),
            (radius - 44) * math.sin(angle),
          );
      final tp = TextPainter(
        text: TextSpan(text: '${i * 5}', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        labelPos - Offset(tp.width / 2, tp.height / 2),
      );
    }

    // Thumb knob at the end of the arc — only when the user has moved
    // off the 12 o'clock origin.
    if (sweep > 0) {
      final thumbAngle = -math.pi / 2 + sweep;
      final thumbPos = center +
          Offset(
            ringRadius * math.cos(thumbAngle),
            ringRadius * math.sin(thumbAngle),
          );
      final thumbFill = Paint()..color = AppColors.primary;
      final thumbBorder = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(thumbPos, 10, thumbFill);
      canvas.drawCircle(thumbPos, 10, thumbBorder);
    }
  }

  @override
  bool shouldRepaint(covariant _DialPainter oldDelegate) =>
      oldDelegate.progressRadians != progressRadians;
}
