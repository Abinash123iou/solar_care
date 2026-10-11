import '../models/diagnostic_result_model.dart';
import '../../problem_report/models/problem_report_model.dart';

/// Service generating contextual rule-based diagnostic findings for rooftop solar reports.
/// Separates business and diagnostic rules from presentation widgets.
class DiagnosticService {
  /// Evaluates the submitted problem report and returns diagnostic results.
  /// Simulates AWS Lambda cloud rule execution.
  static Future<DiagnosticReportResult> analyzeReport(
    FullProblemReport report,
  ) async {
    // Simulated processing latency for rule engine
    await Future.delayed(const Duration(milliseconds: 1400));

    final symptomIds = report.symptomIds;
    final errorCode = report.inverterErrorCode?.trim();

    // Contextual evaluation based on selected symptoms
    if (symptomIds.contains('inverter_fault') ||
        (errorCode != null && errorCode.isNotEmpty)) {
      return _generateInverterFaultResult(report);
    } else if (symptomIds.contains('overheating')) {
      return _generateOverheatingResult(report);
    } else if (symptomIds.contains('grid_issue')) {
      return _generateGridIssueResult(report);
    } else if (symptomIds.contains('other_not_sure') ||
        (report.otherNotSureData != null &&
            report.otherNotSureData!.isFilled)) {
      return _generateOtherNotSureResult(report);
    } else {
      // Default / Low Generation / Shading / General
      return generateGenerationOrShadingResult(report);
    }
  }

  /// Generates sample results for Low Generation / Shading symptoms
  static DiagnosticReportResult generateGenerationOrShadingResult(
    FullProblemReport report,
  ) {
    final hasShading = report.symptomIds.contains('shading');

    return DiagnosticReportResult(
      report: report,
      status: DiagnosticStatus.complete,
      overallHealthStatus: 'Degraded Performance • Action Advised',
      severity: SeverityLevel.moderate,
      suspectedCategory: hasShading
          ? 'Partial Shading & String Inbalance'
          : 'Under-Generation & PV Soiling',
      analyzedAt: DateTime.now(),
      isDemoData: true,
      measurements: const [
        DiagnosticMeasurement(
          label: 'Current Yield Loss',
          value: '-31.4%',
          normalRange: '± 5.0% Variance',
          status: 'Below Baseline',
          isWarning: true,
        ),
        DiagnosticMeasurement(
          label: 'String 1 DC Voltage',
          value: '382 V',
          normalRange: '360 - 410 V',
          status: 'Healthy Range',
          isWarning: false,
        ),
        DiagnosticMeasurement(
          label: 'String 2 DC Voltage',
          value: '218 V',
          normalRange: '360 - 410 V',
          status: 'Under-Voltage',
          isWarning: true,
        ),
      ],
      findings: [
        DiagnosticFinding(
          id: 'find_string_voltage_drop',
          title: 'String 2 DC Voltage Disparity Detected',
          explanation:
              'String 2 is operating at 218V, approximately 43% below String 1 (382V). This indicates localized module suppression or bypass diode engagement.',
          confidence: 0.89,
          isSuspected: true,
          supportingEvidence:
              'Telemetry logs show String 2 DC input drop initiating at 10:45 AM during peak solar irradiance. System output is capped at 2.6 kW instead of 4.2 kW nominal.',
          severity: SeverityLevel.moderate,
        ),
        DiagnosticFinding(
          id: 'find_soiling_or_shading',
          title: hasShading
              ? 'Localized Array Obstruction / Foliage'
              : 'Localized Surface Soiling or Debris',
          explanation: hasShading
              ? 'Asymmetric string yield curve matches profile of external tree or structure shadow casting across rows 2 and 3.'
              : 'Gradual multi-day yield tapering matches heavy dust or particulate settlement on the lower quadrant of panels.',
          confidence: 0.82,
          isSuspected: true,
          supportingEvidence:
              'Reported issue symptoms and uploaded rooftop photos correlate with localized light attenuation on panel surface.',
          severity: SeverityLevel.low,
        ),
      ],
      recommendations: const [
        DiagnosticRecommendation(
          stepNumber: 1,
          title: 'Perform Ground-Level Visual Inspection',
          description:
              'Inspect panels on String 2 from ground level or a safe vantage point. Look for tree branch shading, bird droppings, or accumulated leaves.',
          isProfessionalRequired: false,
          isSafetyWarning: false,
        ),
        DiagnosticRecommendation(
          stepNumber: 2,
          title: 'Clean Panel Glass Safely (Early Morning Only)',
          description:
              'If safe to do so from the ground, gently rinse panel glass with low-pressure water before 10:00 AM while panels are cool. Never use abrasive chemicals or high-pressure washers.',
          isProfessionalRequired: false,
          isSafetyWarning: false,
        ),
        DiagnosticRecommendation(
          stepNumber: 3,
          title: 'Schedule Certified Technician Inspection',
          description:
              'If String 2 voltage remains suppressed after cleaning, an on-site technician should test DC string open-circuit voltage (Voc) and bypass diodes.',
          isProfessionalRequired: true,
          isSafetyWarning: false,
        ),
        DiagnosticRecommendation(
          stepNumber: 4,
          title: 'High Voltage Safety Advisory',
          description:
              'Do NOT attempt to disconnect solar cables, open inverter enclosures, or touch exposed wiring. Rooftop DC voltages can exceed 400V.',
          isProfessionalRequired: false,
          isSafetyWarning: true,
        ),
      ],
    );
  }

