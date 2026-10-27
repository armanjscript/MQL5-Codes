//+------------------------------------------------------------------+
//|                                 stdDirectoryTradingFunctions.mqh |
//|                                  Copyright 2026, MetaQuotes Ltd. |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, MetaQuotes Ltd."
#property link      ""

//+------------------------------------------------------------------+
//| EA FUNCTIONS                                                     |
//+------------------------------------------------------------------+

//+------------+// Price Functions //+-----------+//
double Close(int pShift){
   
   MqlRates bar[];                                         //it creates an object array of MqlRates structure
   ArraySetAsSeries(bar, true);                           //it sets the array as series array(so current bar is position 0, the previous bar is 1)
   CopyRates(_Symbol, PERIOD_CURRENT, 0, 3, bar);        //it copies the bar price information of bars position 0, 1 and 2 to our array "bar"
   
   return bar[pShift].close;
}


double Open(int pShift){
   
   MqlRates bar[];                                         //it creates an object array of MqlRates structure
   ArraySetAsSeries(bar, true);                           //it sets the array as series array(so current bar is position 0, the previous bar is 1)
   CopyRates(_Symbol, PERIOD_CURRENT, 0, 3, bar);        //it copies the bar price information of bars position 0, 1 and 2 to our array "bar"
   
   return bar[pShift].open;
}



//+------------+// Moving Average Functions //+-----------+//
int MA_init(int pMAPeriod, int pMAShift, ENUM_MA_METHOD pMAMethod, ENUM_APPLIED_PRICE pMAPrice){
   
   //In case of error when initializing the MA, GetLastError() will get the error code and store it in _lastError. 
   //ResetLastError will change _lastError variable to 0  
   ResetLastError();
   
   //A unique identifier for the indicator. Used for all actions related to the indicator, such as copying data and removing the indicator
   int Handle = iMA(_Symbol, PERIOD_CURRENT, pMAPeriod, pMAShift, pMAMethod, pMAPrice);
   
   if(Handle == INVALID_HANDLE){
      return -1;
      Print("There was an error creating the MA Indicator Handle: ", GetLastError());
   }
   
   Print("MA Indicator handle initialized successfully");
   return Handle;
}


double ma(int pMAHandle, int pShift){
   
   ResetLastError();
   
   //We create and fill an array with MA values 
   double ma[];
   ArraySetAsSeries(ma, true);
   
   //We fill the array with 3 most recent ma values
   bool fillResult = CopyBuffer(pMAHandle, 0, 0, 3, ma);
   if(fillResult == false){
      Print("FILL_ERROR: ", GetLastError());
   }
   
   //We ask for the ma value stored in pShift
   double maValue = ma[pShift];
   
   //We normalize the maValue to our symbol's digits and return it 
   maValue = NormalizeDouble(maValue, _Digits);
   
   return maValue;
}


string MA_EntrySignal(double pPrice1, double pPrice2, double pMA1, double pMA2){
   
   string str = "";
   string indicatorValues;
   
   if(pPrice1 > pMA1 && pPrice2 <= pMA2){
      str = "LONG";
   }
   else if(pPrice1 < pMA1 && pPrice2 >= pMA2){
      str = "SHORT";
   }
   else{
      str = "NO_TRADE";
   }
   
   StringConcatenate(indicatorValues, "MA 1: ", DoubleToString(pMA1, _Digits), " | ", "MA 2: ", DoubleToString(pMA2, _Digits), 
   " | ", "Close 1: ", DoubleToString(pPrice1, _Digits), " | ", "Close 2: ", DoubleToString(pPrice2, _Digits));
   
   Print("Indicator Values: ", indicatorValues);
   
   return str;
   
}


