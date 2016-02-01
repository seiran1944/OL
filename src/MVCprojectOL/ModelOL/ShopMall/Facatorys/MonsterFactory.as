package MVCprojectOL.ModelOL.ShopMall.Facatorys
{
	//import MVCprojectOL.ModelOL.ShopMall.basic.Pay;
	//import MVCprojectOL.ModelOL.Vo.Get.Get_PalyerBasicVaule;
	import MVCprojectOL.ModelOL.ShopMall.basic.PayDynamic;
	import MVCprojectOL.ModelOL.ShopMall.basic.PayMonsterDynamic;
	import MVCprojectOL.ModelOL.Vo.Get.Get_PlayerBasicValue;
	import MVCprojectOL.ModelOL.Vo.Set.Set_usemall;
	import strLib.proxyStr.ProxyPVEStrList;
	//import MVCprojectOL.ModelOL.ShopMall.InterFaceCore.IfCreatShopMall;
	import MVCprojectOL.ModelOL.ShopMall.InterFaceCore.IfPayShop;
	
	/**
	 * ...
	 * @author EricHuang
	 * 怪受回復一次回滿的操作
	 */
	public class MonsterFactory  extends TimeLineCompleteFacatory 
	{
		
		//---指定要帶入的type--ProxyPVEStrList.ShopMall_PayEng/ProxyPVEStrList.ShopMall_PayHP
		//private var _typeStr:String = "";
		
		//private var _sendPayStr:String = "";
		public function MonsterFactory(_fun:Function,_setObj:Object,_setPay:Object)
		{
			super(_fun, _setObj, _setPay);
			
		}
		
		/*
		override public function othersVaule(_obj:Object=null):void 
		{
			/*
			if (_obj != null) {
			    //---hp/fatigue(代入這兩個)
				this._typeStr = _obj._str;	
			  	this._sendPayStr = (_obj._str=="hp")?ProxyPVEStrList.ShopMall_PayHP:ProxyPVEStrList.ShopMall_PayEng;
			}
		}*/
		
		
		override public function craetPay(_obj:Object):void 
		{
			this._payObject = new PayMonsterDynamic();
			this._payObject.GetPayBill(_obj);
		}
		
		
		override public function Pay():void 
		{
			var _obj:Object = this._setterObj.GetSettingInfo();
			var _sendStr:String = (_obj._valType=="hp")?ProxyPVEStrList.ShopMall_PayHP:ProxyPVEStrList.ShopMall_PayEng;
			//this.PayObjHandler();
			this._sendFun(new Set_usemall(_sendStr,{_type:_obj._type,_targetID:_obj._targetID,_valType:_obj._valType}),true);
			//this._sendFun(new Get_PlayerBasicValue("shopPayReset"),true);
			
		}
		
	}
	
}