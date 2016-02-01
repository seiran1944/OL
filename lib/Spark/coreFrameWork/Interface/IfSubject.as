package Spark.coreFrameWork.Interface
{
	
	/**
	 * ...
	 * @author EricHuang
	 * ---subject interface------
	 */
	public interface  IfSubject  
	{
		//--註冊
	    function RegisterObserver (_id:String,_obj:IfObserver):void;
		//--移除
		function KillRegister(registerID:String):void;
		//---執行
		function NotifyRegister():void;
	}
	
}