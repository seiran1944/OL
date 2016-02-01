package MVCprojectOL.ModelOL.Vo
	{
		import flash.utils.ByteArray;
	
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.04.08.15.55
		@documentation 玩家建築基本資料
	 */
	public class  Building 
	{
		
		public var _guid:String;
		public var _name:String;//名稱key
		public var _picKey:String;//實體圖檔key //沒有小icon
		public var _info:String;//tip說明key
		public var _type:uint;//建築物類型1.大廳（魔法陣）, 2.巢穴 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室
		public var _status:int//建築物狀態( 0 閒置  /  1升級中  /  2建築功能運作中 )
		public var _lv:uint;//當前等級
		public var _maxLv:uint;//最高等級
		public var _workLimit:uint;//排程上限值
		public var _fur:uint;//升級所需毛
		public var _wood:uint;//升級所需木
		public var _stone:uint;//升級所需石
		public var _aryWorking:Array;//  排程key  ( 溶解所 圖書館 鍊金所 牢房 英靈室 )  >>  若無則為空陣列
		public var _cost:uint;//升級所耗費金錢 (靈魂)
		public var _needUpCD:uint;//升級所需時間
		public var _upgradable:Boolean;//可否升級
		public var _enable:Boolean;//是否可操作該棟建築功能 ( 依照系統預設初始限定起始 ) 任務可能影響建築功能性
		public var _gridLimit:int;//巢穴、儲藏室、牢房、英靈室 會用到//格子數量上限值
		public var _nextGridLimit:int;//巢穴、儲藏室、牢房、英靈室 會用到//格子數量上限值(下一等級)[TIPS USE]
		
		//public var _aryMaterial :Array;//升級所需素材 key / amount >>  若無則為空陣列
		//public var _currentUpCD:uint;//當前升級倒數
		//public var _x:uint;//座落位置(八種建築八個位置) 會依照格子座標配置
		//public var _y:uint;//座落位置(八種建築八個位置) 會依照格子座標配置
		//public var _width:uint;//建築物寬對應格子的數量
		//public var _height:uint;//建築物高對應格子的數量
		
		
		public function Destroy():void
		{
			if(this._aryWorking!=null) this._aryWorking.length = 0;
			this._aryWorking = null;
		}
		
	}
	
}