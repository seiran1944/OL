package Spark.coreFrameWork.commands
{
	import Spark.coreFrameWork.Interface.IfCatchCommands;
	import Spark.coreFrameWork.Interface.IfCommands;
	import Spark.coreFrameWork.Interface.IfFacade;
	import Spark.coreFrameWork.Interface.IfNotify;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.MVC.FacadeCenter;
	import Spark.coreFrameWork.observer.Notify;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  CatchCommands extends Notify implements IfCommands,IfNotify,IfCatchCommands
	{
		
		protected var _facaed:IfFacade = FacadeCenter.GetFacadeCenter();
		
		
		public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			
		}
	    
		
		//(override this function)-----10/30回傳該之commands有興趣的監聽commands(string)----
	    public function GetListRegisterCommands():Array 
		{
			return [];
		}
		
		
		protected function onResCommandsHandler(_obj:IfNotifyInfo):void 
		{
			
			
			
		}
		
	   	
		
		
	}
	
}