  /// Generates sample results for Inverter Fault / Error Code symptoms
  static DiagnosticReportResult _generateInverterFaultResult(
    FullProblemReport report,
  ) {
    final code = report.inverterErrorCode ?? 'E022';

    return DiagnosticReportResult(
      report: report,
      status: DiagnosticStatus.complete,
      overallHealthStatus:
          'Inverter Lockout • Professional Inspection Required',
      severity: SeverityLevel.high,
      suspectedCategory: 'Inverter Isolation / DC Disconnect Event',
      analyzedAt: DateTime.now(),
      isDemoData: true,
      measurements: [
        DiagnosticMeasurement(
          label: 'Inverter Fault Code',
          value: code,
          normalRange: 'No Active Code',
          status: 'Fault Active',
          isWarning: true,
        ),
        const DiagnosticMeasurement(
          label: 'Insulation Resistance (Riso)',
          value: '0.42 MΩ',
          normalRange: '> 1.0 MΩ Norm',
          status: 'Low Insulation',
          isWarning: true,
        ),
        const DiagnosticMeasurement(
          label: 'AC Grid Sync Voltage',
          value: '236 V',
          normalRange: '220 - 245 V',
          status: 'Grid Synced',
          isWarning: false,
        ),
      ],
      findings: [
        DiagnosticFinding(
          id: 'find_inverter_lockout',
          title: 'Inverter Safety Lockout ($code)',
          explanation:
              'Inverter triggered an automated safety shutdown after detecting low insulation resistance (0.42 MΩ), which prevents electrical leakage into grounding.',
          confidence: 0.94,
          isSuspected: false, // Confirmed fault based on error code
          supportingEvidence:
              'Telemetry log recorded fault code $code with instantaneous DC power cut-off. Inverter relay opened to isolate PV array from household grid.',
          severity: SeverityLevel.high,
        ),
        const DiagnosticFinding(
          id: 'find_wiring_moisture',
          title: 'Suspected Moisture Ingress in MC4 Connector',
          explanation:
              'Low insulation resistance is commonly triggered by water ingress in outdoor junction boxes or worn cable sheathing after rain.',
          confidence: 0.79,
          isSuspected: true,
          supportingEvidence:
              'Insulation resistance dropped below 1.0 MΩ following recent temperature changes and moisture condensation.',
          severity: SeverityLevel.moderate,
        ),
      ],
      recommendations: const [
        DiagnosticRecommendation(
          stepNumber: 1,
          title: 'Perform Controlled Inverter Safe Restart',
          description:
              'Turn OFF AC breaker first, then switch OFF DC isolator switch. Wait 5 minutes for capacitors to discharge, then turn DC isolator ON, followed by AC breaker.',
          isProfessionalRequired: false,
          isSafetyWarning: false,
        ),
        DiagnosticRecommendation(
          stepNumber: 2,
          title: 'Do NOT Open Inverter Casing',
          description:
              'Live lethal DC voltages are present inside the inverter enclosure. Under no circumstances should casing screws be removed by non-certified personnel.',
          isProfessionalRequired: false,
          isSafetyWarning: true,
        ),
        DiagnosticRecommendation(
          stepNumber: 3,
          title: 'Contact Qualified Solar Installer / Service Team',
          description:
              'If the isolation fault code recurs immediately upon restarting, contact a qualified technician to conduct an insulation resistance test with a megohmmeter.',
          isProfessionalRequired: true,
          isSafetyWarning: false,
        ),
      ],
    );
  }

