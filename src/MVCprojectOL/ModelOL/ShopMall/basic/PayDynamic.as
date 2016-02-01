package MVCprojectOL.ModelOL.ShopMall.basic
{
	import MVCprojectOL.ModelOL.PayBill.PayBillDataCenter;
	import MVCprojectOL.ModelOL.ShopMall.InterFaceCore.IfPay;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	import MVCprojectOL.ModelOL.Vo.PayBill;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class PayDynamic  extends PayBasic implements IfPay 
	{
		
		//---動態的金額消費方式---
		//{_key:payKey,_target:SCHID,_build:String}
		override public function GetPayBill(_obj:Object):void 
		{
			var _pay:PayBill = PayBillDataCenter.GetInstance().Inquiry(_obj._key);
			
			if (_pay!=null) {
				var _getTime:int = TimeLineObject.GetTimeLineObject().GetCalculateTime(_obj._build,_obj._target);
			   	var _index:int=Math.ceil(_getTime/_pay._value);
				this._shopMoney = _index * _pay._moneyBasic;
				trace("hello");
			}
			
		}
		
		
		
		
	}
	
}