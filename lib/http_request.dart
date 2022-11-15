import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'main.dart';
import 'schedule.dart';

/// Get Schedules API (GAS) をコールして、指定したユーザーのスケジュール一覧を取得する。
Future<List<Schedule>> fetchSchedules() async {
  final response = await http.get(
    _gasUri(addUserIdToQueryParameter: true),
    headers: <String, String>{
      'Accept': 'application/json',
    },
  );
  _log(response);
  final schedules =
      (jsonDecode(response.body) as List).map((json) => Schedule.fromJson(json)).toList();
  return schedules;
}

/// Create Schedule API (GAS) をコールして、スケジュールを作成する。
Future<void> createSchedule({
  required String title,
  required DateTime dueDateTime,
}) async {
  final response = await http.post(
    _gasUri(),
    body: <String, dynamic>{
      'userId': userId,
      'title': title,
      'dueDateTime': dueDateTime.toIso8601String(),
    },
    headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
  );
  _log(response);
}

/// dotenv に記述した GAS の WEB App のエンドポイントの Uri を返す。
/// addUserIdToQueryParameter: true とすると、Uri に userId={userId} の
/// クエリパラメータを付加する。
Uri _gasUri({bool addUserIdToQueryParameter = false}) {
  final gasUrl = dotenv.get('GAS_URL');
  if (gasUrl.isEmpty) {
    throw UnimplementedError('.env に GAS_URL を指定してください。');
  }
  return Uri.parse('$gasUrl${addUserIdToQueryParameter ? '?userId=$userId' : ''}');
}

/// デバッグ用に HTTP リクエスト・レスポンスの概要をコンソールに出力する。
void _log(http.Response response) {
  final stringBuffer = StringBuffer();
  stringBuffer.write('********************\n');
  final request = response.request;
  if (request != null) {
    stringBuffer.write('[Request]\n');
    stringBuffer.write('${request.method} ${request.url.toString()}\n');
  }
  stringBuffer.write('[Response]\n');
  stringBuffer.write('${response.statusCode} ${response.body}\n');
  stringBuffer.write('********************');
  debugPrint(stringBuffer.toString());
}