string MA_ExitSignal(double pPrice1, double pPrice2, double pMA1, double pMA2){
   
   string str = "";
   string indicatorValues;
   
   if(pPrice1 > pMA1 && pPrice2 <= pMA2){
      str = "EXIT_SHORT";
   }
   else if(pPrice1 < pMA1 && pPrice2 >= pMA2){
      str = "EXIT_LONG";
   }
   else{
      str = "NO_EXIT";
   }
   
   StringConcatenate(indicatorValues, "MA 1: ", DoubleToString(pMA1, _Digits), " | ", "MA 2: ", DoubleToString(pMA2, _Digits), 
   " | ", "Close 1: ", DoubleToString(pPrice1, _Digits), " | ", "Close 2: ", DoubleToString(pPrice2, _Digits));
   
   Print("Indicator Values: ", indicatorValues);
   
   return str;
   
}

//+------------+// Bollinger Bands Functions //+-----------+//
int BB_init(int pBBPeriod, int pBBShift, double pBBDeviation, ENUM_APPLIED_PRICE pBBPrice){
   
   //In case of error when initializing the MA, GetLastError() will get the error code and store it in _lastError. 
   //ResetLastError will change _lastError variable to 0  
   ResetLastError();
   
   //A unique identifier for the indicator. Used for all actions related to the indicator, such as copying data and removing the indicator
   int Handle = iBands(_Symbol, PERIOD_CURRENT, pBBPeriod, pBBShift, pBBDeviation, pBBPrice);
   
   if(Handle == INVALID_HANDLE){
      return -1;
      Print("There was an error creating the BB Indicator Handle: ", GetLastError());
   }
   
   Print("BB Indicator handle initialized successfully");
   return Handle;
}


double BB(int pBBHandle, int pBBLineBuffer, int pShift){
   
   ResetLastError();
   
   //We create and fill an array with MA values 
   double BB[];
   ArraySetAsSeries(BB, true);
   
   //We fill the array with 3 most recent ma values
   bool fillResult = CopyBuffer(pBBHandle, 0, 0, 3, BB);
   if(fillResult == false){
      Print("FILL_ERROR: ", GetLastError());
   }
   
   //We ask for the ma value stored in pShift
   double BBValue = BB[pShift];
   
   //We normalize the maValue to our symbol's digits and return it 
   BBValue = NormalizeDouble(BBValue, _Digits);
   
   return BBValue;
}

//+------------+// Order Placement Functions //+-----------+//

ulong OpenTrades(string pEntrySignal, ulong pMagicNumber, double pFixedVol){
   
    //Buy positions open trades at Ask but close them at Bid
   //Sell positions open trades at Bid but close them at Ask
   
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   
   //Price must be normalized either to digits or ticksize
   askPrice = round(askPrice / tickSize) * tickSize;
   bidPrice = round(bidPrice / tickSize) * tickSize;
   
   string comment = pEntrySignal + " | " + _Symbol + " | " + string(pMagicNumber);  
   
   //Request and Result Declaration and Initialization
   MqlTradeRequest request = {};
   MqlTradeResult result = {};
   
   if(pEntrySignal == "LONG"){
      
      //Request Parameters
      request.action    = TRADE_ACTION_DEAL;
      request.symbol    = _Symbol;
      request.volume    = pFixedVol;
      request.type      = ORDER_TYPE_BUY;
      request.price     = askPrice;
      request.deviation = 10;
      request.magic     = pMagicNumber;
      request.comment   = comment;
      
      
      //Request Send
      if(!OrderSend(request, result))
         Print("OrderSend trade placement error: ", GetLastError()); //if request was not sent, print error code
         
      //Trade Information
      Print("Open ", request.symbol, " ", pEntrySignal, " order #", result.order, ": ", result.retcode, ", Volume: ", result.volume, ", Price: ", DoubleToString(result.price, _Digits));
         
   } else if(pEntrySignal == "SHORT"){
       
      //Request Parameters
      request.action    = TRADE_ACTION_DEAL;
      request.symbol    = _Symbol;
      request.volume    = pFixedVol;
      request.type      = ORDER_TYPE_SELL;
      request.price     = bidPrice;
      request.deviation = 10;
      request.magic     = pMagicNumber;
      request.comment   = comment;
      
      
      //Request Send
      if(!OrderSend(request, result))
         Print("OrderSend trade placement error: ", GetLastError()); //if request was not sent, print error code
         
      //Trade Information
      Print("Open ", request.symbol, " ", pEntrySignal, " order #", result.order, ": ", result.retcode, ", Volume: ", result.volume, ", Price: ", DoubleToString(result.price, _Digits));
   }
   
   if(result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_DONE_PARTIAL || result.retcode == TRADE_RETCODE_PLACED || result.retcode == TRADE_RETCODE_NO_CHANGES){
      
      return result.order;
      
   } else return 0;
}


