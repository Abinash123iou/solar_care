import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_care/features/profile/screens/profile_settings_screen.dart';
import 'package:solar_care/features/profile/services/user_profile_repository.dart';
import 'package:solar_care/features/profile/widgets/faq_sheet.dart';
import 'package:solar_care/features/profile/widgets/profile_header_card.dart';
import 'package:solar_care/features/profile/widgets/system_info_card.dart';

void main() {
  group('UserProfileRepository Unit Tests', () {
    late UserProfileRepository repository;

    setUp(() {
      repository = UserProfileRepository.instance;
      repository.resetToDefault();
    });

    test('Initializes with default owner profile', () {
      final profile = repository.profile;
      expect(profile.name, 'Ravi Kumar');
      expect(profile.email, 'ravi.kumar@solarcare.energy');
      expect(profile.consumerId, 'SC-89241');
      expect(profile.systemCapacity, '5.2 kWp Monocrystalline');
      expect(profile.criticalAlertsEnabled, true);
      expect(profile.dailySummaryEnabled, true);
    });

    test('updateProfileDetails modifies name, email, and phone', () {
      repository.updateProfileDetails(
        name: 'Priya Sharma',
        email: 'priya.sharma@solarcare.io',
        phone: '+91 91234 56789',
      );

      final updated = repository.profile;
      expect(updated.name, 'Priya Sharma');
      expect(updated.email, 'priya.sharma@solarcare.io');
      expect(updated.phone, '+91 91234 56789');
    });

    test('updateNotificationSettings toggles preferences', () {
      repository.updateNotificationSettings(
        criticalAlerts: false,
        dailySummary: false,
        weatherNotices: true,
      );

      final updated = repository.profile;
      expect(updated.criticalAlertsEnabled, false);
      expect(updated.dailySummaryEnabled, false);
      expect(updated.weatherNoticesEnabled, true);
    });

    test('updateTelemetryFrequency updates rate', () {
      repository.updateTelemetryFrequency('5 Minutes');
      expect(repository.profile.telemetryFrequency, '5 Minutes');
    });

    test('Handles fetchProfile with forceError and forceEmpty', () async {
      expect(
        () => repository.fetchProfile(forceError: true),
        throwsA(isA<Exception>()),
      );

      final guestProfile = await repository.fetchProfile(forceEmpty: true);
      expect(guestProfile.name, 'Guest User');
      expect(guestProfile.consumerId, 'SC-GUEST-001');
    });
  });

  group('ProfileSettingsScreen Widget Tests', () {
    setUp(() {
      UserProfileRepository.instance.resetToDefault();
    });

    testWidgets('Renders Profile & Settings screen components', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(home: ProfileSettingsScreen(showBottomNav: false)),
      );
      await tester.pumpAndSettle();

      // App bar
      expect(find.text('Profile & Settings'), findsOneWidget);

      // Profile Header
      expect(find.byType(ProfileHeaderCard), findsOneWidget);
      expect(find.text('Ravi Kumar'), findsOneWidget);
      expect(find.text('ID: SC-89241'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);

      // System Info Card
      expect(find.byType(SystemInfoCard), findsOneWidget);
      expect(find.text('REGISTERED SOLAR SYSTEM'), findsOneWidget);
      expect(find.text('5.2 kWp Monocrystalline'), findsOneWidget);

      // Notification settings section
      expect(find.text('NOTIFICATION PREFERENCES'), findsOneWidget);
      expect(find.text('Critical Inverter Faults'), findsOneWidget);
      expect(find.text('Daily Generation Summary'), findsOneWidget);

      // Support Section
      expect(find.text('SUPPORT & HELP'), findsOneWidget);
      expect(find.text('Diagnostic Knowledge Base (FAQ)'), findsOneWidget);
      expect(find.text('Certified Technician Support'), findsOneWidget);
      expect(find.text('About SolarCare'), findsOneWidget);

      // Sign Out Action
      expect(find.text('Sign Out / Reset Session'), findsOneWidget);
    });

    testWidgets('Toggles notification preference switches', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(home: ProfileSettingsScreen(showBottomNav: false)),
      );
      await tester.pumpAndSettle();

      // Find first SwitchListTile (Critical Inverter Faults)
      final switches = find.byType(Switch);
      expect(switches, findsNWidgets(3));

      // Toggle first switch off
      await tester.tap(switches.first);
      await tester.pumpAndSettle();

      expect(
        UserProfileRepository.instance.profile.criticalAlertsEnabled,
        false,
      );
    });

    testWidgets('Opens FAQ sheet and displays troubleshooting questions', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(home: ProfileSettingsScreen(showBottomNav: false)),
      );
      await tester.pumpAndSettle();

      // Scroll to and tap FAQ item
      final faqFinder = find.text('Diagnostic Knowledge Base (FAQ)');
      await tester.scrollUntilVisible(
        faqFinder,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(faqFinder);
      await tester.pumpAndSettle();

      // Verify FAQ sheet is presented
      expect(find.byType(FaqSheet), findsOneWidget);
      expect(find.text('Frequently Asked Questions'), findsOneWidget);
      expect(
        find.text('What does Inverter Fault code E022 indicate?'),
        findsOneWidget,
      );
    });

    testWidgets('Sign Out displays confirmation dialog and can be cancelled', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const MaterialApp(home: ProfileSettingsScreen(showBottomNav: false)),
      );
      await tester.pumpAndSettle();

      // Scroll to and tap Sign Out
      final signOutFinder = find.text('Sign Out / Reset Session');
      await tester.scrollUntilVisible(
        signOutFinder,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(signOutFinder);
      await tester.pumpAndSettle();

      // Confirmation dialog is shown
      expect(find.text('Sign Out of SolarCare?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Sign Out of SolarCare?'), findsNothing);
    });
  });
}
