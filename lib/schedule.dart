/// アプリで管理・操作するスケジュール。
class Schedule {
  Schedule.fromJson(Map<String, dynamic> json)
      : scheduleId = (json['scheduleId'] ?? '') as String,
        title = (json['title'] ?? '') as String,
        createdAt = DateTime.parse(json['createdAt']),
        dueDateTime = DateTime.parse(json['dueDateTime']),
        isNotified = json['isNotified'] ?? false;

  final String scheduleId;
  final String title;
  final DateTime createdAt;
  final DateTime dueDateTime;
  final bool isNotified;
}
