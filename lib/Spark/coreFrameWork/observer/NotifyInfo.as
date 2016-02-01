package Spark.coreFrameWork.observer
{
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	
	/**
	 * ...
	 * @author EricHuang
	 * 
	 */
	public class NotifyInfo implements IfNotifyInfo
	{
		
		private var _name:String;
		private var _class:Object;
		
		public function NotifyInfo (_strName:String,_notifyInfoClass:Object=null) 
		{
			this._name = _strName;
			this._class = _notifyInfoClass;
		}
		
		
		
		public function GetName():String 
		{
		  return this._name;	
		}
		
		public function SetName(_strName:String):void 
		{
			this._name = _strName;
		}
		
		//---必要時候可以取得本體(代入的class)
		public function GetClass():Object 
		{
			return this._class;
		}
		
		
		public function SetClass(_notifyInfoClass:Object):void 
		{
			this._class = _notifyInfoClass;
		}
		
	}
	
}