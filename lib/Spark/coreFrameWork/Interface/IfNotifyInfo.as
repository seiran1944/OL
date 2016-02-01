package Spark.coreFrameWork.Interface
{
	
	/**
	 * ...
	 * @author EricHuang
	 * interface [NotifyInfo].........
	 * save [Notify`s interface]---------
	 */
	public interface IfNotifyInfo 
	{
		function GetName():String;
		function SetName(_str:String):void;
		function GetClass():Object;
		function SetClass(_obj:Object):void;
	}
	
}