package Spark.MVCs.COMMANDS
{
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.MenuLine.MenuSequenceProxy;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.08.15.11.20
		@documentation MenuSequenceProxy註冊
	 */
	public class MenuSeqCommand extends Commands
	{
		
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			this._facaed.RegisterProxy(new MenuSequenceProxy(CommandsStrLad.SEQUENCE_SYSTEM));
			
		}
		
	}
	
}