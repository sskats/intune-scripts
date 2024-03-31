# w32timeIgniter

***Please use at your own risk.**

W32Time Service の
- スタートアップの種類
- 状態
- トリガー

を変更するスクリプトです。
ローカルで実行する他に、Intune からスクリプトとして、または intunewinに 変換してアプリとして配信出来ます。

デバイス(マシン)スコープでの配信動作を確認しています。<br>
本番環境で使用する場合は必ず検証を行って下さい。

## intunewin に変換してアプリとして配信する

アプリとして配信することで検出ルールが設定できるため、特定の設定が変更された際にスクリプトを再実行することができます。
https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool<br>
https://learn.microsoft.com/en-us/mem/intune/apps/apps-win32-prepare

### インストールコマンド

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File w32timeIgniter.ps1
```

### 検出ルールの例

設定の例です。本番環境で使用する際は環境に合わせて設定して下さい。

#### サービスのトリガを検出

初回の実行を想定したルールです。<br>
スクリプトによって2つのトリガーが作成されるため、2つめのトリガーが検出されたらインストールされているとみなします。

|項目|内容|
|-|-|
|規則の種類|レジストリ|
|キーパス|HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\TriggerInfo\1|
|値の名前|Action|
|検出方法|値が存在する|

#### サービスのスタートアップの種類を検出

初回の実行時の他に、ユーザーが時刻同期を無効に設定したケースを想定したルールです。<br>
W32Timeサービスのスタートアップの種類が`3`(`手動`)もしくは`4`(`無効`)の場合を検出します。
GUIで時刻同期をオフにするとこの値が`4`となるため、スクリプトが実行されます。<br>
*GUIで時刻同期を無効にした場合、スクリプトが実行されても GUI 上では無効になったままに見えます。

|項目|内容|
|-|-|
|規則の種類|レジストリ|
|キーパス|HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time|
|値の名前|Start|
|検出方法|整数値を比較|
|演算子|より小さい|
|値|3|

## NTP Client の設定

スクリプトと併せて構成プロファイルで NTP クライアントの設定を配信します。下記項目以外はデフォルト値です。参照するNTPサーバは変更可能です。

|項目|内容|
|-|-|
| NtpServer| time.windows.com,0x8|
| Type(Device)|NTP|

## 参考

[Windows Time service doesn't start automatically on a workgroup computer | learn.microsoft.com ](https://learn.microsoft.com/en-us/troubleshoot/windows-client/active-directory/w32time-not-start-on-workgroup)

[When SpecialPollInterval is used as a polling interval, the Windows Time service does not correct the time if the service gets into Spike state | learn.microsoft.com ](https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/specialpollinterval-polling-interval-time-service-not-correct)

[Windowsネットワーク時刻同期の基礎とノウハウ（改訂版） | ＠IT itmedia.co.jp](https://atmarkit.itmedia.co.jp/ait/articles/1205/17/news135_2.html)
