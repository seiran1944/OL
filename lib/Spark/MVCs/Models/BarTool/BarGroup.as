package Spark.MVCs.Models.BarTool
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.07.13.11.20
		@documentation BAR庫存管理 操作工具
	 */
	public class  BarGroup
	{
		private var _barStore:BarStore = new BarStore();
		
		//main use
		/**
		 * 加入Bar元件註冊進管理
		 * @param	name 自定義註冊名稱
		 * @param	bar 須要控制的實體物件(Bar)
		 * @param	nowValue 當前數值
		 * @param	totalValue 最大上限值
		 * @param	parallel 是否為平行Bar
		 * @param	runTime 動態速度
		 */
		public function AddBar(name:String ,bar:DisplayObject,nowValue:Number,totalValue:Number ,parallel:Boolean=true,runTime:Number=1):void 
		{
			var bst:BarScaleTool = new BarScaleTool(bar, nowValue, totalValue, parallel, runTime);
			this._barStore.OnStore(name, bst);
		}
		
		//remove single bar
		/**
		 * 移除Bar註冊
		 * @param	name 自定義的名稱
		 */
		public function RemoveBar(name:String):void
		{
			this._barStore.OutStore(name);
		}
		
		//移除所有Bar
		/**
		 * 移除所有註冊的Bar
		 */
		public function RemoveAllBar():void 
		{
			this._barStore.CleanAllBar();
		}
		
		//同時會銷毀倉庫
		/**
		 * 註銷群組
		 */
		public function Destroy():void 
		{
			this._barStore.CleanAllBar();
			this._barStore.Destroy();
			this._barStore = null;
		}
		
		/**
		 * 變更Bar的當前數值 ( 傳入變化值 )
		 * @param	name 自定義的Bar名稱
		 * @param	value 變化值
		 */
		public function BarRunValue(name:String ,value:Number):void 
		{
			this.barReturn(name).RunChangeValue = value;
		}
		
		/**
		 * 變更Bar的當前數值 ( 傳入當前數值 )
		 * @param	name 自定義的Bar名稱
		 * @param	value 當前數值
		 */
		public function BarTotalValue(name:String,value:Number):void 
		{
			this.barReturn(name).RunTotalValue = value;
		}
		
		/**
		 * 回滿Bar條顯示 & 重置最大值  的操作
		 * @param	name 自定義的Bar名稱
		 * @param	fullOf 是否回滿Bar條顯示
		 * @param	value 是否重置Bar條最大值 0為不變動
		 */
		public function BarReset(name:String ,fullOf:Boolean,value:Number=0):void
		{
			this.barReturn(name).ReSetBar(fullOf, value);
		}
		
		//取得操作實體
		/**
		 * 回傳註冊的Bar條容器
		 * @param	name 自定義的Bar名稱
		 */
		public function GetBar(name:String):DisplayObject
		{
			var source:DisplayObject = this.barReturn(name).Source;
			return	source;
		}
		
		//<< check use >>
		/**
		 * GET 取得所有註冊過的名稱
		 */
		public function get GetAllKeys():Array
		{
			return this._barStore.GetAllKeys;
		}
		
		// << get value >>
		//取得當前動態處理後的數值
		/**
		 * 取得當前動態處理變化下的當前值
		 * @param	name 自定義的Bar名稱
		 */
		public function GetCurrentValue(name:String ):Number
		{
			return this.barProcess(name, 0);
		}
		
		//取得上限總值
		/**
		 * 取得目前上限最大值
		 * @param	name 自定義的Bar名稱
		 */
		public function GetTotalValue(name:String ):Number 
		{
			return this.barProcess(name, 1);
		}
		
		//取得變更後最終實際值
		/**
		 * 取得最終變更後數值
		 * @param	name 自定義的Bar名稱
		 */
		public function GetFinalValue(name:String ):Number 
		{
			return this.barProcess(name, 2);
		}
		
		
		
		private function barReturn(name:String):BarScaleTool
		{
			var bar:BarScaleTool = this._barStore.GetBar(name);
			return bar;
		}
		private function barProcess(name:String,type:int):Number
		{
			var bar:BarScaleTool = this._barStore.GetBar(name);
			switch (type) 
			{
				case 0:
					return bar.CurrentValue;
				break;
				case 1:
					return bar.TotalValue;
				break;
				case 2:
					return bar.FinalValue;
				break;
				default: return -1;
			}
			
		}
		
		
		
	}
	
}