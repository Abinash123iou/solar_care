import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';
import '../models/diagnostic_result_model.dart';

/// Card displaying an individual diagnostic finding with evidence and confidence tags
class DiagnosticFindingCard extends StatelessWidget {
  final DiagnosticFinding finding;

  const DiagnosticFindingCard({super.key, required this.finding});

  @override
  Widget build(BuildContext context) {
    return SolarCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Status tag (Suspected vs Confirmed) & Confidence
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Suspected vs Confirmed Fault Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: finding.isSuspected
                      ? const Color(0xFFFEF3C7) // Amber/Yellow for Suspected
                      : const Color(0xFFFEE2E2), // Red/Pink for Confirmed Fault
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      finding.isSuspected
                          ? Icons.help_outline_rounded
                          : Icons.error_rounded,
                      size: 13,
                      color: finding.isSuspected
                          ? const Color(0xFFB45309)
                          : const Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      finding.isSuspected
                          ? 'Suspected Issue'
                          : 'Confirmed Fault',
                      style: TextStyle(
                        color: finding.isSuspected
                            ? const Color(0xFFB45309)
                            : const Color(0xFFDC2626),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Confidence badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5EC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_graph_rounded,
                      size: 13,
                      color: AppColors.primaryEmerald,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Confidence: ${finding.confidencePercentage}',
                      style: const TextStyle(
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

          // Title
          Text(
            finding.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 6),

          // Explanation
          Text(
            finding.explanation,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 12),

          // Supporting evidence box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF6FAF7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE0ECE4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.analytics_outlined,
                  size: 16,
                  color: AppColors.primaryEmerald,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Supporting Telemetry Evidence',
                        style: TextStyle(
                          color: Color(0xFF335041),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        finding.supportingEvidence,
                        style: const TextStyle(
                          color: Color(0xFF5A7265),
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
