package Spark.MVCs.COMMANDS
{
	
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfView;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.CommandsStrLad;
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.08.15
	 * @Explain:SourceCommads 啟動SourceProxy
	 * @playerVersion:11.0
	 */
	
	public class SourceCommads extends Commands 
	{
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void 
		{	
			this._facaed.RegisterProxy( SourceProxy.GetInstance());
		}
		
	}
	
}