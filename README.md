# flutter_liff_scheduler

Flutter Web と LIFF を組み合わせてスケジュール共有アプリを作るサンプルプロジェクト。

![architecture.drawio.png](./docs/architecture.drawio.png)

## 開発環境

```bash
% fvm flutter --version
Flutter 3.3.1 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 4f9d92fbbd (2 weeks ago) • 2022-09-06 17:54:53 -0700
Engine • revision 3efdf03e73
Tools • Dart 2.18.0 • DevTools 2.15.0
```

## ローカル環境での実行方法

[FVM](https://fvm.app/docs/getting_started/in) の導入

```bash
brew tap leoafarias/fvm
brew install fvm
```

FVM で所定のバージョンの Flutter SDK の環境を構築

```bash
fvm install
```

デバッグ実行

```bash
flutter run -d web-server --web-port 8080
```

ngrok のインストール

```bash
brew install ngrok
```

<https://dashboard.ngrok.com/> にアクセスしサインアップした後に、認証を行う。

```bash
ngrok config add-authtoken <your-auth-token>
```

ngrok での一時公開（flutter runしているターミナルとは別ターミナルで実行する）

```bash
ngrok http 8080
```

- ngrokを起動したターミナルで表示されている `Forwarding` の `https://<ランダム値>.ngrok.io` のURLを LINE Developers コンソールから対象の LIFF が紐付いている LINE ログインチャネルのコールバックURLに指定する。
- 上記の設定で ngrok が払い出した URL 経由で LINEログイン が許可される様になる。
