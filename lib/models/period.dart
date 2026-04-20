// lib/models/period.dart

class Period {
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> symptoms;
  final String? notes;
  final int? flowIntensity; // 1=light, 2=medium, 3=heavy

  Period({
    required this.startDate,
    this.endDate,
    this.symptoms = const [],
    this.notes,
    this.flowIntensity,
  });

  int? get duration {
    if (endDate == null) return null;
    return endDate!.difference(startDate).inDays + 1;
  }

  bool get isActive => endDate == null;

  bool containsDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(startDate.year, startDate.month, startDate.day);
    if (endDate == null) return d == s;
    final e = DateTime(endDate!.year, endDate!.month, endDate!.day);
    return (d.isAtSameMomentAs(s) || d.isAfter(s)) &&
        (d.isAtSameMomentAs(e) || d.isBefore(e));
  }

  Map<String, dynamic> toJson() => {
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'symptoms': symptoms,
    'notes': notes,
    'flowIntensity': flowIntensity,
  };

  factory Period.fromJson(Map<String, dynamic> json) => Period(
    startDate: DateTime.parse(json['startDate']),
    endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    symptoms: List<String>.from(json['symptoms'] ?? []),
    notes: json['notes'],
    flowIntensity: json['flowIntensity'],
  );

  Period copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symptoms,
    String? notes,
    int? flowIntensity,
  }) => Period(
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    symptoms: symptoms ?? this.symptoms,
    notes: notes ?? this.notes,
    flowIntensity: flowIntensity ?? this.flowIntensity,
  );
}
