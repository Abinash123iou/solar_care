import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../models/other_not_sure_data.dart';
import '../models/problem_report_model.dart';
import '../widgets/other_not_sure_wizard_sheet.dart';
import '../widgets/symptom_card.dart';
import 'report_problem_details_screen.dart';

/// Screen 2 — Select Problem / Report a Problem
/// Allows users to identify symptoms with their rooftop solar system.
class SelectProblemScreen extends StatefulWidget {
  final ProblemReportDraft? initialDraft;

  const SelectProblemScreen({super.key, this.initialDraft});

  @override
  State<SelectProblemScreen> createState() => _SelectProblemScreenState();
}

class _SelectProblemScreenState extends State<SelectProblemScreen> {
  final Set<String> _selectedSymptomIds = <String>{};
  late final TextEditingController _errorCodeController;
  late final TextEditingController _notesController;

  // The categories matching the approved design reference
  final List<SymptomCategory> _primaryCategories = const [
    SymptomCategory(
      id: 'low_generation',
      label: 'Low Generation',
      icon: Icons.wb_sunny_outlined,
      customIconColor: AppColors.primaryEmerald,
    ),
    SymptomCategory(
      id: 'shading',
      label: 'Shading',
      icon: Icons.solar_power_rounded,
      customIconColor: AppColors.primaryEmerald,
    ),
    SymptomCategory(
      id: 'overheating',
      label: 'Overheating\nWarning',
      icon: Icons.thermostat_rounded,
      customIconColor: Color(0xFFEA580C), // Orange warning color from reference
    ),
    SymptomCategory(
      id: 'grid_issue',
      label: 'Grid Issue',
      icon: Icons.electrical_services_rounded,
      customIconColor: AppColors.primaryEmerald,
    ),
  ];

  final SymptomCategory _inverterCategory = const SymptomCategory(
    id: 'inverter_fault',
    label: 'Inverter Fault',
    icon: Icons.developer_board_rounded,
    customIconColor: AppColors.primaryEmerald,
    isFullWidth: true,
  );

  // Additional categories supported by the product scope
  final List<SymptomCategory> _additionalCategories = const [
    SymptomCategory(
      id: 'damaged_panels',
      label: 'Panels Damaged',
      icon: Icons.broken_image_outlined,
      customIconColor: AppColors.primaryEmerald,
    ),
    SymptomCategory(
      id: 'unusual_noise',
      label: 'Unusual Noise',
      icon: Icons.volume_up_outlined,
      customIconColor: AppColors.primaryEmerald,
    ),
  ];

  final SymptomCategory _otherNotSureCategory = const SymptomCategory(
    id: 'other_not_sure',
    label: 'Other / Not Sure',
    icon: Icons.help_outline_rounded,
    customIconColor: AppColors.primaryEmerald,
    isFullWidth: true,
  );

  bool _showMoreCategories = false;
  OtherNotSureData? _otherNotSureData;

  @override
  void initState() {
    super.initState();
    if (widget.initialDraft != null) {
      _selectedSymptomIds.addAll(widget.initialDraft!.selectedSymptomIds);
      _otherNotSureData = widget.initialDraft!.otherNotSureData;
      _errorCodeController = TextEditingController(
        text: widget.initialDraft!.inverterErrorCode ?? '',
      );
      _notesController = TextEditingController(
        text: widget.initialDraft!.additionalNotes ?? '',
      );
    } else {
      _errorCodeController = TextEditingController();
      _notesController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _errorCodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _toggleSymptom(String id) {
    if (id == 'other_not_sure') {
      _onOtherNotSureTap();
      return;
    }
    setState(() {
      if (_selectedSymptomIds.contains(id)) {
        _selectedSymptomIds.remove(id);
      } else {
        _selectedSymptomIds.add(id);
      }
    });
  }

  void _onOtherNotSureTap() {
    if (_selectedSymptomIds.contains('other_not_sure')) {
      // If already selected, open the wizard to edit or view answers
      _openOtherNotSureWizard();
    } else {
      // Select it and prompt the 4 questions
      setState(() {
        _selectedSymptomIds.add('other_not_sure');
      });
      _openOtherNotSureWizard();
    }
  }

  void _openOtherNotSureWizard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => OtherNotSureWizardSheet(
        initialData: _otherNotSureData,
        onSaved: (data) {
          setState(() {
            _otherNotSureData = data;
            _selectedSymptomIds.add('other_not_sure');
          });
        },
      ),
    );
  }

  List<String> _getSelectedLabels() {
    final all = [
      ..._primaryCategories,
      _inverterCategory,
      ..._additionalCategories,
      _otherNotSureCategory,
    ];
    return all
        .where((cat) => _selectedSymptomIds.contains(cat.id))
        .map((cat) => cat.label.replaceAll('\n', ' '))
        .toList();
  }

