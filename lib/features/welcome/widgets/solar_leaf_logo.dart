import 'package:flutter/material.dart';

/// Leaf logo matching the SolarDiagnostics branding in the reference design.
class SolarLeafLogo extends StatelessWidget {
  final double size;

  const SolarLeafLogo({super.key, this.size = 58});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _LeafPainter());
  }
}

class _LeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Right/Top half of leaf (brighter fresh green)
    final rightPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Left/Bottom half of leaf (rich emerald green)
    final leftPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF15803D), Color(0xFF137A4B)],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Center vein (subtle lighter green slit)
    final veinPaint = Paint()
      ..color = const Color(0xFFE8F5EC).withValues(alpha: 0.8)
      ..strokeWidth = w * 0.035
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // Draw Right Leaf Half
    final rightPath = Path()
      ..moveTo(w * 0.28, h * 0.82)
      ..cubicTo(
        w * 0.55,
        h * 0.70,
        w * 0.78,
        h * 0.48,
        w * 0.88,
        h * 0.12, // Tip
      )
      ..cubicTo(w * 0.95, h * 0.42, w * 0.82, h * 0.78, w * 0.45, h * 0.88)
      ..close();

    // Draw Left Leaf Half
    final leftPath = Path()
      ..moveTo(w * 0.28, h * 0.82)
      ..cubicTo(w * 0.18, h * 0.65, w * 0.22, h * 0.35, w * 0.50, h * 0.20)
      ..cubicTo(
        w * 0.68,
        h * 0.12,
        w * 0.80,
        h * 0.10,
        w * 0.88,
        h * 0.12, // Tip
      )
      ..cubicTo(w * 0.70, h * 0.45, w * 0.48, h * 0.68, w * 0.28, h * 0.82)
      ..close();

    // Vein curve from base to near tip
    final veinPath = Path()
      ..moveTo(w * 0.28, h * 0.82)
      ..quadraticBezierTo(w * 0.55, h * 0.55, w * 0.85, h * 0.16);

    canvas.drawPath(leftPath, leftPaint);
    canvas.drawPath(rightPath, rightPaint);
    canvas.drawPath(veinPath, veinPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
