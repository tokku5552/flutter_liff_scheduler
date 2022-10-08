import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'http_request.dart';
import 'schedule.dart';

/// スケジュール一覧ページ。
class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  SchedulesPageState createState() => SchedulesPageState();
}

class SchedulesPageState extends State<SchedulesPage> {
  Future<List<Schedule>> _schedules = fetchSchedules();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('スケジュール一覧')),
      body: FutureBuilder<List<Schedule>>(
        future: _schedules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final schedules = snapshot.data ?? [];
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _schedules = fetchSchedules();
                });
              },
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];
                  return ListTile(
                    leading: Icon(
                      schedule.isNotified
                          ? Icons.check_box_outlined
                          : Icons.check_box_outline_blank,
                    ),
                    title: Text(schedule.title),
                  );
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateSchedulePage(),
              fullscreenDialog: true,
            ),
          );
          // 元の画面に戻った際にスケジュール一覧を取得・描画し直す。
          setState(() {
            _schedules = fetchSchedules();
          });
        },
      ),
    );
  }
}

/// スケジュールを作成するページ。
class CreateSchedulePage extends StatefulWidget {
  const CreateSchedulePage({super.key});

  @override
  CreateSchedulePageState createState() => CreateSchedulePageState();
}

class CreateSchedulePageState extends State<CreateSchedulePage> {
  late TextEditingController titleController;
  late TextEditingController dueDateTimeController;
  DateTime? dueDateTime;
  bool submitting = false;

  @override
  void initState() {
    titleController = TextEditingController();
    dueDateTimeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    dueDateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('スケジュール登録')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'スケジュール名',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: dueDateTimeController,
                  readOnly: true,
                  onTap: () => DatePicker.showDateTimePicker(
                    context,
                    minTime: DateTime.now(),
                    onConfirm: (dateTime) => setState(() {
                      dueDateTime = dateTime;
                      dueDateTimeController.text = dateTime.toIso8601String();
                    }),
                  ),
                  decoration: const InputDecoration(
                    labelText: '日時',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => submitting ? null : _createSchedule(),
                  child: Text(submitting ? '通信中...' : 'スケジュールを登録'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// スケジュールを登録する。
  Future<void> _createSchedule() async {
    final navigator = Navigator.of(context);
    final title = titleController.value.text;
    if (title.isEmpty) {
      _showSnackBar('タイトルを入力してください。');
      return;
    }
    if (dueDateTime == null) {
      _showSnackBar('日時を入力してください。');
      return;
    }
    setState(() => submitting = true);
    try {
      await createSchedule(title: title, dueDateTime: dueDateTime!);
    } finally {
      setState(() => submitting = false);
    }
    navigator.pop();
  }

  /// SnackBar を表示する。
  void _showSnackBar(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
