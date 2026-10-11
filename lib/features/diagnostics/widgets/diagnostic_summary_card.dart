import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';
import '../models/diagnostic_result_model.dart';
import '../../problem_report/models/problem_report_model.dart';

/// Report Summary Card presenting report ID, submission time, symptoms, and live processing status
class DiagnosticSummaryCard extends StatelessWidget {
  final FullProblemReport report;
  final DiagnosticStatus status;

  const DiagnosticSummaryCard({
    super.key,
    required this.report,
    required this.status,
  });

  String _formatDateTime(DateTime dt) {
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
    final day = dt.day;
    final year = dt.year;

    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';

    return '$month $day, $year • $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return SolarCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Report Identifier & Copy button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'REPORT IDENTIFIER',
                      style: TextStyle(
                        color: Color(0xFF6B8274),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          report.reportId,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: report.reportId),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Copied ${report.reportId} to clipboard',
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.copy_rounded,
                              size: 15,
                              color: AppColors.primaryEmerald,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: status.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: status.color.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(status.icon, size: 14, color: status.color),
                    const SizedBox(width: 5),
                    Text(
                      status.label,
                      style: TextStyle(
                        color: status.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 14),

          // Date & Time Submitted
          _infoRow(
            icon: Icons.calendar_today_rounded,
            label: 'Submitted At',
            value: _formatDateTime(report.submittedAt),
          ),

          const SizedBox(height: 10),

          // Symptoms logged
          _infoRow(
            icon: Icons.warning_amber_rounded,
            label: 'Reported Symptoms',
            value: report.symptomLabels.isEmpty
                ? 'General Rooftop Issue'
                : report.symptomLabels.join(', '),
          ),

          // Inverter Error Code (if present)
          if (report.inverterErrorCode != null &&
              report.inverterErrorCode!.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            _infoRow(
              icon: Icons.qr_code_2_rounded,
              label: 'Inverter Code',
              value: report.inverterErrorCode!.trim(),
              isHighlight: true,
            ),
          ],

          // Attached Photos count
          if (report.photos.isNotEmpty) ...[
            const SizedBox(height: 10),
            _infoRow(
              icon: Icons.photo_camera_back_outlined,
              label: 'Photos Attached',
              value: '${report.photos.length} rooftop image(s)',
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlight = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: const Color(0xFF6B8274)),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF6B8274),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isHighlight
                  ? AppColors.primaryEmerald
                  : AppColors.textPrimary,
              fontSize: 12.5,
              fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
