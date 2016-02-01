package Spark.MVCs.Models.BarTool
{
	import com.greensock.*;
	import Spark.ErrorsInfo.MessageTool;
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.07.13.11.20
		@documentation Bar Stock
	 */
	public class BarStore 
	{
		internal var _objStore:Object = { };
		
		internal function OnStore(name:String ,bar:BarScaleTool):void
		{
			if (!(name in this._objStore)) {
				this._objStore[name] = bar;
			}else {
				//throw new Error("'BarStore'   Your key has been use");
				MessageTool.InputMessageKey(704);
			}
		}
		
		internal function OutStore(name:String):void 
		{
			if (name in this._objStore) {
				TweenMax.killTweensOf(this._objStore[name].Source);
				
				this._objStore[name].ReleaseBar();
				this._objStore[name] = null;
				delete this._objStore[name];
			}else {
				//throw new Error("'BarStroe'   Your key has been removed");
				MessageTool.InputMessageKey(704);
			}
		}
		
		internal function GetBar(name:String ):BarScaleTool
		{
			var bar:BarScaleTool=this._objStore[name];
			
			if (bar != null) {
				return bar;
			}else {
				//throw new Error("'BarStore'  Can't find this Bar");
				MessageTool.InputMessageKey(704);
				return null;
			}
			
		}
		
		internal function CleanAllBar():void 
		{
			for (var i:String in this._objStore) 
			{
				this.OutStore(i);
			}
			
		}
		
		internal function Destroy():void 
		{
			this._objStore = null;
		}
		
		internal function get GetAllKeys():Array 
		{
			var arrKey:Array = [];
			for (var key:String in this._objStore) {
				arrKey.push(key);
			}
			return arrKey;
		}
		
		
	}
	
}