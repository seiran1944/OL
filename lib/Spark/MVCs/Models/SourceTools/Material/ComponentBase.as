package Spark.MVCs.Models.SourceTools.Material
{
	
	import Spark.MVCs.Models.SourceTools.Material.MaterialComponent;
	
	
	
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.08.08
	 * @Explain:ComponentBase 基底元件資訊
	 * @playerVersion:11.0
	 */
	
	
	public class ComponentBase 
	{
		//記錄元件URL位置
		private var _Url:String = "";
		//記錄元件KeyValue
		private var _KeyValue:String = "";
		//記錄元件類型
		//private var _Type:uint = 0;
		//記錄元件實體物件
		private var _Content:*;
		
		
		public function ComponentBase( _InputURL:String , _InputKey:String , _InputContent:* ) 
		{
			this._Url = _InputURL;
			this._KeyValue = _InputKey;
			//this._Type = _InputType;
			this._Content = _InputContent;	
			
		}
		//取出元件URL位置
		public function get URL():String 
		{
			return this._Url;
		}
		//取出元件Key碼		
		public function get Key():String 
		{
			return this._KeyValue;
		}
		//取出元件Type類型
		/*public function get Type():uint 
		{
			return this._Type;
		}*/
		//取出元件實體物件		
		public function get Content():* 
		{
			return this._Content;
		}
		
		
	}//end class
}//end package