//Load Libraries & then the Classes by definding the Objects
#include <Trade\Trade.mqh>
CTrade N_trade;
#include <Trade\PositionInfo.mqh>
CPositionInfo N_position;

//Load Class and define object to use it
         
MqlTradeRequest N_request;  //Load the class and Define an object to use it
MqlTradeResult N_result;    //Load the class and Define an object to use it


//Variables Start
static datetime Static_BAR_Time;
datetime Live_Bar_Time[1];//Array with 1 price
bool IsNewBar_Variable;
bool EnoughNewBars_Variable;
int CopiedTime;
int time=2;
int Magic= _Period;
string Symbol= _Symbol;
input double StopLoss = 0.001;
input double TakeProfit= 0.001;

//int CountBars;
int CountBarsNew;
//Variables End
 

void OnTick()
{
double   BidNassos=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits); //fere to bid kai kanto normalized gia ta digits
double   AskNassos=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits); //fere to ask kai kanto normalized gia ta digits
CountBarsNew=Bars(_Symbol,_Period);// count the bars for this period?
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if(CountBarsNew>10000000000)
{Alert("Thelo pio polla bars");}//End if;

CopiedTime=CopyTime(_Symbol,_Period,0,1,Live_Bar_Time);//Edo kaneis copy to live Bar_Time!
if(CopiedTime>0 && Live_Bar_Time[0]!=Static_BAR_Time) //An i kainourgia Bar_Time den einai idia me tin Palia
   {Alert("NewTime"); // Enimerono
   Static_BAR_Time=Live_Bar_Time[0];}//Vazo tin palia idia me tin torini
else
   {return;}// End if;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if(PositionsTotal()<10)
   {Sell_N_request(BidNassos,BidNassos,0.1);}

Comment ("Positions Total: " , PositionsTotal() , "\n"
          "Buy Volume: "  , Buy_Volume(),  "\n"
          "Sell Volume: "  , Sell_Volume(),  "\n"
          "Magic Defined: ",Magic,"\n"          
          "Static_BAR_Time: ",Static_BAR_Time,"\n"        
          "Live_Bar_Time_0: " , Live_Bar_Time[0]);

 

//      if(PositionVolume<1)

//     {

//         if( PositionType == 0)//0=Buy, 1=Sell

//         {Buy_N_request(BidNassos,BidNassos,0.1);}

//      }     

//      if(PositionVolume<1)

//      {

//         if ( PositionType == 1)  //0=Buy, 1=Sell

//         {Sell_N_request(BidNassos,BidNassos,0.1);}      

//      }                             

//      if(PositionVolume>1)

//      {

//         if(PositionType == 0)//0=Buy, 1=Sell

//         {Sell_N_request(BidNassos,BidNassos,1);}     

//      }                             

//      if(PositionVolume>1)

//      { 

//         if(PositionType == 1)//0=Buy, 1=Sell

//         {Buy_N_request(BidNassos,BidNassos,1);}

//      } 

//           

//Comment ("Positions Total: " , PositionsTotal() , "\n"

//          "Position Type",PositionType,  "\n"

//          "Position Volume",PositionVolume , "\n"

//          "Magic Defined: ",Magic,"\n"          

//          "Static_BAR_Time: ",Static_BAR_Time,"\n"        

//          "Live_Bar_Time_0: " , Live_Bar_Time[0]);

//}//End For

 

 
}//End void OnTick

//+------------------------------------------------------------------+

void Sell_N_request(double Bid,double Ask,double Volume)
{
      ZeroMemory(N_request); 
      ZeroMemory(N_result);       
      N_request.action = TRADE_ACTION_DEAL;
      N_request.type = ORDER_TYPE_SELL;
      N_request.symbol =_Symbol;
      N_request.volume = Volume;
      N_request.type_filling = 1;
      N_request.price = Bid;
      N_request.magic=Magic;
      N_request.sl = NormalizeDouble(Ask*(1+StopLoss),_Digits);
      N_request.tp = NormalizeDouble(Ask*(1-TakeProfit),_Digits);
      N_request.deviation =5;
      Print("Sell now = ");
      int ticket=OrderSend (N_request,N_result);
      };//End Sell Function

void Buy_N_request(double Bid,double Ask,double Volume)
{
      ZeroMemory(N_request); 
      ZeroMemory(N_result);        
      N_request.action = TRADE_ACTION_DEAL;
      N_request.type = ORDER_TYPE_BUY;
      N_request.symbol =_Symbol;
      N_request.volume = Volume;
      N_request.type_filling = 1;
      N_request.price = Ask;
      N_request.magic=Magic;
      N_request.sl = NormalizeDouble(Bid*(1-StopLoss),_Digits);
      N_request.tp = NormalizeDouble(Bid*(1+TakeProfit),_Digits);
      N_request.deviation =5;
      Print("Buy now = ");
      int ticket=OrderSend (N_request,N_result);
      };//End Sell Function


int Buy_Volume()
{
double TotalBuyVolume=0;
   for(int i=PositionsTotal()-1; i>=0; i--)
   {
   ulong Position_Symbol = PositionGetSymbol(i); //Get the symbol of the position
   int PositionType = PositionGetInteger(POSITION_TYPE); //0=Buy, 1=Sell
   double PositionVolume = PositionGetDouble(POSITION_VOLUME);//Get the volume of the position
      if(Position_Symbol==_Symbol&&PositionType==0)// if currency pair is equal
      {TotalBuyVolume=TotalBuyVolume+PositionVolume;}
    }//End for loop
    return TotalBuyVolume;
}//End Buy_Volume Function

int Sell_Volume()
{
double TotalSellVolume=0;
   for(int i=PositionsTotal()-1; i>=0; i--)
   {
   ulong Position_Symbol = PositionGetSymbol(i); //Get the symbol of the position
   int PositionType = PositionGetInteger(POSITION_TYPE); //0=Buy, 1=Sell
   double PositionVolume = PositionGetDouble(POSITION_VOLUME);//Get the volume of the position
      if(Position_Symbol==_Symbol&&PositionType==1)// if currency pair is equal
      {TotalSellVolume=TotalSellVolume+PositionVolume;}
    }//End for loop
    return TotalSellVolume;
}//End Buy_Volume Function   


void CloseAll()
{
   for(int i=PositionsTotal()-1; i>=0; i--)
   if(N_position.SelectByIndex(i))   
   if(N_position.Symbol()==Symbol&&N_position.Magic()==Magic)
   {N_trade.PositionClose(N_position.Ticket());}//Where here i am using both classes CPositionInfo & CTrade
}
   
    