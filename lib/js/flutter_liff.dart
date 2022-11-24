@JS()
library flutter_liff;

import 'package:js/js.dart';

@JS('init')
external Object init(String liffId);

@JS('getUserId')
external Object getUserId([bool ignoreError = false]);

@JS('getLiffId')
external String getLiffId();

@JS('getGroupId')
external String getGroupId();

@JS('getAccessToken')
external Object getAccessToken();

// 名前付き引数を渡したい為、クラスを定義
@JS()
@anonymous
class Config {
  external String get liffId;
  external Function? get successCallback;
  external Function(dynamic error)? get errorCallback;
  external factory Config({
    String liffId,
    Function? successCallback,
    Function(dynamic error)? errorCallback,
  });
}
