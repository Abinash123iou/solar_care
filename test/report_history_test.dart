import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_care/features/diagnostics/models/diagnostic_result_model.dart';
import 'package:solar_care/features/diagnostics/screens/diagnostics_results_screen.dart';
import 'package:solar_care/features/problem_report/models/problem_report_model.dart';
import 'package:solar_care/features/report_history/models/report_history_entry.dart';
import 'package:solar_care/features/report_history/screens/report_history_screen.dart';
import 'package:solar_care/features/report_history/services/report_history_repository.dart';
import 'package:solar_care/features/report_history/widgets/report_history_summary_card.dart';

void main() {
  group('ReportHistoryRepository Unit Tests', () {
    late ReportHistoryRepository repository;

    setUp(() {
      repository = ReportHistoryRepository.instance;
      repository.resetToDefault();
    });

    test('Loads initial demo reports', () async {
      final reports = await repository.getReports();
      expect(reports.length, 5);
      expect(reports.any((r) => r.status == DiagnosticStatus.complete), true);
      expect(reports.any((r) => r.status == DiagnosticStatus.pending), true);
      expect(reports.any((r) => r.status == DiagnosticStatus.analyzing), true);
      expect(reports.any((r) => r.status == DiagnosticStatus.failed), true);
    });

    test('addReport prepends newly submitted report to history', () async {
      final initialCount = (await repository.getReports()).length;

      final newReport = FullProblemReport(
        reportId: 'SC-REP-2026-9999',
        symptomIds: {'inverter_fault'},
        symptomLabels: ['Inverter Fault'],
        problemDescription: 'Test newly submitted inverter fault',
        photos: const [],
        submittedAt: DateTime.now(),
      );

      repository.addReport(newReport, status: DiagnosticStatus.complete);

      final updated = await repository.getReports();
      expect(updated.length, initialCount + 1);
      expect(updated.first.reportId, 'SC-REP-2026-9999');
      expect(updated.first.primaryCategory, 'Inverter Fault');
    });

    test('updateStatus modifies report status by ID', () async {
      repository.updateStatus('SC-REP-2026-5102', DiagnosticStatus.complete);
      final updated = await repository.getReports();
      final report = updated.firstWhere(
        (r) => r.reportId == 'SC-REP-2026-5102',
      );
      expect(report.status, DiagnosticStatus.complete);
    });

    test('Handles forceError and forceEmpty correctly', () async {
      expect(
        () => repository.getReports(forceError: true),
        throwsA(isA<Exception>()),
      );

      final empty = await repository.getReports(forceEmpty: true);
      expect(empty.isEmpty, true);
    });
  });

  group('ReportStatusFilter Unit Tests', () {
    test('Correctly filters by diagnostic status', () {
      expect(ReportStatusFilter.all.matches(DiagnosticStatus.complete), true);
      expect(
        ReportStatusFilter.completed.matches(DiagnosticStatus.complete),
        true,
      );
      expect(
        ReportStatusFilter.completed.matches(DiagnosticStatus.pending),
        false,
      );
      expect(
        ReportStatusFilter.pending.matches(DiagnosticStatus.pending),
        true,
      );
      expect(
        ReportStatusFilter.pending.matches(DiagnosticStatus.submitted),
        true,
      );
      expect(
        ReportStatusFilter.analyzing.matches(DiagnosticStatus.analyzing),
        true,
      );
      expect(ReportStatusFilter.failed.matches(DiagnosticStatus.failed), true);
    });
  });

  group('ReportHistorySummaryCard Widget Tests', () {
    testWidgets('Calculates and displays summary counts accurately', (
      WidgetTester tester,
    ) async {
      final reports = [
        ReportHistoryEntry(
          status: DiagnosticStatus.complete,
          report: FullProblemReport(
            reportId: 'SC-1',
            symptomIds: {'s1'},
            symptomLabels: ['Low Gen'],
            problemDescription: 'Desc 1',
            photos: const [],
            submittedAt: DateTime.now(),
          ),
        ),
        ReportHistoryEntry(
          status: DiagnosticStatus.pending,
          report: FullProblemReport(
            reportId: 'SC-2',
            symptomIds: {'s2'},
            symptomLabels: ['Shading'],
            problemDescription: 'Desc 2',
            photos: const [],
            submittedAt: DateTime.now(),
          ),
        ),
        ReportHistoryEntry(
          status: DiagnosticStatus.complete,
          report: FullProblemReport(
            reportId: 'SC-3',
            symptomIds: {'s3'},
            symptomLabels: ['Inverter'],
            problemDescription: 'Desc 3',
            photos: const [],
            submittedAt: DateTime.now(),
          ),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ReportHistorySummaryCard(reports: reports)),
        ),
      );

      // Total reports = 3
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Total Reports'), findsOneWidget);

      // Pending = 1
      expect(find.text('1'), findsOneWidget);
      expect(find.text('Pending Reports'), findsOneWidget);

      // Completed = 2
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Completed Reports'), findsOneWidget);
    });
  });

  group('ReportHistoryScreen Widget Tests', () {
    setUp(() {
      ReportHistoryRepository.instance.resetToDefault();
    });

    testWidgets('Renders Report History screen with cards and summary', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ReportHistoryScreen(showBottomNav: false)),
      );

      // Settle simulated network load
      await tester.pumpAndSettle();

      // App bar
      expect(find.text('Report History'), findsOneWidget);

      // Metrics in summary card
      expect(find.text('Total Reports'), findsOneWidget);
      expect(find.text('Pending Reports'), findsOneWidget);
      expect(find.text('Completed Reports'), findsOneWidget);

      // Filter chips
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Analyzing'), findsWidgets);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);

      // Cards from initial demo reports
      expect(find.text('SC-REP-2026-4821'), findsOneWidget);
      expect(find.text('Low Power Generation'), findsOneWidget);
      expect(find.text('View Diagnostic Details'), findsWidgets);
    });

    testWidgets('Filters list when status chip is selected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ReportHistoryScreen(showBottomNav: false)),
      );
      await tester.pumpAndSettle();

      // Tap "Completed" filter chip
      await tester.tap(find.text('Completed'));
      await tester.pumpAndSettle();

      // Should show completed reports and hide pending/analyzing
      expect(find.text('SC-REP-2026-4821'), findsOneWidget); // Completed
      expect(find.text('SC-REP-2026-3914'), findsOneWidget); // Completed
      expect(find.text('SC-REP-2026-5102'), findsNothing); // Pending
    });

    testWidgets('Filters list when search text is typed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ReportHistoryScreen(showBottomNav: false)),
      );
      await tester.pumpAndSettle();

      // Search for specific ID
      await tester.enterText(find.byType(TextField), '3914');
      await tester.pumpAndSettle();

      expect(find.text('SC-REP-2026-3914'), findsOneWidget);
      expect(find.text('SC-REP-2026-4821'), findsNothing);
    });

    testWidgets('Displays search empty state and clears query', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ReportHistoryScreen(showBottomNav: false)),
      );
      await tester.pumpAndSettle();

      // Search for non-existent query
      await tester.enterText(find.byType(TextField), 'NonExistentIssue123');
      await tester.pumpAndSettle();

      expect(find.text('No Matching Reports Found'), findsOneWidget);
      expect(find.text('Clear Search Query'), findsOneWidget);

      // Tap clear
      await tester.tap(find.text('Clear Search Query'));
      await tester.pumpAndSettle();

      expect(find.text('No Matching Reports Found'), findsNothing);
      expect(find.text('SC-REP-2026-4821'), findsOneWidget);
    });

    testWidgets('Tapping report card opens DiagnosticsResultsScreen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ReportHistoryScreen(showBottomNav: false)),
      );
      await tester.pumpAndSettle();

      // Tap the first card
      await tester.tap(find.text('SC-REP-2026-4821'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pumpAndSettle();

      // Navigated to DiagnosticsResultsScreen
      expect(find.byType(DiagnosticsResultsScreen), findsOneWidget);
      expect(find.text('Diagnostic Results'), findsOneWidget);
    });
  });
}
