import '../../diagnostics/models/diagnostic_result_model.dart';
import '../../problem_report/models/other_not_sure_data.dart';
import '../../problem_report/models/problem_report_model.dart';

/// Status of a technician customer service request
enum TechnicianRequestStatus {
  pending('Pending Dispatch'),
  assigned('Assigned to Me'),
  inProgress('In Progress'),
  resolved('Resolved');

  final String label;
  const TechnicianRequestStatus(this.label);
}

/// A customer service/problem report request visible on the Technician Dashboard
class TechnicianRequest {
  final String id;
  final String reportId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String systemCapacity;
  final String inverterModel;
  final List<String> symptoms;
  final String? inverterErrorCode;
  final String problemDescription;
  final SeverityLevel severity;
  final TechnicianRequestStatus status;
  final DateTime createdAt;
  final DateTime? scheduledTime;
  final String? technicianNotes;
  final OtherNotSureData? otherNotSureData;
  final FullProblemReport? fullReport;

  const TechnicianRequest({
    required this.id,
    required this.reportId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.systemCapacity,
    required this.inverterModel,
    required this.symptoms,
    this.inverterErrorCode,
    required this.problemDescription,
    this.severity = SeverityLevel.moderate,
    this.status = TechnicianRequestStatus.pending,
    required this.createdAt,
    this.scheduledTime,
    this.technicianNotes,
    this.otherNotSureData,
    this.fullReport,
  });

  TechnicianRequest copyWith({
    String? id,
    String? reportId,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? systemCapacity,
    String? inverterModel,
    List<String>? symptoms,
    String? inverterErrorCode,
    String? problemDescription,
    SeverityLevel? severity,
    TechnicianRequestStatus? status,
    DateTime? createdAt,
    DateTime? scheduledTime,
    String? technicianNotes,
    OtherNotSureData? otherNotSureData,
    FullProblemReport? fullReport,
  }) {
    return TechnicianRequest(
      id: id ?? this.id,
      reportId: reportId ?? this.reportId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      systemCapacity: systemCapacity ?? this.systemCapacity,
      inverterModel: inverterModel ?? this.inverterModel,
      symptoms: symptoms ?? this.symptoms,
      inverterErrorCode: inverterErrorCode ?? this.inverterErrorCode,
      problemDescription: problemDescription ?? this.problemDescription,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      technicianNotes: technicianNotes ?? this.technicianNotes,
      otherNotSureData: otherNotSureData ?? this.otherNotSureData,
      fullReport: fullReport ?? this.fullReport,
    );
  }
}
