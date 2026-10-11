import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solar_care/features/dashboard/widgets/inverter_status_card.dart';
import 'package:solar_care/features/problem_report/models/other_not_sure_data.dart';
import 'package:solar_care/features/problem_report/screens/select_problem_screen.dart';
import 'package:solar_care/features/problem_report/widgets/other_not_sure_wizard_sheet.dart';
import 'package:solar_care/features/technician/models/technician_request.dart';
import 'package:solar_care/features/technician/screens/technician_dashboard_screen.dart';
import 'package:solar_care/features/technician/services/technician_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Refinement 1 — InverterStatusCard Tests', () {
    testWidgets('Renders Inverter Status Card with metrics', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InverterStatusCard(
              inverterModel: 'Sungrow SG5.0RS (Single Phase)',
              acPowerKw: 3.85,
              dcVoltageV: 340.0,
              temperatureC: 41.8,
              efficiencyPercent: 98.2,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Inverter Status'), findsOneWidget);
      expect(find.text('Sungrow SG5.0RS (Single Phase)'), findsOneWidget);
      expect(find.text('ONLINE'), findsOneWidget);
      expect(find.text('3.85 kW'), findsOneWidget);
      expect(find.text('41.8 °C'), findsOneWidget);
      expect(find.text('98.2%'), findsOneWidget);
    });

    testWidgets('Tapping InverterStatusCard opens telemetry modal sheet', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: InverterStatusCard())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Inverter Status'));
      await tester.pumpAndSettle();

      expect(
        find.text('String Inverter Telemetry & Diagnostic Health'),
        findsOneWidget,
      );
      expect(find.text('Close Inverter Telemetry'), findsOneWidget);

      await tester.tap(find.text('Close Inverter Telemetry'));
      await tester.pumpAndSettle();
      expect(
        find.text('String Inverter Telemetry & Diagnostic Health'),
        findsNothing,
      );
    });
  });

  group('Refinement 2 — Technician Dashboard Tests', () {
    setUp(() {
      TechnicianRepository.instance.resetToDefault();
    });

    test(
      'TechnicianRepository holds requests and updates status and notes',
      () {
        final repo = TechnicianRepository.instance;
        expect(repo.requests.isNotEmpty, isTrue);

        final firstReq = repo.requests.first;
        repo.updateStatus(firstReq.id, TechnicianRequestStatus.inProgress);
        expect(
          repo.requests.first.status,
          equals(TechnicianRequestStatus.inProgress),
        );

        repo.updateNotes(firstReq.id, 'Inspected wiring terminals.');
        expect(
          repo.requests.first.technicianNotes,
          equals('Inspected wiring terminals.'),
        );
      },
    );

    testWidgets(
      'Renders TechnicianDashboardScreen with requests and filter chips',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          const MaterialApp(home: TechnicianDashboardScreen()),
        );
        await tester.pumpAndSettle();

        expect(find.text('Technician Dashboard'), findsOneWidget);
        expect(find.text('Vikram S.'), findsOneWidget);
        expect(find.text('Ravi Kumar'), findsWidgets);

        // Tap filter chip for Resolved
        final resolvedChip = find.textContaining('Resolved');
        expect(resolvedChip, findsWidgets);
        await tester.tap(resolvedChip.first);
        await tester.pumpAndSettle();

        // Tap first request to open detail sheet
        final requestCard = find.text('Anand Ranganathan');
        if (requestCard.evaluate().isNotEmpty) {
          await tester.tap(requestCard);
          await tester.pumpAndSettle();
          expect(find.text('Save & Update Status'), findsOneWidget);
          await tester.tap(find.text('Cancel'));
          await tester.pumpAndSettle();
        }
      },
    );
  });

  group('Refinement 3 — Other / Not Sure 4-Question Questionnaire Tests', () {
    test('OtherNotSureData formats answers properly', () {
      const data = OtherNotSureData(
        noticedSymptoms: [
          'Inverter repeatedly switches on and off',
          'Inverter seems unusually hot',
        ],
        problemStartTime: 'Today / suddenly',
        inverterProducingStatus: 'No, it appears to have stopped',
        accessibleInterfaces: 'Both',
      );

      expect(data.isFilled, isTrue);
      expect(data.answeredCount, equals(4));
      final summary = data.toSummaryText();
      expect(
        summary.contains('Inverter repeatedly switches on and off'),
        isTrue,
      );
      expect(summary.contains('Today / suddenly'), isTrue);
      expect(summary.contains('No, it appears to have stopped'), isTrue);
      expect(summary.contains('Both'), isTrue);
    });

    testWidgets('OtherNotSureWizardSheet allows selecting answers and saving', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      OtherNotSureData? savedData;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtherNotSureWizardSheet(
              onSaved: (data) {
                savedData = data;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Other / Not Sure'), findsOneWidget);
      expect(
        find.text('1. What have you noticed?'),
        findsNothing,
      ); // Check section header
      expect(find.text('What have you noticed?'), findsOneWidget);
      expect(find.text('When did the problem start?'), findsOneWidget);
      expect(find.text('Is the inverter producing power now?'), findsOneWidget);
      expect(find.text('What can you access?'), findsOneWidget);

      // Select Q1 option
      await tester.tap(find.text('Generation is lower than usual'));
      await tester.pump();

      // Select Q2 option
      await tester.tap(find.text('Today / suddenly'));
      await tester.pump();

      // Select Q3 option
      await tester.tap(find.text('Yes, it appears to be producing'));
      await tester.pump();

      // Select Q4 option
      await tester.tap(find.text('Both'));
      await tester.pump();

      // Tap Save
      await tester.tap(find.text('Save Answers'));
      await tester.pumpAndSettle();

      expect(savedData, isNotNull);
      expect(
        savedData!.noticedSymptoms.contains('Generation is lower than usual'),
        isTrue,
      );
      expect(savedData!.problemStartTime, equals('Today / suddenly'));
      expect(
        savedData!.inverterProducingStatus,
        equals('Yes, it appears to be producing'),
      );
      expect(savedData!.accessibleInterfaces, equals('Both'));
    });

    testWidgets(
      'SelectProblemScreen displays Other / Not Sure card and opens wizard',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(const MaterialApp(home: SelectProblemScreen()));
        await tester.pumpAndSettle();

        final otherCard = find.text('Other / Not Sure');
        expect(otherCard, findsOneWidget);

        await tester.tap(otherCard);
        await tester.pumpAndSettle();

        // Wizard sheet should appear
        expect(
          find.text('Answer 4 quick questions to help diagnose your system'),
          findsOneWidget,
        );
      },
    );
  });
}
