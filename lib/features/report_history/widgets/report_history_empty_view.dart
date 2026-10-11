import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/report_history_entry.dart';

enum HistoryEmptyType { noReports, noSearchMatch, noFilterMatch }

/// Dynamic empty state widget handling all three empty scenarios
class ReportHistoryEmptyView extends StatelessWidget {
  final HistoryEmptyType type;
  final String? searchQuery;
  final ReportStatusFilter? filter;
  final VoidCallback onReportProblem;
  final VoidCallback onClearSearch;
  final VoidCallback onResetFilter;

  const ReportHistoryEmptyView({
    super.key,
    required this.type,
    this.searchQuery,
    this.filter,
    required this.onReportProblem,
    required this.onClearSearch,
    required this.onResetFilter,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case HistoryEmptyType.noReports:
        return _buildLayout(
          icon: Icons.assignment_outlined,
          iconBg: AppColors.mint,
          iconColor: AppColors.primaryEmerald,
          title: 'No Reports Submitted Yet',
          subtitle:
              'Any rooftop solar problem reports you submit will appear here with diagnostic telemetry and live status tracking.',
          action: PrimaryButton(
            label: 'Report a Problem',
            icon: Icons.add_rounded,
            onPressed: onReportProblem,
          ),
        );

      case HistoryEmptyType.noSearchMatch:
        return _buildLayout(
          icon: Icons.search_off_rounded,
          iconBg: const Color(0xFFF1F5F9),
          iconColor: const Color(0xFF64748B),
          title: 'No Matching Reports Found',
          subtitle:
              'No reports matched "${searchQuery ?? ''}". Try searching with a different symptom keyword or Report ID.',
          action: OutlinedButton.icon(
            onPressed: onClearSearch,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryEmerald,
              side: const BorderSide(
                color: AppColors.primaryEmerald,
                width: 1.4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.clear_all_rounded, size: 18),
            label: const Text(
              'Clear Search Query',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        );

      case HistoryEmptyType.noFilterMatch:
        return _buildLayout(
          icon: Icons.filter_alt_off_rounded,
          iconBg: const Color(0xFFFEF3C7),
          iconColor: const Color(0xFFD97706),
          title: 'No ${filter?.label ?? ''} Reports',
          subtitle:
              'There are currently no problem reports with status "${filter?.label ?? ''}".',
          action: OutlinedButton.icon(
            onPressed: onResetFilter,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryEmerald,
              side: const BorderSide(
                color: AppColors.primaryEmerald,
                width: 1.4,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text(
              'Show All Reports',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        );
    }
  }

  Widget _buildLayout({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget action,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Center(child: Icon(icon, size: 32, color: iconColor)),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF6B8274),
                fontSize: 13.5,
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            action,
          ],
        ),
      ),
    );
  }
}
