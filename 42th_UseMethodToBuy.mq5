//+----
///Load Library

#include <Trade\Trade.mqh>

//Load Class and define object to use it

CTrade N_trade;  

#include <Trade\Positioninfo.mqh>

CPositionInfo N_Position;           

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

string StringMagic=IntegerToString(Magic);

string Symbol= _Symbol;

string SuperMagic=Symbol+StringMagic;

int CountBarsNew;

ENUM_POSITION_TYPE PositionType;

 

input double StopLoss = 0.001;

input double TakeProfit= 0.001;

 

double TotalSellVolume=0;

double TotalBuyVolume=0;

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

 

if(PositionsTotal()<10 && Sell_Volume()<10)

Sell_N_request(BidNassos,AskNassos,0.5);

if(PositionsTotal()<10 && Buy_Volume()<10)

Buy_N_request(BidNassos,AskNassos,0.5);

 

 

Comment ("Positions Total: " , PositionsTotal() , "\n"

          "Buy Volume: "  , Buy_Volume(),  "\n"

          "Buy Volume Method: "  , Buy_Volume_Method() ,  "\n"

          "Sell Volume: "  , Sell_Volume(),  "\n"        

          "Magic Defined: ",Magic,"\n" 

          "SuperMagic Defined: ",SuperMagic,"\n"    

          "Static_BAR_Time: ",Static_BAR_Time,"\n"        

          "Live_Bar_Time_0: " , Live_Bar_Time[0]);

}

 

//Helping Functions Below.

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

      Print("Sell now = ");

      int ticket=OrderSend (N_request,N_result);

};//End Buy Function

     

 

double Buy_Volume()

{  TotalBuyVolume=0;// I make it zero to start count from the begining

   for(int i=PositionsTotal()-1; i>=0; i--)

   {

      string Position_Symbol = PositionGetSymbol(i); //Get the symbol of the position

      PositionType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE); //0=Buy, 1=Sell

      Print(PositionType);//this is 0 for buy 1 for sell

     string PositionTypeString=EnumToString(PositionType);  //make it to be like string

      Print(PositionTypeString); 

      double PositionVolume = PositionGetDouble(POSITION_VOLUME);//Get the volume of the position

      double PositionMagic=PositionGetInteger(POSITION_MAGIC);

      if(Symbol()==Position_Symbol &&PositionMagic==Magic&& PositionType==POSITION_TYPE_BUY)// if currency pair is equal

               {TotalBuyVolume=TotalBuyVolume+PositionVolume;}

      Print(TotalBuyVolume);

    }//End for loop

    return TotalBuyVolume;

}//End Buy_Volume Function

 

double Sell_Volume()

{  TotalSellVolume=0;// I make it zero to start count from the begining

   for(int i=PositionsTotal()-1; i>=0; i--)

   {

      string Position_Symbol = PositionGetSymbol(i); //Get the symbol of the position

      PositionType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE); //0=Buy, 1=Sell

      Print(PositionType);//this is 0 for buy 1 for sell

      string PositionTypeString=EnumToString(PositionType);// make it to be like string

      Print(PositionTypeString); 

      double PositionVolume = PositionGetDouble(POSITION_VOLUME);//Get the volume of the position

      double PositionMagic=PositionGetInteger(POSITION_MAGIC);

      if( Symbol()==Position_Symbol && PositionMagic==Magic &&PositionType==POSITION_TYPE_SELL)

               {TotalSellVolume=TotalSellVolume+PositionVolume;}

      Print(TotalSellVolume);

    }//End for loop

return TotalSellVolume;

}//End Sell_Volume Function

 
//Afto to function Pano den doulevei. Den mazeuei to BuyVolume. Prospathisa na to kano me to using the CPositionInfo class alla kati den paei kala..
double Buy_Volume_Method()

{TotalBuyVolume=0;// I make it zero to start count from the begining

   for(int i=PositionsTotal()-1; i>=0; i--)//Scan the possitions

   {

   if(N_Position.SelectByIndex(i)) //Tsimpa to index tou position      

      if(N_Position.Symbol()==_Symbol && N_Position.Magic()==Magic&&N_Position.Type()=="buy") // Edo learn to do the above with N_position object

               {TotalBuyVolume=TotalBuyVolume+N_Position.Volume();}

      Print(TotalBuyVolume);

    }//End for loop

    return TotalBuyVolume;

}//End Buy_Volume Function
