#property copyright "Copyright 2026, MetaQuotes Ltd."
#property link      ""
#property version   "1.00"

void OnStart()
  {
      double stopLossPrice = StopLoss("BUY", 1.1255);
      Print(stopLossPrice); 
      double stopLossPriceSell = StopLoss("SHORT", 1.1255);
      Print(stopLossPriceSell);      
  }


double StopLoss(string pTradingDirection, double pOpenPrice, int pStopLossPoints=403){
   
   double stopLossPrice = 0;
   
   if(pTradingDirection == "BUY"){
   
      stopLossPrice = pOpenPrice - pStopLossPoints * _Point;
      
   } else if(pTradingDirection == "SHORT"){
   
      stopLossPrice = pOpenPrice + pStopLossPoints * _Point;
   }
   
   return stopLossPrice;

}
