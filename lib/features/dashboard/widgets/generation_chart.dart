import 'package:flutter/material.dart';

/// Custom painter for the solar generation wave sparkline chart
/// matching the exact curve and green gradient fill in the reference design.
class GenerationSparkline extends StatelessWidget {
  final double width;
  final double height;

  const GenerationSparkline({super.key, this.width = 130, this.height = 65});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _SparklinePainter()),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF1EAB68)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Normalizing coordinates across the width & height
    // Points mimic the exact wave in reference:
    // start (0, 0.75), up to (0.2, 0.65), down to (0.35, 0.72),
    // rise to peak (0.6, 0.25), drop to (0.8, 0.45), high finish at (1.0, 0.12)
    final path = Path();
    path.moveTo(0, size.height * 0.85);

    path.cubicTo(
      size.width * 0.12,
      size.height * 0.82,
      size.width * 0.22,
      size.height * 0.62,
      size.width * 0.35,
      size.height * 0.68,
    );

    path.cubicTo(
      size.width * 0.48,
      size.height * 0.72,
      size.width * 0.55,
      size.height * 0.18,
      size.width * 0.68,
      size.height * 0.28,
    );

    path.cubicTo(
      size.width * 0.78,
      size.height * 0.36,
      size.width * 0.88,
      size.height * 0.55,
      size.width * 1.0,
      size.height * 0.15,
    );

    // Gradient fill path
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF1EAB68).withValues(alpha: 0.28),
          const Color(0xFF1EAB68).withValues(alpha: 0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
