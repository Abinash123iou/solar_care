import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/solar_system_model.dart';

/// Section showing active rooftop diagnostics findings and energy recommendations.
class AlertsSection extends StatelessWidget {
  final List<DiagnosticAlert> alerts;
  final Function(DiagnosticAlert alert)? onAlertTap;

  const AlertsSection({super.key, required this.alerts, this.onAlertTap});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Diagnostic Findings & Tips',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${alerts.length} Active',
                style: const TextStyle(
                  color: AppColors.primaryEmerald,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: alerts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final alert = alerts[index];
            return SolarCard(
              padding: const EdgeInsets.all(14),
              onTap: () => onAlertTap?.call(alert),
              borderColor: alert.badgeType == StatusBadgeType.warning
                  ? const Color(0xFFFDE68A)
                  : AppColors.borderSubtle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: alert.badgeType == StatusBadgeType.warning
                              ? AppColors.statusWarningBg
                              : AppColors.mint,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          alert.icon,
                          size: 18,
                          color: alert.badgeType == StatusBadgeType.warning
                              ? AppColors.statusWarning
                              : AppColors.primaryEmerald,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alert.title,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              alert.timestamp,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(
                        label: alert.severity,
                        type: alert.badgeType,
                        showDot: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    alert.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 15,
                          color: AppColors.primaryEmerald,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            alert.recommendation,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
