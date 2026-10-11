import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';
import '../models/technician_request.dart';

/// Card displaying a customer service request in the Technician Dashboard.
class TechnicianRequestCard extends StatelessWidget {
  final TechnicianRequest request;
  final VoidCallback onTap;

  const TechnicianRequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  Color _getStatusColor(TechnicianRequestStatus status) {
    switch (status) {
      case TechnicianRequestStatus.pending:
        return const Color(0xFFD97706); // Amber
      case TechnicianRequestStatus.assigned:
        return AppColors.primaryEmerald;
      case TechnicianRequestStatus.inProgress:
        return const Color(0xFF2563EB); // Blue
      case TechnicianRequestStatus.resolved:
        return const Color(0xFF16A34A); // Green
    }
  }

  Color _getStatusBgColor(TechnicianRequestStatus status) {
    switch (status) {
      case TechnicianRequestStatus.pending:
        return const Color(0xFFFEF3C7);
      case TechnicianRequestStatus.assigned:
        return AppColors.mintLight;
      case TechnicianRequestStatus.inProgress:
        return const Color(0xFFDBEAFE);
      case TechnicianRequestStatus.resolved:
        return const Color(0xFFDCFCE7);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(request.status);
    final statusBgColor = _getStatusBgColor(request.status);

    return SolarCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Customer Name + Time Ago + Status Pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            request.customerName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.primaryEmerald,
                          size: 15,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            request.customerAddress,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      request.status.label,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimeAgo(request.createdAt),
                    style: const TextStyle(
                      color: Color(0xFF8BA095),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Inverter & Hardware metadata
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text(
                  request.systemCapacity,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  request.inverterModel,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Symptoms & Issues
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ...request.symptoms.map(
                (s) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mintLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    s,
                    style: const TextStyle(
                      color: AppColors.primaryEmerald,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (request.inverterErrorCode != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Error ${request.inverterErrorCode}',
                    style: const TextStyle(
                      color: Color(0xFFB45309),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (request.otherNotSureData != null &&
                  request.otherNotSureData!.isFilled)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mint,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppColors.primaryEmerald.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.checklist_rounded,
                        size: 11,
                        color: AppColors.primaryEmerald,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Assessment (${request.otherNotSureData!.answeredCount}/4)',
                        style: const TextStyle(
                          color: AppColors.primaryEmerald,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          if (request.problemDescription.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              request.problemDescription,
              style: const TextStyle(
                color: Color(0xFF5A7064),
                fontSize: 12,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: 10),

          // Footer with View Details CTA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (request.technicianNotes != null &&
                  request.technicianNotes!.isNotEmpty)
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.note_alt_outlined,
                        size: 13,
                        color: AppColors.primaryEmerald,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Notes: ${request.technicianNotes!}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primaryEmerald,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Spacer(),
              const Row(
                children: [
                  Text(
                    'Review Request',
                    style: TextStyle(
                      color: AppColors.primaryEmerald,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: AppColors.primaryEmerald,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
