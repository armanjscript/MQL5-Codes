//+------------------------------------------------------------------+
//| DISCLAIMER                                                       |
//+------------------------------------------------------------------+

//THE SOFTWARE IS DELIVERED “AS IS” AND “AS AVAILABLE”, WITHOUT WARRANTY OF ANY KIND. 
//YOU EXPRESSLY ACKNOWLEDGE AND AGREE THAT THE ENTIRE RISK AS TO THE USE, RESULTS AND 
//PERFORMANCE OF THE SOFTWARE IS ASSUMED SOLELY BY YOU. 
//TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, THE AUTHOR EXPRESSLY DISCLAIMS ALL 
//WARRANTIES, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO,  THE IMPLIED 
//WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE AND 
//NON-INFRINGEMENT, OR ANY WARRANTY ARISING OUT OF ANY PROPOSAL, 
//SPECIFICATION OR SAMPLE WITH RESPECT TO THE SOFTWARE, AND WARRANTIES THAT MAY ARISE 
//OUT OF COURSE OF DEALING, COURSE OF PERFORMANCE, USAGE OR TRADE PRACTICE. 
//WITHOUT LIMITATION OF THE FOREGOING, THE AUTHOR PROVIDES NO WARRANTY OR UNDERTAKING, 
//AND MAKE NO REPRESENTATION OF ANY KIND THAT THE SOFTWARE, WILL MEET YOUR REQUIREMENTS, 
//ACHIEVE ANY INTENDED RESULTS, BE COMPATIBLE OR WORK WITH ANY OTHER SOFTWARE, SYSTEMS 
//OR SERVICES, OPERATE WITHOUT INTERRUPTION, MEET ANY PERFORMANCE OR RELIABILITY STANDARDS 
//OR BE ERROR FREE OR THAT ANY ERRORS OR DEFECTS CAN OR WILL BE CORRECTED. 
//NO ORAL OR WRITTEN INFORMATION OR ADVICE GIVEN BY THE AUTHOR SHALL CREATE 
//A WARRANTY OR IN ANY WAY AFFECT THE SCOPE AND OPERATION OF THIS DISCLAIMER. 
//THIS DISCLAIMER OF WARRANTY CONSTITUTES AN ESSENTIAL PART OF THIS LICENSE.

//+------------------------------------------------------------------+
//| Expert information                                               |
//+------------------------------------------------------------------+

//#include <stdDirectoryTradingFunctions.mqh> for including files
#include "currDirectoryTradingFunctions.mqh" // for several expert advisors
#property copyright "Copyright 2026, MetaQuotes Ltd."
#property link      ""
#property version   "1.10"

//+------------------------------------------------------------------+
//| Expert Notes                                                     |
//+------------------------------------------------------------------+
// Expert Advisor that codes a Moving Average strategy
// It is designed to trade in direction of the trend, placing buy positions when last bar closes above the moving average and short sell positions when last bar closes below the moving average 
// It incorporates two different alternative stop-loss that consists of fixed points below the open price or moving average, for long trades, or above the open price or moving average, for short trades
// It incorporates settings for placing profit taking, as well as break-even and trailing stop loss


//+------------------------------------------------------------------+
//| EA Enumerations                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Input & Global Variables                                         |
//+------------------------------------------------------------------+

sinput group                  "EA GENERAL SETTINGS";
input ulong                    MagicNumber = 101;

sinput group                  "MOVING AVERAGE SETTINGS";
input int                      MAPeriod = 30;
input                          ENUM_MA_METHOD MAMethod = MODE_SMA;
input int                      MAShift = 0;
input ENUM_APPLIED_PRICE       MaPrice = PRICE_CLOSE;

sinput group                  "MONEY MANAGEMENT";
input double                   FixedVolume = 0.01;


sinput group                  "POSITION MANAGEMENT";
input ushort                   SLFixedPoints = 0;
input ushort                   SLFixedPointsMA = 200;
input ushort                   TPFixedPoints = 0;
input ushort                   TSLFixedPoints = 0;
input ushort                   BEFixedPoints = 0;

datetime glTimeBarOpen;
int      MAHandle;

//+------------------------------------------------------------------+
//| Event Handlers                                                   |
//+------------------------------------------------------------------+

int OnInit()
{
   glTimeBarOpen = D'1994.12.22 00:00';
   
   MAHandle = MA_init(MAPeriod, MAShift, MAMethod, MaPrice);
   if(MAHandle == -1){
      return INIT_FAILED;
   }
   
   return(INIT_SUCCEEDED);
}




void OnDeinit(const int reason)
{
   Print("Expert removed");
}






void OnTick()
{

   //--------------------//
   //  NEW BAR CONTROL   //
   //--------------------//
   
   bool newBar = false;
   
   //Check for new bar
   if(glTimeBarOpen != iTime(_Symbol, PERIOD_CURRENT, 0)){
      
      newBar = true;
      glTimeBarOpen = iTime(_Symbol, PERIOD_CURRENT, 0);
   }
   
   if(newBar){
   
         //--------------------//
         // PRICE & INDICATORS //
         //--------------------//
          
          //Price
          double close1 = Close(1);
          double close2 = Close(2);
          //double open = Open(1);
          //Print(open);
          
          //Normalization of close price to digits
          //close = NormalizeDouble(close, _Digits);
          
          
          //Normalization of close price to tick size
          double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
          close1 = round(close1/tickSize) * tickSize;
          close2 = round(close2/tickSize) * tickSize;
          //double closeTickSize = round(close / tickSize) * tickSize;
          
          
          //Moving Average
          double ma1 = ma(MAHandle, 1);
          double ma2 = ma(MAHandle, 2);
          //Print("ma Value for bar 1: ", DoubleToString(ma1, _Digits));
          
          
         //--------------------//
         //     TRADE EXIT     //
         //--------------------//
         
         //Exit Signals & Close Trades Execution
         string exitSignal = "";
         
         if(exitSignal == "EXIT_LONG" || exitSignal == "EXIT_SHORT"){
               
               CloseTrades(MagicNumber, exitSignal);
         }
         
         Sleep(1000);
              
         //--------------------//
         //   TRADE PLACEMENT  //
         //--------------------//
         
         double stopLoss = CalculateStopLoss("LONG", SLFixedPoints, SLFixedPointsMA, ma1);
         double takeProfit = CalculateTakeProfit("LONG", TPFixedPoints);
         
         //Entry Signals & Order Placement Execution
         string entrySignal = MA_EntrySignal(close1, close2, ma1, ma2);
         Comment("EA #", MagicNumber, " | ", exitSignal, " | ", entrySignal, " SIGNALS DETECTED");
         
         if((entrySignal == "LONG" || entrySignal == "SHORT") && CheckPlacedPositions(MagicNumber) == false ){
            
            ulong ticket = OpenTrades(entrySignal, MagicNumber, FixedVolume);
            
            //SL & TP Trade Modification
            if(ticket > 0){
                double stopLoss = CalculateStopLoss(entrySignal, SLFixedPoints, SLFixedPointsMA, ma1);
                double takeProfit = CalculateTakeProfit(entrySignal, TPFixedPoints);
                TradeModification(ticket, MagicNumber, stopLoss, takeProfit);
            }
            
         }
         
         //--------------------//
         // POSITION MANAGEMENT//
         //--------------------//
         if(TSLFixedPoints > 0) TrailingStopLoss(MagicNumber, TSLFixedPoints);
         if(BEFixedPoints > 0) BreakEven(MagicNumber, BEFixedPoints);
   }

}
  
  
 
