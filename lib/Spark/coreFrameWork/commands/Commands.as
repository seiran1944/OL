package Spark.coreFrameWork.commands
{
	import Spark.coreFrameWork.Interface.IfCommands;
	import Spark.coreFrameWork.Interface.IfFacade;
	import Spark.coreFrameWork.Interface.IfNotify;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.MVC.FacadeCenter;
	import Spark.coreFrameWork.observer.Notify;
	
	/**
	 * ...
	 * @author EricHuang
	 * ----抽象class----
	 * 需要繼承才可以被使用
	 * 8/11新增可以讓commands發送notify訊息的功能-----
	 */
	public class Commands extends Notify implements IfCommands, IfNotify
	{
		
		//---提供繼承的使用,讓使用command的使用者直接掉用facade-----
		protected var _facaed:IfFacade = FacadeCenter.GetFacadeCenter();
		
		//-----10/29該之command註冊的名稱----
		//protected var _commandsName:String;
		
		//--08/11----
		//----<PS>也可以共用一個commands-----由IfNotifyInfo.getName()---switch/case來作判斷區隔開
		public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			
			
		}
	    
		
	
		
		//-----10/29回傳該之command被註冊的名稱----
		/*
		public function get commandsName():String 
		{
			return _commandsName;
		}
		
		*/
		//-----請override掉
		public function RemoveCommands():void 
		{
			
		}
		
	}

}