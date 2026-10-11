import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_care/features/diagnostics/models/diagnostic_result_model.dart';
import 'package:solar_care/features/diagnostics/screens/diagnostics_results_screen.dart';
import 'package:solar_care/features/diagnostics/services/diagnostic_service.dart';
import 'package:solar_care/features/diagnostics/widgets/diagnosis_processing_widget.dart';
import 'package:solar_care/features/problem_report/models/problem_report_model.dart';

void main() {
  group('DiagnosticService Unit Tests', () {
    final mockReport = FullProblemReport(
      reportId: 'SC-REP-2026-1001',
      symptomIds: {'low_generation', 'shading'},
      symptomLabels: ['Low Power Generation', 'Panel Shading'],
      inverterErrorCode: null,
      screen2Notes: 'Output dropped at noon',
      problemDescription: 'Lower row covered in shade from neighbor tree.',
      photos: const [
        PhotoAttachment(
          id: 'test_photo_1',
          imageUri: 'https://example.com/solar1.jpg',
          description: 'Tree shadow across panel row',
          label: 'Shaded Panels',
        ),
      ],
      submittedAt: DateTime(2026, 10, 11, 12, 0),
    );

    test(
      'analyzeReport produces complete findings for low generation and shading',
      () async {
        final result = await DiagnosticService.analyzeReport(mockReport);

        expect(result.status, DiagnosticStatus.complete);
        expect(result.report.reportId, 'SC-REP-2026-1001');
        expect(result.findings.isNotEmpty, true);
        expect(result.measurements.isNotEmpty, true);
        expect(result.recommendations.isNotEmpty, true);
        expect(result.isDemoData, true);
      },
    );

    test(
      'analyzeReport produces inverter fault finding when error code is present',
      () async {
        final inverterReport = FullProblemReport(
          reportId: 'SC-REP-2026-1002',
          symptomIds: {'inverter_fault'},
          symptomLabels: ['Inverter Fault / Blinking Red'],
          inverterErrorCode: 'E022',
          problemDescription: 'Inverter tripped with red light',
          photos: const [],
          submittedAt: DateTime(2026, 10, 11, 12, 15),
        );

        final result = await DiagnosticService.analyzeReport(inverterReport);

        expect(result.status, DiagnosticStatus.complete);
        expect(result.severity, SeverityLevel.high);
        expect(
          result.findings.any((f) => !f.isSuspected),
          true,
          reason:
              'Should have a confirmed fault finding for inverter error code',
        );
      },
    );

    test(
      'getPendingResult, getEmptyResult, getErrorResult match expected statuses',
      () {
        final pending = DiagnosticService.getPendingResult(mockReport);
        expect(pending.status, DiagnosticStatus.pending);

        final empty = DiagnosticService.getEmptyResult(mockReport);
        expect(empty.status, DiagnosticStatus.empty);

        final error = DiagnosticService.getErrorResult(mockReport);
        expect(error.status, DiagnosticStatus.failed);
        expect(error.errorMessage, isNotNull);
      },
    );
  });

  group('Diagnostics Processing Widget Tests', () {
    testWidgets('DiagnosisProcessingWidget displays progress checklist', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DiagnosisProcessingWidget(
              onComplete: () {},
              autoAdvance: false,
            ),
          ),
        ),
      );

      expect(find.text('Analyzing Your Solar System'), findsOneWidget);
      expect(
        find.text(
          'Our system is checking your data and looking for possible causes...',
        ),
        findsOneWidget,
      );
      expect(find.text('Validating your input'), findsOneWidget);
      expect(find.text('Checking recent readings'), findsOneWidget);
      expect(find.text('Running diagnostic rules'), findsOneWidget);
      expect(find.text('Preparing explanation'), findsOneWidget);
      expect(
        find.text('This usually takes less than a minute.'),
        findsOneWidget,
      );
    });
  });

  group('Diagnostics Results Screen Widget Tests', () {
    final testReport = FullProblemReport(
      reportId: 'SC-REP-2026-8888',
      symptomIds: {'low_generation'},
      symptomLabels: ['Low Power Generation'],
      problemDescription: 'System only generating 1.2 kW at peak sun.',
      photos: const [],
      submittedAt: DateTime(2026, 10, 11, 11, 30),
    );

    testWidgets('Displays report summary and completed diagnostic sections', (
      WidgetTester tester,
    ) async {
      final completedResult =
          DiagnosticService.generateGenerationOrShadingResult(testReport);

      await tester.pumpWidget(
        MaterialApp(
          home: DiagnosticsResultsScreen(
            report: testReport,
            autoStartProcessing: false,
            initialStatus: DiagnosticStatus.complete,
            initialResult: completedResult,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // App bar
      expect(find.text('Diagnostic Results'), findsOneWidget);

      // Report Summary
      expect(find.text('SC-REP-2026-8888'), findsOneWidget);
      expect(find.text('Analysis Complete'), findsOneWidget);

      // Section Headings
      expect(find.text('Diagnostic Findings'), findsOneWidget);
      expect(find.text('Recommended Next Steps'), findsOneWidget);
      expect(find.text('Reported Photos'), findsOneWidget);

      // Bottom Actions
      expect(find.text('Back to Home'), findsOneWidget);
      expect(find.text('Report Another Problem'), findsOneWidget);
    });

    testWidgets('Displays empty state message when status is empty', (
      WidgetTester tester,
    ) async {
      final emptyResult = DiagnosticService.getEmptyResult(testReport);

      await tester.pumpWidget(
        MaterialApp(
          home: DiagnosticsResultsScreen(
            report: testReport,
            autoStartProcessing: false,
            initialStatus: DiagnosticStatus.empty,
            initialResult: emptyResult,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Your report has been submitted. Diagnostic results are not available yet.',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'Displays error state with retry button when status is failed',
      (WidgetTester tester) async {
        final errorResult = DiagnosticService.getErrorResult(testReport);

        await tester.pumpWidget(
          MaterialApp(
            home: DiagnosticsResultsScreen(
              report: testReport,
              autoStartProcessing: false,
              initialStatus: DiagnosticStatus.failed,
              initialResult: errorResult,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Analysis Failed'), findsNWidgets(2));
        expect(find.text('Retry Diagnostic Analysis'), findsOneWidget);
      },
    );
  });
}
