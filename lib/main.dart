import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_line_liff/flutter_line_liff.dart';

import 'schedules_page.dart';

/// TODO: groupId をグローバルに書くのをやめることを検討する。
String groupId = '';

Future<void> main() async {
  await dotenv.load(fileName: 'env');
  // TODO: flutter_line_liff パッケージの使用の廃止を検討する。
  String id = dotenv.get('LIFFID', fallback: 'LIFFID not found');
  await FlutterLineLiff().init(
    config: Config(liffId: id),
    errorCallback: (error) {},
  );
  final liffContext = FlutterLineLiff().context;
  groupId = liffContext?.groupId ?? '';
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter LIFF Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SchedulesPage(),
    );
  }
}
