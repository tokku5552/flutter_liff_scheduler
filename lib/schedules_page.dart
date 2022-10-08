import 'package:flutter/material.dart';
import 'package:flutter_liff_scheduler/schedule.dart';

/// スケジュール一覧ページ
class SchedulesPage extends StatelessWidget {
  const SchedulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('スケジュール一覧')),
      body: ListView.builder(
        itemCount: _schedules.length,
        itemBuilder: (context, index) {
          final schedule = _schedules[index];
          return ListTile(
            leading: Icon(
              schedule.isNotified ? Icons.check_box_outlined : Icons.check_box_outline_blank,
            ),
            title: Text(schedule.title),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // TODO: スケジュールを作成できるようにする
        },
      ),
    );
  }
}

/// TODO: ハードコード。GET リクエストができるようになったら消す。
final _schedules = <Schedule>[
  for (final json in _jsons) Schedule.fromJson(json),
];

/// TODO: ハードコード。GET リクエストができるようになったら消す。
final _jsons = <Map<String, dynamic>>[
  {
    'scheduleId': '1',
    'title': 'タイトル 1',
    'createdAt': '2022-10-01 00:00:00',
    'dueDateTime': '2022-10-01 00:00:00',
    'isNotified': false,
  },
  {
    'scheduleId': '2',
    'title': 'タイトル 2',
    'createdAt': '2022-10-01 00:00:00',
    'dueDateTime': '2022-10-02 00:00:00',
    'isNotified': false,
  },
  {
    'scheduleId': '3',
    'title': 'タイトル 3',
    'createdAt': '2022-10-01 00:00:00',
    'dueDateTime': '2022-10-03 00:00:00',
    'isNotified': false,
  },
  {
    'scheduleId': '4',
    'title': 'タイトル 4',
    'createdAt': '2022-10-01 00:00:00',
    'dueDateTime': '2022-10-04 00:00:00',
    'isNotified': false,
  },
  {
    'scheduleId': '5',
    'title': 'タイトル 5',
    'createdAt': '2022-10-01 00:00:00',
    'dueDateTime': '2022-10-05 00:00:00',
    'isNotified': false,
  },
];
