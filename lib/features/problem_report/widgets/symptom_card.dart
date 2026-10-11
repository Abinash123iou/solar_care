import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../models/problem_report_model.dart';

/// Selectable symptom card matching the reference design layout and styling.
class SymptomCard extends StatelessWidget {
  final SymptomCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const SymptomCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = isSelected
        ? AppColors.primaryEmerald
        : AppColors.borderSubtle;

    final effectiveBgColor = isSelected
        ? AppColors.mintLight
        : AppColors.surface;

    final defaultIconColor =
        category.customIconColor ?? AppColors.primaryEmerald;
    final iconColor = isSelected ? AppColors.primaryEmerald : defaultIconColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: isSelected ? 1.8 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.primaryEmerald.withValues(alpha: 0.12)
                : AppColors.shadow,
            blurRadius: isSelected ? 10 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          onTap: onTap,
          child: Stack(
            children: [
              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                child: category.isFullWidth
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category.icon, size: 26, color: iconColor),
                          const SizedBox(width: 12),
                          Text(
                            category.label,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primaryEmerald
                                  : AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(category.icon, size: 32, color: iconColor),
                            const SizedBox(height: 10),
                            Text(
                              category.label,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primaryEmerald
                                    : AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
              ),

              // Selected check indicator badge in top right
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryEmerald,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