  /// Generates sample results for Overheating symptoms
  static DiagnosticReportResult _generateOverheatingResult(
    FullProblemReport report,
  ) {
    return DiagnosticReportResult(
      report: report,
      status: DiagnosticStatus.complete,
      overallHealthStatus: 'Thermal Warning • Inverter Derating',
      severity: SeverityLevel.moderate,
      suspectedCategory: 'Inverter Overheating & Heat Dissipation',
      analyzedAt: DateTime.now(),
      isDemoData: true,
      measurements: const [
        DiagnosticMeasurement(
          label: 'Inverter Internal Temp',
          value: '68.4 °C',
          normalRange: '< 55.0 °C',
          status: 'High Temp',
          isWarning: true,
        ),
        DiagnosticMeasurement(
          label: 'Power Derating',
          value: '-28.0%',
          normalRange: '0.0% Nominal',
          status: 'Derating Active',
          isWarning: true,
        ),
        DiagnosticMeasurement(
          label: 'Cooling Fan RPM',
          value: '1,200 RPM',
          normalRange: '3,200 RPM Max',
          status: 'Low Airflow',
          isWarning: true,
        ),
      ],
      findings: const [
        DiagnosticFinding(
          id: 'find_thermal_throttling',
          title: 'Automated Thermal Power Derating Active',
          explanation:
              'Inverter internal temperature reached 68.4°C, triggering protective software derating to prevent component burnout.',
          confidence: 0.92,
          isSuspected: false,
          supportingEvidence:
              'Inverter telemetry recorded progressive power curtailment starting at 12:15 PM when ambient enclosure temperature exceeded 65°C.',
          severity: SeverityLevel.moderate,
        ),
        DiagnosticFinding(
          id: 'find_airflow_restriction',
          title: 'Suspected Heat Sink Ventilation Obstruction',
          explanation:
              'Cooling fan speed is constrained or heat sink fins may have accumulated dust, reducing thermal dissipation.',
          confidence: 0.81,
          isSuspected: true,
          supportingEvidence:
              'Cooling fan operating at only 1,200 RPM during peak heat cycle; temperature slope is 35% steeper than nominal baseline.',
          severity: SeverityLevel.moderate,
        ),
      ],
      recommendations: const [
        DiagnosticRecommendation(
          stepNumber: 1,
          title: 'Check Inverter Clearances & Ventilation',
          description:
              'Ensure at least 30 cm (12 in) of open space around the top, bottom, and sides of the inverter. Remove any stored boxes, covers, or debris.',
          isProfessionalRequired: false,
          isSafetyWarning: false,
        ),
        DiagnosticRecommendation(
          stepNumber: 2,
          title: 'Clean External Heat Sink Fins',
          description:
              'Use a soft, dry brush or low-pressure canned air to remove dust and cobwebs from external aluminum heat sink fins on the back of the unit.',
          isProfessionalRequired: false,
          isSafetyWarning: false,
        ),
        DiagnosticRecommendation(
          stepNumber: 3,
          title: 'Contact Technician for Fan Replacement',
          description:
              'If the inverter cooling fan fails to spin up during peak sun, request an installer service call to test or replace the internal cooling fan unit.',
          isProfessionalRequired: true,
          isSafetyWarning: false,
        ),
      ],
    );
  }

