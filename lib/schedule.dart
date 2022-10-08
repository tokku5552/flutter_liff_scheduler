/// アプリで管理・操作するスケジュール。
class Schedule {
  Schedule({
    required this.scheduleId,
    required this.title,
    required this.dueDateTime,
    this.isNotified = false,
    this.createdAt,
  });

  final String scheduleId;
  final String title;
  final DateTime dueDateTime;
  final bool isNotified;
  final DateTime? createdAt;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        scheduleId: (json['scheduleId'] ?? '') as String,
        title: (json['title'] ?? '') as String,
        dueDateTime: DateTime.parse(json['dueDateTime']),
        isNotified: json['isNotified'] ?? false,
        createdAt: DateTime.tryParse(json['createdAt']),
      );
}
