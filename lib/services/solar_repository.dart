import 'package:flutter/material.dart';
import '../core/widgets/status_badge.dart';
import '../models/solar_system_model.dart';

/// Clean service repository layer for SolarCare diagnostics.
/// Supplies mock data with realistic energy telemetry and error/empty handling.
class SolarRepository {
  /// Fetch solar dashboard data with simulated network latency.
  Future<SolarDashboardData> fetchDashboardData({
    bool forceError = false,
    bool forceEmpty = false,
  }) async {
    // Simulate real-world network latency
    await Future.delayed(const Duration(milliseconds: 650));

    if (forceError) {
      throw Exception(
        'Unable to reach Solar Gateway. Please verify inverter Wi-Fi connection.',
      );
    }

    if (forceEmpty) {
      return const SolarDashboardData(
        summary: SolarSystemSummary(
          systemName: 'New Rooftop Installation',
          installationType: 'Pending Calibration',
          currentPowerKw: 0.0,
          todayEnergyKwh: 0.0,
          healthScore: 0,
          healthStatus: 'Awaiting Diagnostics',
          lastScanTime: 'Never scanned',
          peakCapacityKw: 5.0,
          co2SavedKg: 0.0,
          performanceRatio: 0.0,
          isOnline: false,
        ),
        components: [],
        alerts: [],
      );
    }

    // Default rich realistic mock data
    return const SolarDashboardData(
      summary: SolarSystemSummary(
        systemName: 'Rooftop Array Alpha (5.2 kWp)',
        installationType: 'Monocrystalline Grid-Tied',
        currentPowerKw: 3.85,
        todayEnergyKwh: 18.4,
        healthScore: 94,
        healthStatus: 'Good Health',
        lastScanTime: 'Today at 10:15 AM',
        peakCapacityKw: 5.2,
        co2SavedKg: 14.6,
        performanceRatio: 96.2,
        isOnline: true,
      ),
      components: [
        SolarComponentStatus(
          id: 'pv_array',
          name: 'PV Array Panels',
          metricDetail: '12/12 Panels Active • 320W Avg Output',
          statusText: 'Optimal',
          badgeType: StatusBadgeType.success,
          icon: Icons.solar_power_rounded,
        ),
        SolarComponentStatus(
          id: 'inverter',
          name: 'String Inverter (5kW)',
          metricDetail: 'Efficiency 97.4% • 234V AC Stable',
          statusText: 'Healthy',
          badgeType: StatusBadgeType.success,
          icon: Icons.electric_bolt_rounded,
        ),
        SolarComponentStatus(
          id: 'grid_meter',
          name: 'Bi-Directional Meter',
          metricDetail: 'Exporting 2.1 kW to Local Grid',
          statusText: 'Synced',
          badgeType: StatusBadgeType.success,
          icon: Icons.grid_view_rounded,
        ),
        SolarComponentStatus(
          id: 'isolation',
          name: 'Wiring & Isolation',
          metricDetail: 'Insulation Resistance: 1.8 MΩ (> 1.0 MΩ standard)',
          statusText: 'Safe',
          badgeType: StatusBadgeType.success,
          icon: Icons.shield_rounded,
        ),
      ],
      alerts: [
        DiagnosticAlert(
          id: 'alert_soiling_string_b',
          title: 'Minor Soiling on String B Panels',
          description:
              'A 6.2% localized yield variance was observed compared to String A during peak irradiance.',
          severity: 'Notice',
          badgeType: StatusBadgeType.warning,
          recommendation:
              'Schedule a light surface water rinse before noon to restore peak generation.',
          timestamp: '2 hrs ago',
          icon: Icons.cleaning_services_rounded,
        ),
        DiagnosticAlert(
          id: 'alert_optimal_yield',
          title: 'Clear Sky Window Available',
          description:
              'Irradiance is currently optimal at 840 W/m². Inverter operating at max thermal efficiency.',
          severity: 'Optimal',
          badgeType: StatusBadgeType.success,
          recommendation: 'Ideal time for heavy household electrical loads.',
          timestamp: 'Just now',
          icon: Icons.wb_sunny_rounded,
        ),
      ],
    );
  }
}
