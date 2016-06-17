# facebot
crawling IDCF NETWORK ALERT

## 使い方

### 事前

- railsで動作しています。
- 一応、install.shでひととおりインストールするようにしてますが、全体を通しての確認はしてません。
  - 導入するのはエンジニアの方でしょうから、trouble shootも容易かと。

### 設定

1. git clone しちゃう
1. install.shを実行(中身はdebian/ubuntu前提)
1. config/account.ymlを修正します
  - 環境変数から読みこむように実装してますが、確認はしてません。
  - URLはslack の incoming webhookのURLを設定してください

### 実行

1. setup.shを実行
  - これで、既に発生している障害情報を取り込みます
1. execute.shを実行
  - これで、直前に取り込んだ障害との差分（追加分）をslackに通知します
