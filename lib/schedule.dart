/// アプリで管理・操作するスケジュール。
class Schedule {
  Schedule({
    required this.userId,
    required this.title,
    required this.dueDateTime,
    this.isNotified = false,
  });

  /// LIFF のユーザー ID。
  final String userId;

  /// スケジュールのタイトル。
  final String title;

  /// スケジュールの締め切り日時。
  final DateTime dueDateTime;

  /// スケジュールを LINE Messaging API で通知済みかどうか。
  final bool isNotified;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        userId: (json['userId'] ?? '') as String,
        title: (json['title'] ?? '') as String,
        dueDateTime: DateTime.fromMillisecondsSinceEpoch(json['dueDateTime']),
        isNotified: json['isNotified'] ?? false,
      );
}
