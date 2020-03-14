# CloudWatch_Jstat_GC_Shell
"CloudWatch_Jstat_GC_Shell" は、 JavaのGC情報(メモリー情報)をAWS CloudWatchに送るスクリプトです。

# DEMO
CloudWatchに送ったメトリクスをいい感じにgrafanaでグラフ化した例です。

# CloudWatch詳細情報
## CloudWatch NameSpace
ネームスペースは "Middleware" です。

## CloudWatch Dimmensions
"AutoscalingGroup" と "InstanceId"、２つのディメンションに送っています。

## CloudWatch Metrics
送るメトリクスの項目は "jstat -gc" で出力される以下17項目です。

| メトリクス名 | 説明                                            | 備考 |
| :----------- | :---------------------------------------------- | :--- |
| S0C          | Survivor領域0の現在の容量(KB)                   |      |
| S1C          | Survivor領域1の現在の容量(KB)                   |      |
| S0U          | Survivor領域0の使用率(KB)                       |      |
| S1U          | Survivor領域1の使用率(KB)                       |      |
| EC           | Eden領域の現在の容量(KB)                        |      |
| EU           | Eden領域の使用率(KB)                            |      |
| OC           | Old領域の現在の容量(KB)                         |      |
| OU           | Old領域の使用率(KB)                             |      |
| MC           | メタスペースの容量(KB)                          |      |
| MU           | メタスペースの使用率(KB)                        |      |
| CCSC         | 圧縮されたクラス領域の容量(KB)                  |      |
| CCSU         | 使用されている圧縮されたクラス領域(KB)          |      |
| YGC          | Young世代のガベージ・コレクション・イベントの数 |      |
| YGCT         | Young世代のガベージ・コレクション時間           |      |
| FGC          | フルGCイベントの数                              |      |
| FGCT         | フル・ガベージ・コレクションの時間              |      |
| GCT          | ガベージ・コレクションの総時間                  |      |

# DEMO

# 必要条件
実行した環境は以下となります。

- AmazonLinux2
- java-1.8.0-openjdk-devel

# 使い方
JAVAのGC情報を取得したいマシンで、当スクリプトを実行するだけです。

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

```

# Installation

Install Pyxel with pip command.

```bash
pip install pyxel
```
