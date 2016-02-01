package Spark.MVCs.COMMANDS
{
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.TextDriftTool.TextDriftProxy;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class TextDriftCommand extends Commands 
	{
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			this._facaed.RegisterProxy(TextDriftProxy.GetInstance());
			
		}
		
		
	}
	
}