package Spark.coreFrameWork.observer
{
	import Spark.coreFrameWork.Interface.IfFacade;
	import Spark.coreFrameWork.Interface.IfNotify;
	import Spark.coreFrameWork.MVC.FacadeCenter;
	
	/**
	 * ...
	 * @author EricHuang
	 * observer patterns [core observer]
	 *
	 * 主要功用用來發送通知訊息----
	 * 
	 */
	public class Notify implements IfNotify
	{
		
		public function SendNotify(_notifyName:String,body:Object=null):void
		{
			
			FacadeCenter.GetFacadeCenter().SendNotify(_notifyName,body);		
		}
		
		
	}
	
}