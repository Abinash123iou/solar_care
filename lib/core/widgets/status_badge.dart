import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

enum StatusBadgeType { success, warning, danger, info, neutral }

/// Reusable status badge with dot or icon indicator and soft background.
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusBadgeType type;
  final IconData? icon;
  final bool showDot;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = StatusBadgeType.success,
    this.icon,
    this.showDot = true,
  });

  Color _getBackgroundColor() {
    switch (type) {
      case StatusBadgeType.success:
        return AppColors.mint;
      case StatusBadgeType.warning:
        return AppColors.statusWarningBg;
      case StatusBadgeType.danger:
        return AppColors.statusDangerBg;
      case StatusBadgeType.info:
        return AppColors.statusInfoBg;
      case StatusBadgeType.neutral:
        return AppColors.background;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case StatusBadgeType.success:
        return AppColors.primaryEmerald;
      case StatusBadgeType.warning:
        return AppColors.statusWarning;
      case StatusBadgeType.danger:
        return AppColors.statusDanger;
      case StatusBadgeType.info:
        return AppColors.statusInfo;
      case StatusBadgeType.neutral:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getBackgroundColor();
    final textColor = _getTextColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ] else if (showDot) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: textColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
