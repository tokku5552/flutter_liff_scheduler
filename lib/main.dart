import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

import 'js/flutter_liff.dart' as liff;
import 'js/main_js.dart';
import 'schedules_page.dart';

/// LIFF アプリとして起動すると、main() の中で 上書きされるユーザー ID。
String userId = '';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  final liffId = dotenv.get('LIFFID', fallback: '.env に LIFFID を指定してください。');
  // JS の Promise を Dart の Future に変換するために promiseToFuture() でラップする。
  await promiseToFuture(
    liff.init(
      liff.Config(
        liffId: liffId,
        // JS に関数を渡すために allowInterop() でラップする。
        successCallback: allowInterop(() => log('LIFF の初期化に成功しました。')),
        errorCallback: allowInterop((e) => log('LIFF の初期化に失敗しました。$e')),
      ),
    ),
  );

  // ユーザー ID を取得して上書きする。
  userId = await promiseToFuture(liff.getUserId()) ?? '';
  runApp(const App());
}

/// main() の runApp() の引数に指定するウィジェット。
/// 中で MaterialApp を返す。
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
