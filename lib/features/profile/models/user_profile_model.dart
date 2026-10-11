/// Model representing user profile, solar system details, and application preferences
class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String consumerId;
  final String avatarUrl;
  final String systemName;
  final String systemCapacity;
  final String installationDate;
  final String installationAddress;
  final String inverterModel;
  final bool criticalAlertsEnabled;
  final bool dailySummaryEnabled;
  final bool weatherNoticesEnabled;
  final String telemetryFrequency;
  final bool isDemoProfile;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.consumerId,
    required this.avatarUrl,
    required this.systemName,
    required this.systemCapacity,
    required this.installationDate,
    required this.installationAddress,
    required this.inverterModel,
    this.criticalAlertsEnabled = true,
    this.dailySummaryEnabled = true,
    this.weatherNoticesEnabled = false,
    this.telemetryFrequency = '15 Minutes',
    this.isDemoProfile = true,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? consumerId,
    String? avatarUrl,
    String? systemName,
    String? systemCapacity,
    String? installationDate,
    String? installationAddress,
    String? inverterModel,
    bool? criticalAlertsEnabled,
    bool? dailySummaryEnabled,
    bool? weatherNoticesEnabled,
    String? telemetryFrequency,
    bool? isDemoProfile,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      consumerId: consumerId ?? this.consumerId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      systemName: systemName ?? this.systemName,
      systemCapacity: systemCapacity ?? this.systemCapacity,
      installationDate: installationDate ?? this.installationDate,
      installationAddress: installationAddress ?? this.installationAddress,
      inverterModel: inverterModel ?? this.inverterModel,
      criticalAlertsEnabled:
          criticalAlertsEnabled ?? this.criticalAlertsEnabled,
      dailySummaryEnabled: dailySummaryEnabled ?? this.dailySummaryEnabled,
      weatherNoticesEnabled:
          weatherNoticesEnabled ?? this.weatherNoticesEnabled,
      telemetryFrequency: telemetryFrequency ?? this.telemetryFrequency,
      isDemoProfile: isDemoProfile ?? this.isDemoProfile,
    );
  }
}