void TradeModification(ulong ticket, ulong pMagic, double pSLPrice, double pTPPrice){
   
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   
   MqlTradeRequest request = {};
   MqlTradeResult result = {};
   
   request.action = TRADE_ACTION_SLTP;
   request.position = ticket;
   request.symbol = _Symbol;
   request.sl = round(pSLPrice / tickSize) * tickSize;
   request.tp = round(pTPPrice / tickSize) * tickSize;
   request.comment = "MOD." + " | " + _Symbol + " | " + string(pMagic) + ", SL: " + DoubleToString(request.sl, _Digits) + ", TP: " + DoubleToString(request.tp, _Digits);
   
   if(request.sl > 0 || request.tp > 0){
      
      Sleep(1000);
      bool sent = OrderSend(request, result);
      Print(request.comment);
      
      if(!sent){
         
         Print("OrderSend Modification error: ", GetLastError());
         Sleep(3000);
         
         sent = OrderSend(request, result);
         Print(request.comment);  
         if(!sent){
            
           Print("OrderSend 2nd Try Modification error: ", GetLastError()); 
         }       
         
      }
      
   }

}


bool CheckPlacedPositions(ulong pMagic){
   
   bool placedPositions = false;
   
   for(int i = PositionsTotal() - 1; i>=0; i--){
      
      ulong positionTicket = PositionGetTicket(i);
      PositionSelectByTicket(positionTicket);
      
      ulong posMagic = PositionGetInteger(POSITION_MAGIC);
      
      if(posMagic == pMagic){
        
         placedPositions = true;
         break;
      }
   }
   
   return placedPositions;
}


void CloseTrades(ulong pMagic, string pExitSignal){

    //Request and Result Declaration and Initialization
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    for(int i = PositionsTotal() - 1; i>=0; i--){
      
      //Reset of request and result values
      ZeroMemory(request);
      ZeroMemory(result);
      
      ulong positionTicket = PositionGetTicket(i);
      PositionSelectByTicket(positionTicket);
      
      
      ulong posMagic = PositionGetInteger(POSITION_MAGIC);
      ulong posType  = PositionGetInteger(POSITION_TYPE);
      
      if(posMagic == pMagic && pExitSignal == "EXIT_LONG" && posType == ORDER_TYPE_BUY){
         
         request.action = TRADE_ACTION_DEAL;
         request.type = ORDER_TYPE_SELL;
         request.symbol = _Symbol;
         request.position = positionTicket;
         request.volume = PositionGetDouble(POSITION_VOLUME);
         request.price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         request.deviation = 10;
         
         bool sent = OrderSend(request, result);
         if(sent == true){
            Print("Position #", positionTicket, " closed");
         }
         
      } else if(posMagic == pMagic && pExitSignal == "EXIT_SHORT" && posType == ORDER_TYPE_SELL){
         
         request.action = TRADE_ACTION_DEAL;
         request.type = ORDER_TYPE_BUY;
         request.symbol = _Symbol;
         request.position = positionTicket;
         request.volume = PositionGetDouble(POSITION_VOLUME);
         request.price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
         request.deviation = 10;
         
         bool sent = OrderSend(request, result);
         if(sent == true){
            Print("Position #", positionTicket, " closed");
         }
      
      }
      
    }

}


//+------------+// Position Management Functions //+-----------+//

