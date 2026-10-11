import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/solar_card.dart';
import '../../dashboard/widgets/solar_bottom_nav_bar.dart';
import '../models/user_profile_model.dart';
import '../services/user_profile_repository.dart';
import '../widgets/contact_support_sheet.dart';
import '../widgets/edit_profile_sheet.dart';
import '../widgets/faq_sheet.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/system_info_card.dart';
import '../../technician/screens/technician_dashboard_screen.dart';

enum ProfileViewState { loading, success, error }

/// Screen 6 — Profile & Settings Screen
/// Presents user profile, solar system specifications, notification preferences, support, and session controls.
class ProfileSettingsScreen extends StatefulWidget {
  final bool showBottomNav;

  const ProfileSettingsScreen({super.key, this.showBottomNav = true});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final UserProfileRepository _repository = UserProfileRepository.instance;

  ProfileViewState _viewState = ProfileViewState.success;
  late UserProfile _profile;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _profile = _repository.profile;
  }

  Future<void> _loadProfile({
    bool forceError = false,
    bool forceEmpty = false,
  }) async {
    setState(() {
      _viewState = ProfileViewState.loading;
    });

    try {
      final data = await _repository.fetchProfile(
        forceError: forceError,
        forceEmpty: forceEmpty,
      );
      if (!mounted) return;
      setState(() {
        _profile = data;
        _viewState = ProfileViewState.success;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _viewState = ProfileViewState.error;
      });
    }
  }

  void _openEditProfile() {
    EditProfileSheet.show(
      context: context,
      profile: _profile,
      onSave: (name, email, phone) {
        setState(() {
          _repository.updateProfileDetails(
            name: name,
            email: email,
            phone: phone,
          );
          _profile = _repository.profile;
        });
      },
    );
  }

  void _toggleCriticalAlerts(bool value) {
    setState(() {
      _repository.updateNotificationSettings(criticalAlerts: value);
      _profile = _repository.profile;
    });
  }

  void _toggleDailySummary(bool value) {
    setState(() {
      _repository.updateNotificationSettings(dailySummary: value);
      _profile = _repository.profile;
    });
  }

  void _toggleWeatherNotices(bool value) {
    setState(() {
      _repository.updateNotificationSettings(weatherNotices: value);
      _profile = _repository.profile;
    });
  }

  void _selectTelemetryFrequency() {
    const options = ['5 Minutes', '15 Minutes', 'Hourly'];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Telemetry Sampling Rate',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((opt) {
            final isSelected = _profile.telemetryFrequency == opt;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                opt,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primaryEmerald
                      : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              trailing: isSelected
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primaryEmerald,
                    )
                  : null,
              onTap: () {
                setState(() {
                  _repository.updateTelemetryFrequency(opt);
                  _profile = _repository.profile;
                });
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showPrivacyPolicyModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
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
              'Privacy & Solar Telemetry Policy',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'SolarCare collects rooftop inverter telemetry (voltage, current, power derating) and user-submitted diagnostic photos strictly for fault triage and performance optimization.\n\n• End-to-end telemetry encryption\n• Anonymized inverter performance benchmarking\n• No third-party data selling or tracking cookies\n• Full compliance with local energy telemetry standards',
              style: TextStyle(
                color: Color(0xFF5A7265),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryEmerald,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Understood',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutSolarCareModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
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
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.mint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.solar_power_rounded,
                    color: AppColors.primaryEmerald,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SolarCare',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Rooftop Solar Diagnostics MVP v1.0.0',
                      style: TextStyle(color: Color(0xFF6B8274), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'SolarCare empowers rooftop solar owners with automated inverter fault classification, string imbalance detection, and actionable maintenance guidance.',
              style: TextStyle(
                color: Color(0xFF5A7265),
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Engineered for the Rooftop Solar Diagnostics Hackathon MVP.',
              style: TextStyle(
                color: AppColors.primaryEmerald,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryEmerald,
                  side: const BorderSide(color: AppColors.primaryEmerald),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.statusDanger, size: 22),
            SizedBox(width: 10),
            Text(
              'Sign Out of SolarCare?',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to sign out? Your session preferences and saved reports will be safely reset.',
          style: TextStyle(
            color: Color(0xFF5A7265),
            fontSize: 13.5,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF6B8274),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _repository.resetToDefault();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.primaryEmerald,
                  content: Text('Session reset. Signed out successfully.'),
                ),
              );
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusDanger,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  /// Evaluator Demo State Switcher
  void _openDemoStateSwitcher() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
              'Demo: Profile & Settings States',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Evaluate Screen 6 data and error handling:',
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
                  Icons.person_rounded,
                  color: AppColors.primaryEmerald,
                  size: 18,
                ),
              ),
              title: const Text('Default Owner Profile (Ravi Kumar)'),
              subtitle: const Text('Normal authenticated solar owner'),
              onTap: () {
                Navigator.pop(ctx);
                _repository.resetToDefault();
                _loadProfile();
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
                  Icons.no_accounts_outlined,
                  color: Color(0xFFD97706),
                  size: 18,
                ),
              ),
              title: const Text('Guest / Unassigned Solar System'),
              subtitle: const Text(
                'Simulates account with missing system data',
              ),
              onTap: () {
                Navigator.pop(ctx);
                _loadProfile(forceEmpty: true);
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
              title: const Text('Profile Fetch Error State'),
              subtitle: const Text('Displays error view with retry action'),
              onTap: () {
                Navigator.pop(ctx);
                _loadProfile(forceError: true);
              },
            ),
          ],
        ),
      ),
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
          'Profile & Settings',
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
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(child: _buildBody()),
      bottomNavigationBar: widget.showBottomNav
          ? SolarBottomNavBar(
              currentIndex: 3, // More / Settings tab is index 3
              onTabSelected: (index) {
                if (index == 0) {
                  Navigator.of(context).pop();
                } else if (index != 3) {
                  Navigator.of(context).pop();
                }
              },
            )
          : null,
    );
  }

  Widget _buildBody() {
    switch (_viewState) {
      case ProfileViewState.loading:
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryEmerald),
          ),
        );

      case ProfileViewState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SolarCard(
              backgroundColor: const Color(0xFFFFF5F5),
              borderColor: const Color(0xFFFCA5A5),
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.statusDanger,
                    size: 36,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Unable to Load Settings',
                    style: TextStyle(
                      color: Color(0xFF991B1B),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Color(0xFF7F1D1D),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _loadProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryEmerald,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );

      case ProfileViewState.success:
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile Header Card (Section 2.B)
              ProfileHeaderCard(
                profile: _profile,
                onEditProfile: _openEditProfile,
              ),

              const SizedBox(height: 16),

              // 2. Solar System Information Card (Section 2.C)
              SystemInfoCard(profile: _profile),

              const SizedBox(height: 20),

              // 3. Notification Preferences (Section 2.D)
              _buildSectionTitle('NOTIFICATION PREFERENCES'),
              const SizedBox(height: 8),
              SolarCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    SwitchListTile(
                      activeThumbColor: AppColors.primaryEmerald,
                      activeTrackColor: AppColors.mint,
                      title: const Text(
                        'Critical Inverter Faults',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'Immediate push alert on isolation trips or disconnects',
                        style: TextStyle(
                          color: Color(0xFF6B8274),
                          fontSize: 12,
                        ),
                      ),
                      value: _profile.criticalAlertsEnabled,
                      onChanged: _toggleCriticalAlerts,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    SwitchListTile(
                      activeThumbColor: AppColors.primaryEmerald,
                      activeTrackColor: AppColors.mint,
                      title: const Text(
                        'Daily Generation Summary',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        '7:00 PM sunset summary of today\'s kWh output',
                        style: TextStyle(
                          color: Color(0xFF6B8274),
                          fontSize: 12,
                        ),
                      ),
                      value: _profile.dailySummaryEnabled,
                      onChanged: _toggleDailySummary,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    SwitchListTile(
                      activeThumbColor: AppColors.primaryEmerald,
                      activeTrackColor: AppColors.mint,
                      title: const Text(
                        'Weather & Shading Advisories',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'Notices when heavy overcast or dust storms are forecast',
                        style: TextStyle(
                          color: Color(0xFF6B8274),
                          fontSize: 12,
                        ),
                      ),
                      value: _profile.weatherNoticesEnabled,
                      onChanged: _toggleWeatherNotices,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 4. Diagnostic Telemetry & App Settings (Section 2.D)
              _buildSectionTitle('DIAGNOSTIC & APPLICATION SETTINGS'),
              const SizedBox(height: 8),
              SolarCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.speed_rounded,
                        color: AppColors.primaryEmerald,
                      ),
                      title: const Text(
                        'Telemetry Sampling Rate',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        'Currently: ${_profile.telemetryFrequency}',
                        style: const TextStyle(
                          color: Color(0xFF6B8274),
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF8A9F93),
                      ),
                      onTap: _selectTelemetryFrequency,
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    ListTile(
                      leading: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.primaryEmerald,
                      ),
                      title: const Text(
                        'Privacy & Telemetry Security',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'Encrypted inverter data and GDPR principles',
                        style: TextStyle(
                          color: Color(0xFF6B8274),
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF8A9F93),
                      ),
                      onTap: _showPrivacyPolicyModal,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 5. Help & Support (Section 2.E)
              _buildSectionTitle('SUPPORT & HELP'),
              const SizedBox(height: 8),
              SolarCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.help_outline_rounded,
                        color: AppColors.primaryEmerald,
                      ),
                      title: const Text(
                        'Diagnostic Knowledge Base (FAQ)',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'Fault codes, cleaning tips, and technical guides',
                        style: TextStyle(
                          color: Color(0xFF6B8274),
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF8A9F93),
                      ),
                      onTap: () => FaqSheet.show(context),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    ListTile(
                      leading: const Icon(
                        Icons.support_agent_rounded,
                        color: AppColors.primaryEmerald,
                      ),
                      title: const Text(
                        'Certified Technician Support',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'On-site inspection and callback assistance',
                        style: TextStyle(
                          color: Color(0xFF6B8274),
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF8A9F93),
                      ),
                      onTap: () => ContactSupportSheet.show(context),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    ListTile(
                      leading: const Icon(
                        Icons.engineering_rounded,
                        color: AppColors.primaryEmerald,
                      ),
                      title: const Text(
                        'Technician Service Portal',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'Triage and resolve customer diagnostic requests',
                        style: TextStyle(
                          color: Color(0xFF6B8274),
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF8A9F93),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const TechnicianDashboardScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    ListTile(
                      leading: const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primaryEmerald,
                      ),
                      title: const Text(
                        'About SolarCare',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'Version 1.0.0 (Hackathon MVP)',
                        style: TextStyle(
                          color: Color(0xFF6B8274),
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF8A9F93),
                      ),
                      onTap: _showAboutSolarCareModal,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 6. Sign Out / Reset Session (Section 2.F)
              SolarCard(
                onTap: _confirmSignOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout_rounded,
                      color: AppColors.statusDanger,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Sign Out / Reset Session',
                        style: TextStyle(
                          color: AppColors.statusDanger,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Color(0xFFDC2626),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF6B8274),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
