import 'package:flutter/material.dart';
import 'other_not_sure_data.dart';

/// Represents an identifiable solar symptom category
class SymptomCategory {
  final String id;
  final String label;
  final IconData icon;
  final Color? customIconColor;
  final bool isFullWidth;

  const SymptomCategory({
    required this.id,
    required this.label,
    required this.icon,
    this.customIconColor,
    this.isFullWidth = false,
  });
}

/// Represents an attached photo with its individual description
class PhotoAttachment {
  final String id;
  final String imageUri;
  final String description;
  final String label;
  final bool isSamplePhoto;

  const PhotoAttachment({
    required this.id,
    required this.imageUri,
    this.description = '',
    this.label = 'Rooftop Photo',
    this.isSamplePhoto = false,
  });

  PhotoAttachment copyWith({String? description, String? label}) {
    return PhotoAttachment(
      id: id,
      imageUri: imageUri,
      description: description ?? this.description,
      label: label ?? this.label,
      isSamplePhoto: isSamplePhoto,
    );
  }
}

/// Data payload holding user-selected symptoms and descriptions from Screen 2
class ProblemReportDraft {
  final Set<String> selectedSymptomIds;
  final List<String> selectedSymptomLabels;
  final String? inverterErrorCode;
  final String? additionalNotes;
  final List<PhotoAttachment> attachedPhotos;
  final OtherNotSureData? otherNotSureData;

  const ProblemReportDraft({
    required this.selectedSymptomIds,
    required this.selectedSymptomLabels,
    this.inverterErrorCode,
    this.additionalNotes,
    this.attachedPhotos = const [],
    this.otherNotSureData,
  });

  bool get isValid => selectedSymptomIds.isNotEmpty;

  ProblemReportDraft copyWith({
    Set<String>? selectedSymptomIds,
    List<String>? selectedSymptomLabels,
    String? inverterErrorCode,
    String? additionalNotes,
    List<PhotoAttachment>? attachedPhotos,
    OtherNotSureData? otherNotSureData,
  }) {
    return ProblemReportDraft(
      selectedSymptomIds: selectedSymptomIds ?? this.selectedSymptomIds,
      selectedSymptomLabels:
          selectedSymptomLabels ?? this.selectedSymptomLabels,
      inverterErrorCode: inverterErrorCode ?? this.inverterErrorCode,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      attachedPhotos: attachedPhotos ?? this.attachedPhotos,
      otherNotSureData: otherNotSureData ?? this.otherNotSureData,
    );
  }
}

/// Complete problem report submission payload for Screen 3
class FullProblemReport {
  final String reportId;
  final Set<String> symptomIds;
  final List<String> symptomLabels;
  final String? inverterErrorCode;
  final String? screen2Notes;
  final String problemDescription;
  final List<PhotoAttachment> photos;
  final DateTime submittedAt;
  final OtherNotSureData? otherNotSureData;

  const FullProblemReport({
    required this.reportId,
    required this.symptomIds,
    required this.symptomLabels,
    this.inverterErrorCode,
    this.screen2Notes,
    required this.problemDescription,
    required this.photos,
    required this.submittedAt,
    this.otherNotSureData,
  });

  FullProblemReport copyWith({
    String? reportId,
    Set<String>? symptomIds,
    List<String>? symptomLabels,
    String? inverterErrorCode,
    String? screen2Notes,
    String? problemDescription,
    List<PhotoAttachment>? photos,
    DateTime? submittedAt,
    OtherNotSureData? otherNotSureData,
  }) {
    return FullProblemReport(
      reportId: reportId ?? this.reportId,
      symptomIds: symptomIds ?? this.symptomIds,
      symptomLabels: symptomLabels ?? this.symptomLabels,
      inverterErrorCode: inverterErrorCode ?? this.inverterErrorCode,
      screen2Notes: screen2Notes ?? this.screen2Notes,
      problemDescription: problemDescription ?? this.problemDescription,
      photos: photos ?? this.photos,
      submittedAt: submittedAt ?? this.submittedAt,
      otherNotSureData: otherNotSureData ?? this.otherNotSureData,
    );
  }
}
