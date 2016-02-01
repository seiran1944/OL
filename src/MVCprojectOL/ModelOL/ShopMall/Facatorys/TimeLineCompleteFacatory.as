package MVCprojectOL.ModelOL.ShopMall.Facatorys
{
	//import MVCprojectOL.ModelOL.ShopMall.basic.Pay;
	//import MVCprojectOL.ModelOL.ShopMall.InterFaceCore.IfCreatShopMall;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.MissionCalculateBase;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.ShopMall.basic.PayBasic;
	import MVCprojectOL.ModelOL.ShopMall.basic.SettingBasic;
	import MVCprojectOL.ModelOL.ShopMall.InterFaceCore.IfPay;
	import MVCprojectOL.ModelOL.ShopMall.InterFaceCore.IfPayShop;
	import MVCprojectOL.ModelOL.ShopMall.InterFaceCore.IfSetMallTarget;
	import MVCprojectOL.ModelOL.ShopMall.ShopMallData;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Mission;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionConditionComplete;
	import Spark.Utils.Text;
	import strLib.GameSystemStrLib;
	//import MVCprojectOL.ModelOL.Vo.Get.Get_PalyerBasicVaule;
	import MVCprojectOL.ModelOL.Vo.Get.Get_PlayerBasicValue;
	import MVCprojectOL.ModelOL.Vo.Set.Set_usemall;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 * 時間排程類的工廠(不包含建築物升級)
	 * 立即完成類型
	 */
	public class TimeLineCompleteFacatory implements IfPayShop
	{
		
		//---type=建築物帶碼??----
		
		protected var _setterObj:IfSetMallTarget;
		protected var _payObject:IfPay
		public var _sendFun:Function;
		public function TimeLineCompleteFacatory(_fun:Function,_setObj:Object,_setPay:Object):void 
		{
			if (_fun != null) this._sendFun = _fun;
			this.creatSet(_setObj);
		    this.craetPay(_setPay);
		}
		
		public function othersVaule(_obj:Object=null):void 
		{
			
		}
		
		public function GetPayMoney():uint 
		{
		    return this._payObject.showMoney();	
		}
		
		public function creatSet(_obj:Object):void 
		{
			this._setterObj = new SettingBasic();
			this._setterObj.Setting=_obj;
		}
		
		public function craetPay(_obj:Object):void 
		{
			this._payObject = new PayBasic();
			this._payObject.GetPayBill(_obj);
		}
		
		protected function getSetObject():Object 
		{
		   return  this._setterObj.GetSettingInfo();
		}
		
		protected function PayObjHandler():void 
		{
		    //---扣款
		    this._payObject.PayMoney();	
		}
		
		public function checkPay():Boolean 
		{ 
			return this._payObject.CheckMoneyHandler();
		}
		
		public function Pay():void 
		{
			var _obj:Object= this._setterObj.GetSettingInfo();
			this.onCompleteCalculate(_obj);
			this.PayObjHandler();
			//---直接連線了----
			//---0509連線追蹤
			//ShopMallData.PAYTIMEROLD = getTimer();
			//var _sprite:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameMenuView);
			//var _text:Text = _sprite.getChildByName("PAY_TXT") as Text;
			//_text.ReSetString("usePay : Y  /getTimer : "+ShopMallData.PAYTIMEROLD+"  back: N");
			//----以上為連線追蹤
			//MissionConditionComplete
			var _str:String = _obj._build +":" + _obj._schID;
		    var _mission:MissionConditionComplete= new MissionConditionComplete(); 
			_mission._missionType = _obj._mission;
			_mission._target = _obj._targetID;
			this._sendFun(new Set_usemall("TimeLineShop",{_type:_obj._type,_targetID:_obj._schID,_buildType:_obj._build},_str));
			this._sendFun(new Get_Mission([_mission]),true);
			
		}
		
		//-----消費需做的扣除動作之類的----
		public function onCompleteCalculate(_obj:Object=null):void 
		{
			var _buildGuid:String = (_obj._build==0)?"buildingTimeline":BuildingProxy.GetInstance().GetBuildingGuid(_obj._build);	
			//----暫停排程----
			TimeLineObject.GetTimeLineObject().CleanLine(_buildGuid,_obj._targetID);
		}
	
		
		
	}
	
}