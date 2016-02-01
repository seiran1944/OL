package MVCprojectOL.ControllOL
{
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import strLib.proxyStr.BuildingStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.09.03.10.30
		@documentation 註冊BuildingProxy
	 */
	public class BuildingCommand extends Commands 
	{
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			this._facaed.RegisterProxy(BuildingProxy.GetInstance());
			
		}
		
		
	}
	
}