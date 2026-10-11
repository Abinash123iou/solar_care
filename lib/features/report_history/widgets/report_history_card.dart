import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';
import '../models/report_history_entry.dart';

/// Clean rounded card presenting an individual submitted problem report
class ReportHistoryCard extends StatelessWidget {
  final ReportHistoryEntry entry;
  final VoidCallback onTap;

  const ReportHistoryCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final month = months[dt.month - 1];
      return '$month ${dt.day}, ${dt.year}';
    }
  }

  Widget _buildPhotoThumbnail(String uri) {
    Widget imageWidget;
    if (uri.startsWith('http://') || uri.startsWith('https://')) {
      imageWidget = Image.network(
        uri,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallbackThumbnail(),
      );
    } else {
      try {
        final file = File(uri);
        if (file.existsSync()) {
          imageWidget = Image.file(file, fit: BoxFit.cover);
        } else {
          imageWidget = _fallbackThumbnail();
        }
      } catch (_) {
        imageWidget = _fallbackThumbnail();
      }
    }

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1EC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0ECE4)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: imageWidget,
      ),
    );
  }

  Widget _fallbackThumbnail() {
    return const Center(
      child: Icon(
        Icons.solar_power_rounded,
        size: 22,
        color: AppColors.primaryEmerald,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = entry.status;
    final primaryPhoto = entry.primaryPhoto;

    return SolarCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: [Report ID + Date] and [Status Badge]
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      entry.reportId,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8A9F93),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(entry.submittedAt),
                      style: const TextStyle(
                        color: Color(0xFF7A9386),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: status.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: status.color.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(status.icon, size: 12, color: status.color),
                    const SizedBox(width: 4),
                    Text(
                      status.label,
                      style: TextStyle(
                        color: status.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Problem Title & Error Code Pill (if present)
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.primaryCategory,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              if (entry.inverterErrorCode != null &&
                  entry.inverterErrorCode!.trim().isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Text(
                    entry.inverterErrorCode!.trim(),
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 6),

          // Middle row: Description on left, Thumbnail on right (if photo exists)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  entry.summaryText,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (primaryPhoto != null) ...[
                const SizedBox(width: 12),
                _buildPhotoThumbnail(primaryPhoto.imageUri),
              ],
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),

          // Bottom Action Row: "View Diagnostic Details →" & Demo badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    'View Diagnostic Details',
                    style: TextStyle(
                      color: AppColors.primaryEmerald,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: AppColors.primaryEmerald,
                  ),
                ],
              ),
              if (entry.isDemoData)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F5F2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Demo Log',
                    style: TextStyle(
                      color: Color(0xFF7A9386),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
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
