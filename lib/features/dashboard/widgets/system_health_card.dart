import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/solar_system_model.dart';

/// Hero card showcasing overall rooftop solar health score and active system status.
class SystemHealthCard extends StatelessWidget {
  final SolarSystemSummary summary;
  final VoidCallback? onDetailsTap;

  const SystemHealthCard({super.key, required this.summary, this.onDetailsTap});

  @override
  Widget build(BuildContext context) {
    return SolarCard(
      padding: const EdgeInsets.all(18),
      onTap: onDetailsTap,
      borderColor: AppColors.primaryEmerald.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.mint,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.solar_power_rounded,
                            size: 18,
                            color: AppColors.primaryEmerald,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            summary.systemName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      summary.installationType,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(
                label: summary.isOnline ? 'Online' : 'Offline',
                type: summary.isOnline
                    ? StatusBadgeType.success
                    : StatusBadgeType.danger,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.borderSubtle),
          const SizedBox(height: 16),
          Row(
            children: [
              // Circular health score indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: summary.healthScore / 100,
                      strokeWidth: 7,
                      backgroundColor: AppColors.mint,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryEmerald,
                      ),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${summary.healthScore}%',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Text(
                        'Health',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          summary.healthStatus,
                          style: const TextStyle(
                            color: AppColors.primaryEmerald,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: AppColors.primaryEmerald,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'All 12 rooftop photovoltaic modules operating within normal voltage tolerances.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 13,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Last scan: ${summary.lastScanTime}',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
