package MVCprojectOL.ModelOL.Vo
{
	
	/**
	 * ...
	 * @author ...eric huang
	 * 交易所掛賣/買商品 server回覆---
	 */
	public class ExchangeSellBuy  
	{
		//--0=stone/1=武器/2=防具/3=飾品/4=monster
		public var _type:int = -1;
		
		//------_type=-1(掛賣商品server同意,回覆>ExchangeGoods)
		//------_type!=-1>買商品成功>回覆該物件的類型
		public var _serverBack:*;
		
		public var _playerBasicValue:PlayerBasicValue;
	}
	
}