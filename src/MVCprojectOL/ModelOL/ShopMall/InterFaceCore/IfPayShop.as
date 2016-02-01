package MVCprojectOL.ModelOL.ShopMall.InterFaceCore
{
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public interface IfPayShop
	{
		function creatSet(_obj:Object):void 
		function craetPay(_obj:Object):void 
		function checkPay():Boolean;
		//---帶入特殊的參數-----
		function othersVaule(_obj:Object=null):void
		
		//---取得付款金額
		function GetPayMoney():uint
		
		function Pay():void 
		//---後續計算處理(暫停排程或是先刪掉東西諸如此類的)
		function onCompleteCalculate(_obj:Object=null):void 
	}
	
}