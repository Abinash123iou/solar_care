import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/other_not_sure_data.dart';

/// Modal questionnaire for the "Other / Not Sure" symptom category.
/// Guides users through the 4 structured diagnostic questions.
class OtherNotSureWizardSheet extends StatefulWidget {
  final OtherNotSureData? initialData;
  final ValueChanged<OtherNotSureData> onSaved;

  const OtherNotSureWizardSheet({
    super.key,
    this.initialData,
    required this.onSaved,
  });

  @override
  State<OtherNotSureWizardSheet> createState() =>
      _OtherNotSureWizardSheetState();
}

class _OtherNotSureWizardSheetState extends State<OtherNotSureWizardSheet> {
  final Set<String> _selectedNoticed = {};
  late final TextEditingController _somethingElseController;
  String? _problemStartTime;
  String? _inverterProducingStatus;
  String? _accessibleInterfaces;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _selectedNoticed.addAll(widget.initialData!.noticedSymptoms);
      _problemStartTime = widget.initialData!.problemStartTime;
      _inverterProducingStatus = widget.initialData!.inverterProducingStatus;
      _accessibleInterfaces = widget.initialData!.accessibleInterfaces;
    }
    _somethingElseController = TextEditingController(
      text: widget.initialData?.somethingElseDetail ?? '',
    );
  }

  @override
  void dispose() {
    _somethingElseController.dispose();
    super.dispose();
  }

  void _toggleNoticed(String option) {
    setState(() {
      if (_selectedNoticed.contains(option)) {
        _selectedNoticed.remove(option);
      } else {
        _selectedNoticed.add(option);
      }
    });
  }

  void _onSave() {
    final result = OtherNotSureData(
      noticedSymptoms: _selectedNoticed.toList(),
      somethingElseDetail: _selectedNoticed.contains('Something else')
          ? _somethingElseController.text.trim()
          : null,
      problemStartTime: _problemStartTime,
      inverterProducingStatus: _inverterProducingStatus,
      accessibleInterfaces: _accessibleInterfaces,
    );
    widget.onSaved(result);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final hasAnySelection =
        _selectedNoticed.isNotEmpty ||
        _problemStartTime != null ||
        _inverterProducingStatus != null ||
        _accessibleInterfaces != null;

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
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.mint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.help_outline_rounded,
                    color: AppColors.primaryEmerald,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Other / Not Sure',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Answer 4 quick questions to help diagnose your system',
                        style: TextStyle(
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

          // Scrollable questions list
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ----------------------------------------------------
                  // Question 1: What have you noticed? (Multi-select)
                  // ----------------------------------------------------
                  _buildSectionHeader(
                    questionNum: '1',
                    title: 'What have you noticed?',
                    subtitle: 'Select all that apply',
                  ),
                  const SizedBox(height: 10),
                  ...OtherNotSureData.q1Options.map((opt) {
                    final isChecked = _selectedNoticed.contains(opt);
                    return InkWell(
                      onTap: () => _toggleNoticed(opt),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isChecked
                              ? AppColors.mintLight
                              : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isChecked
                                ? AppColors.primaryEmerald
                                : AppColors.borderSubtle,
                            width: isChecked ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isChecked
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank_rounded,
                              color: isChecked
                                  ? AppColors.primaryEmerald
                                  : const Color(0xFF8BA095),
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                opt,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: isChecked
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Optional details if "Something else" selected
                  if (_selectedNoticed.contains('Something else')) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, top: 2),
                      child: TextField(
                        controller: _somethingElseController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Describe what else you observed...',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                          filled: true,
                          fillColor: AppColors.mintLight.withAlpha(120),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.primaryEmerald,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // ----------------------------------------------------
                  // Question 2: When did the problem start?
                  // ----------------------------------------------------
                  _buildSectionHeader(
                    questionNum: '2',
                    title: 'When did the problem start?',
                    subtitle: 'Choose the closest timeframe',
                  ),
                  const SizedBox(height: 10),
                  ...OtherNotSureData.q2Options.map((opt) {
                    final isSelected = _problemStartTime == opt;
                    return _buildSingleSelectTile(
                      label: opt,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _problemStartTime = opt;
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 20),

                  // ----------------------------------------------------
                  // Question 3: Is the inverter producing power now?
                  // ----------------------------------------------------
                  _buildSectionHeader(
                    questionNum: '3',
                    title: 'Is the inverter producing power now?',
                    subtitle: 'Current operational observation',
                  ),
                  const SizedBox(height: 10),
                  ...OtherNotSureData.q3Options.map((opt) {
                    final isSelected = _inverterProducingStatus == opt;
                    return _buildSingleSelectTile(
                      label: opt,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _inverterProducingStatus = opt;
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 20),

                  // ----------------------------------------------------
                  // Question 4: What can you access?
                  // ----------------------------------------------------
                  _buildSectionHeader(
                    questionNum: '4',
                    title: 'What can you access?',
                    subtitle: 'Available interfaces or readings',
                  ),
                  const SizedBox(height: 10),
                  ...OtherNotSureData.q4Options.map((opt) {
                    final isSelected = _accessibleInterfaces == opt;
                    return _buildSingleSelectTile(
                      label: opt,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _accessibleInterfaces = opt;
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),

          // Bottom confirmation bar
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
                    label: hasAnySelection ? 'Save Answers' : 'Skip & Close',
                    onPressed: _onSave,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String questionNum,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(top: 2),
          decoration: const BoxDecoration(
            color: AppColors.primaryEmerald,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              questionNum,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleSelectTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mintLight : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryEmerald
                : AppColors.borderSubtle,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected
                  ? AppColors.primaryEmerald
                  : const Color(0xFF8BA095),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
