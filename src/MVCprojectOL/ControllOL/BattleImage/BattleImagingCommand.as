package MVCprojectOL.ControllOL.BattleImage
{
	import MVCprojectOL.ControllOL.BattleImage.BattleBridgeCommand;
	import MVCprojectOL.ModelOL.BattleImaging.BattleImagingProxy;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 初始系統戰鬥播放環境系統
	 */
	public class BattleImagingCommand extends Commands
	{
		
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			this._facaed.RegisterProxy(BattleImagingProxy.GetInstance());
			this._facaed.RegisterCommand(ArchivesStr.BATTLEIMAGING_BRIDGE, BattleBridgeCommand);
			
			
			
		}
		
		
	}
	
}