# facebot
crawling IDCF NETWORK ALERT

## 使い方

### 事前

- ruby on rails の rake task として動作しています。
- 一応、install.shでひととおりインストールするようにしてますが、全体を通しての確認はしてません。
  - 導入するのはエンジニアの方でしょうから、trouble shootも容易かと。

### 設定

1. git clone しちゃう
1. install.shを実行(中身はdebian/ubuntu前提)
1. config/account.ymlを修正します
  - 環境変数から読みこむように実装してますが、確認はしてません。
  - URLはslack の incoming webhookのURLを設定してください
  - tokenとbotnameはslackのbot設定で確認してください
    - ここで指定したbotに対してmentionしてください
    - botnameが違うと反応しません。

### 実行

#### IDCF crawlerの実行

1. setup.shを実行
  - これで、既に発生している障害情報を取り込みます
1. execute.shを実行
  - これで、直前に取り込んだ障害との差分（追加分）をslackに通知します

#### botの使用方法
1. botrun.shを実行
  - これで、設定した通りのbotが起動します。

### 応用編

- cronで実行すれば、何かあった時に勝手に通知してくれます
  - とはいえ、短時間で何度もクロールして垢バンされても知りません。
- botのコマンドは lib/handler/commands/ の下に配置してください
  - Handler::Commands::[コマンド名]Command という形で実装する必要があります
  - コマンド名はcase-insencitiveです
  - exec({cmd:, data:}) が呼ばれます
  - dataには、slackから通知された内容が設定されます
  - インスタンス変数として cfg,client があります
