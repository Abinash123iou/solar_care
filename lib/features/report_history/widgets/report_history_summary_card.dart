import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';
import '../../diagnostics/models/diagnostic_result_model.dart';
import '../models/report_history_entry.dart';

/// Compact summary card presenting dynamic counts of total, pending, and completed reports
class ReportHistorySummaryCard extends StatelessWidget {
  final List<ReportHistoryEntry> reports;

  const ReportHistorySummaryCard({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    final total = reports.length;
    final pending = reports
        .where(
          (r) =>
              r.status == DiagnosticStatus.pending ||
              r.status == DiagnosticStatus.submitted ||
              r.status == DiagnosticStatus.analyzing,
        )
        .length;
    final completed = reports
        .where((r) => r.status == DiagnosticStatus.complete)
        .length;

    return SolarCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Total Reports
          Expanded(
            child: _buildMetricItem(
              label: 'Total Reports',
              count: total,
              countColor: AppColors.textPrimary,
              icon: Icons.assignment_outlined,
              iconColor: const Color(0xFF5A7265),
            ),
          ),

          _buildDivider(),

          // Pending Reports
          Expanded(
            child: _buildMetricItem(
              label: 'Pending Reports',
              count: pending,
              countColor: const Color(0xFFD97706),
              icon: Icons.hourglass_top_rounded,
              iconColor: const Color(0xFFD97706),
            ),
          ),

          _buildDivider(),

          // Completed Reports
          Expanded(
            child: _buildMetricItem(
              label: 'Completed Reports',
              count: completed,
              countColor: AppColors.primaryEmerald,
              icon: Icons.check_circle_outline_rounded,
              iconColor: AppColors.primaryEmerald,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.borderSubtle,
    );
  }

  Widget _buildMetricItem({
    required String label,
    required int count,
    required Color countColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: TextStyle(
                color: countColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B8274),
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
