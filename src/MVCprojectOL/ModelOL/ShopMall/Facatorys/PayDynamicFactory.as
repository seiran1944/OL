package MVCprojectOL.ModelOL.ShopMall.Facatorys
{
	import MVCprojectOL.ModelOL.ShopMall.basic.PayDynamic;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  PayDynamicFactory extends TimeLineCompleteFacatory
	{
		
		
		public function PayDynamicFactory(_fun:Function,_setObj:Object,_setPay:Object) 
		{
			super(_fun,_setObj,_setPay);
		}
		
		override public function craetPay(_obj:Object):void 
		{
			this._payObject = new PayDynamic();
			this._payObject.GetPayBill(_obj);
		}
	}
	
}