  /// Generates sample results for Grid Issue symptoms
  static DiagnosticReportResult _generateGridIssueResult(
    FullProblemReport report,
  ) {
    return DiagnosticReportResult(
      report: report,
      status: DiagnosticStatus.complete,
      overallHealthStatus: 'Grid Instability • Over-Voltage Cutoff',
      severity: SeverityLevel.moderate,
      suspectedCategory: 'Utility Grid Voltage Fluctuation',
      analyzedAt: DateTime.now(),
      isDemoData: true,
      measurements: const [
        DiagnosticMeasurement(
          label: 'Grid AC Voltage',
          value: '254.2 V',
          normalRange: '216 - 248 V',
          status: 'Over-Voltage',
          isWarning: true,
        ),
        DiagnosticMeasurement(
          label: 'Grid Frequency',
          value: '50.1 Hz',
          normalRange: '49.8 - 50.2 Hz',
          status: 'Stable',
          isWarning: false,
        ),
        DiagnosticMeasurement(
          label: 'Inverter Grid Disconnects',
          value: '4 today',
          normalRange: '0 Nominal',
          status: 'Intermittent',
          isWarning: true,
        ),
      ],
      findings: const [
        DiagnosticFinding(
          id: 'find_grid_overvoltage',
          title: 'Local Grid Voltage Exceeded Safety Threshold',
          explanation:
              'Inverter recorded AC grid voltage spikes reaching 254.2V. Local grid standards require solar inverters to disconnect when grid voltage exceeds 253V.',
          confidence: 0.95,
          isSuspected: false,
          supportingEvidence:
              '4 anti-islanding trip events recorded between 1:00 PM and 3:00 PM, aligning with neighborhood rooftop export peaks.',
          severity: SeverityLevel.moderate,
        ),
      ],
      recommendations: const [
        DiagnosticRecommendation(
          stepNumber: 1,
          title: 'Confirm Neighborhood Solar Penetration',
          description:
              'High grid voltage during mid-afternoon often occurs when multiple neighboring solar systems export simultaneously onto a localized utility transformer.',
          isProfessionalRequired: false,
          isSafetyWarning: false,
        ),
        DiagnosticRecommendation(
          stepNumber: 2,
          title: 'Report Over-Voltage to Utility Grid Operator',
          description:
              'Provide logged voltage readings (254.2V) to your local power distribution utility. They may need to tap-change the neighborhood substation transformer.',
          isProfessionalRequired: false,
          isSafetyWarning: false,
        ),
        DiagnosticRecommendation(
          stepNumber: 3,
          title: 'Consult Installer for Grid Volt-Watt Settings',
          description:
              'Ask your certified solar installer whether Volt-Watt response mode (AS/NZS 4777 or IEEE 1547) can be enabled to gracefully ramp down rather than tripping off entirely.',
          isProfessionalRequired: true,
          isSafetyWarning: false,
        ),
      ],
    );
  }

  /// Generates a pending state result
  static DiagnosticReportResult getPendingResult(FullProblemReport report) {
    return DiagnosticReportResult(
      report: report,
      status: DiagnosticStatus.pending,
      overallHealthStatus: 'Awaiting Telemetry Stream & Rule Evaluation',
      severity: SeverityLevel.low,
      suspectedCategory: 'Analysis in Progress',
      analyzedAt: null,
      isDemoData: true,
      measurements: const [],
      findings: const [],
      recommendations: const [],
    );
  }

  /// Generates an empty state result
  static DiagnosticReportResult getEmptyResult(FullProblemReport report) {
    return DiagnosticReportResult(
      report: report,
      status: DiagnosticStatus.empty,
      overallHealthStatus: 'No Diagnostic Telemetry Available',
      severity: SeverityLevel.low,
      suspectedCategory: 'Telemetry Awaiting Initial Scan',
      analyzedAt: null,
      isDemoData: true,
      measurements: const [],
      findings: const [],
      recommendations: const [],
    );
  }

