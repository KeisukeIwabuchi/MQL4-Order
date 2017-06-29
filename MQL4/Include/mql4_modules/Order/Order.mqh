//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                                 Copyright 2017, Keisuke Iwabuchi |
//|                                        https://order-button.com/ |
//+------------------------------------------------------------------+
#property version "1.001"


#ifndef _LOAD_MODULE_ORDER
#define _LOAD_MODULE_ORDER


/** Include header files. */
/**
 * MQL4-OrderData
 * @link https://github.com/KeisukeIwabuchi/MQL4-OrderData
 */
#include <mql4_modules\OrderData\OrderData.mqh>


/** Order pool */
enum ORDER_POOL
{
   TRADING_POOL = MODE_TRADES,
   HISTORY_POOL = MODE_HISTORY
};


/** Opened or pending order count. */
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
   int total_pos;  // All types
};


/** Strictry selecting order. */
class Order
{
   public:
      static bool getOrderCount(OpenPositions &pos, const int &magic[]);
      static bool getOrderCount(OpenPositions &pos, const int magic);
      
      static bool getOrderByTrades(const int &magic[], OrderData &data[]);
      static bool getOrderByTrades(const int magic, OrderData &data[]);
      
      static bool getOrderByHistory(const int &magic[], OrderData &data[]);
      static bool getOrderByHistory(const int magic, OrderData &data[]);
      
      static bool getOrderByTicket(const int ticket, OrderData &data);

   private:
      static bool getOrder(ORDER_POOL  pool, 
                           const int  &magic[], 
                           OrderData  &data[]);
      static bool getOrder(ORDER_POOL  pool, 
                           const int   magic, 
                           OrderData  &data[]);
      static void setData(OrderData &data);
      static void resetOpenPositons(OpenPositions &pos);
      static void addPositons(const int type, OpenPositions &pos);
};


/**
 * Get the number of categorized orders with matching magic number.
 *
 * @param OpenPositions &pos オーダー数を受け取る構造体
 * @param int &magic[] マジックナンバーの配列
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrderCount(OpenPositions &pos, const int &magic[])
{  
   int  size   = 0;
   int  total  = 0;
   int  ticket = 0;
   bool is_set = false;
   
   Order::resetOpenPositons(pos);
   
   size  = ArraySize(magic);
   total = OrdersTotal();
   if(total > 0) {
      if(!OrderSelect(total - 1, SELECT_BY_POS, MODE_TRADES)) return(false);
      ticket = OrderTicket();
   }
   
   for(int i = 0; i < OrdersTotal(); i++) {
      if(!OrderSelect(i, SELECT_BY_POS)) return(false);
      
      is_set = false;
      for(int j = 0; j < size; j++) {
         if(OrderMagicNumber() == magic[j]) {
            is_set = true;
            break;
         }
      }
      if(!is_set) continue;
      
      Order::addPositons(OrderType(), pos);
   }
   
   if(total > 0) {
      if(!OrderSelect(total - 1, SELECT_BY_POS, MODE_TRADES)) return(false);
      if(ticket != OrderTicket()) return(false);
   }
   
   return(OrdersTotal() == total);
}


/**
 * Get the number of categorized orders with matching magic number.
 *
 * @param OpenPositions &pos オーダー数を受け取る構造体
 * @param int magic マジックナンバー
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrderCount(OpenPositions &pos, const int magic)
{
   int  total  = 0;
   int  ticket = 0;
   
   Order::resetOpenPositons(pos);
   
   total = OrdersTotal();
   if(total > 0) {
      if(!OrderSelect(total - 1, SELECT_BY_POS, MODE_TRADES)) return(false);
      ticket = OrderTicket();
   }
   
   for(int i = 0; i < OrdersTotal(); i++) {
      if(!OrderSelect(i, SELECT_BY_POS)) return(false);
      
      if(OrderMagicNumber() != magic) continue;
      
      Order::addPositons(OrderType(), pos);
   }
   
   if(total > 0) {
      if(!OrderSelect(total - 1, SELECT_BY_POS, MODE_TRADES)) return(false);
      if(ticket != OrderTicket()) return(false);
   }
   
   return(OrdersTotal() == total);
}


/**
 * Select orders count with matching magic number from trading pool.
 *
 * @param const int &magic[] マジックナンバーの配列 
 * @param OrderData &data[] オーダー情報を受け取る構造体の配列
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrderByTrades(const int &magic[], OrderData &data[])
{
   return(Order::getOrder(TRADING_POOL, magic, data));
}


/**
 * Select orders count with matching magic number from trading pool.
 *
 * @param const int  magic マジックナンバー
 * @param OrderData &data[] オーダー情報を受け取る構造体の配列
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrderByTrades(const int magic, OrderData &data[])
{
   return(Order::getOrder(TRADING_POOL, magic, data));
}


/**
 * Select orders with matching magic number from history pool.
 *
 * @param const int &magic[] マジックナンバーの配列 
 * @param OrderData &data[] オーダー情報を受け取る構造体の配列
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrderByHistory(const int &magic[], OrderData &data[])
{
   return(Order::getOrder(HISTORY_POOL, magic, data));
}


/**
 * Select orders with matching magic number from history pool.
 *
 * @param const int  magic マジックナンバー
 * @param OrderData &data[] オーダー情報を受け取る構造体の配列
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrderByHistory(const int magic, OrderData &data[])
{
   return(Order::getOrder(HISTORY_POOL, magic, data));
}


/**
 * Select orders with matching ticket number from history pool.
 *
 * @param const int ticket チケット番号
 * @param OrderData &data オーダー情報を受け取る構造体
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrderByTicket(const int ticket, OrderData &data)
{
   if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(false);

   Order::setData(data);

   return(true);
}


/**
 * オーダー情報を取得する
 *
 * @param ORDER_POOL pool オーダーを取得するプール
 * @param const int &magic[] マジックナンバーの配列
 * @param OrderData &data[] オーダー情報を受け取る構造体の配列
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrder(ORDER_POOL  pool,
                            const int  &magic[],
                            OrderData  &data[])
{
   int  size   = 0;
   int  total  = 0;
   int  ticket = 0;
   int  count  = 0;
   bool is_set = false;
   bool result = false;
   
   size   = ArraySize(magic);
   total  = (pool == TRADING_POOL) ? OrdersTotal() : OrdersHistoryTotal();
   if(total > 0) {
      if(!OrderSelect(total - 1, SELECT_BY_POS, pool)) return(false);
      ticket = OrderTicket();
   }
   
   for(int i = 0; i < total; i++) {
      if(!OrderSelect(i, SELECT_BY_POS, pool)) return(false);
      
      is_set = false;
      for(int j = 0; j < size; j++) {
         if(OrderMagicNumber() == magic[j]) {
            is_set = true;
            break;
         }
      }
      if(!is_set) continue;
      
      Order::setData(data[count]);
      count++;
   }

   if(total > 0) {
      if(!OrderSelect(total - 1, SELECT_BY_POS, pool)) return(false);
      if(ticket != OrderTicket()) return(false);
   }
   
   if(pool == TRADING_POOL) {
      if(OrdersTotal() == total) result = true;
   }
   else {
      if(OrdersHistoryTotal() == total) result = true;
   }
   
   return(result);
}


/**
 * オーダー情報を取得する
 *
 * @param ORDER_POOL pool オーダーを取得するプール
 * @param const int  magic マジックナンバー
 * @param OrderData &data[] オーダー情報を受け取る構造体の配列
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrder(ORDER_POOL  pool,
                            const int   magic,
                            OrderData  &data[])
{
   int  total  = 0;
   int  ticket = 0;
   int  count  = 0;
   bool result = false;
   
   total  = (pool == TRADING_POOL) ? OrdersTotal() : OrdersHistoryTotal();
   if(total > 0) {
      if(!OrderSelect(total - 1, SELECT_BY_POS, pool)) return(false);
      ticket = OrderTicket();
   }
   
   for(int i = 0; i < total; i++) {
      if(!OrderSelect(i, SELECT_BY_POS, pool)) return(false);
      
      if(OrderMagicNumber() != magic) continue;
      
      Order::setData(data[count]);
      count++;
   }

   if(total > 0) {
      if(!OrderSelect(total - 1, SELECT_BY_POS, pool)) return(false);
      if(ticket != OrderTicket()) return(false);
   }
   
   if(pool == TRADING_POOL) {
      if(OrdersTotal() == total) result = true;
   }
   else {
      if(OrdersHistoryTotal() == total) result = true;
   }
   
   return(result);
}


/**
 * オーダー情報をパラメータdataに設定する
 *
 * @param OrderData &data オーダー情報を受け取る構造体
 */
