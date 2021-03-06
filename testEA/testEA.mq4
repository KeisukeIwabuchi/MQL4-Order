//+------------------------------------------------------------------+
//|                                                       testEA.mqh |
//|                                 Copyright 2017, Keisuke Iwabuchi |
//|                                        https://order-button.com/ |
//+------------------------------------------------------------------+
#property copyright   "Copyright 2017, Keisuke Iwabuchi"
#property link        "https://order-button.com/"
#property version     "1.00"
#property strict


#include <mql4_modules\Order\Order.mqh>


int OnInit()
{  
   return(INIT_SUCCEEDED);
}


void OnTick()
{
   /** test getOrderCount method */
   OpenPositions pos;
   if(!Order::getOrderCount(pos, 0)) {
      Alert("getOrderCount method failed.");
      ExpertRemove();
   }
   Comment(
      "open_buy:",   pos.open_buy,   "\n",
      "open_sell:",  pos.open_sell,  "\n",
      "limit_buy:",  pos.limit_buy,  "\n",
      "limit_sell:", pos.limit_sell, "\n",
      "stop_buy:",   pos.stop_buy,   "\n",
      "stop_sell:",  pos.stop_sell,  "\n",
      "open_pos:",   pos.open_pos,   "\n",
      "pend_pos:",   pos.pend_pos,   "\n",
      "pend_buy:",   pos.pend_buy,   "\n",
      "pend_sell:",  pos.pend_sell,  "\n",
      "total_buy:",  pos.total_buy,  "\n",
      "total_sell:", pos.total_sell, "\n",
      "total_pos:",  pos.total_pos
   );
   
   
   /** test getOrderCount method */
   /*
   OpenPositions pos_arr;
   int magic_arr = { 0 };
   if(!Order::getOrderCount(pos_arr, magic_arr)) {
      Alert("getOrderCount method failed.");
      ExpertRemove();
   }
   
   Comment(
      "open_buy:",   pos_arr.open_buy,   "\n",
      "open_sell:",  pos_arr.open_sell,  "\n",
      "limit_buy:",  pos_arr.limit_buy,  "\n",
      "limit_sell:", pos_arr.limit_sell, "\n",
      "stop_buy:",   pos_arr.stop_buy,   "\n",
      "stop_sell:",  pos_arr.stop_sell,  "\n",
      "open_pos:",   pos_arr.open_pos,   "\n",
      "pend_pos:",   pos_arr.pend_pos,   "\n",
      "pend_buy:",   pos_arr.pend_buy,   "\n",
      "pend_sell:",  pos_arr.pend_sell,  "\n",
      "total_buy:",  pos_arr.total_buy,  "\n",
      "total_sell:", pos_arr.total_sell, "\n",
      "total_pos:",  pos_arr.total_pos
   );
   */
}