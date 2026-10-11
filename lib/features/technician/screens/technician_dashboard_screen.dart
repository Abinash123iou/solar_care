import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';
import '../models/technician_request.dart';
import '../services/technician_repository.dart';
import '../widgets/request_detail_sheet.dart';
import '../widgets/technician_request_card.dart';

/// Screen — Technician Dashboard
/// A simple, dedicated technician dashboard for viewing and managing customer service requests.
class TechnicianDashboardScreen extends StatefulWidget {
  const TechnicianDashboardScreen({super.key});

  @override
  State<TechnicianDashboardScreen> createState() =>
      _TechnicianDashboardScreenState();
}

class _TechnicianDashboardScreenState extends State<TechnicianDashboardScreen> {
  TechnicianRequestStatus? _selectedStatusFilter;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    TechnicianRepository.instance.syncFromReportHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TechnicianRequest> get _filteredRequests {
    final all = TechnicianRepository.instance.requests;
    return all.where((req) {
      if (_selectedStatusFilter != null &&
          req.status != _selectedStatusFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = req.customerName.toLowerCase().contains(query);
        final matchesAddress = req.customerAddress.toLowerCase().contains(
          query,
        );
        final matchesReportId = req.reportId.toLowerCase().contains(query);
        final matchesSymptoms = req.symptoms.any(
          (s) => s.toLowerCase().contains(query),
        );
        final matchesInverter = req.inverterModel.toLowerCase().contains(query);
        return matchesName ||
            matchesAddress ||
            matchesReportId ||
            matchesSymptoms ||
            matchesInverter;
      }
      return true;
    }).toList();
  }

  void _openRequestDetails(TechnicianRequest req) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => RequestDetailSheet(
        request: req,
        onUpdated: (updated) {
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.primaryEmerald,
              content: Text(
                'Request ${updated.id} updated to ${updated.status.label}.',
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allRequests = TechnicianRepository.instance.requests;
    final pendingCount = allRequests
        .where((r) => r.status == TechnicianRequestStatus.pending)
        .length;
    final inProgressCount = allRequests
        .where(
          (r) =>
              r.status == TechnicianRequestStatus.inProgress ||
              r.status == TechnicianRequestStatus.assigned,
        )
        .length;
    final resolvedCount = allRequests
        .where((r) => r.status == TechnicianRequestStatus.resolved)
        .length;

    final displayed = _filteredRequests;

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
              'Technician Dashboard',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Customer Diagnostic Requests',
              style: TextStyle(color: Color(0xFF637B6E), fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.sync_rounded,
              color: AppColors.primaryEmerald,
            ),
            tooltip: 'Refresh Requests',
            onPressed: () {
              setState(() {
                TechnicianRepository.instance.syncFromReportHistory();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Synchronized latest customer reports.'),
                  duration: Duration(milliseconds: 1200),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Technician Profile Info Banner
            SolarCard(
              padding: const EdgeInsets.all(16),
              backgroundColor: AppColors.surface,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryEmerald,
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'VS',
                        style: TextStyle(
                          color: AppColors.primaryEmerald,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vikram S.',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Field Engineer • ID: SC-TECH-409',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.mintLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryEmerald.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryEmerald,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'ON DUTY',
                          style: TextStyle(
                            color: AppColors.primaryEmerald,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Metric Summary Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    label: 'Total',
                    count: '${allRequests.length}',
                    color: AppColors.textPrimary,
                    bgColor: AppColors.cardBackground,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    label: 'Pending',
                    count: '$pendingCount',
                    color: const Color(0xFFD97706),
                    bgColor: const Color(0xFFFEF3C7),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    label: 'Active',
                    count: '$inProgressCount',
                    color: const Color(0xFF2563EB),
                    bgColor: const Color(0xFFDBEAFE),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    label: 'Resolved',
                    count: '$resolvedCount',
                    color: const Color(0xFF16A34A),
                    bgColor: const Color(0xFFDCFCE7),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search customer, address, or report...',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    label: 'All (${allRequests.length})',
                    isSelected: _selectedStatusFilter == null,
                    onTap: () {
                      setState(() {
                        _selectedStatusFilter = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Pending ($pendingCount)',
                    isSelected:
                        _selectedStatusFilter ==
                        TechnicianRequestStatus.pending,
                    onTap: () {
                      setState(() {
                        _selectedStatusFilter = TechnicianRequestStatus.pending;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Assigned',
                    isSelected:
                        _selectedStatusFilter ==
                        TechnicianRequestStatus.assigned,
                    onTap: () {
                      setState(() {
                        _selectedStatusFilter =
                            TechnicianRequestStatus.assigned;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'In Progress',
                    isSelected:
                        _selectedStatusFilter ==
                        TechnicianRequestStatus.inProgress,
                    onTap: () {
                      setState(() {
                        _selectedStatusFilter =
                            TechnicianRequestStatus.inProgress;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    label: 'Resolved ($resolvedCount)',
                    isSelected:
                        _selectedStatusFilter ==
                        TechnicianRequestStatus.resolved,
                    onTap: () {
                      setState(() {
                        _selectedStatusFilter =
                            TechnicianRequestStatus.resolved;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Customer Requests List
            if (displayed.isEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.search_off_rounded,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No Customer Requests Found',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Try adjusting your search keywords or status filter.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ] else ...[
              ...displayed.map((req) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TechnicianRequestCard(
                    request: req,
                    onTap: () => _openRequestDetails(req),
                  ),
                );
              }),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String count,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.85),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryEmerald : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryEmerald
                : AppColors.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
