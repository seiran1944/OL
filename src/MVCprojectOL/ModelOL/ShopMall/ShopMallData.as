package MVCprojectOL.ModelOL.ShopMall
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import MVCprojectOL.ModelOL.ShopMall.Facatorys.MonsterFactory;
	import MVCprojectOL.ModelOL.ShopMall.Facatorys.PayDynamicFactory;
	import MVCprojectOL.ModelOL.ShopMall.Facatorys.RandomSkillFactory;
	import MVCprojectOL.ModelOL.ShopMall.Facatorys.TimeLineCompleteFacatory;
	//import MVCprojectOL.ModelOL.ShopMall.Facatorys.TimeLineFacatorys;
	import MVCprojectOL.ModelOL.ShopMall.InterFaceCore.IfPayShop;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class ShopMallData  
	{
		
	    private var _aryFactory:Dictionary ;
		//private static var _ShopMallData:ShopMallData;
		private var _realFactory:IfPayShop;
		private var _callServerFunction:Function;
		//TimeLineCompleteFacatory,MonsterFactory
		public static var PAYTIMEROLD:uint;
		public function ShopMallData(_fun:Function) 
		{
		   this._callServerFunction = _fun;
			//-----批次增加各種消費型態的工廠------
		   
			this._aryFactory = new Dictionary(true)
			//--一般排程固定消費--
			this._aryFactory["TimeLineCompleteFacatory"] = TimeLineCompleteFacatory;
			//---怪獸消費(動態計價)
			this._aryFactory["MonsterFactory"] = MonsterFactory;
			//---動態計算價位
			this._aryFactory["PayDynamicFactory"] = PayDynamicFactory;
			//--刷技能消費
			this._aryFactory["RandomSkillFactory"] = RandomSkillFactory;
			
			//[
			//TimeLineFacatorys, 
			//TimeLineCompleteFacatory,
			//MonsterFactory
		   //]
		}
		
		/*
		public static function GetInstance(_fun:Function=null):ShopMallData 
		{
			if (_fun != null && ShopMallData._ShopMallData == null) ShopMallData._ShopMallData = new ShopMallData(_fun); 			
			return ShopMallData._ShopMallData;
		}*/
		
		
		public function Pay():void 
		{
			this._realFactory.Pay();
		}
		
		public function CheckPay(_classType:String,_setObj:Object,_setPay:Object,_otherVaule:Object=null):Boolean 
		{
			this.creatFactoryHandler(_classType, _setObj, _setPay);
			if(_otherVaule!=null)this._realFactory.othersVaule(_otherVaule);
			var _flag:Boolean = (this._realFactory!=null)?this._realFactory.checkPay():false;
			return _flag;
		}
		
		//--0: // 魔王城建築升級加速 1: // 回復怪物血量 20130408  /  2: // 回復怪物疲勞 20130409 
		
		private function creatFactoryHandler(_classType:String,_setObj:Object,_setPay:Object):void 
		{
			
			//var _class:Class = getDefinitionByName("TimeLineCompleteFacatory") as Class;
			var _class:Class = this._aryFactory[_classType] as Class;
			this._realFactory = new _class(this._callServerFunction,_setObj, _setPay);
			
		}
		
		
		public function GetPayTotal():uint 
		{
			return this._realFactory.GetPayMoney();
		}
		
		
	}
	
}