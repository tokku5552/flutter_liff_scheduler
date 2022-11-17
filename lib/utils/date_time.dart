import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  /// 「2022年01月01日 13時00分」のような文字列に変換する
  String get toJapaneseFormat => DateFormat('yyyy年MM月dd日 HH時mm分').format(this);
}
