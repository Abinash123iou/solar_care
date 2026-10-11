import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Diagnosis Processing View matching Screen Reference: "5. Diagnosis Processing"
/// Shows progress indicator and step-by-step checklist while AWS Lambda / rule engine runs analysis.
class DiagnosisProcessingWidget extends StatefulWidget {
  final VoidCallback onComplete;
  final bool autoAdvance;

  const DiagnosisProcessingWidget({
    super.key,
    required this.onComplete,
    this.autoAdvance = true,
  });

  @override
  State<DiagnosisProcessingWidget> createState() =>
      _DiagnosisProcessingWidgetState();
}

class _DiagnosisProcessingWidgetState extends State<DiagnosisProcessingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  int _currentStep = 0; // 0, 1, 2, 3, 4 (completed)

  static const List<String> _steps = [
    'Validating your input',
    'Checking recent readings',
    'Running diagnostic rules',
    'Preparing explanation',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _animController.addListener(() {
      final progress = _animController.value;
      final step = (progress * _steps.length).clamp(0, _steps.length).toInt();
      if (step != _currentStep && mounted) {
        setState(() {
          _currentStep = step;
        });
      }
    });

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          widget.autoAdvance &&
          mounted) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            widget.onComplete();
          }
        });
      }
    });

    if (widget.autoAdvance) {
      _animController.forward();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),

            // Top Circular Progress Indicator with Sun & Solar Panel Icon (Matching reference image)
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return _buildCircularProgress(_animController.value);
              },
            ),

            const SizedBox(height: 36),

            // Title: Analyzing Your Solar System (Matching reference image)
            const Text(
              'Analyzing Your Solar System',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // Subtitle: Our system is checking your data and looking for possible causes...
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Our system is checking your data and looking for possible causes...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 36),

            // Checklist of 4 analysis steps (Matching reference image)
            Container(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Column(
                children: List.generate(_steps.length, (index) {
                  final isDone = _currentStep > index;
                  final isInProgress =
                      _currentStep == index && _animController.isAnimating;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        // Step status indicator
                        _buildStepIndicator(
                          isDone: isDone,
                          isInProgress: isInProgress,
                        ),
                        const SizedBox(width: 14),
                        // Step label
                        Expanded(
                          child: Text(
                            _steps[index],
                            style: TextStyle(
                              color: isDone || isInProgress
                                  ? AppColors.textPrimary
                                  : const Color(0xFF7A9285),
                              fontSize: 15,
                              fontWeight: isDone
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 48),

            // Footnote Pill: "This usually takes less than a minute." (Matching reference image)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5EC), // Mint background
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFD4EEDD)),
              ),
              child: const Text(
                'This usually takes less than a minute.',
                style: TextStyle(
                  color: Color(0xFF1B6A45),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgress(double progress) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle & animated stroke
          CustomPaint(
            size: const Size(140, 140),
            painter: _SolarArcPainter(progress: progress),
          ),

          // Center Icon: Sun + Solar panel
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryEmerald.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.solar_power_rounded,
                size: 42,
                color: AppColors.primaryEmerald,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator({
    required bool isDone,
    required bool isInProgress,
  }) {
    if (isDone) {
      return Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
          color: AppColors.primaryEmerald,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.check_rounded, color: Colors.white, size: 15),
        ),
      );
    }

    if (isInProgress) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.primaryEmerald,
          ),
          backgroundColor: AppColors.mint,
        ),
      );
    }

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFB0C4B8), width: 1.8),
      ),
    );
  }
}

/// Custom painter for the circular progress arc with emerald gradient
class _SolarArcPainter extends CustomPainter {
  final double progress;

  _SolarArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 14) / 2;

    // Background track ring
    final bgPaint = Paint()
      ..color = const Color(0xFFE2F3E7)
      ..strokeWidth = 9.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Active progress arc
    final sweepAngle = 2 * math.pi * progress.clamp(0.05, 1.0);
    final activePaint = Paint()
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [
          Color(0xFF26B072),
          AppColors.primaryEmerald,
          Color(0xFF0E5D38),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 9.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SolarArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
