# MQL4-Order
ポジション情報を楽に扱うためのクラス


## Requirement
- [MQL4-OrderData](https://github.com/KeisukeIwabuchi/MQL4-OrderData)


## Install
1. Order.mqhをダウンロード
2. データフォルダを開き、/MQL4/Includes/mql4_modules/Order/Order.mqhとして保存


## Usage
Order.mqhをincludeして使用する。
主な昨日は以下の通り。  

### getOrderCount
保有中のポジション数を構造体OpenPositionsに格納する

### getOrderByTrades
マジックナンバーを使用してトレーディングプールからポジション情報を取得する

### getOrderByHistory
マジックナンバーを使用してヒストリープールからポジション情報を取得する

### getOrderByTicket
チケット番号を使用してポジション情報を取得する

詳しくは各メソッドの機能はOrder.mqhのコメントを呼んでください。
