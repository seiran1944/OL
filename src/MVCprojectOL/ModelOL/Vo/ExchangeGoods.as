package MVCprojectOL.ModelOL.Vo
{
	import MVCprojectOL.ModelOL.Vo.Template.BasicVaule;
	
	/**
	 * ...
	 * @author ...ericHuang---VO
	 * ---交易所貨品資訊
	 * 
	 */
	public class ExchangeGoods extends BasicVaule
	{
		
		//--0=stone/1=武器/2=防具/3=飾品/4=monster
		public var _type:int = 0;
		
		//---PS-只適用玩家掛賣商品[成功]的時候使用---
		//---原生guid---
		public var _originGuid:String = "";
		//---原生groupGuid---
		public var _originGruopGuid:String = "";
		
		
		//----裝備圖片----
		public var _picItem:String = "";
		
		//---裝備(怪獸)等級
		public var _lv:int = -1;
		
		//--怪獸色階/裝備品質
		public var _rank:int = -1;
		
		//--怪獸色階
		/*
		public var _color:int = -1;
		//--裝備品質
		public var _quality:int = -1;
		*/
		//--售價
		public var _sellMoney:int = 0;
		
		public var _info:String = "";
		
		//--掛賣起始時間---
		
		public var _starTime:uint = 0;
		
		//--掛賣結數需要時間
		public var _needTime:uint = 0;
		
	}
	
}