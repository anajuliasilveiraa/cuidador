class WellbeingEntry {
  final DateTime date;
  final int sleepQuality; // 0–10
  final int mood; // 0–10
  final String? notes;

  WellbeingEntry({
    required this.date,
    required this.sleepQuality,
    required this.mood,
    this.notes,
  });

  factory WellbeingEntry.fromJson(Map<String, dynamic> json) {
    return WellbeingEntry(
      date: DateTime.parse(json['date'] as String),
      sleepQuality: json['sleep_quality'] as int,
      mood: json['mood'] as int,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'sleep_quality': sleepQuality,
      'mood': mood,
      'notes': notes,
    };
  }
}


