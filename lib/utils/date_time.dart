import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// 日本の曜日
  static const List<String> japaneseWeekdays = [
    '月',
    '火',
    '水',
    '木',
    '金',
    '土',
    '日',
  ];

  /// 「2022年01月01日 13時00分」のような文字列に変換する
  String get toJapaneseFormat => DateFormat('yyyy年MM月dd日 HH時mm分').format(this);

  /// 入力日の日本の曜日を返す
  String get japaneseWeekDay => japaneseWeekdays[_weekDayInt(this) - 1];

  /// 入力日の曜日を整数型で返す
  int _weekDayInt(DateTime dateTime) => dateTime.weekday;
}
