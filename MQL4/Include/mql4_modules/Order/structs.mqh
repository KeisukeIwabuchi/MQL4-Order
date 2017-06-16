//+------------------------------------------------------------------+
//|                                                      structs.mqh |
//|                                 Copyright 2017, Keisuke Iwabuchi |
//|                                        https://order-button.com/ |
//+------------------------------------------------------------------+


/**
 * フレームワークで使用する構造体をまとめたファイル
 */


/** 保有中オーダー情報 */
struct OrderData
{
   int      ticket;
   string   symbol;
   int      type;
   double   lots;
   datetime open_time;
   double   open_price;
   double   stoploss;
   double   takeprofit;
   datetime close_time;
   double   close_price;
   datetime expiration;
   double   commission;
   double   swap;
   double   profit;
   string   comment;
   int      magic;
};


/** 保有中ポジション状況 */
struct OpenPositions
{
   int open_buy;   // OP_BUY
   int open_sell;  // OP_SELL
   int limit_buy;  // OP_BUYLIMIT
   int limit_sell; // OP_SELLLIMIT
   int stop_buy;   // OP_BUYSTOP
   int stop_sell;  // OP_SELLSTOP
   int open_pos;   // OP_BUY and OP_SELL
   int pend_pos;   // OP_BUYLIMIT, OP_BUYSTOP, OP_SELLLIMIT and OP_SELLSTOP
   int pend_buy;   // OP_BUYLIMIT and OP_BUYSTOP
   int pend_sell;  // OP_SELLLIMIT and OP_SELLSTOP
   int total_buy;  // OP_BUY, OP_BUYLIMIT and OP_BUYSTOP
   int total_sell; // OP_SELL, OP_SELLLIMIT and OP_SELLSTOP
   int total_pos;  // OP_BUY, OP_SELL, OP_BUYLIMIT, OP_BUYSTOP, OP_SELLLIMIT and OP_SELLSTOP
};
