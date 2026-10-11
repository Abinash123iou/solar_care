import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/solar_card.dart';

/// Side-by-side status cards matching the reference screenshot:
/// [Check Icon | System Status: Normal] and [Clock Icon | Latest Reading: 2:45 PM]
class StatusSummaryRow extends StatelessWidget {
  final String systemStatus;
  final String latestReadingTime;
  final VoidCallback? onStatusTap;
  final VoidCallback? onReadingTap;

  const StatusSummaryRow({
    super.key,
    this.systemStatus = 'Normal',
    this.latestReadingTime = '2:45 PM',
    this.onStatusTap,
    this.onReadingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left Card: System Status Normal
        Expanded(
          child: SolarCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            borderRadius: AppTheme.cardRadius,
            onTap: onStatusTap,
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 26,
                  color: Color(0xFF1EAB68),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'System Status',
                        style: TextStyle(
                          color: Color(0xFF5E7368),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        systemStatus,
                        style: const TextStyle(
                          color: Color(0xFF1EAB68),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Right Card: Latest Reading 2:45 PM
        Expanded(
          child: SolarCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            borderRadius: AppTheme.cardRadius,
            onTap: onReadingTap,
            child: Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 26,
                  color: Color(0xFF1EAB68),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Latest Reading',
                        style: TextStyle(
                          color: Color(0xFF5E7368),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        latestReadingTime,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
