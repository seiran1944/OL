package MVCprojectOL.ModelOL.Vo.Set
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	import flash.net.registerClassAlias;
	registerClassAlias("Set_PvpBuyingGoods", Set_PvpBuyingGoods);
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class Set_PvpBuyingGoods extends VoTemplate
	{
		
		public var _guid:String;
		
		public function Set_PvpBuyingGoods(guid:String):void 
		{
			super("PvpGoodsInvoice");
			this._guid = guid;
		}
		
		
	}
	
}