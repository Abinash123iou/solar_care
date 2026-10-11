import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/solar_card.dart';
import '../../../models/solar_system_model.dart';
import '../../../services/solar_repository.dart';
import '../widgets/components_list.dart';
import '../widgets/diagnose_button.dart';
import '../widgets/empty_dashboard_view.dart';
import '../widgets/error_dashboard_view.dart';
import '../widgets/generation_card.dart';
import '../widgets/home_header.dart';
import '../widgets/loading_dashboard_view.dart';
import '../widgets/qr_scanner_sheet.dart';
import '../widgets/solar_bottom_nav_bar.dart';
import '../widgets/solar_details_review_sheet.dart';
import '../widgets/status_summary_row.dart';
import '../widgets/system_dropdown_card.dart';
import '../widgets/inverter_status_card.dart';
import '../../problem_report/screens/select_problem_screen.dart';
import '../../report_history/screens/report_history_screen.dart';
import '../../profile/screens/profile_settings_screen.dart';
import '../../technician/screens/technician_dashboard_screen.dart';

enum DashboardViewState { success, loading, empty, error }

/// Screen 1 — SolarCare Dashboard/Home
/// Faithfully reproduces the approved reference design.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final SolarRepository _repository = SolarRepository();

  DashboardViewState _viewState = DashboardViewState.success;
  SolarDashboardData? _data;
  String _errorMessage = '';
  int _activeNavIndex = 0;

  // Selected system
  String _selectedSystemName = 'Home Solar System';
  String _selectedSystemCapacity = '5 kW';

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData({
    bool forceError = false,
    bool forceEmpty = false,
  }) async {
    setState(() {
      _viewState = DashboardViewState.loading;
    });

    try {
      final data = await _repository.fetchDashboardData(
        forceError: forceError,
        forceEmpty: forceEmpty,
      );

      if (!mounted) return;

      setState(() {
        _data = data;
        if (data.components.isEmpty &&
            data.alerts.isEmpty &&
            data.summary.healthScore == 0) {
          _viewState = DashboardViewState.empty;
        } else {
          _viewState = DashboardViewState.success;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _viewState = DashboardViewState.error;
      });
    }
  }

  void _openQrScannerFlow() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return QrScannerSheet(
          onDetailsDetected: (details) {
            _showDetailsReviewSheet(details);
          },
        );
      },
    );
  }

  void _showDetailsReviewSheet(ScannedSolarDetails details) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return SolarDetailsReviewSheet(
          details: details,
          onConfirm: () {
            setState(() {
              _selectedSystemName = details.systemName;
              _selectedSystemCapacity = details.capacity;
              if (_viewState == DashboardViewState.empty) {
                _loadDashboardData();
              }
            });
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.primaryEmerald,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${details.systemName} (${details.capacity}) linked successfully!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          },
        );
      },
    );
  }

  void _onSystemDropdownTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
              const SizedBox(height: 18),
              const Text(
                'Select Solar Installation',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Switch between your rooftop solar diagnostic meters:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),
              _buildSystemChoiceTile(
                name: 'Home Solar System',
                capacity: '5 kW • Monocrystalline',
                isSelected: _selectedSystemName == 'Home Solar System',
                onSelect: () {
                  setState(() {
                    _selectedSystemName = 'Home Solar System';
                    _selectedSystemCapacity = '5 kW';
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              _buildSystemChoiceTile(
                name: 'Farmhouse Solar Array',
                capacity: '8 kW • Bifacial Ground/Roof',
                isSelected: _selectedSystemName == 'Farmhouse Solar Array',
                onSelect: () {
                  setState(() {
                    _selectedSystemName = 'Farmhouse Solar Array';
                    _selectedSystemCapacity = '8 kW';
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryEmerald,
                    side: const BorderSide(
                      color: AppColors.primaryEmerald,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _openQrScannerFlow();
                  },
                  icon: const Icon(Icons.qr_code_scanner_rounded, size: 20),
                  label: const Text(
                    'Scan QR to Add Solar System',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSystemChoiceTile({
    required String name,
    required String capacity,
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    return SolarCard(
      padding: const EdgeInsets.all(14),
      borderColor: isSelected
          ? AppColors.primaryEmerald
          : AppColors.borderSubtle,
      backgroundColor: isSelected
          ? AppColors.mintLight
          : AppColors.cardBackground,
      onTap: onSelect,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryEmerald : AppColors.mint,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.solar_power_rounded,
              color: isSelected ? Colors.white : AppColors.primaryEmerald,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  capacity,
                  style: const TextStyle(
                    color: Color(0xFF5A7064),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primaryEmerald,
              size: 22,
            ),
        ],
      ),
    );
  }

  void _onDiagnoseTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectProblemScreen()),
    );
  }

  void _onStatusCardTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
              const SizedBox(height: 18),
              const Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF1EAB68),
                    size: 26,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'System Health: Normal',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'All string inverters, bypass diodes, and bidirectional grid meters are operating within certified operating limits.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              PrimaryButton(
                label: 'Close',
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _onReadingCardTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: const Row(
          children: [
            Icon(Icons.access_time_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Telemetry synced 2 minutes ago via Wi-Fi gateway.'),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onGenerationCardTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryEmerald,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: const Text(
          "Today's peak generation reached 3.85 kW at 12:40 PM.",
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: _buildDrawer(),
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: SolarBottomNavBar(
        currentIndex: _activeNavIndex,
        onTabSelected: (index) {
          setState(() {
            _activeNavIndex = index;
          });
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ReportHistoryScreen(),
              ),
            ).then((_) {
              if (mounted) {
                setState(() {
                  _activeNavIndex = 0;
                });
              }
            });
          } else if (index == 2) {
            _onSystemDropdownTap();
            if (mounted) {
              setState(() {
                _activeNavIndex = 0;
              });
            }
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileSettingsScreen(),
              ),
            ).then((_) {
              if (mounted) {
                setState(() {
                  _activeNavIndex = 0;
                });
              }
            });
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_viewState) {
      case DashboardViewState.loading:
        return const SingleChildScrollView(child: LoadingDashboardView());

      case DashboardViewState.error:
        return ErrorDashboardView(
          errorMessage: _errorMessage,
          onRetry: () => _loadDashboardData(),
        );

      case DashboardViewState.empty:
        return EmptyDashboardView(
          onRunInitialScan: () => _loadDashboardData(),
          onScanQr: _openQrScannerFlow,
        );

      case DashboardViewState.success:
        return RefreshIndicator(
          color: AppColors.primaryEmerald,
          backgroundColor: AppColors.surface,
          onRefresh: () => _loadDashboardData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.screenPadding,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header with menu, logo, avatar, greeting & location
                HomeHeader(
                  userName: 'Ravi Kumar',
                  location: 'Chennai, Tamil Nadu',
                  onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                  onProfileTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileSettingsScreen(),
                      ),
                    );
                  },
                  onQrScanTap: _openQrScannerFlow,
                ),

                const SizedBox(height: 18),

                // System selector card (Home Solar System • 5 kW)
                SystemDropdownCard(
                  systemName: _selectedSystemName,
                  capacity: _selectedSystemCapacity,
                  onTap: _onSystemDropdownTap,
                ),

                const SizedBox(height: 16),

                // Today's Generation card with live sparkline wave chart
                GenerationCard(
                  generationKwh: _data?.summary.todayEnergyKwh ?? 18.4,
                  trendText: '12% vs. yesterday',
                  isLive: true,
                  onTap: _onGenerationCardTap,
                ),

                const SizedBox(height: 14),

                // Side-by-side cards: System Status Normal | Latest Reading 2:45 PM
                StatusSummaryRow(
                  systemStatus: 'Normal',
                  latestReadingTime: '2:45 PM',
                  onStatusTap: _onStatusCardTap,
                  onReadingTap: _onReadingCardTap,
                ),

                const SizedBox(height: 14),

                // Inverter Status Card with live AC/DC metrics & telemetry modal
                const InverterStatusCard(),

                const SizedBox(height: 18),

                // Primary CTA button: "⚡ Diagnose a Problem"
                DiagnoseButton(isLoading: false, onPressed: _onDiagnoseTap),

                const SizedBox(height: 24),

                // Additional Diagnostic Breakdown (Scrollable telemetry)
                if (_data != null && _data!.components.isNotEmpty) ...[
                  ComponentsList(
                    components: _data!.components,
                    onComponentTap: (comp) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('${comp.name}: ${comp.metricDetail}'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        );
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.mint, width: 2),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: AppColors.mint,
                      child: Icon(
                        Icons.person,
                        color: AppColors.primaryEmerald,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ravi Kumar',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Consumer ID: SC-89241',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderSubtle),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.dashboard_rounded,
                      color: AppColors.primaryEmerald,
                    ),
                    title: const Text('Dashboard'),
                    selected: true,
                    selectedColor: AppColors.primaryEmerald,
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.solar_power_rounded,
                      color: AppColors.textSecondary,
                    ),
                    title: const Text('My Solar Installations'),
                    onTap: () {
                      Navigator.pop(context);
                      _onSystemDropdownTap();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.bolt_rounded,
                      color: AppColors.textSecondary,
                    ),
                    title: const Text('Diagnose System'),
                    onTap: () {
                      Navigator.pop(context);
                      _onDiagnoseTap();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: AppColors.textSecondary,
                    ),
                    title: const Text('Scan Inverter QR Code'),
                    onTap: () {
                      Navigator.pop(context);
                      _openQrScannerFlow();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.assignment_outlined,
                      color: AppColors.textSecondary,
                    ),
                    title: const Text('Report History'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.textSecondary,
                    ),
                    title: const Text('Profile & Settings'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.mint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.engineering_rounded,
                        color: AppColors.primaryEmerald,
                        size: 18,
                      ),
                    ),
                    title: const Text(
                      'Technician Portal',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'View customer requests & field jobs',
                      style: TextStyle(fontSize: 11),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const TechnicianDashboardScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(color: AppColors.borderSubtle),
                  // Demo States for testing
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'DEMO STATE EVALUATION',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.primaryEmerald,
                    ),
                    title: const Text('Success State (Live)'),
                    onTap: () {
                      Navigator.pop(context);
                      _loadDashboardData();
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.hourglass_empty_rounded,
                      color: Color(0xFF0284C7),
                    ),
                    title: const Text('Loading Shimmer State'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _viewState = DashboardViewState.loading);
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.inbox_outlined,
                      color: Color(0xFFD97706),
                    ),
                    title: const Text('Empty State'),
                    onTap: () {
                      Navigator.pop(context);
                      _loadDashboardData(forceEmpty: true);
                    },
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.wifi_off_rounded,
                      color: AppColors.statusDanger,
                    ),
                    title: const Text('Error State (Offline)'),
                    onTap: () {
                      Navigator.pop(context);
                      _loadDashboardData(forceError: true);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'SolarCare MVP v1.0.0',
                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