  /// Generates sample results for Other / Not Sure assessment
  static DiagnosticReportResult _generateOtherNotSureResult(
    FullProblemReport report,
  ) {
    final data = report.otherNotSureData;
    final noticed = data?.noticedSymptoms ?? [];
    final isCycling = noticed.contains(
      'Inverter repeatedly switches on and off',
    );
    final isHot = noticed.contains('Inverter seems unusually hot');
    final isWarning = noticed.contains('Warning light or unusual message');
    final isOff = noticed.contains('System appears completely off');
    final isAppStopped = noticed.contains(
      'Monitoring app has stopped updating',
    );

    String healthStatus = 'Diagnostic Assessment Completed';
    SeverityLevel severity = SeverityLevel.moderate;
    String suspectedCategory = 'Multi-Factor Diagnostic Assessment';

    if (isOff || isCycling) {
      severity = SeverityLevel.critical;
      healthStatus = 'Critical Operating Anomaly Detected';
      suspectedCategory = isOff
          ? 'System Inoperative / Breaker Tripped'
          : 'Inverter Thermal Cycling / Grid Voltage Instability';
    } else if (isHot || isWarning) {
      severity = SeverityLevel.high;
      healthStatus = 'Warning State Detected';
      suspectedCategory = isHot
          ? 'Thermal Overheating Risk'
          : 'Inverter Fault Indicator Active';
    } else if (isAppStopped) {
      severity = SeverityLevel.low;
      healthStatus = 'Telemetry & Gateway Desynchronization';
      suspectedCategory = 'Communication Gateway Disconnected';
    }

    return DiagnosticReportResult(
      report: report,
      status: DiagnosticStatus.complete,
      overallHealthStatus: healthStatus,
      severity: severity,
      suspectedCategory: suspectedCategory,
      analyzedAt: DateTime.now(),
      isDemoData: true,
      measurements: [
        DiagnosticMeasurement(
          label: 'Inverter Output',
          value: data?.inverterProducingStatus ?? 'Status Unknown',
          normalRange: 'Producing Nominal',
          status: data?.inverterProducingStatus?.contains('Yes') == true
              ? 'Generating'
              : 'Needs Inspection',
          isWarning: data?.inverterProducingStatus?.contains('No') == true,
        ),
        DiagnosticMeasurement(
          label: 'Problem Timeline',
          value: data?.problemStartTime ?? 'Recent Incident',
          normalRange: 'Standard Baseline',
          status: 'Recorded',
          isWarning: false,
        ),
        DiagnosticMeasurement(
          label: 'Accessible Interface',
          value: data?.accessibleInterfaces ?? 'Local Display',
          normalRange: 'App & Inverter Sync',
          status: 'Available',
          isWarning: false,
        ),
      ],
      findings: [
        DiagnosticFinding(
          id: 'ons_1',
          title: 'User Reported Observations Evaluated',
          explanation: noticed.isNotEmpty
              ? 'Troubleshooting questionnaire identified: ${noticed.join(', ')}.'
              : 'User submitted assessment for unclassified rooftop symptoms.',
          confidence: 0.88,
          isSuspected: true,
          supportingEvidence:
              'Correlated user questionnaire responses with solar inverter operational thresholds.',
          severity: severity,
        ),
        if (isCycling)
          const DiagnosticFinding(
            id: 'ons_2',
            title: 'Repetitive Power-Cycle Characteristic',
            explanation:
                'Repeated on/off cycling indicates internal thermal cutoff protection or out-of-spec utility grid impedance.',
            confidence: 0.91,
            isSuspected: true,
            supportingEvidence:
                'Inverter relays clicking on and off during daytime irradiance peak.',
            severity: SeverityLevel.critical,
          ),
        if (isHot)
          const DiagnosticFinding(
            id: 'ons_3',
            title: 'Heatsink Thermal Dissipation Alert',
            explanation:
                'Inverter casing temperature elevated. Heat dissipation fins may be clogged or external fan failed.',
            confidence: 0.87,
            isSuspected: true,
            supportingEvidence:
                'High ambient temperature coupled with restricted ventilation clearance.',
            severity: SeverityLevel.high,
          ),
      ],
      recommendations: const [
        DiagnosticRecommendation(
          stepNumber: 1,
          title: 'Review Inverter Display & Error Indicators',
          description:
              'Check the LED status light on the front panel (Green = Normal, Amber = Standby, Red = Alarm).',
          isProfessionalRequired: false,
          isSafetyWarning: false,
        ),
        DiagnosticRecommendation(
          stepNumber: 2,
          title: 'Perform Controlled System Power-Cycle',
          description:
              'Follow the standard shutdown procedure: Switch AC isolator OFF, then DC switch OFF. Wait 5 minutes before restarting.',
          isProfessionalRequired: false,
          isSafetyWarning: false,
        ),
        DiagnosticRecommendation(
          stepNumber: 3,
          title: 'Dispatch Certified SolarCare Field Technician',
          description:
              'Because multiple unconfirmed symptoms were noted, request an on-site technician inspection from the Service Portal.',
          isProfessionalRequired: true,
          isSafetyWarning: false,
        ),
      ],
    );
  }

  /// Generates an error/failed state result
  static DiagnosticReportResult getErrorResult(FullProblemReport report) {
    return DiagnosticReportResult(
      report: report,
      status: DiagnosticStatus.failed,
      overallHealthStatus: 'Diagnostics Service Unavailable',
      severity: SeverityLevel.high,
      suspectedCategory: 'Gateway Connection Timeout',
      analyzedAt: null,
      errorMessage:
          'Unable to establish secure telemetry handshake with rooftop inverter gateway. Please verify Wi-Fi signal or retry.',
      isDemoData: true,
      measurements: const [],
      findings: const [],
      recommendations: const [],
    );
  }
}
