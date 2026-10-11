import 'package:flutter/foundation.dart';

/// Structured answers collected when a user chooses "Other / Not Sure".
/// Captures the 4-question troubleshooting assessment.
@immutable
class OtherNotSureData {
  /// Q1: What have you noticed? (Multi-select)
  final List<String> noticedSymptoms;

  /// Optional text detail when "Something else" is checked in Q1
  final String? somethingElseDetail;

  /// Q2: When did the problem start?
  final String? problemStartTime;

  /// Q3: Is the inverter producing power now?
  final String? inverterProducingStatus;

  /// Q4: What can you access?
  final String? accessibleInterfaces;

  const OtherNotSureData({
    this.noticedSymptoms = const [],
    this.somethingElseDetail,
    this.problemStartTime,
    this.inverterProducingStatus,
    this.accessibleInterfaces,
  });

  /// Standard options for Q1
  static const List<String> q1Options = [
    'Generation is lower than usual',
    'Inverter repeatedly switches on and off',
    'Warning light or unusual message',
    'Inverter seems unusually hot',
    'Monitoring app has stopped updating',
    'Unusual sound or smell',
    'System appears completely off',
    'Something else',
  ];

  /// Standard options for Q2
  static const List<String> q2Options = [
    'Today / suddenly',
    'A few days ago',
    'Several weeks ago',
    'Not sure',
  ];

  /// Standard options for Q3
  static const List<String> q3Options = [
    'Yes, it appears to be producing',
    'No, it appears to have stopped',
    'I don\'t know how to check',
  ];

  /// Standard options for Q4
  static const List<String> q4Options = [
    'Solar monitoring app',
    'Inverter display or indicator lights',
    'Both',
    'Neither / not sure',
  ];

  bool get isFilled =>
      noticedSymptoms.isNotEmpty ||
      problemStartTime != null ||
      inverterProducingStatus != null ||
      accessibleInterfaces != null;

  int get answeredCount {
    int count = 0;
    if (noticedSymptoms.isNotEmpty) count++;
    if (problemStartTime != null && problemStartTime!.isNotEmpty) count++;
    if (inverterProducingStatus != null &&
        inverterProducingStatus!.isNotEmpty) {
      count++;
    }
    if (accessibleInterfaces != null && accessibleInterfaces!.isNotEmpty) {
      count++;
    }
    return count;
  }

  /// Formats all answers into a clean, human-readable summary
  String toSummaryText() {
    final buffer = StringBuffer();
    if (noticedSymptoms.isNotEmpty) {
      buffer.writeln('• Noticed: ${noticedSymptoms.join(', ')}');
      if (noticedSymptoms.contains('Something else') &&
          somethingElseDetail != null &&
          somethingElseDetail!.trim().isNotEmpty) {
        buffer.writeln('  Details: ${somethingElseDetail!.trim()}');
      }
    }
    if (problemStartTime != null && problemStartTime!.isNotEmpty) {
      buffer.writeln('• Started: $problemStartTime');
    }
    if (inverterProducingStatus != null &&
        inverterProducingStatus!.isNotEmpty) {
      buffer.writeln('• Inverter Producing: $inverterProducingStatus');
    }
    if (accessibleInterfaces != null && accessibleInterfaces!.isNotEmpty) {
      buffer.writeln('• Accessible Tools: $accessibleInterfaces');
    }
    return buffer.toString().trim();
  }

  OtherNotSureData copyWith({
    List<String>? noticedSymptoms,
    String? somethingElseDetail,
    String? problemStartTime,
    String? inverterProducingStatus,
    String? accessibleInterfaces,
  }) {
    return OtherNotSureData(
      noticedSymptoms: noticedSymptoms ?? this.noticedSymptoms,
      somethingElseDetail: somethingElseDetail ?? this.somethingElseDetail,
      problemStartTime: problemStartTime ?? this.problemStartTime,
      inverterProducingStatus:
          inverterProducingStatus ?? this.inverterProducingStatus,
      accessibleInterfaces: accessibleInterfaces ?? this.accessibleInterfaces,
    );
  }
}