double CalculateStopLoss(string pEntrySignal, int pSLFixedPoints, int pSLFixedPointsMA, double pMA){
   
   double stopLoss = 0.0;  
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   
   
   if(pEntrySignal == "LONG"){
      
      if(pSLFixedPoints > 0){
         stopLoss = bidPrice - (pSLFixedPoints * _Point);
      }
      else if(pSLFixedPointsMA > 0){
         stopLoss = pMA - (pSLFixedPointsMA * _Point);
      }
      
      if(stopLoss > 0) stopLoss = AdjustBelowStopLevel(bidPrice, stopLoss);
      
   
   } else if(pEntrySignal == "SHORT"){
      
      if(pSLFixedPoints > 0){
         stopLoss = askPrice + (pSLFixedPoints * _Point);
      }
      else if(pSLFixedPointsMA > 0){
         stopLoss = pMA + (pSLFixedPointsMA * _Point);
      }      
      
      if(stopLoss > 0) stopLoss = AdjustAboveStopLevel(askPrice, stopLoss);
   
   } 
   
   stopLoss = round(stopLoss / tickSize) * tickSize;
   return stopLoss;

}



double CalculateTakeProfit(string pEntrySignal, int pTPFixedPoints){
   
   double takeProfit = 0.0;  
   double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   
   
   if(pEntrySignal == "LONG"){
      
      if(pTPFixedPoints > 0){
         takeProfit = bidPrice + (pTPFixedPoints * _Point);
      }
      
      if(takeProfit > 0) takeProfit = AdjustAboveStopLevel(bidPrice, takeProfit);
   
   } else if(pEntrySignal == "SHORT"){
      
      if(pTPFixedPoints > 0){
         takeProfit = askPrice - (pTPFixedPoints * _Point);
      }   
   
      if(takeProfit > 0) takeProfit = AdjustBelowStopLevel(askPrice, takeProfit);
   
   } 
   
   takeProfit = round(takeProfit / tickSize) * tickSize;
   return takeProfit;

}


void TrailingStopLoss(ulong pMagic, int PTSLFixedPoints){

    //Request and Result Declaration and Initialization
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    for(int i = PositionsTotal() - 1; i >= 0; i--){
         
         //Reset of request and result values
         ZeroMemory(request);
         ZeroMemory(result);
         
         ulong positionTicket = PositionGetTicket(i);
         PositionSelectByTicket(positionTicket);
         
         ulong posMagic = PositionGetInteger(POSITION_MAGIC);
         ulong posType = PositionGetInteger(POSITION_TYPE);
         double currentStopLoss = PositionGetDouble(POSITION_SL);
         double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
         double newStopLoss;
         
         
         if(posMagic == pMagic && posType == ORDER_TYPE_BUY){
            
            double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            newStopLoss = bidPrice - (PTSLFixedPoints * _Point);
            newStopLoss = AdjustBelowStopLevel(bidPrice, newStopLoss);
            newStopLoss = round(newStopLoss / tickSize) * tickSize;
            
            if(newStopLoss > currentStopLoss){
               
               request.action = TRADE_ACTION_SLTP;
               request.position = positionTicket;
               request.comment = "TSL. " + " | " + _Symbol + " | " + string(pMagic);
               request.sl = newStopLoss;
               
               bool sent = OrderSend(request, result);
               
               if(!sent){
                  Print("OrderSend TSL Error: ", GetLastError());
               }
            }
            
         } else if(posMagic == pMagic && posType == ORDER_TYPE_SELL){
                        
            double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            newStopLoss = askPrice + (PTSLFixedPoints * _Point);
            newStopLoss = AdjustAboveStopLevel(askPrice, newStopLoss);
            newStopLoss = round(newStopLoss / tickSize) * tickSize;
            
            if(newStopLoss < currentStopLoss){
               
               request.action = TRADE_ACTION_SLTP;
               request.position = positionTicket;
               request.comment = "TSL. " + " | " + _Symbol + " | " + string(pMagic);
               request.sl = newStopLoss;
               
               bool sent = OrderSend(request, result);
               
               if(!sent){
                  Print("OrderSend TSL Error: ", GetLastError());
               }
         }
    }   
   
   }
}


