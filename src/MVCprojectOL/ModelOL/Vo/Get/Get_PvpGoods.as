package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	import flash.net.registerClassAlias;
	registerClassAlias("Get_PvpGoods", Get_PvpGoods);
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class Get_PvpGoods extends VoTemplate
	{
		
		public var _needGoods:Boolean;//是否需要商品資料  true =首次撈取  /  false = 後續開啟UI
		
		public function Get_PvpGoods(needGoods:Boolean=false):void 
		{
			super("PvpShopInit");
			this._needGoods = needGoods;
		}
		
		
	}
	
}