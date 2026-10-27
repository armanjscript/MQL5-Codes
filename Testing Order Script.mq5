#property copyright "Copyright 2026, MetaQuotes Ltd."
#property link      ""
#property version   "1.00"
#property script_show_inputs

input bool UseFillingPolicy = false;
input ENUM_ORDER_TYPE_FILLING FillingPolicy = ORDER_FILLING_FOK;

uint MagicNumber = 101;

void OnStart()
  {
  
   //Buy positions open trades at Ask but close them at Bid
   //Sell positions open trades at Bid but close them at Ask
   
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   
   //Price must be normalized either to digits or ticksize
   askPrice = round(askPrice / tickSize) * tickSize;
   bidPrice = round(bidPrice / tickSize) * tickSize;
   
   string comment = "LONG" + " | " + _Symbol + " | " + string(MagicNumber);  
   
   //Request and Result Declaration and Initialization
   MqlTradeRequest request = {};
   MqlTradeResult result = {};
   
   
   
   
   //Request Parameters
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = 0.01;
   request.type = ORDER_TYPE_BUY;
   request.price = askPrice;
   request.deviation = 10;
   request.magic = MagicNumber;
   request.comment = comment;
   
   if(UseFillingPolicy == true) request.type_filling = FillingPolicy;
   
   
   //Request Send
   if(!OrderSend(request, result))
      Print("OrderSend trade placement error: ", GetLastError()); //if request was not sent, print error code
      
   //Trade Information
   Print("Open ", request.symbol, " LONG", " order #", result.order, ": ", result.retcode, ", Volume: ", result.volume, ", Price: ", DoubleToString(result.price, _Digits));
   
  }
//+------------------------------------------------------------------+
