# recordedCommand

recordedCommand for Chinachu.  
Chinachu用のrecordedCommandです。  
Chinachuのドキュメント中には簡単な例しか無かったと思うので、使いやすいrecordedCommandを共有します。  

# Description

このスクリプトにてできること  

- HandBrakeCLIによるmp4へのエンコード
- `recorded.json`への自動追記によるmp4ファイルのChinachu WUI上での管理

# Installation

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
  - example: `GDFILEPATH="/mnt/gd/m2ts/${MP4FILENAME}"`

次に、Chinachuの仕様として`config.json`内に`recordedCommand`を書くと録画終了時に自動実行されるので、以下のような設定を追記します。  

    "recordedCommand": "/home/chinachu/recorded.sh",  

詳しくはChinachuのドキュメントを参照することをお勧めします。

