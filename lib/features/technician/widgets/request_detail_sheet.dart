import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../diagnostics/screens/diagnostics_results_screen.dart';
import '../../problem_report/models/problem_report_model.dart';
import '../models/technician_request.dart';
import '../services/technician_repository.dart';

/// Modal bottom sheet displaying detailed customer request information for field technicians.
class RequestDetailSheet extends StatefulWidget {
  final TechnicianRequest request;
  final ValueChanged<TechnicianRequest> onUpdated;

  const RequestDetailSheet({
    super.key,
    required this.request,
    required this.onUpdated,
  });

  @override
  State<RequestDetailSheet> createState() => _RequestDetailSheetState();
}

class _RequestDetailSheetState extends State<RequestDetailSheet> {
  late TechnicianRequestStatus _currentStatus;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.request.status;
    _notesController = TextEditingController(
      text: widget.request.technicianNotes ?? '',
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updated = widget.request.copyWith(
      status: _currentStatus,
      technicianNotes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );
    TechnicianRepository.instance.updateStatus(updated.id, _currentStatus);
    TechnicianRepository.instance.updateNotes(
      updated.id,
      _notesController.text.trim(),
    );
    widget.onUpdated(updated);
    Navigator.of(context).pop();
  }

  void _openFullDiagnostics() {
    final FullProblemReport report =
        widget.request.fullReport ??
        FullProblemReport(
          reportId: widget.request.reportId,
          symptomIds: widget.request.symptoms
              .map((s) => s.toLowerCase().replaceAll(' ', '_'))
              .toSet(),
          symptomLabels: widget.request.symptoms,
          inverterErrorCode: widget.request.inverterErrorCode,
          problemDescription: widget.request.problemDescription,
          photos: const [],
          submittedAt: widget.request.createdAt,
          otherNotSureData: widget.request.otherNotSureData,
        );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiagnosticsResultsScreen(
          report: report,
          autoStartProcessing: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.mint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.assignment_ind_rounded,
                    color: AppColors.primaryEmerald,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.request.customerName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Request ID: ${widget.request.id} • ${widget.request.reportId}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 24),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer & Location Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: AppColors.primaryEmerald,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.request.customerAddress,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone_outlined,
                              size: 18,
                              color: AppColors.primaryEmerald,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.request.customerPhone,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: AppColors.primaryEmerald,
                                    content: Text(
                                      'Connecting call to ${widget.request.customerPhone}...',
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.mint,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.call,
                                      size: 13,
                                      color: AppColors.primaryEmerald,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Call Customer',
                                      style: TextStyle(
                                        color: AppColors.primaryEmerald,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Solar Hardware Specs
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.solar_power_rounded,
                              size: 18,
                              color: AppColors.primaryEmerald,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Array Capacity:',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.request.systemCapacity,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.developer_board_rounded,
                              size: 18,
                              color: AppColors.primaryEmerald,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Inverter Unit:',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                widget.request.inverterModel,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (widget.request.inverterErrorCode != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                size: 18,
                                color: Color(0xFFD97706),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Fault Code:',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.request.inverterErrorCode!,
                                style: const TextStyle(
                                  color: Color(0xFFD97706),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Customer Reported Problem Description
                  const Text(
                    'Customer Description',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.mintLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primaryEmerald.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      widget.request.problemDescription.isNotEmpty
                          ? widget.request.problemDescription
                          : 'No additional narrative entered by user.',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),

                  // -----------------------------------------------------------------
                  // Troubleshooting Assessment Responses (Other/Not Sure Answers)
                  // -----------------------------------------------------------------
                  if (widget.request.otherNotSureData != null &&
                      widget.request.otherNotSureData!.isFilled) ...[
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Icon(
                          Icons.checklist_rounded,
                          size: 16,
                          color: AppColors.primaryEmerald,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Troubleshooting Questionnaire Assessment',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primaryEmerald.withValues(
                            alpha: 0.35,
                          ),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.request.otherNotSureData!.toSummaryText(),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 12.5,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Update Request Status
                  const Text(
                    'Update Dispatch Status',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: TechnicianRequestStatus.values.map((status) {
                      final isSelected = _currentStatus == status;
                      return ChoiceChip(
                        label: Text(status.label),
                        selected: isSelected,
                        selectedColor: AppColors.primaryEmerald,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: 12.5,
                        ),
                        backgroundColor: AppColors.cardBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primaryEmerald
                                : AppColors.borderSubtle,
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _currentStatus = status;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),

                  // Technician Field Notes
                  const Text(
                    'Technician Service Notes',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          'Add on-site inspection findings, replacement parts, or next steps...',
                      hintStyle: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.borderSubtle,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.borderSubtle,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primaryEmerald,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),

                  if (widget.request.fullReport != null) ...[
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                        side: const BorderSide(color: AppColors.primaryEmerald),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.analytics_outlined,
                        color: AppColors.primaryEmerald,
                        size: 18,
                      ),
                      label: const Text(
                        'View Full AI Diagnostic Findings',
                        style: TextStyle(
                          color: AppColors.primaryEmerald,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      onPressed: _openFullDiagnostics,
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.borderSubtle),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    label: 'Save & Update Status',
                    onPressed: _saveChanges,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
