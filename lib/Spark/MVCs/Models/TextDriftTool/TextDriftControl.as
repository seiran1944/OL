package Spark.MVCs.Models.TextDriftTool
{
	import flash.utils.Dictionary;
	import Spark.ErrorsInfo.MessageTool;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class TextDriftControl 
	{
		
		private var _dicDriftPool:Dictionary;
		
		public function TextDriftControl():void 
		{
			this._dicDriftPool = new Dictionary(true);
		}
		
		public function InDriftPool(name:String):TextDriftPool
		{
			var textPool:TextDriftPool;
			if (!this.CheckPool(name)) {
				textPool = new TextDriftPool();
				this._dicDriftPool[name] = textPool;
			}else {
				textPool = null;
				MessageTool.InputMessageKey("X01");//已經註冊過的群組名稱
			}
			return textPool;
		}
		
		public function OutDriftPool(name:String):void 
		{
			if (this.CheckPool(name)) {
				this._dicDriftPool[name].Destroy();
				delete this._dicDriftPool[name];
			}else {
				MessageTool.InputMessageKey("X02");//群組名稱已經被移除
			}
			
		}
		
		public function GetDriftPool(name:String):TextDriftPool
		{
			return this.CheckPool(name) ? this._dicDriftPool[name] : null;
		}
		
		public function CheckPool(name:String):Boolean
		{
			return name in this._dicDriftPool ? true : false;
		}
		
	}
	
}