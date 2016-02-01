package MVCprojectOL.ModelOL.Exchange
{
	import Spark.coreFrameWork.ProxyMode.ProxY;
	//import Spark.MVCs.Models.NetWork.AmfConnector;
	//import Spark.MVCs.Models.NetWork.NetEvent;
	//import Spark.MVCs.Models.NetWork.NetResultPack;
	//import Spark.Utils.GlobalEvent.EventExpress;
	//import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author ...EricHuang---
	 */
	public class ExchangeProxy extends ProxY
	{
		//private var _netConnect:AmfConnector; 
		private var _exchangeDataCenter:ExchangeDataCenter;
		public function ExchangeProxy ()
		{
			
			super(ProxyPVEStrList.EXCHANGE_PROXY);
			
		}
		
		override public function onRegisteredProxy():void 
		{
			
			//EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler ,this );
			//this._netConnect = AmfConnector.GetInstance();
			this._exchangeDataCenter = new ExchangeDataCenter(this.SendNotify);
			
			this.SendNotify(ProxyPVEStrList.EXCHANGE_PROXY_READY);
			//this.SendNotifyHandler(ProxyPVEStrList.STONE_PROXYReady);
			
		}
		
		//---換頁
		public function ChangePage(_index:int):void 
		{
			this._exchangeDataCenter.ChangePage(_index);
		}
		
		//---準備切換操作模式>>
		//--0=stone/1=武器/2=防具/3=飾品/4=monster
		public function StartSearch(_index:int=0):void 
		{
			this._exchangeDataCenter.StartSearch(_index);
		}
		
		
		public function SetSearch(_type:String,..._args):void 
		{
			this._exchangeDataCenter.SetSearch(_type,_args);
		}
		
		
		public function Sort(_type:String,_upDown:String):void 
		{
			this._exchangeDataCenter.Sort(_type,_upDown);
		}
		
		public function ReSetCondition():void 
		{
			this._exchangeDataCenter.ReSetCondition();
		}
		
		//---取得玩家的掛賣清單
		public function GetPlayerSellList():void 
		{
			this._exchangeDataCenter.GetPlayerSellList();
		}
		//--取得玩家可以掛賣的商品(可掛賣的商品)----
		public function GetPlayerSellGoods(_type:String):Array 
		{
			return this._exchangeDataCenter.GetPlayerSellGoods(_type);
		}
		
		//---販賣商品
		public function SellGoods(_money:int,_type:String,_guid:String,_groupGuid:String=""):void 
		{
			this._exchangeDataCenter.SellGoods(_money,_type,_guid,_groupGuid);
		}
		
		//---買東西
		public function BuyGoods(id:String,_money:int):Boolean 
		{
			return this._exchangeDataCenter.BuyGoods(id,_money);
		}
	}
	
}