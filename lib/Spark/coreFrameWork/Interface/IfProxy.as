package Spark.coreFrameWork.Interface
{
	/**
	 * ...
	 * @author EricHuang
	 * 
	 * //--註冊者必須實踐這個proxy的 界面interface-----
	 * [proxy pattern]
	 * 
	 */
	public interface  IfProxy 
	{
		function GetData():Object; 
		function SetData(_obj:Object):void; 
		function GetProxyName():String; 
		function SetProxyName(_name:String):void; 
		//---註冊後要處理的相關事項
		function onRegisteredProxy():void; 
		//----移除之後的處理
		function onRemovedProxy():void; 
		
		
	}
	
	
	
}