# MQL4-Order
Module for strictry selecting order.


## Requirement
- [MQL4-OrderData](https://github.com/KeisukeIwabuchi/MQL4-OrderData)


## Install
1. Download Order.mqh
2. Save the file to <terminal data folder>/MQL4/Includes/mql4_modules/Order/Order.mqh


## Usage
Include: `#include <mql4_modules/Order/Order.mqh>`

The main functions are as follow.

### getOrderCount
You can get the number of categorized orders with matching magic number.
```cpp
OpenPositions pos;
Order::getOrderCount(pos, magic);

Print("buy count = ", pos.open_buy);
Print("sell count = ", pos.open_sell);

```

### getOrderByTrades
Select orders count with matching magic number from trading pool(opened and pending orders).
```cpp
OrderData data[10];
if(!Order::getOrderByTrades(magic, data)) return;
if(ArraySize(data) > 0) {
   int ticket = data[0].ticket;
}
```

### getOrderByHistory
Select orders with matching magic number from history pool(closed and canceled orders).
```cpp
OrderData data[10];
if(!Order::getOrderByHistory(magic, data)) return;
double profit = data[0].profit;
```

### getOrderByTicket
Select orders with matching ticket number from history pool.
```cpp
OrderData data;
if(!Order::getOrderByHistory(ticket, data)) return;
double profit = data.profit;
```

