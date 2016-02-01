package Spark.MVCs.Models.TextDriftTool
{
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import Spark.ErrorsInfo.MessageTool;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.08.10.30
		@documentation  文字框管理群組
	 */
	public class TextDriftPool 
	{
		
		private var _dicTextPool:Dictionary;//對應群組
		
		
		public function TextDriftPool():void 
		{
			this._dicTextPool = new Dictionary(true);
		}
		
		/**
		 * 註冊文字框
		 * @param	name 自定義名稱
		 * @param	text 須操作的文字框元件
		 */
		public function RegisterText(name:String,text:TextField):void
		{
			if (!this.CheckRegister(name)) {
				var textUnit:DriftUnit = new DriftUnit(text);
				this._dicTextPool[name] = textUnit;
			}else {
				MessageTool.InputMessageKey("X03");//此群組該文字框名稱已經註冊過
			}
		}
		
		/**
		 * 確認是(true)  /  否(false)  為註冊過的名稱
		 * @param	name 需確認的名稱
		 */
		public function CheckRegister(name:String):Boolean
		{
			return name in this._dicTextPool ? true : false;
		}
		
		/**
		 * 移除註冊的文字框
		 * @param	name 已註冊的名稱
		 */
		public function RemoveRegister(name:String):void 
		{
			
			if (this.CheckRegister(name)) {
				this._dicTextPool[name].ReleaseDrift();
				delete this._dicTextPool[name];
			}else {
				MessageTool.InputMessageKey("X04");//此群組該文字框名稱已經移除
			}
			
		}
		
		/**
		 * 取得註冊的文字框
		 * @param	name 註冊的名稱
		 */
		public function GetText(name:String):TextField
		{
			if (this.CheckRegister(name)) {
				return this._dicTextPool[name].Text;
			}else {
				MessageTool.InputMessageKey("X05");//無註冊此名稱文字框
				return null;
			}
			
		}
		
		/**
		 * 變更指定的文字框內容
		 * @param	name 註冊的名稱
		 * @param	startValue 起始數值
		 * @param	endValue 變更後的數值
		 */
		public function DriftTo(name:String,startValue:int,endValue:int):void 
		{
			if (this.CheckRegister(name)) {
				var driftUnit:DriftUnit = this._dicTextPool[name];
				driftUnit.DriftTo(startValue, endValue);
			}else {
				MessageTool.InputMessageKey("X05");//無註冊此名稱文字框
			}
			
		}
		
		/**
		 * 變更指定文字框的內容 ( 起始值固定0~9變換 )
		 * @param	name 註冊的名稱
		 * @param	to 變更後的數值
		 */
		public function RandomTo(name:String,to:int):void 
		{
			if (this.CheckRegister(name)) {
				var driftUnit:DriftUnit = this._dicTextPool[name];
				driftUnit.RandomDrift(to);
			}else {
				MessageTool.InputMessageKey("X05");//無註冊此名稱文字框
			}
			
		}
		
		
		/**
		 * 移除所有管理文字框工具與庫存槽
		 */
		public function Destroy():void 
		{
			for (var txtName:String in this._dicTextPool) 
			{
				this._dicTextPool[txtName].ReleaseDrift();
				delete this._dicTextPool[txtName];
			}
			
			this._dicTextPool = null;
		}
		
	}
	
}

