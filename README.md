# recordedCommand

recordedCommand for Chinachu.  
Chinachu用のrecordedCommandです。  
Chinachuのドキュメント中には簡単な例しか無かったと思うので、機能的なrecordedCommandを共有します。  

# Description

このスクリプトにてできること  

- HandBrakeCLIによるmp4へのエンコード
- `recorded.json`への自動追記によるmp4ファイルのChinachu WUI上での管理
- ファイル名を判別しGoogle Driveにアップロード
  - Chinachuのスケジューラーによる録画はファイル名を個別に設定できるので、例えばルールの録画ファイル名フォーマットを  
    `[<date:yymmdd>][gd]<title>.m2ts`  
    に設定するとファイル名に`[gd]`が入るのでこのスクリプトでGoogle Driveにアップロードできます。

# Requirement

- bash
- jq
- HandBrakeCLI
  - このスクリプトの設定では`libfdk_aac`を使用
- google-drive-ocamlfuse
  - Google Driveへのアップロードに使用

# Installation

## スクリプトの設置

まず、`recorded.sh`を適当な場所に置き、実行権限を付けます。この説明では`/home/chinachu/recorded.sh`とします。  
`recorded.sh`先頭付近のパラメータを環境に合わせて編集します。  

- `RECORDEDJSON`: Chinachuインストールディレクトリ以下の`data/recorded.json`
  - example: `RECORDEDJSON="/home/chinachu/chinachu/data/recorded.json"`
- `TSFILENAME`,`MP4FILENAME`: 変更不要
- `LOG`: ログファイル名
  - example: `LOG="/mnt/hdd/share/log/${TSFILENAME%.*}.log"`
- `MP4FILEPATH`: エンコードしたmp4の保存先
  - example: `MP4FILEPATH="/mnt/hdd/share/mp4/${MP4FILENAME}"`
- `GDFILEPATH`: Google Drive等へのmp4の保存先
  - example: `GDFILEPATH="/mnt/gd/mp4/${MP4FILENAME}"`

## Chinachu側の設定

Chinachuの仕様として`config.json`内に`recordedCommand`を書くと録画終了時に自動実行されます。  
`recordedFormat`はこれ以外を使う場合はスクリプトの書き換えが必要になることがあります。  

    "recordedFormat": "[<date:yymmdd>]<title>.m2ts",
    "recordedCommand": "/home/chinachu/recorded.sh",  

詳しくはChinachuのドキュメントを参照することをお勧めします。ケツカンマはエラーの原因になります。

## cronの設定

ログファイルとGoogle Driveのファイルの定期削除の設定例です。この場合は14日前のファイルを削除します。  
findの後ろのファイルパス部分は環境に合わせて書き換えてください。

    SHELL=/bin/bash
    0 3 * * * find /mnt/hdd/share/log/*.log -maxdepth 0 -mtime +14 -exec rm {} \;
    0 3 * * * find /mnt/gd/m2ts/*.mp4 -maxdepth 0 -mtime +14 -exec rm {} \;
