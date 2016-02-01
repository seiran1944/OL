package MVCprojectOL.ModelOL.ShopMall.InterFaceCore
{

	
	/**
	 * ...
	 * @author EricHuang
	 */
	public interface IfPay 
	{
		//---檢查確認金額是否足夠
		function CheckMoneyHandler():Boolean 
		//---取得付款的金額
		function GetPayBill(_obj:Object):void
		//---消費
		function PayMoney():void 
		//---取得顯示運算的金額
		function showMoney():uint
		//---顯示取得的金額
		//function GetShowPay():uint
	    //---後續處理
		//function Calculate():void 
		
	}
	
}