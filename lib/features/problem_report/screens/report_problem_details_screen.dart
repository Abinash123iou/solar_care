import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../models/problem_report_model.dart';
import '../services/photo_picker_service.dart';
import '../widgets/photo_preview_card.dart';
import '../../diagnostics/models/diagnostic_result_model.dart';
import '../../diagnostics/screens/diagnostics_results_screen.dart';
import '../../report_history/services/report_history_repository.dart';

/// Screen 3 — Report a Problem
/// Faithfully reproduces the approved Screen 3 design reference:
/// - App bar: "← Report a Problem"
/// - "SELECTED ISSUE" mint card with chosen symptoms
/// - "Describe the issue" with multiline text field
/// - "Upload Photos (optional)" with "Take Photo" & "Choose from Gallery" buttons
/// - "Selected photos will appear here with previews and remove controls" placeholder / preview list
/// - "Submit Report" emerald button
class ReportProblemDetailsScreen extends StatefulWidget {
  final ProblemReportDraft draft;

  const ReportProblemDetailsScreen({super.key, required this.draft});

  @override
  State<ReportProblemDetailsScreen> createState() =>
      _ReportProblemDetailsScreenState();
}

class _ReportProblemDetailsScreenState
    extends State<ReportProblemDetailsScreen> {
  late ProblemReportDraft _currentDraft;
  late final TextEditingController _descriptionController;

  final List<PhotoAttachment> _photos = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _currentDraft = widget.draft;
    _descriptionController = TextEditingController();
    _photos.addAll(widget.draft.attachedPhotos);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _addPhoto(PhotoAttachment photo) {
    if (_photos.length >= PhotoPickerService.maxPhotoLimit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.statusWarning,
          content: Text('Maximum limit of 5 photos reached.'),
        ),
      );
      return;
    }

    setState(() {
      _photos.add(photo);
    });
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  void _updatePhotoDescription(int index, String newDescription) {
    setState(() {
      _photos[index] = _photos[index].copyWith(description: newDescription);
    });
  }

  void _handleEditSymptoms() {
    Navigator.pop(context, _currentDraft.copyWith(attachedPhotos: _photos));
  }

  void _submitReport() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    // Brief feedback before navigating to diagnostics processing
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    final reportId =
        'SC-REP-${DateTime.now().year}-${1000 + (DateTime.now().millisecondsSinceEpoch % 8999)}';

    final fullReport = FullProblemReport(
      reportId: reportId,
      symptomIds: _currentDraft.selectedSymptomIds,
      symptomLabels: _currentDraft.selectedSymptomLabels,
      inverterErrorCode: _currentDraft.inverterErrorCode,
      screen2Notes: _currentDraft.additionalNotes,
      problemDescription: _descriptionController.text.trim(),
      photos: List.unmodifiable(_photos),
      submittedAt: DateTime.now(),
      otherNotSureData: _currentDraft.otherNotSureData,
    );

    // Persist to Report History so new submissions immediately appear in history
    ReportHistoryRepository.instance.addReport(
      fullReport,
      status: DiagnosticStatus.complete,
    );

    setState(() {
      _isSubmitting = false;
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DiagnosticsResultsScreen(
          report: fullReport,
          autoStartProcessing: true,
        ),
      ),
    );
  }

  String _getSymptomDisplayTitle() {
    if (_currentDraft.selectedSymptomLabels.isEmpty) {
      return 'Low Power Generation';
    }
    return _currentDraft.selectedSymptomLabels.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final canAddMore = _photos.length < PhotoPickerService.maxPhotoLimit;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 24,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        titleSpacing: 0,
        centerTitle: false,
        title: const Text(
          'Report a Problem',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.screenPadding,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. SELECTED ISSUE Card (Matching exact reference screenshot)
                    GestureDetector(
                      onTap: _handleEditSymptoms,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFEBF5EE,
                          ), // Soft light mint background from reference
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'SELECTED ISSUE',
                                  style: TextStyle(
                                    color: AppColors.primaryEmerald,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.edit_outlined,
                                      size: 13,
                                      color: AppColors.primaryEmerald,
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: AppColors.primaryEmerald,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _getSymptomDisplayTitle(),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Review the selected symptoms from the previous screen.',
                              style: TextStyle(
                                color: Color(0xFF5A7064),
                                fontSize: 13,
                                height: 1.35,
                              ),
                            ),
                            if (_currentDraft.inverterErrorCode != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Inverter Error Code: ${_currentDraft.inverterErrorCode}',
                                style: const TextStyle(
                                  color: AppColors.primaryEmerald,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            if (_currentDraft.otherNotSureData != null &&
                                _currentDraft.otherNotSureData!.isFilled) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.primaryEmerald.withValues(
                                      alpha: 0.25,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.checklist_rounded,
                                          size: 14,
                                          color: AppColors.primaryEmerald,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Troubleshooting Assessment Responses:',
                                          style: TextStyle(
                                            color: AppColors.primaryEmerald,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _currentDraft.otherNotSureData!
                                          .toSummaryText(),
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 11.5,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 2. Describe the issue section (Matching reference screenshot)
                    const Text(
                      'Describe the issue',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2EDE6)),
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText:
                              'Describe the issue, when it started, and any changes you noticed...',
                          hintStyle: TextStyle(
                            color: Color(0xFF8A9E93),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // 3. Upload Photos (optional) (Matching reference screenshot)
                    const Text(
                      'Upload Photos (optional)',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Add up to 5 photos of your solar panels or inverter.',
                      style: TextStyle(color: Color(0xFF5A7064), fontSize: 13),
                    ),
                    const SizedBox(height: 12),

                    // Two side-by-side action buttons: [Take Photo] [Choose from Gallery]
                    Row(
                      children: [
                        // Left: Take Photo button
                        Expanded(
                          child: InkWell(
                            onTap: canAddMore
                                ? () =>
                                      PhotoPickerService.showPhotoSourceSelector(
                                        context: context,
                                        currentPhotoCount: _photos.length,
                                        onPhotoSelected: _addPhoto,
                                      )
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 72,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: canAddMore
                                      ? AppColors.primaryEmerald
                                      : AppColors.borderSubtle,
                                  width: 1.2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    size: 22,
                                    color: canAddMore
                                        ? AppColors.primaryEmerald
                                        : AppColors.textMuted,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Take Photo',
                                    style: TextStyle(
                                      color: canAddMore
                                          ? AppColors.primaryEmerald
                                          : AppColors.textMuted,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Right: Choose from Gallery button
                        Expanded(
                          child: InkWell(
                            onTap: canAddMore
                                ? () =>
                                      PhotoPickerService.showPhotoSourceSelector(
                                        context: context,
                                        currentPhotoCount: _photos.length,
                                        onPhotoSelected: _addPhoto,
                                      )
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 72,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: canAddMore
                                      ? AppColors.primaryEmerald
                                      : AppColors.borderSubtle,
                                  width: 1.2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo_library_outlined,
                                    size: 22,
                                    color: canAddMore
                                        ? AppColors.primaryEmerald
                                        : AppColors.textMuted,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Choose from Gallery',
                                    style: TextStyle(
                                      color: canAddMore
                                          ? AppColors.primaryEmerald
                                          : AppColors.textMuted,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Selected photos container / placeholder (Matching reference screenshot)
                    if (_photos.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 22,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2EDE6)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 28,
                              color: AppColors.primaryEmerald,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Selected photos will appear here with previews and remove controls.',
                              style: TextStyle(
                                color: Color(0xFF6A8275),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _photos.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final photo = _photos[index];
                          return PhotoPreviewCard(
                            photo: photo,
                            onRemove: () => _removePhoto(index),
                            onDescriptionChanged: (val) =>
                                _updatePhotoDescription(index, val),
                          );
                        },
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // 4. Submit Report Button (Matching reference screenshot)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryEmerald,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primaryEmerald
                        .withValues(alpha: 0.6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        14,
                      ), // Rounded rectangle matching design
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Submit Report',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