static void Order::setData(OrderData &data)
{
   data.ticket      = OrderTicket();
   data.symbol      = OrderSymbol();
   data.type        = OrderType();
   data.lots        = OrderLots();
   data.open_time   = OrderOpenTime();
   data.open_price  = OrderOpenPrice();
   data.stoploss    = OrderStopLoss();
   data.takeprofit  = OrderTakeProfit();
   data.close_time  = OrderCloseTime();
   data.close_price = OrderClosePrice();
   data.expiration  = OrderExpiration();
   data.commission  = OrderCommission();
   data.swap        = OrderSwap();
   data.profit      = OrderProfit();
   data.comment     = OrderComment();
   data.magic       = OrderMagicNumber();
}


/**
 * OpenPositions構造体を初期化する
 *
 * @param OpenPositions &pos 初期化する構造体を受け取る
 */
static void Order::resetOpenPositons(OpenPositions &pos)
{
   pos.open_buy   = 0;
   pos.open_sell  = 0;
   pos.limit_buy  = 0;
   pos.limit_sell = 0;
   pos.stop_buy   = 0;
   pos.stop_sell  = 0;
   pos.open_pos   = 0;
   pos.pend_pos   = 0;
   pos.pend_buy   = 0;
   pos.pend_sell  = 0;
   pos.total_buy  = 0;
   pos.total_sell = 0;
   pos.total_pos  = 0;
}


/**
 * typeとして受け取ったOrderTypeに応じて、OpenPositions構造体を増加させる
 *
 * @param const int type 取引種別
 * @param OpenPositions &pos 値を増加させる構造体を受け取る
 */
static void Order::addPositons(const int type, OpenPositions &pos)
{
   switch(type) {
      case OP_BUY:
         pos.open_buy++;
         pos.open_pos++;
         pos.total_buy++;
         break;
      case OP_SELL:
         pos.open_sell++;
         pos.open_pos++;
         pos.total_sell++;
         break;
      case OP_BUYLIMIT:
         pos.limit_buy++;
         pos.pend_pos++;
         pos.pend_buy++;
         pos.total_buy++;
         break;
      case OP_SELLLIMIT:
         pos.limit_sell++;
         pos.pend_pos++;
         pos.pend_sell++;
         pos.total_sell++;
         break;
      case OP_BUYSTOP:
         pos.stop_buy++;
         pos.pend_pos++;
         pos.pend_buy++;
         pos.total_buy++;
         break;
      case OP_SELLSTOP:
         pos.stop_sell++;
         pos.pend_pos++;
         pos.pend_sell++;
         pos.total_sell++;
         break;
   }
   pos.total_pos++;
}


#endif 
