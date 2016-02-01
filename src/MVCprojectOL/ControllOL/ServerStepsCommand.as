package MVCprojectOL.ControllOL
{
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.commands.SingleCompleteCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.29.16.34
		@documentation 註冊ServerTimework Proxy
	 */
	public class ServerStepsCommand extends SingleCompleteCommands 
	{
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			this._facaed.RegisterProxy(ServerTimework.GetInstance());
			this.onCompleteHandler();
		}
		
		
	}
	
}