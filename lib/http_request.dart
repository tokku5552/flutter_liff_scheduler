import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'schedule.dart';

/// Get Schedules API (GAS) をコールして、スケジュール一覧を取得する。
Future<List<Schedule>> fetchSchedules() async {
  final response = await http.get(
    _gasUri,
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
    _gasUri,
    body: <String, dynamic>{
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
Uri get _gasUri => Uri.parse(dotenv.get('GAS_URL'));

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
