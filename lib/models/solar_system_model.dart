import 'package:flutter/material.dart';
import '../core/widgets/status_badge.dart';

/// Represents high-level health and energy telemetry for the rooftop solar system.
class SolarSystemSummary {
  final String systemName;
  final String installationType;
  final double currentPowerKw;
  final double todayEnergyKwh;
  final int healthScore; // 0 - 100
  final String healthStatus;
  final String lastScanTime;
  final double peakCapacityKw;
  final double co2SavedKg;
  final double performanceRatio;
  final bool isOnline;

  const SolarSystemSummary({
    required this.systemName,
    required this.installationType,
    required this.currentPowerKw,
    required this.todayEnergyKwh,
    required this.healthScore,
    required this.healthStatus,
    required this.lastScanTime,
    required this.peakCapacityKw,
    required this.co2SavedKg,
    required this.performanceRatio,
    required this.isOnline,
  });
}

/// Represents individual rooftop solar component diagnostic telemetry.
class SolarComponentStatus {
  final String id;
  final String name;
  final String metricDetail;
  final String statusText;
  final StatusBadgeType badgeType;
  final IconData icon;

  const SolarComponentStatus({
    required this.id,
    required this.name,
    required this.metricDetail,
    required this.statusText,
    required this.badgeType,
    required this.icon,
  });
}

/// Diagnostic alert or recommendation derived from solar telemetry and AI diagnostics.
class DiagnosticAlert {
  final String id;
  final String title;
  final String description;
  final String severity; // "Notice", "Warning", "Critical"
  final StatusBadgeType badgeType;
  final String recommendation;
  final String timestamp;
  final IconData icon;

  const DiagnosticAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.badgeType,
    required this.recommendation,
    required this.timestamp,
    required this.icon,
  });
}

/// Top-level data package for the SolarCare Dashboard.
class SolarDashboardData {
  final SolarSystemSummary summary;
  final List<SolarComponentStatus> components;
  final List<DiagnosticAlert> alerts;

  const SolarDashboardData({
    required this.summary,
    required this.components,
    required this.alerts,
  });
}
