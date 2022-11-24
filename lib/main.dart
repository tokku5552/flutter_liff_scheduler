import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:js/js_util.dart';

import 'js/flutter_liff.dart' as liff;
import 'ui/schedule.dart';

/// LIFF アプリとして起動すると、main() の中で 上書きされるユーザー ID。
String userId = '';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  final liffId = dotenv.get('LIFFID', fallback: '.env に LIFFID を指定してください。');
  // JS の Promise を Dart の Future に変換するために promiseToFuture() でラップする。
  await promiseToFuture(liff.init(liffId));

  // デバッグモードではユーザー ID 取得のエラーを無視する。
  userId = await promiseToFuture(liff.getUserId(kDebugMode));
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
