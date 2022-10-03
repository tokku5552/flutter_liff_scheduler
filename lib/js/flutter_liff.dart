@JS()
library flutter_liff;

import 'package:js/js.dart';

@JS('init')
external Object init(Config config);

@JS('getUserID')
external Object getUserID();

@JS('getLiffID')
external String getLiffID();

@JS('getAccessToken')
external Object getAccessToken();

// 名前付き引数を渡したい為、クラスを作成
@JS()
@anonymous
class Config {
  external String get liffID;
  external Function? get successCallback;
  external Function(dynamic error)? get errorCallback;
  external factory Config({
    String liffID,
    Function? successCallback,
    Function(dynamic error)? errorCallback,
  });
}
