package MVCprojectOL.ModelOL.Vo.Pvp
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class PvpGoods
	{
		public var _guid:String;			//商品唯一編碼
		public var _title:String;			//商品名稱標題
		public var _info:String;			//商品介紹
		public var _moneyType:int;	//貨幣種類 >> 0 = 積分 , 1 = 晶鑽 
		public var _price:int;				//售價
		public var _levelLimit:int;		//能購買的PVP等級限制
		public var _amount:int;			//數量
		public var _sortPriority:int;	//顯示優先度等級    <最優先>1.2.3.4.....~
		public var _goods:Object;		//商品資料VO  <PlayerEquipment...>
		
		
		//CLIENT端用判斷值
		public var _locking:Boolean;	//是否鎖住購買按鈕灰階無法點選 <true = 鎖>
		public function CheckLocking(userPlace:int):void 
		{
			this._locking = this._levelLimit <= 0 ? false : userPlace <= this._levelLimit ? false : true;
		}
		
		
		
		//企劃資料尚無
		//public var _salesPromotionType:int;			//促銷種類 可同時做優先度類型排列   <最優先>1.2.3.4.....~
		//public var _salesPromotionData:Object;	//促銷相關資料(新/半價/...)
		/*
		{
			_picItem : String 	<圖示>
			_info : String			<銷售文>
			...anything else needed data
		}
		*/
		
	}
	
}