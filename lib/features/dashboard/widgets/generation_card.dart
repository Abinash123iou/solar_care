import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/solar_card.dart';
import 'generation_chart.dart';

/// Hero Generation card matching the reference screenshot:
/// - "Today's Generation" header + "Live Data" mint pill
/// - "18.4 kWh" prominent generation stat
/// - "▲ 12% vs. yesterday" green trend indicator
/// - Wave sparkline chart on the right with smooth emerald gradient
class GenerationCard extends StatelessWidget {
  final double generationKwh;
  final String trendText;
  final bool isLive;
  final VoidCallback? onTap;

  const GenerationCard({
    super.key,
    this.generationKwh = 18.4,
    this.trendText = '12% vs. yesterday',
    this.isLive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SolarCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      borderRadius: AppTheme.cardRadius,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: "Today's Generation" and "Live Data" badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Generation",
                style: TextStyle(
                  color: Color(0xFF3B5246),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLive) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryEmerald,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    const Text(
                      'Live Data',
                      style: TextStyle(
                        color: AppColors.primaryEmerald,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Content row: Large generation metric on left, sparkline wave on right
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Metric and Trend
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: generationKwh.toStringAsFixed(1),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const TextSpan(
                          text: ' kWh',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_drop_up_rounded,
                        size: 20,
                        color: Color(0xFF1EAB68),
                      ),
                      Text(
                        trendText,
                        style: const TextStyle(
                          color: Color(0xFF1EAB68),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Sparkline wave graph
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: GenerationSparkline(width: 140, height: 60),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