  void _handleContinue() {
    if (_selectedSymptomIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.statusDanger,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text('Please select at least one symptom to continue.'),
              ),
            ],
          ),
        ),
      );
      return;
    }

    final draft = ProblemReportDraft(
      selectedSymptomIds: Set<String>.from(_selectedSymptomIds),
      selectedSymptomLabels: _getSelectedLabels(),
      inverterErrorCode: _errorCodeController.text.trim().isEmpty
          ? null
          : _errorCodeController.text.trim(),
      additionalNotes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      otherNotSureData: _otherNotSureData,
    );

    _navigateToScreen3(draft);
  }

  void _navigateToScreen3(ProblemReportDraft draft) async {
    final updatedDraft = await Navigator.push<ProblemReportDraft>(
      context,
      MaterialPageRoute(
        builder: (context) => ReportProblemDetailsScreen(draft: draft),
      ),
    );

    if (updatedDraft != null && mounted) {
      setState(() {
        _selectedSymptomIds.clear();
        _selectedSymptomIds.addAll(updatedDraft.selectedSymptomIds);
        _otherNotSureData = updatedDraft.otherNotSureData;
        if (updatedDraft.inverterErrorCode != null) {
          _errorCodeController.text = updatedDraft.inverterErrorCode!;
        }
        if (updatedDraft.additionalNotes != null) {
          _notesController.text = updatedDraft.additionalNotes!;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isContinueEnabled = _selectedSymptomIds.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        centerTitle: true,
        title: Column(
          children: const [
            Text(
              'Report a Problem',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Select the issue you're facing",
              style: TextStyle(
                color: Color(0xFF637B6E),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2x2 Grid of Primary Symptoms (Low Generation, Shading, Overheating, Grid Issue)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _primaryCategories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 1.25,
                          ),
                      itemBuilder: (context, index) {
                        final cat = _primaryCategories[index];
                        final isSelected = _selectedSymptomIds.contains(cat.id);
                        return SymptomCard(
                          category: cat,
                          isSelected: isSelected,
                          onTap: () => _toggleSymptom(cat.id),
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    // Full-width Inverter Fault Card
                    SymptomCard(
                      category: _inverterCategory,
                      isSelected: _selectedSymptomIds.contains(
                        _inverterCategory.id,
                      ),
                      onTap: () => _toggleSymptom(_inverterCategory.id),
                    ),

                    // Optional toggle to show more symptom categories
                    if (_showMoreCategories) ...[
                      const SizedBox(height: 14),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _additionalCategories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 1.25,
                            ),
                        itemBuilder: (context, index) {
                          final cat = _additionalCategories[index];
                          final isSelected = _selectedSymptomIds.contains(
                            cat.id,
                          );
                          return SymptomCard(
                            category: cat,
                            isSelected: isSelected,
                            onTap: () => _toggleSymptom(cat.id),
                          );
                        },
                      ),
                    ],

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          foregroundColor: AppColors.primaryEmerald,
                        ),
                        onPressed: () {
                          setState(() {
                            _showMoreCategories = !_showMoreCategories;
                          });
                        },
                        icon: Icon(
                          _showMoreCategories
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.add_circle_outline_rounded,
                          size: 16,
                        ),
                        label: Text(
                          _showMoreCategories
                              ? 'Show fewer issues'
                              : 'More issue categories',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Full-width Other / Not Sure Card
                    SymptomCard(
                      category: _otherNotSureCategory,
                      isSelected: _selectedSymptomIds.contains(
                        _otherNotSureCategory.id,
                      ),
                      onTap: _onOtherNotSureTap,
                    ),

                    if (_selectedSymptomIds.contains(
                      _otherNotSureCategory.id,
                    )) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mintLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primaryEmerald.withValues(
                              alpha: 0.35,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primaryEmerald,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.checklist_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _otherNotSureData != null &&
                                            _otherNotSureData!.isFilled
                                        ? 'Assessment Complete (${_otherNotSureData!.answeredCount}/4 answered)'
                                        : 'Assessment Pending (4 quick questions)',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _otherNotSureData != null &&
                                            _otherNotSureData!.isFilled
                                        ? (_otherNotSureData!
                                                  .noticedSymptoms
                                                  .isNotEmpty
                                              ? _otherNotSureData!
                                                    .noticedSymptoms
                                                    .join(', ')
                                              : 'Responses recorded')
                                        : 'Tap to complete the 4-question assessment',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryEmerald,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                              ),
                              onPressed: _openOtherNotSureWizard,
                              child: Text(
                                _otherNotSureData != null &&
                                        _otherNotSureData!.isFilled
                                    ? 'Edit'
                                    : 'Answer',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),

                    // Inverter Error Code (optional)
                    const Text(
                      'Inverter Error Code (optional)',
                      style: TextStyle(
                        color: Color(0xFF5A7265),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: TextField(
                        controller: _errorCodeController,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'e.g. E022',
                          hintStyle: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Additional Notes (optional)
                    const Text(
                      'Additional Notes (optional)',
                      style: TextStyle(
                        color: Color(0xFF5A7265),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: TextField(
                        controller: _notesController,
                        maxLines: 3,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Tell us more about the issue...',
                          hintStyle: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Persistent Bottom Action Button (Submit)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.screenPadding,
                vertical: 12,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.borderSubtle, width: 1),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isContinueEnabled ? _handleContinue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryEmerald,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.primaryEmerald
                          .withValues(alpha: 0.4),
                      disabledForegroundColor: Colors.white70,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          26,
                        ), // Pill shape from design
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.1,
                      ),
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
