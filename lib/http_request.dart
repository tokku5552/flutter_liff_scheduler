import 'dart:convert';

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
  final schedules =
      (jsonDecode(response.body) as List).map((json) => Schedule.fromJson(json)).toList();
  return schedules;
}

/// Create Schedule API (GAS) をコールして、スケジュールを作成する。
Future<void> createSchedule({
  required String title,
  required DateTime dueDateTime,
}) async {
  await http.post(
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
}

/// dotenv に記述した GAS の WEB App のエンドポイントの Uri を返す。
Uri get _gasUri => Uri.parse(dotenv.get('GAS_URL'));
