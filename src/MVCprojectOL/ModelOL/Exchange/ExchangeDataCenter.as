package MVCprojectOL.ModelOL.Exchange
{
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Equipment.EquipmentDataCenter;
	import MVCprojectOL.ModelOL.Exchange.sellCenter.ExchangeSell;
	import MVCprojectOL.ModelOL.Monster.MonsterServerWrite;
	import MVCprojectOL.ModelOL.Stone.StoneDataCenter;
	import MVCprojectOL.ModelOL.Vo.Exchange_Error;
	import MVCprojectOL.ModelOL.Vo.ExchangeData;
	import MVCprojectOL.ModelOL.Vo.ExchangeGoods;
	import MVCprojectOL.ModelOL.Vo.ExchangeSellBuy;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Exchange;
	import MVCprojectOL.ModelOL.Vo.Get.Get_ExchangeSellList;
	import MVCprojectOL.ModelOL.Vo.PlayerData;
	import MVCprojectOL.ModelOL.Vo.PlayerEquipment;
	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	import MVCprojectOL.ModelOL.Vo.PlayerStone;
	import MVCprojectOL.ModelOL.Vo.Set.Set_ExchangeGoods;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author ...erichuang
	 * 0531--
	 */
	public class ExchangeDataCenter 
	{
    	private var _sendNotifyFunction:Function;
    	//private var _callFunction:Function;
		private var _exchangeConditionCenter:ExchangeConditionCenter;
		//private var _vecSellGoods:Vector.<>
		private var _netConnect:AmfConnector; 
		//---買賣商品----
		private var _sellCenter:ExchangeSell;
		
		public function ExchangeDataCenter(_fun:Function)
		{
			EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler ,this );
			this._netConnect = AmfConnector.GetInstance();
			this._sendNotifyFunction = _fun;
			//this._callFunction = _fun;
			this._exchangeConditionCenter = new ExchangeConditionCenter();
			this._sellCenter = new ExchangeSell(_fun);
		}
		
		
		private function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			var _netResultPack:NetResultPack =  _Result.Content as NetResultPack;
			
			//---switch case-------
			switch(_Result.Status) {
				case "Get_Exchange":
				//--拍賣商品回來(取得商品清單)
			    var _serverBack:ExchangeData = _netResultPack._result as ExchangeData;
				var _sendObj:Object;
				if (_serverBack._aryGoods.length>0 ) {	
				   _sendObj = { _goods:_serverBack._aryGoods, _max:_serverBack._goodsMax };
				}
				this._sendNotifyFunction(ProxyPVEStrList.EXCHANGE_SEARCH_READY,_sendObj);
				break;
				//---取得玩家的掛賣狀態---
			    case "Get_ExchangeSellList":
				    var _aryPlayerSellList:Array = _netResultPack._result as Array;
					this._sellCenter.playerSellListe = _aryPlayerSellList;
				 
				break;
				
				
				//---掛賣成功---
			    case "sell_ExchangeGoods":
				  var _goodsList:ExchangeGoods = (_netResultPack._result as ExchangeSellBuy)._serverBack;
				  this._sellCenter.SellSuccess(_goodsList);
				break;
				
				//---買商品回來
			    case "buy_ExchangeGoods":
				  var _buyBack:ExchangeSellBuy = _netResultPack._result as ExchangeSellBuy;
				  var _target:*;
				  if (_buyBack._type == 0) {
					  _target = PlayerStone(_buyBack._serverBack);
					  StoneDataCenter.GetStoneDataControl().AddVoStone([_target]);  
				  } 
				  if (_buyBack._type == 1 || _buyBack._type == 2 || _buyBack._type == 3) {
					 _target = PlayerEquipment(_buyBack._serverBack);  
					EquipmentDataCenter.GetEquipment().AddEquipment([_target]);  
				 }
				  if (_buyBack._type == 4) {
					 _target = PlayerMonster(_buyBack._serverBack);    
					MonsterServerWrite.GetMonsterServerWrite().AddVoMonster([_target]);  
				  } 
				//---返回值的異動  
				if (_buyBack._playerBasicValue!=null)PlayerDataCenter.SetPlayerDataVaule(_buyBack._playerBasicValue);  
				this._sendNotifyFunction(ProxyPVEStrList.EXCHANGE_BUY_SUCCESS,{_picItem:_target._picItem, _showName: _target._showName }); 
				  
				break;
				
				
				case "Exchange_Error":	
				this._sendNotifyFunction(ProxyPVEStrList.EXCHANGE_ERROR,Exchange_Error(_netResultPack._result as Exchange_Error)._typeError);
				break;
				
			}
			
			
		}
	
		public function SetSearch(_type:String,_args:*):void 
		{
			
			switch(_type) {
				
		     	case ProxyPVEStrList.EXCHANGE_SEA_MONEY:
				this._exchangeConditionCenter.moneyMax = _args[0];
				break;
				
			    case ProxyPVEStrList.EXCHANGE_SEA_NAME:
				this._exchangeConditionCenter.searchName = _args[0];
				break;
				
			    case ProxyPVEStrList.EXCHANGE_SEA_QUALITY:
				this._exchangeConditionCenter.quality = _args[0];
				break;
				
			    default:
				var _index:String = _type.substr(13, _type.length - 13);
				this._exchangeConditionCenter.AddCondition(_index,_args[0],_args[1]);
			}
		}
		
		
		
		//---準備切換操作模式>>
		//--0=stone/1=武器/2=防具/3=飾品/4=monster
		public function StartSearch(_type:int):void 
		{
			this._exchangeConditionCenter.type = _type;
			//var _getExchange:Get_Exchange = this._exchangeConditionCenter.get_Exchange;
			//return this._exchangeConditionCenter.get_Exchange;
			this._netConnect.VoCall(this._exchangeConditionCenter.get_Exchange);
		}
		
		//---換頁
		public function ChangePage(_index:int):void 
		{
			this._exchangeConditionCenter.page = _index;
			//return this._exchangeConditionCenter.get_Exchange;
			this._netConnect.VoCall(this._exchangeConditionCenter.get_Exchange);
		}
		
		public function Sort(_type:String,_upDown:String):void 
		{
			this._exchangeConditionCenter.sortType = _type;
			this._exchangeConditionCenter.upDown = _upDown;
			this._netConnect.VoCall(this._exchangeConditionCenter.get_Exchange);
			/*
			var _getExchange:Get_Exchange = this._exchangeConditionCenter.get_Exchange;
			return _getExchange;
			*/
		}
		
		//---清空所有的搜尋條件
		public function ReSetCondition():void 
		{
			this._exchangeConditionCenter.ResetExchangeHandler();
		}
		
		//--取得玩家可以掛賣的商品(可掛賣的商品)----
		public function GetPlayerSellGoods(_type:String):Array 
		{
			return this._sellCenter.GetPlayerCanSellGoods(_type);
		
		}
		
		//---取得玩家的掛賣明細
		public function GetPlayerSellList():void 
		{
			var _ary:Array = this._sellCenter.playerSellListe;
			if (_ary == null) {
			    //----init call server--- 
				this._netConnect.VoCall(new Get_ExchangeSellList());
			}else {
				this._sendNotifyFunction(ProxyPVEStrList.EXCHANGE_SELL_LISTREDAY,_ary);
			}
		}
		
		//---販賣商品
		public  function SellGoods(_money:int,_type:String,_guid:String,_groupGuid:String=""):void 
		{
			//---改變商品的狀態或是脫掉裝備
			this._sellCenter.ChangeSellGoodsStatus(_type, _guid, _groupGuid);
			this._netConnect.VoCall(new Set_ExchangeGoods("sell_ExchangeGoods",_guid,_money));
		}
		
		//--check金額
		public function BuyGoods(id:String,_money:int):Boolean 
		{
		    var _flag:Boolean=false;
			if (PlayerDataCenter.PlayerSoul>=_money && id!="") {
				this._netConnect.VoCall(new Set_ExchangeGoods("buy_ExchangeGoods",id,_money));
			    _flag = true;
			}	
			return _flag;
		}
		
		
	}
	
}