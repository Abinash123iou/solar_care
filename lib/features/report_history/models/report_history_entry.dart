import '../../diagnostics/models/diagnostic_result_model.dart';
import '../../problem_report/models/problem_report_model.dart';

/// Filter criteria for report status
enum ReportStatusFilter {
  all('All'),
  pending('Pending'),
  analyzing('Analyzing'),
  completed('Completed'),
  failed('Failed');

  final String label;
  const ReportStatusFilter(this.label);

  bool matches(DiagnosticStatus status) {
    switch (this) {
      case ReportStatusFilter.all:
        return true;
      case ReportStatusFilter.pending:
        return status == DiagnosticStatus.pending ||
            status == DiagnosticStatus.submitted;
      case ReportStatusFilter.analyzing:
        return status == DiagnosticStatus.analyzing;
      case ReportStatusFilter.completed:
        return status == DiagnosticStatus.complete;
      case ReportStatusFilter.failed:
        return status == DiagnosticStatus.failed;
    }
  }
}

/// A historical problem report entry combining report details with its diagnostic status
class ReportHistoryEntry {
  final FullProblemReport report;
  final DiagnosticStatus status;
  final bool isDemoData;
  final String? customSummary;

  const ReportHistoryEntry({
    required this.report,
    required this.status,
    this.isDemoData = false,
    this.customSummary,
  });

  String get reportId => report.reportId;
  DateTime get submittedAt => report.submittedAt;
  List<String> get symptomLabels => report.symptomLabels;
  String? get inverterErrorCode => report.inverterErrorCode;
  String get problemDescription => report.problemDescription;
  List<PhotoAttachment> get photos => report.photos;

  String get primaryCategory =>
      symptomLabels.isNotEmpty ? symptomLabels.first : 'General Rooftop Issue';

  String get summaryText {
    if (customSummary != null && customSummary!.isNotEmpty) {
      return customSummary!;
    }
    if (problemDescription.isNotEmpty) {
      return problemDescription;
    }
    if (report.screen2Notes != null && report.screen2Notes!.isNotEmpty) {
      return report.screen2Notes!;
    }
    return 'Diagnostic triage requested for rooftop system.';
  }

  PhotoAttachment? get primaryPhoto => photos.isNotEmpty ? photos.first : null;

  ReportHistoryEntry copyWith({
    FullProblemReport? report,
    DiagnosticStatus? status,
    bool? isDemoData,
    String? customSummary,
  }) {
    return ReportHistoryEntry(
      report: report ?? this.report,
      status: status ?? this.status,
      isDemoData: isDemoData ?? this.isDemoData,
      customSummary: customSummary ?? this.customSummary,
    );
  }
}
