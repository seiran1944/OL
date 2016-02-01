package Spark.coreFrameWork.Interface
{
	
	/**
	 * ...
	 * @author EricHuang
	 * 
	 */
	public interface IfNotify 
	{
		//----發送通知調用------
		function SendNotify(_notifyName:String,body:Object=null):void;
		
	}
	
}