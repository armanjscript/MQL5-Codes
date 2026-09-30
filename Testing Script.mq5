//+------------------------------------------------------------------+
//|                                               Testing Script.mq5 |
//|                                  Copyright 2026, MetaQuotes Ltd. |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, MetaQuotes Ltd."
#property link      ""
#property version   "1.00"

#property script_show_inputs //for input

//Define Constants
//#define EA_SYSTEM_NAME "TURTLE'S SYSTEM"

/*enum DaysOfWeek {
   Sunday = 0,
   Monday,
   Tuesday,
   Wednesday,
   Thursday,
   Friday,
   Saturday
};*/

/*struct tradeSetting{
   double orderPrice;
   double stopLoss;
   double takeProfit;
   uchar slippage;
   double volume;
   ENUM_ORDER_TYPE orderType;
   
};*/

//Global variable
//int globalVar = 5;

input int stopLoss = 200;
input int takeProfit = 200;
input int maProfit = 20;

void OnStart()
  {
      //---Alert("Hello World");
      
      //int x = 5, y = 7, z = 3;
      
      //x = x + y + z;
      
      //x = x * y - z;
      
      //double price = 5.5; 
      
      //double price;
      //price = 5.5;
      
      //price = price * 5;
      
      //Alert("Value of price: " + price);
      
      //bool marketIsTrending = true;
      
      //if(marketIsTrending == true) Print("Market is trending, ", marketIsTrending);  
      //if(marketIsTrending == false) Print("Market is not trending, ", marketIsTrending); 
      
      
      //Literal representation - RGB
      //color blueLiteral = C'45,35,186';
      
      //Integral representation - Hexadecimal
      //color blueIntegral = 0x3023ba;
      
      //Web-Color representation - Color name of mql5 constants
      //color blueWebColor = clrDarkBlue;
      
      
      /*datetime newYear = D'2026.01.01';
      datetime newYear2 = D'2026.01.01 00:25:20';
      datetime newYear3 = D'01.01.2026';
      
      datetime compilationDate = __DATE__;
      datetime compilationTime = __DATETIME__;
      
      Print("New Year 1: ", newYear);
      Print("New Year 2: ", newYear2);
      Print("New Year 3: ", newYear3);
      
      Print("Compilation Date: ", compilationDate);
      Print("Compilation Time: ", compilationTime); */
      
      
      //Enum
      /*DaysOfWeek today = Wednesday;
      Print("Today is: ", today, " which is ", EnumToString(today));*/
      
      //float  price = 15.55778;   //4 bytes  7 digits
      //double  lastPrice = 158.66854432; //8 bytes  16 digits
      
      /*string message = "Market is \"bullish\"" + " BUY";
      
      string messageConc;
      
      StringConcatenate(messageConc, "Market is \"bullish\"", " BUY");
      
      Print(message);
      
      Print(messageConc);*/
      
      /*int price[5];
      
      price[0] = 10;
      price[1] = 20;
      price[2] = 30;
      price[3] = 40;
      price[4] = 50;
      
      Print("Index 3 is: ", price[3]);*/
      
      //Dynamic Array
      
     /* int priceDynamic[];
      ArrayResize(priceDynamic, 5);
      
      priceDynamic[3] = 40;
      
      Print("Index 3 is: ", priceDynamic[3]); */
      
      //Multi Indexed Array
      
      /*int priceMulti [3][3];
      
      priceMulti[0][0] = 5;
      priceMulti[0][1] = 6;
      priceMulti[0][2] = 8;
      priceMulti[1][0] = 55;
      priceMulti[1][1] = 4;
      priceMulti[1][2] = 3;
      priceMulti[2][0] = 1;
      priceMulti[2][1] = 0;
      priceMulti[2][2] = 7; 
      
      Print("Index 1 2 is: ", priceMulti[1][2]);    */
      
      //Struct
      /*tradeSetting Trade;
      
      Trade.orderPrice = 125.50;
      Trade.stopLoss = 120;
      
      Print("Order Price: ", Trade.orderPrice);*/
      
      //Reserved Structs
      
      /*MqlTick TickInfo;
      
      SymbolInfoTick(_Symbol, TickInfo);
      
      double bid = TickInfo.bid;
      double ask = TickInfo.ask;
      
      Print("Bid: ", bid);
      Print("Ask: ", ask);*/
      
      //Constants
      /*Print("EA System Name: ", EA_SYSTEM_NAME);
      
      const double price = 2.51;
      
      price = 3.16;*/
      
      //Type casting
      /*int intVar = 100;
      char charVar = intVar;
      
      double doubleVar = 100.5899;
      int intVar2 = doubleVar;
      
      //Correct way Type casting
      //float floatVar = float(doubleVar);
      
      //Another Correct way
      float floatVar = (float)doubleVar;*/
      
      //Predefined Variables
      //Print("Current Chart Symbol: ", _Symbol, " | Timeframe: ", EnumToString(_Period), " | Digits: ", _Digits);
      
      
      
      //Scope of variables
      
      //int localVariable = 5;
      
      /*globalVar++;
      
      if(true){
         int localVariable = 5; 
         globalVar++;
         //localVariable++;
      }
      
      //Error
      //localVariable++;
      
      if(true){
         globalVar++;
         //Error
         //localVariable++;
         
      }*/
      
      Print(stopLoss);
      Print(takeProfit);
      Print(maProfit);
  }
  
 
 /*void OpenTrade(){
   
   //Error
   //localVariabale++;
   
   globalVar++;
 }*/

/*
Everything here will be
ignored
*/
