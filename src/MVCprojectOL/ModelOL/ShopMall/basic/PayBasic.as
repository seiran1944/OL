package MVCprojectOL.ModelOL.ShopMall.basic
{
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.PayBill.PayBillDataCenter;
	import MVCprojectOL.ModelOL.ShopMall.InterFaceCore.IfPay;
	import MVCprojectOL.ModelOL.Vo.PayBill;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class PayBasic implements IfPay 
	{
		//private var _sendFun:Function;
		protected var _shopMoney:uint;
		//protected var _type:int;
		//protected var _scherID:String="";
		//protected var _targetID:String;
		//----
		/*
		public function Pay(_fun:Function,_malltype:int,_target:String) 
		{
			if (_fun != null) this._sendFun = _fun;
			if (_malltype != null) this._type = _malltype;
			if (_target!=null) this._targetID = _target;
		}*/
		
		//public function set scherID(value:String):void { _scherID = value };
		
		public function GetPayBill(_obj:Object):void 
		{
		  if (_obj != null) {
			
			 var _vo:PayBill=PayBillDataCenter.GetInstance().Inquiry(_obj._key);	 
			 //---一次性的消費----
			 if (_vo != null) this._shopMoney = _vo._moneyBasic;  
			}
			
		}
		
		//--key=消費金額的代碼----
		public function CheckMoneyHandler():Boolean 
		{
			var _playerMoney:uint = PlayerDataCenter.PlayerMony;
			var _flag:Boolean = (_playerMoney >= this._shopMoney)?true:false;
			return _flag;
		}
		
		//---扣款-----
		public function PayMoney():void 
		{
		   	PlayerDataCenter.addMoney(-(this._shopMoney));
		}
		
		
		public function showMoney():uint 
		{
			return this._shopMoney;
		}
		//---取得計算後的金額
		/*
		public function get shopMoney():uint 
		{
			return this._shopMoney;
		}*/
		
		
		
	}
	
}