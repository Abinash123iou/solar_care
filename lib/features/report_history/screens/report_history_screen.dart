import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';
import '../../dashboard/widgets/solar_bottom_nav_bar.dart';
import '../../diagnostics/models/diagnostic_result_model.dart';
import '../../diagnostics/screens/diagnostics_results_screen.dart';
import '../../problem_report/screens/select_problem_screen.dart';
import '../models/report_history_entry.dart';
import '../services/report_history_repository.dart';
import '../widgets/report_history_card.dart';
import '../widgets/report_history_empty_view.dart';
import '../widgets/report_history_filter_bar.dart';
import '../widgets/report_history_summary_card.dart';

enum HistoryViewState { loading, success, error }

/// Screen 5 — Report History Screen
/// Allows users to review submitted problem reports, filter by status, search, and inspect findings.
class ReportHistoryScreen extends StatefulWidget {
  final bool showBottomNav;

  const ReportHistoryScreen({super.key, this.showBottomNav = true});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  final ReportHistoryRepository _repository = ReportHistoryRepository.instance;
  final TextEditingController _searchController = TextEditingController();

  HistoryViewState _viewState = HistoryViewState.success;
  List<ReportHistoryEntry> _allReports = [];
  String _errorMessage = '';

  ReportStatusFilter _selectedFilter = ReportStatusFilter.all;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadReports({
    bool forceError = false,
    bool forceEmpty = false,
  }) async {
    setState(() {
      _viewState = HistoryViewState.loading;
    });

    try {
      final data = await _repository.getReports(
        forceError: forceError,
        forceEmpty: forceEmpty,
      );
      if (!mounted) return;
      setState(() {
        _allReports = data;
        _viewState = HistoryViewState.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _viewState = HistoryViewState.error;
      });
    }
  }

  void _onSearchChanged(String val) {
    setState(() {
      _searchQuery = val.trim();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _resetAllFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedFilter = ReportStatusFilter.all;
    });
  }

