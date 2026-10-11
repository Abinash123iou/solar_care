import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';
import '../models/diagnostic_result_model.dart';

/// System Health or Diagnostic Overview Card
class DiagnosticOverviewCard extends StatelessWidget {
  final DiagnosticReportResult result;

  const DiagnosticOverviewCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    // If empty or no findings available yet
    if (result.status == DiagnosticStatus.empty ||
        (result.measurements.isEmpty && result.findings.isEmpty)) {
      return SolarCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_empty_rounded,
                color: Color(0xFFD97706),
                size: 26,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Awaiting Analysis',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your report has been submitted. Diagnostic results are not available yet.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SolarCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title & Severity Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SYSTEM HEALTH OVERVIEW',
                style: TextStyle(
                  color: Color(0xFF6B8274),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: result.severity.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: result.severity.color.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: result.severity.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      result.severity.label,
                      style: TextStyle(
                        color: result.severity.color,
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

          // Overall status banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD6EAE0)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.health_and_safety_rounded,
                  color: AppColors.primaryEmerald,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.overallHealthStatus,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Category: ${result.suspectedCategory}',
                        style: const TextStyle(
                          color: Color(0xFF5A7265),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (result.measurements.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Diagnostic Telemetry Readings',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),

            // Grid / Row of diagnostic measurements
            ...result.measurements.map((m) => _buildMeasurementTile(m)),
          ],

          const SizedBox(height: 14),

          // Clarification notice: rule engine demo output
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAF8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5EDE8)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: Color(0xFF6B8274),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Evaluated via rule-engine algorithms against inverter baseline. Physical on-site inspection recommended.',
                    style: TextStyle(
                      color: Color(0xFF6B8274),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementTile(DiagnosticMeasurement m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: m.isWarning
              ? const Color(0xFFFCD34D)
              : const Color(0xFFE2EDE6),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.label,
                  style: const TextStyle(
                    color: Color(0xFF5A7265),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Nominal: ${m.normalRange}',
                  style: const TextStyle(
                    color: Color(0xFF8A9F93),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                m.value,
                style: TextStyle(
                  color: m.isWarning
                      ? const Color(0xFFD97706)
                      : AppColors.primaryEmerald,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: m.isWarning
                      ? const Color(0xFFFEF3C7)
                      : const Color(0xFFE8F5EC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  m.status,
                  style: TextStyle(
                    color: m.isWarning
                        ? const Color(0xFFB45309)
                        : AppColors.primaryEmerald,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
