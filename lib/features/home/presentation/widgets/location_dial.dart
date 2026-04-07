import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Circular clock-face dial from the Electrify Figma
/// (`Ajastin kellotaululla` / `TimerCombined`, node `160:1502`).
///
/// Renders 12 hour markers and a centered play button. Pure visual —
/// no timer math here. // TODO(logic): wire to a charging-state provider.
class LocationDial extends StatelessWidget {
  const LocationDial({
    super.key,
    this.size = 320,
    this.onPlayTap,
  });

  final double size;
  final VoidCallback? onPlayTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DialPainter(),
          ),
          GestureDetector(
            onTap: onPlayTap,
            child: Container(
              width: size * 0.4,
              height: size * 0.4,
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
    );
  }
}

class _DialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final ringPaint = Paint()
      ..color = AppColors.surfaceContainer
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    canvas.drawCircle(center, radius - 8, ringPaint);

    final tickPaint = Paint()
      ..color = AppColors.onSurface
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final textStyle = TextStyle(
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
        text: TextSpan(text: '$i', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        labelPos - Offset(tp.width / 2, tp.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