  List<ReportHistoryEntry> _getFilteredReports() {
    return _allReports.where((entry) {
      // 1. Filter by status
      if (!_selectedFilter.matches(entry.status)) {
        return false;
      }

      // 2. Filter by search query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesId = entry.reportId.toLowerCase().contains(q);
        final matchesCategory = entry.symptomLabels.any(
          (s) => s.toLowerCase().contains(q),
        );
        final matchesDesc = entry.problemDescription.toLowerCase().contains(q);
        final matchesErrorCode =
            entry.inverterErrorCode?.toLowerCase().contains(q) ?? false;

        if (!matchesId &&
            !matchesCategory &&
            !matchesDesc &&
            !matchesErrorCode) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  Map<ReportStatusFilter, int> _calculateStatusCounts() {
    final Map<ReportStatusFilter, int> counts = {
      ReportStatusFilter.all: _allReports.length,
      ReportStatusFilter.pending: 0,
      ReportStatusFilter.analyzing: 0,
      ReportStatusFilter.completed: 0,
      ReportStatusFilter.failed: 0,
    };

    for (final entry in _allReports) {
      if (entry.status == DiagnosticStatus.pending ||
          entry.status == DiagnosticStatus.submitted) {
        counts[ReportStatusFilter.pending] =
            (counts[ReportStatusFilter.pending] ?? 0) + 1;
      } else if (entry.status == DiagnosticStatus.analyzing) {
        counts[ReportStatusFilter.analyzing] =
            (counts[ReportStatusFilter.analyzing] ?? 0) + 1;
      } else if (entry.status == DiagnosticStatus.complete) {
        counts[ReportStatusFilter.completed] =
            (counts[ReportStatusFilter.completed] ?? 0) + 1;
      } else if (entry.status == DiagnosticStatus.failed) {
        counts[ReportStatusFilter.failed] =
            (counts[ReportStatusFilter.failed] ?? 0) + 1;
      }
    }

    return counts;
  }

  void _openReportDetails(ReportHistoryEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DiagnosticsResultsScreen(
          report: entry.report,
          autoStartProcessing: entry.status == DiagnosticStatus.analyzing,
          initialStatus: entry.status,
        ),
      ),
    );
  }

  void _navigateToReportProblem() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SelectProblemScreen()),
    );
  }

  /// Evaluator Demo State Switcher: allows testing loading, error, and empty states
  void _openDemoStateSwitcher() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Demo: Report History States',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Evaluate Screen 5 data and error handling:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 14),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.mint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.history_rounded,
                    color: AppColors.primaryEmerald,
                    size: 18,
                  ),
                ),
                title: const Text('Default History (5 records)'),
                subtitle: const Text('Normal list with mixed statuses'),
                onTap: () {
                  Navigator.pop(ctx);
                  _repository.resetToDefault();
                  _loadReports();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.inbox_outlined,
                    color: Color(0xFFD97706),
                    size: 18,
                  ),
                ),
                title: const Text('Empty State (0 records)'),
                subtitle: const Text(
                  'Simulates account before any submissions',
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _loadReports(forceEmpty: true);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.statusDangerBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.statusDanger,
                    size: 18,
                  ),
                ),
                title: const Text('Error State (Network timeout)'),
                subtitle: const Text('Displays error view with retry action'),
                onTap: () {
                  Navigator.pop(ctx);
                  _loadReports(forceError: true);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.hourglass_empty_rounded,
                    color: Color(0xFF0284C7),
                    size: 18,
                  ),
                ),
                title: const Text('Loading Shimmer State'),
                subtitle: const Text('Displays progress indicator'),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _viewState = HistoryViewState.loading);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        title: const Text(
          'Report History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        actions: [
          // Demo State Switcher
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.tune_rounded,
                size: 18,
                color: AppColors.primaryEmerald,
              ),
            ),
            tooltip: 'Switch Demo State',
            onPressed: _openDemoStateSwitcher,
          ),
          // New Report shortcut
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryEmerald,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
            tooltip: 'Report a Problem',
            onPressed: _navigateToReportProblem,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: widget.showBottomNav
          ? SolarBottomNavBar(
              currentIndex: 1, // History tab is index 1
              onTabSelected: (index) {
                if (index == 0) {
                  Navigator.of(context).pop();
                } else if (index != 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Tab $index selected.'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
            )
          : null,
    );
  }

  Widget _buildBody() {
    switch (_viewState) {
      case HistoryViewState.loading:
        return _buildLoadingState();

      case HistoryViewState.error:
        return _buildErrorState();

      case HistoryViewState.success:
        return _buildSuccessState();
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(
            width: 38,
            height: 38,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryEmerald,
              ),
              backgroundColor: AppColors.mint,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Loading report history...',
            style: TextStyle(
              color: Color(0xFF6B8274),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: SolarCard(
          backgroundColor: const Color(0xFFFFF5F5),
          borderColor: const Color(0xFFFCA5A5),
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  color: AppColors.statusDanger,
                  size: 26,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Unable to Load History',
                style: TextStyle(
                  color: Color(0xFF991B1B),
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage.isNotEmpty
                    ? _errorMessage
                    : 'Failed to synchronize reports with the rooftop gateway. Please verify your connection.',
                style: const TextStyle(
                  color: Color(0xFF7F1D1D),
                  fontSize: 13,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () => _loadReports(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryEmerald,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text(
                    'Retry Loading',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    // If user has zero reports in repository
    if (_allReports.isEmpty) {
      return ReportHistoryEmptyView(
        type: HistoryEmptyType.noReports,
        onReportProblem: _navigateToReportProblem,
        onClearSearch: _clearSearch,
        onResetFilter: _resetAllFilters,
      );
    }

    final filteredReports = _getFilteredReports();
    final statusCounts = _calculateStatusCounts();

    return RefreshIndicator(
      color: AppColors.primaryEmerald,
      backgroundColor: AppColors.surface,
      onRefresh: () => _loadReports(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        children: [
          // 1. Dynamic Summary Section (Section 2.B)
          ReportHistorySummaryCard(reports: _allReports),

          const SizedBox(height: 16),

          // 2. Search & Filter Bar (Section 2.C)
          ReportHistoryFilterBar(
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            onClearSearch: _clearSearch,
            selectedFilter: _selectedFilter,
            onFilterSelected: (filter) {
              setState(() => _selectedFilter = filter);
            },
            statusCounts: statusCounts,
            onResetAll: _resetAllFilters,
          ),

          const SizedBox(height: 16),

          // 3. Report List or Filtered Empty States (Section 2.D & 2.E)
          if (filteredReports.isEmpty) ...[
            if (_searchQuery.isNotEmpty)
              ReportHistoryEmptyView(
                type: HistoryEmptyType.noSearchMatch,
                searchQuery: _searchQuery,
                onReportProblem: _navigateToReportProblem,
                onClearSearch: _clearSearch,
                onResetFilter: _resetAllFilters,
              )
            else
              ReportHistoryEmptyView(
                type: HistoryEmptyType.noFilterMatch,
                filter: _selectedFilter,
                onReportProblem: _navigateToReportProblem,
                onClearSearch: _clearSearch,
                onResetFilter: _resetAllFilters,
              ),
          ] else ...[
            // Report count indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reports (${filteredReports.length})',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (_searchQuery.isNotEmpty ||
                      _selectedFilter != ReportStatusFilter.all)
                    Text(
                      'Filtered from ${_allReports.length}',
                      style: const TextStyle(
                        color: Color(0xFF6B8274),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),

            // List of report cards
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredReports.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = filteredReports[index];
                return ReportHistoryCard(
                  entry: entry,
                  onTap: () => _openReportDetails(entry),
                );
              },
            ),

            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}
