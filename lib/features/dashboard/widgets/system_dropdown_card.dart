import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/solar_card.dart';

/// System Selector card matching the screenshot:
/// [Solar Grid Icon in Green Circle] [Home Solar System \n 5 kW] [Down Arrow]
class SystemDropdownCard extends StatelessWidget {
  final String systemName;
  final String capacity;
  final VoidCallback? onTap;

  const SystemDropdownCard({
    super.key,
    this.systemName = 'Home Solar System',
    this.capacity = '5 kW',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SolarCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: AppTheme.cardRadius,
      onTap: onTap,
      child: Row(
        children: [
          // Green rounded circle with solar panel grid
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primaryEmerald,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.grid_view_rounded,
                size: 22,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // System title and capacity
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  systemName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  capacity,
                  style: const TextStyle(
                    color: Color(0xFF5A7064),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Downward arrow chevron
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 24,
            color: Color(0xFF334A3E),
          ),
        ],
      ),
    );
  }
}
