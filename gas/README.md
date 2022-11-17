# GAS

## 参考

[claspを使ってGoogle Apps Scriptの開発環境を構築してみた](https://dev.classmethod.jp/articles/vscode-clasp-setting/)

## GAS と clasp の環境構築

node プロジェクトを作成し、clasp と GAS に必要なパッケージをインストールする。

```sh
npm init -y
npm install @google/clasp -g
npm install @types/google-apps-script
```

Google アカウントの認証を行い、指示に従う。

```sh
clasp login --no-localhost
```

class アプリケーションを作成する。今回のデモでは `sheets` を選択する。

`clasp.json`（本プロジェクトでは Git の管理対象外）と `appsscript.json` が作成され、マイドライブ直下にアプリケーションが作成さることを確認する。

```sh
clasp create
```

必要に応じて `appsscript.json` の `timeZone` を変更する。

```json
{
  "timeZone": "Asia/Tokyo",
  "dependencies": {},
  "exceptionLogging": "STACKDRIVER",
  "runtimeVersion": "V8"
}
```

## GAS 関数をプッシュする

次のコマンドでプッシュする。

```sh
clasp push
```

当該プロジェクトの Web エディタを開く。

```sh
clasp open
```

Web エディタで変更を保存した場合に、その内容を取り込む。

```shell
clasp pull
```

## 関数をデプロイする

Web 画面の「Deploy > New deployment」から Web app を選択してデプロイする。

2 回目以降は「Deploy > Manage deployments」から New version を反映すれば良い。

## その他の設定

GAS に紐づくスプレッドシートの列名とその順番はこのスプレッドシートと一致させる必要がある。

<https://docs.google.com/spreadsheets/d/1n_Dem-FpKK36tJ-G5VYilWDuN0VBoDaRkvR6B2ziC7M/edit#gid=0>

また、GAS の Script Properties に `CHANNEL_ACCESS_TOKEN` の名前で、対応する LINE ログインチャネルの CHANNEL_ACCESS_TOKEN を設定する。

```txt
CHANNEL_ACCESS_TOKEN=<自分の CHANNEL_ACCESS_TOKEN> 
```
