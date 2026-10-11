import 'package:flutter/material.dart';
import '../../problem_report/models/problem_report_model.dart';
import '../../../core/theme/app_colors.dart';

/// Processing status of a submitted solar problem report
enum DiagnosticStatus {
  submitted,
  analyzing,
  complete,
  pending,
  empty,
  failed;

  String get label {
    switch (this) {
      case DiagnosticStatus.submitted:
        return 'Submitted';
      case DiagnosticStatus.analyzing:
        return 'Analyzing';
      case DiagnosticStatus.complete:
        return 'Analysis Complete';
      case DiagnosticStatus.pending:
        return 'Pending Analysis';
      case DiagnosticStatus.empty:
        return 'Awaiting Data';
      case DiagnosticStatus.failed:
        return 'Analysis Failed';
    }
  }

  Color get color {
    switch (this) {
      case DiagnosticStatus.complete:
        return AppColors.primaryEmerald;
      case DiagnosticStatus.analyzing:
        return const Color(0xFF0284C7);
      case DiagnosticStatus.submitted:
      case DiagnosticStatus.pending:
      case DiagnosticStatus.empty:
        return const Color(0xFFD97706);
      case DiagnosticStatus.failed:
        return AppColors.statusDanger;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case DiagnosticStatus.complete:
        return AppColors.mint;
      case DiagnosticStatus.analyzing:
        return const Color(0xFFE0F2FE);
      case DiagnosticStatus.submitted:
      case DiagnosticStatus.pending:
      case DiagnosticStatus.empty:
        return const Color(0xFFFEF3C7);
      case DiagnosticStatus.failed:
        return AppColors.statusDangerBg;
    }
  }

  IconData get icon {
    switch (this) {
      case DiagnosticStatus.complete:
        return Icons.check_circle_rounded;
      case DiagnosticStatus.analyzing:
        return Icons.autorenew_rounded;
      case DiagnosticStatus.submitted:
        return Icons.mark_email_read_rounded;
      case DiagnosticStatus.pending:
        return Icons.hourglass_top_rounded;
      case DiagnosticStatus.empty:
        return Icons.info_outline_rounded;
      case DiagnosticStatus.failed:
        return Icons.error_outline_rounded;
    }
  }
}

/// Severity classification for solar diagnostic findings
enum SeverityLevel {
  low,
  moderate,
  high,
  critical;

  String get label {
    switch (this) {
      case SeverityLevel.low:
        return 'Low Severity';
      case SeverityLevel.moderate:
        return 'Moderate';
      case SeverityLevel.high:
        return 'High Severity';
      case SeverityLevel.critical:
        return 'Critical';
    }
  }

  Color get color {
    switch (this) {
      case SeverityLevel.low:
        return const Color(0xFF137A4B);
      case SeverityLevel.moderate:
        return const Color(0xFFD97706);
      case SeverityLevel.high:
        return const Color(0xFFEA580C);
      case SeverityLevel.critical:
        return const Color(0xFFDC2626);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case SeverityLevel.low:
        return const Color(0xFFE8F5EC);
      case SeverityLevel.moderate:
        return const Color(0xFFFEF3C7);
      case SeverityLevel.high:
        return const Color(0xFFFFEDD5);
      case SeverityLevel.critical:
        return const Color(0xFFFEE2E2);
    }
  }
}

/// A specific telemetry measurement compared to expected nominal values
class DiagnosticMeasurement {
  final String label;
  final String value;
  final String normalRange;
  final String status;
  final bool isWarning;

  const DiagnosticMeasurement({
    required this.label,
    required this.value,
    required this.normalRange,
    required this.status,
    this.isWarning = false,
  });
}

/// Detailed diagnostic finding produced by the rule engine
class DiagnosticFinding {
  final String id;
  final String title;
  final String explanation;
  final double confidence; // 0.0 to 1.0
  final bool isSuspected; // true = suspected issue, false = confirmed fault
  final String supportingEvidence;
  final SeverityLevel severity;

  const DiagnosticFinding({
    required this.id,
    required this.title,
    required this.explanation,
    required this.confidence,
    this.isSuspected = true,
    required this.supportingEvidence,
    required this.severity,
  });

  String get confidencePercentage => '${(confidence * 100).toInt()}%';
}

/// Actionable step recommended for the solar system owner
class DiagnosticRecommendation {
  final int stepNumber;
  final String title;
  final String description;
  final bool isProfessionalRequired;
  final bool isSafetyWarning;

  const DiagnosticRecommendation({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.isProfessionalRequired = false,
    this.isSafetyWarning = false,
  });
}

/// Complete diagnostic report result aggregate model
class DiagnosticReportResult {
  final FullProblemReport report;
  final DiagnosticStatus status;
  final String overallHealthStatus;
  final SeverityLevel severity;
  final String suspectedCategory;
  final List<DiagnosticMeasurement> measurements;
  final List<DiagnosticFinding> findings;
  final List<DiagnosticRecommendation> recommendations;
  final DateTime? analyzedAt;
  final String? errorMessage;
  final bool isDemoData;

  const DiagnosticReportResult({
    required this.report,
    required this.status,
    required this.overallHealthStatus,
    required this.severity,
    required this.suspectedCategory,
    this.measurements = const [],
    this.findings = const [],
    this.recommendations = const [],
    this.analyzedAt,
    this.errorMessage,
    this.isDemoData = true,
  });

  DiagnosticReportResult copyWith({
    FullProblemReport? report,
    DiagnosticStatus? status,
    String? overallHealthStatus,
    SeverityLevel? severity,
    String? suspectedCategory,
    List<DiagnosticMeasurement>? measurements,
    List<DiagnosticFinding>? findings,
    List<DiagnosticRecommendation>? recommendations,
    DateTime? analyzedAt,
    String? errorMessage,
    bool? isDemoData,
  }) {
    return DiagnosticReportResult(
      report: report ?? this.report,
      status: status ?? this.status,
      overallHealthStatus: overallHealthStatus ?? this.overallHealthStatus,
      severity: severity ?? this.severity,
      suspectedCategory: suspectedCategory ?? this.suspectedCategory,
      measurements: measurements ?? this.measurements,
      findings: findings ?? this.findings,
      recommendations: recommendations ?? this.recommendations,
      analyzedAt: analyzedAt ?? this.analyzedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      isDemoData: isDemoData ?? this.isDemoData,
    );
  }
}
