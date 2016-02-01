package MVCprojectOL.ModelOL.Vo.Set
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author ...ericHuang
	 * 交易所(買/賣)商品
	 */
	public class  Set_ExchangeGoods extends VoTemplate
	{
		//---賣>物品guid/買>商品ID----
		public var _goodsID:String;
		
		//---0=賣/1=買
		//public var _type:int;
		
		public var _money:int;
		
		public function Set_ExchangeGoods(_motation:String,_id:String,_money:int=-1) 
		{
			//---買>buy_ExchangeGoods  賣>sell_ExchangeGoods
			super(_motation);
			//this._type = _type;
			this._goodsID = _id;
			this._money = _money;
			
		}
	}
	
}