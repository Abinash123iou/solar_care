import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';
import '../models/diagnostic_result_model.dart';

/// Card presenting an actionable recommendation step with safety warnings and technician advice
class RecommendationCard extends StatelessWidget {
  final DiagnosticRecommendation recommendation;

  const RecommendationCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    final isSafety = recommendation.isSafetyWarning;
    final isTech = recommendation.isProfessionalRequired;

    return SolarCard(
      borderColor: isSafety
          ? const Color(0xFFFCA5A5)
          : isTech
          ? const Color(0xFFBAE6FD)
          : null,
      backgroundColor: isSafety
          ? const Color(0xFFFFF7F7)
          : isTech
          ? const Color(0xFFF0F9FF)
          : null,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number circle or warning icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isSafety
                  ? const Color(0xFFFEE2E2)
                  : isTech
                  ? const Color(0xFFE0F2FE)
                  : AppColors.mint,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isSafety
                  ? const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFDC2626),
                      size: 18,
                    )
                  : isTech
                  ? const Icon(
                      Icons.engineering_rounded,
                      color: Color(0xFF0284C7),
                      size: 18,
                    )
                  : Text(
                      '${recommendation.stepNumber}',
                      style: const TextStyle(
                        color: AppColors.primaryEmerald,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        recommendation.title,
                        style: TextStyle(
                          color: isSafety
                              ? const Color(0xFF991B1B)
                              : AppColors.textPrimary,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  recommendation.description,
                  style: TextStyle(
                    color: isSafety
                        ? const Color(0xFF7F1D1D)
                        : AppColors.textSecondary,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),

                if (isTech) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 13,
                          color: Color(0xFF0284C7),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Certified Solar Technician Recommended',
                          style: TextStyle(
                            color: Color(0xFF0369A1),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
