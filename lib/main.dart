import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

import 'js/flutter_liff.dart' as liff;
import 'js/main_js.dart';
import 'schedules_page.dart';

/// TODO: userId をグローバルに書くのをやめることを検討する。
String userId = '';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  final id = dotenv.get('LIFFID', fallback: 'LIFFID not found');

  // PromiseをFutureに変換する為、promiseToFuture()でラップ
  await promiseToFuture(
    liff.init(
      liff.Config(
        liffId: id,
        // js側に関数を渡す為、allowInterop()でラップ
        successCallback: allowInterop(() => log('liff init success!!!')),
        errorCallback: allowInterop((e) => log('liff init failed with $e')),
      ),
    ),
  );
  userId = await promiseToFuture(liff.getUserId()) ?? '';
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter LIFF Scheduler',
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SchedulesPage(),
    );
  }
}
