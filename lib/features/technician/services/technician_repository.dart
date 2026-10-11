import '../../diagnostics/models/diagnostic_result_model.dart';
import '../../problem_report/models/other_not_sure_data.dart';
import '../../problem_report/models/problem_report_model.dart';
import '../../report_history/services/report_history_repository.dart';
import '../models/technician_request.dart';

/// Repository managing customer service requests for the Technician Dashboard.
class TechnicianRepository {
  static final TechnicianRepository _instance =
      TechnicianRepository._internal();
  static TechnicianRepository get instance => _instance;

  TechnicianRepository._internal() {
    resetToDefault();
  }

  final List<TechnicianRequest> _requests = [];

  List<TechnicianRequest> get requests => List.unmodifiable(_requests);

  void resetToDefault() {
    _requests.clear();
    _requests.addAll(_buildInitialRequests());
  }

  /// Appends a new request (e.g. from real-time customer submission)
  void addRequest(TechnicianRequest req) {
    _requests.insert(0, req);
  }

  /// Updates request status
  void updateStatus(String requestId, TechnicianRequestStatus newStatus) {
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      _requests[idx] = _requests[idx].copyWith(status: newStatus);
    }
  }

  /// Updates technician notes
  void updateNotes(String requestId, String notes) {
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      _requests[idx] = _requests[idx].copyWith(technicianNotes: notes);
    }
  }

  /// Synchronizes newly submitted reports from ReportHistoryRepository into technician requests
  void syncFromReportHistory() {
    final historyReports = ReportHistoryRepository.instance.cachedReports;
    for (final entry in historyReports) {
      final exists = _requests.any((r) => r.reportId == entry.reportId);
      if (!exists && !entry.isDemoData) {
        _requests.insert(
          0,
          TechnicianRequest(
            id: 'REQ-${entry.reportId.replaceAll('SC-REP-', '')}',
            reportId: entry.reportId,
            customerName: 'Ravi Kumar',
            customerPhone: '+91 98401 23456',
            customerAddress: 'No. 14, 2nd Main Road, Anna Nagar, Chennai',
            systemCapacity: '5.2 kWp Monocrystalline',
            inverterModel: 'Sungrow SG5.0RS',
            symptoms: entry.symptomLabels,
            inverterErrorCode: entry.inverterErrorCode,
            problemDescription: entry.problemDescription,
            severity: entry.symptomLabels.contains('Inverter Fault')
                ? SeverityLevel.critical
                : SeverityLevel.moderate,
            status: TechnicianRequestStatus.pending,
            createdAt: entry.submittedAt,
            otherNotSureData: entry.report.otherNotSureData,
            fullReport: entry.report,
          ),
        );
      }
    }
  }

  static List<TechnicianRequest> _buildInitialRequests() {
    final now = DateTime.now();

    return [
      TechnicianRequest(
        id: 'REQ-8901',
        reportId: 'SC-REP-2024-8901',
        customerName: 'Ravi Kumar',
        customerPhone: '+91 98401 23456',
        customerAddress: '14, 2nd Main Road, Anna Nagar, Chennai',
        systemCapacity: '5.2 kWp Monocrystalline',
        inverterModel: 'Sungrow SG5.0RS (Single Phase)',
        symptoms: ['Other / Not Sure', 'Inverter Power Cycling'],
        inverterErrorCode: 'E022',
        problemDescription:
            'Inverter repeatedly clicks and resets around midday. App stopped updating generation curve.',
        severity: SeverityLevel.critical,
        status: TechnicianRequestStatus.pending,
        createdAt: now.subtract(const Duration(hours: 2)),
        otherNotSureData: const OtherNotSureData(
          noticedSymptoms: [
            'Inverter repeatedly switches on and off',
            'Inverter seems unusually hot',
            'Monitoring app has stopped updating',
          ],
          problemStartTime: 'Today / suddenly',
          inverterProducingStatus: 'No, it appears to have stopped',
          accessibleInterfaces: 'Both',
        ),
        fullReport: FullProblemReport(
          reportId: 'SC-REP-2024-8901',
          symptomIds: {'other_not_sure', 'inverter_fault'},
          symptomLabels: ['Other / Not Sure', 'Inverter Fault'],
          inverterErrorCode: 'E022',
          problemDescription:
              'Inverter repeatedly clicks and resets around midday. App stopped updating generation curve.',
          photos: [],
          submittedAt: now.subtract(const Duration(hours: 2)),
          otherNotSureData: const OtherNotSureData(
            noticedSymptoms: [
              'Inverter repeatedly switches on and off',
              'Inverter seems unusually hot',
              'Monitoring app has stopped updating',
            ],
            problemStartTime: 'Today / suddenly',
            inverterProducingStatus: 'No, it appears to have stopped',
            accessibleInterfaces: 'Both',
          ),
        ),
      ),
      TechnicianRequest(
        id: 'REQ-8742',
        reportId: 'SC-REP-2024-8742',
        customerName: 'Kavitha Sundaram',
        customerPhone: '+91 94440 98112',
        customerAddress: 'Plot 45, Besant Nagar Beach Road, Chennai',
        systemCapacity: '3.3 kWp Polycrystalline',
        inverterModel: 'GoodWe GW3000D-NS',
        symptoms: ['Inverter Fault / Blinking Red', 'Grid Issue'],
        inverterErrorCode: 'E014',
        problemDescription:
            'Red alarm light solid. System not feeding grid power since early morning thunderstorm.',
        severity: SeverityLevel.high,
        status: TechnicianRequestStatus.assigned,
        createdAt: now.subtract(const Duration(hours: 5)),
        technicianNotes:
            'Preliminary diagnosis: Grid surge caused AC surge protector tripping. Scheduled site visit at 3:30 PM.',
      ),
      TechnicianRequest(
        id: 'REQ-8610',
        reportId: 'SC-REP-2024-8610',
        customerName: 'Dr. M. Narayanan',
        customerPhone: '+91 97899 43210',
        customerAddress: '88, Gandhi Road, T. Nagar, Chennai',
        systemCapacity: '10.0 kWp Commercial Rooftop',
        inverterModel: 'SolarEdge SE10K (Three Phase)',
        symptoms: ['Low Power Generation', 'Panel Shading'],
        problemDescription:
            'String 2 output dropped 40% following construction of adjacent building extension.',
        severity: SeverityLevel.moderate,
        status: TechnicianRequestStatus.inProgress,
        createdAt: now.subtract(const Duration(days: 1)),
        technicianNotes:
            'Inspected roof. Recommended installing DC power optimizers on shaded String 2 panels.',
      ),
      TechnicianRequest(
        id: 'REQ-8495',
        reportId: 'SC-REP-2024-8495',
        customerName: 'Anand Ranganathan',
        customerPhone: '+91 98410 77654',
        customerAddress: '22, Velachery Main Road, Chennai',
        systemCapacity: '4.0 kWp Monocrystalline',
        inverterModel: 'Fronius Primo 4.0-1',
        symptoms: ['Overheating Warning'],
        problemDescription:
            'Fan noise excessive in afternoon and inverter thermal derating triggered.',
        severity: SeverityLevel.low,
        status: TechnicianRequestStatus.resolved,
        createdAt: now.subtract(const Duration(days: 3)),
        technicianNotes:
            'Cleaned heatsink dust buildup and verified clearance airflow. Operating at 44°C normal.',
      ),
    ];
  }
}
