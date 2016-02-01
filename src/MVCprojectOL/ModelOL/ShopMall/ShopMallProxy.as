package MVCprojectOL.ModelOL.ShopMall
{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Monster.MonsterServerWrite;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	import MVCprojectOL.ModelOL.Vo.PlayerBasicValue;
	import MVCprojectOL.ModelOL.Vo.ShopMall;
	import Spark.Utils.Text;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ProxyMonsterStr;
	//import MVCprojectOL.ModelOL.Vo.PlayerBasicVaule;
	import MVCprojectOL.ModelOL.Vo.ReturnMonster;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class ShopMallProxy  extends ProxY
	{
		
		private var _factoryCenter:ShopMallData;
		private var _netConnect:AmfConnector;
		private var _monsterServerWrite:MonsterServerWrite;
		public function ShopMallProxy():void 
		{
			super(ProxyPVEStrList.ShopMall_Proxy,this);
		}
		
		override public function onRegisteredProxy():void 
		{
			this._netConnect = AmfConnector.GetInstance();
			//this._factoryCenter = ShopMallData.GetInstance(this._netConnect.VoCallGroup);
			this._factoryCenter = new ShopMallData(this._netConnect.VoCallGroup);
			this._monsterServerWrite = MonsterServerWrite.GetMonsterServerWrite();
			//this._factoryCenter = ShopMallData.GetInstance(this._netConnect.VoCall);
			EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler,this );
		}
		
		private function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			var _netResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//---switch/case---
			var _palyerShop:ShopMall;
			var _returnMonster:ReturnMonster;
			switch(_Result.Status) {
				
				//case "shopPayReset":
				case "TimeLineShop":
					trace("<--resetPlayerBasicMoney---->");
					 //var _playerData:PlayerBasicValue = _netResultPack._result as PlayerBasicValue;
					 _palyerShop= _netResultPack._result as ShopMall;
					 if (_palyerShop!=null) {
					    var _now:uint = getTimer();
						var _backTimer:uint=_now-ShopMallData.PAYTIMEROLD;
						var _oldTimer:uint=ShopMallData.PAYTIMEROLD;
						ShopMallData.PAYTIMEROLD = _now;
						var _sprite:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameMenuView);
						var _text:Text = _sprite.getChildByName("PAY_TXT") as Text;
						_text.ReSetString("usePay : N  /getTimer : "+_oldTimer+"  back: Y"+"/getTimer : "+_backTimer);
						//PlayerDataCenter.SetPlayerDataVaule(_playerData);
						if (_palyerShop._fackSchid != "") {
						var _netRes:NetResultPack = new NetResultPack();
						_netRes._result = _palyerShop._shopBackClass;
						var _netBack:EventExpressPackage = new EventExpressPackage(
						"",
						_palyerShop._fackSchid,
						_netRes
						//new NetResultPack
						//_palyerShop._shopBackClass
						);	
						TimeLineProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.TIMELINE_PROXY)).SetNetResultHandler(_netBack);
							
						}
						if (_palyerShop._playerBasicValue!=null)PlayerDataCenter.SetPlayerDataVaule(_palyerShop._playerBasicValue);
						  
						}
						
						
					
				
				break;
				
				//---回復生命/回復疲勞
			    case ProxyPVEStrList.ShopMall_PayEng:
				case ProxyPVEStrList.ShopMall_PayHP:
					_palyerShop = _netResultPack._result as ShopMall; 
					_returnMonster= _palyerShop._shopBackClass [0]as ReturnMonster;
				     if (_palyerShop._playerBasicValue!=null)PlayerDataCenter.SetPlayerDataVaule(_palyerShop._playerBasicValue);
					MonsterServerWrite.GetMonsterServerWrite().WriteBack(_returnMonster);
					//---通知client改變畫面
				    //ProxyMonsterStr.MONSTER_CHANGE
					this.SendNotify(ProxyMonsterStr.MONSTER_CHANGE,_returnMonster);
				break;
				
			    case"RandomEvo_Skill":
				   _palyerShop = _netResultPack._result as ShopMall; 
				   _returnMonster= _palyerShop._shopBackClass[0] as ReturnMonster;
				   this._monsterServerWrite.WriteBack(_returnMonster);
				   if (_palyerShop._playerBasicValue!=null)PlayerDataCenter.SetPlayerDataVaule(_palyerShop._playerBasicValue);
				  
				break;
			}
		}
		
		//---確認金額
		public function CheckPay(_classType:String,_setObj:Object,_setPay:Object):Boolean 
		{
		  	return this._factoryCenter.CheckPay(_classType,_setObj,_setPay);
		}
		
		//---付款
		public function Pay():void 
		{
			this._factoryCenter.Pay();
		}
		
		public function GetPayTotal():uint 
		{
			return this._factoryCenter.GetPayTotal();
		}
		
		
	}
	
}