package Spark.MVCs.COMMANDS
{
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.BarBasic;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class RegeistBarProxyCommands extends Commands 
	{
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			this._facaed.RegisterProxy(new BarBasic());
			
			
		}
	}
	
}