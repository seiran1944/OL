package Spark.MVCs.COMMANDS
{
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.BarBasic;
	import Spark.MVCs.Models.BarTool.BarProxy;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.08.15.10.50
		@documentation 註冊BarProxy
	 */
	public class BarCommand extends Commands 
	{
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			this._facaed.RegisterProxy(new BarBasic());
			
		}
		
		
	}
	
}