package Spark.coreFrameWork.Interface
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public  interface IfView
	{
		
		function SetViewName(_str:String):void;
		function GetViewName():String;
		//----在移除後可以提供使用者想要的處理操作
		function onRemoved():void;
		//----在註冊後可以提供使用者想要的處理操作
		function onRegisted():void;
		
		
	    function GetViewConter():DisplayObjectContainer;
		//---取得該層容器的名稱
	    function GetViewConterName():String;
		function SetViewConter(_conter:DisplayObjectContainer):void;
		//--取得是否可以刪除的物件檢查
		function GetLock():Boolean;
		//----關閉顯示(關閉viewctrl裡面的容器顯示& mouseChildren=false)
		function DisplayClose():void;
		
		
	}
	
}