void BreakEven(ulong pMagic, int pBBFixedPoints){

    //Request and Result Declaration and Initialization
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    for(int i = PositionsTotal() - 1; i >= 0; i--){
         
         //Reset of request and result values
         ZeroMemory(request);
         ZeroMemory(result);
         
         ulong positionTicket = PositionGetTicket(i);
         PositionSelectByTicket(positionTicket);
         
         ulong posMagic = PositionGetInteger(POSITION_MAGIC);
         ulong posType = PositionGetInteger(POSITION_TYPE);
         double currentStopLoss = PositionGetDouble(POSITION_SL);
         double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
         double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         double newStopLoss = round(openPrice / tickSize) * tickSize;
         
         
         if(posMagic == pMagic && posType == ORDER_TYPE_BUY){
            
            double bidPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            double BEThreshold = openPrice + (pBBFixedPoints * _Point);
            
            if(newStopLoss > currentStopLoss && bidPrice > BEThreshold){
               
               request.action = TRADE_ACTION_SLTP;
               request.position = positionTicket;
               request.comment = "BE. " + " | " + _Symbol + " | " + string(pMagic);
               request.sl = newStopLoss;
               
               bool sent = OrderSend(request, result);
               
               if(!sent){
                  Print("OrderSend BE Error: ", GetLastError());
               }
            }
            
         } else if(posMagic == pMagic && posType == ORDER_TYPE_SELL){
                        
            double askPrice = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            double BEThreshold = openPrice - (pBBFixedPoints * _Point);
            
            
            if(newStopLoss < currentStopLoss && askPrice < BEThreshold){
               
               request.action = TRADE_ACTION_SLTP;
               request.position = positionTicket;
               request.comment = "BE. " + " | " + _Symbol + " | " + string(pMagic);
               request.sl = newStopLoss;
               
               bool sent = OrderSend(request, result);
               
               if(!sent){
                  Print("OrderSend BE Error: ", GetLastError());
               }
         }
    }   
   
   }
}


double AdjustAboveStopLevel(double pCurrentPrice, double pPriceToAdjust, int pPointsToAdd = 10){
   
   double adjustedPrice = pPriceToAdjust;
   
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   long stopsLevel = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   
   
   if(stopsLevel > 0){
      
      double stopsLevelPrice = stopsLevel * point;         //stops level points in price
      stopsLevelPrice = pCurrentPrice + stopsLevelPrice;  //stops price level - distance from bid/ask
      
      
      double addPoints = pPointsToAdd * point;            //Points that will be added/substracted to stops level price to make sure we respect the distance fixed by stops level
      
      if(adjustedPrice <= stopsLevelPrice + addPoints){
         
         adjustedPrice = stopsLevelPrice + addPoints;
         Print("Price adjusted above stops level to ", string(adjustedPrice));
         
      } 
   }
   
   return adjustedPrice;
}


double AdjustBelowStopLevel(double pCurrentPrice, double pPriceToAdjust, int pPointsToAdd = 10){
   
   double adjustedPrice = pPriceToAdjust;
   
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   long stopsLevel = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   
   
   if(stopsLevel > 0){
      
      double stopsLevelPrice = stopsLevel * point;         //stops level points in price
      stopsLevelPrice = pCurrentPrice - stopsLevelPrice;  //stops price level - distance from bid/ask
      
      
      double addPoints = pPointsToAdd * point;            //Points that will be added/substracted to stops level price to make sure we respect the distance fixed by stops level
      
      if(adjustedPrice >= stopsLevelPrice + addPoints){
         
         adjustedPrice = stopsLevelPrice - addPoints;
         Print("Price adjusted below stops level to ", string(adjustedPrice));
         
      } 
   }
   
   return adjustedPrice;
}
