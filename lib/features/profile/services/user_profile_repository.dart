import '../models/user_profile_model.dart';

/// Repository managing user profile data, system specifications, and application preferences
class UserProfileRepository {
  static final UserProfileRepository _instance =
      UserProfileRepository._internal();
  static UserProfileRepository get instance => _instance;

  UserProfileRepository._internal() {
    resetToDefault();
  }

  late UserProfile _currentProfile;

  UserProfile get profile => _currentProfile;

  void resetToDefault() {
    _currentProfile = const UserProfile(
      name: 'Ravi Kumar',
      email: 'ravi.kumar@solarcare.energy',
      phone: '+91 98765 43210',
      consumerId: 'SC-89241',
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      systemName: 'Home Solar System (Array Alpha)',
      systemCapacity: '5.2 kWp Monocrystalline',
      installationDate: 'March 15, 2024',
      installationAddress: 'Chennai, Tamil Nadu',
      inverterModel: 'SolarCare Inverter 5kW-G2 (WiFi Enabled)',
      criticalAlertsEnabled: true,
      dailySummaryEnabled: true,
      weatherNoticesEnabled: false,
      telemetryFrequency: '15 Minutes',
      isDemoProfile: true,
    );
  }

  void updateProfileDetails({
    required String name,
    required String email,
    required String phone,
  }) {
    _currentProfile = _currentProfile.copyWith(
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );
  }

  void updateNotificationSettings({
    bool? criticalAlerts,
    bool? dailySummary,
    bool? weatherNotices,
  }) {
    _currentProfile = _currentProfile.copyWith(
      criticalAlertsEnabled: criticalAlerts,
      dailySummaryEnabled: dailySummary,
      weatherNoticesEnabled: weatherNotices,
    );
  }

  void updateTelemetryFrequency(String frequency) {
    _currentProfile = _currentProfile.copyWith(telemetryFrequency: frequency);
  }

  /// Fetches profile with simulated network latency and mock evaluation flags
  Future<UserProfile> fetchProfile({
    bool forceError = false,
    bool forceEmpty = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (forceError) {
      throw Exception(
        'Unable to load account profile from server. Please check your network connection.',
      );
    }

    if (forceEmpty) {
      return const UserProfile(
        name: 'Guest User',
        email: 'guest@solarcare.energy',
        phone: 'Not provided',
        consumerId: 'SC-GUEST-001',
        avatarUrl: '',
        systemName: 'Unassigned Solar System',
        systemCapacity: 'Not calibrated',
        installationDate: 'Pending setup',
        installationAddress: 'Not registered',
        inverterModel: 'No inverter paired',
        criticalAlertsEnabled: false,
        dailySummaryEnabled: false,
        weatherNoticesEnabled: false,
        telemetryFrequency: 'Standard',
        isDemoProfile: true,
      );
    }

    return _currentProfile;
  }
}
