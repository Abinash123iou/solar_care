import '../../diagnostics/models/diagnostic_result_model.dart';
import '../../problem_report/models/problem_report_model.dart';
import '../models/report_history_entry.dart';

/// In-memory repository managing submitted problem reports and historical records.
/// Enables seamless data flow from Screen 3 submission to Screen 5 history.
class ReportHistoryRepository {
  // Singleton pattern for application-wide consistency
  static final ReportHistoryRepository _instance =
      ReportHistoryRepository._internal();
  static ReportHistoryRepository get instance => _instance;

  ReportHistoryRepository._internal() {
    resetToDefault();
  }

  final List<ReportHistoryEntry> _reports = [];

  List<ReportHistoryEntry> get cachedReports => List.unmodifiable(_reports);

  /// Resets repository to approved default demo history reports
  void resetToDefault() {
    _reports.clear();
    _reports.addAll(_buildInitialDemoReports());
  }

  /// Clears all reports to simulate a fresh empty account state
  void clearReports() {
    _reports.clear();
  }

  /// Appends a newly submitted report to the top of history
  void addReport(
    FullProblemReport report, {
    DiagnosticStatus status = DiagnosticStatus.complete,
  }) {
    // Insert at beginning so newest reports appear first
    _reports.insert(
      0,
      ReportHistoryEntry(report: report, status: status, isDemoData: false),
    );
  }

  /// Updates status of an existing report by ID
  void updateStatus(String reportId, DiagnosticStatus newStatus) {
    final index = _reports.indexWhere((e) => e.reportId == reportId);
    if (index != -1) {
      _reports[index] = _reports[index].copyWith(status: newStatus);
    }
  }

  /// Fetches reports with simulated network latency and mock failure controls
  Future<List<ReportHistoryEntry>> getReports({
    bool forceError = false,
    bool forceEmpty = false,
  }) async {
    // Simulate real-world network latency
    await Future.delayed(const Duration(milliseconds: 550));

    if (forceError) {
      throw Exception(
        'Unable to synchronize report history from SolarCare Gateway. Please check internet connection.',
      );
    }

    if (forceEmpty) {
      return [];
    }

    return List.unmodifiable(_reports);
  }

  static List<ReportHistoryEntry> _buildInitialDemoReports() {
    final now = DateTime.now();

    return [
      // 1. Completed Low Generation Report
      ReportHistoryEntry(
        isDemoData: true,
        status: DiagnosticStatus.complete,
        customSummary:
            'Observed 31% generation drop across String 2 during peak noon irradiance.',
        report: FullProblemReport(
          reportId: 'SC-REP-2026-4821',
          symptomIds: {'low_generation'},
          symptomLabels: ['Low Power Generation'],
          problemDescription:
              'Output dropped to 2.4 kW instead of the expected 4.2 kW during full sunlight.',
          photos: const [
            PhotoAttachment(
              id: 'demo_photo_1',
              imageUri:
                  'https://images.unsplash.com/photo-1508873696983-2df57046475a?auto=format&fit=crop&w=600&q=80',
              label: 'Dust Layer on String 2',
              description:
                  'Visible dirt and pollen accumulation on lower panel row.',
              isSamplePhoto: true,
            ),
          ],
          submittedAt: now.subtract(const Duration(days: 1, hours: 3)),
        ),
      ),

      // 2. Completed Inverter Fault Report
      ReportHistoryEntry(
        isDemoData: true,
        status: DiagnosticStatus.complete,
        customSummary:
            'Inverter triggered safety lockout E022 after morning dew condensation.',
        report: FullProblemReport(
          reportId: 'SC-REP-2026-3914',
          symptomIds: {'inverter_fault'},
          symptomLabels: ['Inverter Fault / Blinking Red'],
          inverterErrorCode: 'E022',
          screen2Notes: 'Red LED blinking 3 times',
          problemDescription:
              'Inverter display shows Isolation Fault E022 and DC switch tripped off.',
          photos: const [
            PhotoAttachment(
              id: 'demo_photo_2',
              imageUri:
                  'https://images.unsplash.com/photo-1558441719-8b489c634a10?auto=format&fit=crop&w=600&q=80',
              label: 'Inverter LCD Fault',
              description: 'Inverter LCD displaying code E022.',
              isSamplePhoto: true,
            ),
          ],
          submittedAt: now.subtract(const Duration(days: 3, hours: 5)),
        ),
      ),

      // 3. Pending Panel Shading Report
      ReportHistoryEntry(
        isDemoData: true,
        status: DiagnosticStatus.pending,
        customSummary:
            'Awaiting telemetry sync: Tree branches encroaching on western solar array.',
        report: FullProblemReport(
          reportId: 'SC-REP-2026-5102',
          symptomIds: {'shading'},
          symptomLabels: ['Panel Shading'],
          problemDescription:
              'Neighboring tree growth has started casting shade across 3 panels after 2 PM.',
          photos: const [
            PhotoAttachment(
              id: 'demo_photo_3',
              imageUri:
                  'https://images.unsplash.com/photo-1509391365360-2e959784a276?auto=format&fit=crop&w=600&q=80',
              label: 'Tree Shadow on Array',
              description:
                  'Branch shadows covering bottom edge of panels 4, 5, and 6.',
              isSamplePhoto: true,
            ),
          ],
          submittedAt: now.subtract(const Duration(hours: 4, minutes: 20)),
        ),
      ),

      // 4. Analyzing Overheating Report
      ReportHistoryEntry(
        isDemoData: true,
        status: DiagnosticStatus.analyzing,
        customSummary:
            'Cloud diagnostic rules executing for inverter thermal derating event.',
        report: FullProblemReport(
          reportId: 'SC-REP-2026-6218',
          symptomIds: {'overheating'},
          symptomLabels: ['Overheating Warning'],
          problemDescription:
              'Inverter enclosure was very hot to touch and fan seemed to be running slowly.',
          photos: const [],
          submittedAt: now.subtract(const Duration(minutes: 45)),
        ),
      ),

      // 5. Failed Grid Issue Report
      ReportHistoryEntry(
        isDemoData: true,
        status: DiagnosticStatus.failed,
        customSummary:
            'Diagnostic gateway timeout: AC grid over-voltage surge caused disconnect.',
        report: FullProblemReport(
          reportId: 'SC-REP-2026-2180',
          symptomIds: {'grid_issue'},
          symptomLabels: ['Grid Issue'],
          problemDescription:
              'Inverter disconnected from local utility grid 4 times this afternoon.',
          photos: const [],
          submittedAt: now.subtract(const Duration(days: 6)),
        ),
      ),
    ];
  }
}
