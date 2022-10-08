import 'package:flutter/material.dart';

import 'http_request.dart';
import 'schedule.dart';

/// スケジュール一覧ページ。
class SchedulesPage extends StatelessWidget {
  const SchedulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('スケジュール一覧')),
      body: FutureBuilder<List<Schedule>>(
        // NOTE: https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html の
        // Flutter Widget of the Week の用例に従っている。
        future: fetchSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final schedules = snapshot.data ?? [];
            return ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return ListTile(
                  leading: Icon(
                    schedule.isNotified ? Icons.check_box_outlined : Icons.check_box_outline_blank,
                  ),
                  title: Text(schedule.title),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => createSchedule(
          // TODO: ハードコードをやめてユーザーの入力を受け付ける。
          title: 'aaa',
          dueDateTime: DateTime(2022, 10, 8),
        ),
      ),
    );
  }
}
