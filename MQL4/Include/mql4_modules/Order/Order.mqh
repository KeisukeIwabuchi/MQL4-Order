//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                                 Copyright 2017, Keisuke Iwabuchi |
//|                                        https://order-button.com/ |
//+------------------------------------------------------------------+


#ifndef _LOAD_MODULE_ORDER_DATA
#define _LOAD_MODULE_ORDER_DATA


/** 関連ファイルの読み込み */
#include <mql4_modules\OrderData\enums.mqh>
#include <mql4_modules\OrderData\structs.mqh>


/** オーダー情報取得クラス */
class Order
{
   public:
      static bool getOrderCount(OpenPositions &pos, int &magic[]);
      static bool getOrderByTrades(int &magic[], OrderData &data[]);
      static bool getOrderByHistory(int &magic[], OrderData &data[]);
      static bool getOrderByTicket(int ticket, OrderData &data);

   private:
      static bool getOrder(ORDER_POOL  pool, 
                           int        &magic[], 
                           OrderData  &data[]);
      static void setData(OrderData &data);
};


/**
 * 保有中オーダー数を取得する
 *
 * @param OpenPositions &pos オーダー数を受け取る構造体
 * @param int magic マジックナンバー
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrderCount(OpenPositions &pos, int &magic[])
{  
   int  size   = 0;
   int  total  = 0;
   int  ticket = 0;
   bool is_set = false;
   
   size  = ArraySize(magic);
   total = OrdersTotal();
   if(!OrderSelect(total - 1, SELECT_BY_POS, MODE_TRADES)) return(false);
   ticket = OrderTicket();
   
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
      
      switch(OrderType()) {
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
   
   if(!OrderSelect(total - 1, SELECT_BY_POS, MODE_TRADES)) return(false);
   
   return(OrdersTotal() == total && ticket == OrderTicket());
}


/**
 * マジックナンバーを指定してトレーディングプールからオーダー情報を取得する
 *
 * @param int &magic[] マジックナンバーの配列 
 * @param OrderData &data[] オーダー情報を受け取る構造体の配列
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrderByTrades(int &magic[], OrderData &data[])
{
   return(Order::getOrder(TRADING_POOL, magic, data));
}


/**
 * マジックナンバーを指定してヒストリープールからオーダー情報を取得する
 *
 * @param int &magic[] マジックナンバーの配列 
 * @param OrderData &data[] オーダー情報を受け取る構造体の配列
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrderByHistory(int &magic[], OrderData &data[])
{
   return(Order::getOrder(HISTORY_POOL, magic, data));
}


/**
 * チケット番号を指定して情報を取得する
 *
 * @param int ticket チケット番号
 * @param OrderData &data オーダー情報を受け取る構造体
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrderByTicket(int ticket, OrderData &data)
{
   if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(false);

   Order::setData(data);

   return(true);
}


/**
 * オーダー情報を取得する
 *
 * @param ORDER_POOL pool オーダーを取得するプール
 * @param int &magic[] マジックナンバーの配列
 * @param OrderData &data[] オーダー情報を受け取る構造体の配列
 *
 * @return bool true:成功, false:失敗
 */
static bool Order::getOrder(ORDER_POOL  pool,
                            int        &magic[],
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
   if(!OrderSelect(total - 1, SELECT_BY_POS, pool)) return(false);
   ticket = OrderTicket();
   
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

   if(!OrderSelect(total - 1, SELECT_BY_POS, pool)) return(false);
   
   if(pool == TRADING_POOL) {
      if(OrdersTotal() == total && ticket == OrderTicket()) {
         result = true;
      }
   }
   else {
      if(OrdersHistoryTotal() == total && ticket == OrderTicket()) {
         result = true;
      }
   }
   
   return(result);
}


/**
 * オーダー情報をパラメータdataに設定する
 *
 * @param OrderData &data オーダー情報を受け取る構造体
 */
void Order::setData(OrderData &data)
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


#endif 
