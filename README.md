# CloudWatch_Jstat_GC_Shell
"CloudWatch_Jstat_GC_Shell" は、 JavaのGC情報(メモリー情報)をAWS CloudWatchに送るスクリプトです。

# DEMO
CloudWatchに送ったメトリクスをいい感じにgrafanaでグラフ化した例です。

# CloudWatch詳細情報
## CloudWatch NameSpace
ネームスペースは "Middleware" です。

## CloudWatch Dimmensions
"HostName" と "InstanceId"、２つのディメンションに送っています。
私の使用している環境は、AutoScalingGroupName = HostName なので、
"HostName"を"AutoScalingGroupName"の代わりに使用しています。
AutoScalingGroupNameを取得するにはAPIを叩く必要があるためです。
基本的には"InstanceId"ごとにメトリクスを確認します。

## CloudWatch Metrics
CloudWatchに送るメトリクスの項目は、 "jstat -gcutil" で出力される以下11項目です。

| メトリクス名 | 説明                         | 備考 |
| :----------- | :--------------------------- | :--- |
| S0           | S0領域の使用率               |      |
| S1           | S1領域の使用率               |      |
| E            | Eden領域の使用率             |      |
| O            | Old領域の使用率              |      |
| M            | メタスペースの使用率         |      |
| CCS          | 圧縮されたクラス領域の使用率 |      |
| YGC          | YoungGCのイベント数          |      |
| YGCT         | YoungGCの処理時間            |      |
| FGC          | FullGCイベントの数           |      |
| FGCT         | FullGCの処理時間             |      |
| GCT          | GCの総時間                   |      |

# DEMO

# 必要条件
実行した環境は以下となります。

- AmazonLinux2
- java-1.8.0-openjdk-devel

スクリプトの中でjstatコマンドを使用しているため、openjdk-develが必要です。

```
yum install -y java-1.8.0-openjdk-devel 
```

CloudWatchにメトリクスをPushしているため、AWSの権限が必要になります。
実行するEC2に必要なロールがアタッチされている前提となります。
AWS管理ポリシーである "CloudWatchAgentAdminPolicy" がアタッチされていれば十分です。





# 使い方
JavaのGC情報を取得したいマシンで、当スクリプトを実行するだけです。
awscliやjstatなどのコマンドが叩けるのであれば、配置場所はどこでも構いません。
一時ファイル等も作成しません。

## 実行ユーザー
rootユーザーでの実行を前提としています。
スクリプト内で下記引数2のユーザーにsudoしてコマンドを実行している部分が一部あります。

## 引数
スクリプトの実行時に2つの引数を与える必要があります。
  - $1: target java proccess name.  ex) Bootstrap
  - $2: target java proccess owner. ex) tomcat

## 実行例

```bash
./cloudwatch_jstat_gc.sh Bootstrap tomcat
```

## Cron設定例

```
* * * * * /usr/local/scripts/cloudwatch_jstat_gc.sh Bootstrap tomcat
```
