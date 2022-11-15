import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_liff_scheduler/main.dart';
import 'package:flutter_liff_scheduler/utils/date_time.dart';

import '../http_request.dart';
import '../schedule.dart';

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
                _schedules = fetchSchedules();
                await _schedules;
                setState(() {});
              },
              child: Column(
                children: [
                  if (userId.isEmpty)
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.yellow[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '⚠️ ユーザー ID を取得できていないため '
                        'LIFF アプリとして正常に機能しない可能性があります',
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        final schedule = schedules[index];
                        return ListTile(
                          leading: Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: schedule.isNotified ? Colors.grey : Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              schedule.isNotified ? '通知済み' : '通知予定',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          title: Text(
                            schedule.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(schedule.dueDateTime.toJapaneseFormat),
                        );
                      },
                    ),
                  ),
                ],
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
          _schedules = fetchSchedules();
          setState(() {});
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
                      dueDateTimeController.text = dateTime.toJapaneseFormat;
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
