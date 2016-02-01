package MVCprojectOL.ControllOL.BattleImage
{
	import MVCprojectOL.ModelOL.BattleImaging.BattleImagingProxy;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.CombatMonsterDisplayProxy;
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplayProxy;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class CatchBattleReady extends CatchCommands 
	{
		
		private var _countReady:int;
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			//trace(_obj.GetName(),this._countReady ,"收到戰場素材完成訊號");
			switch (_obj.GetName())
			{
				case CombatMonsterDisplayProxy.ReadySignal:
				case CombatSkillDisplayProxy.ReadySignal:
					this._countReady++;
					if (this._countReady == 2) {
						BattleImagingProxy(this._facaed.GetProxy(ArchivesStr.BATTLEIMAGING_SYSTEM)).LoadReady();
						//this._facaed.RemoveCommand("", this);//**************************************************************************************remember to remove 注意display會發送多次訊號的現象
						//remove換了方法
						this._facaed.RemoveALLCatchCommands(CatchBattleReady);//記得打開註解(新版的模組下才有這個功能項目能用)
						
						//技能的載入完成發送可能有多重發送的狀況(點擊LOADING中關閉後開啟另外戰場的時候)
					}
				break;
			}
			
		}
		
	    override public function GetListRegisterCommands():Array
		{
			return [CombatSkillDisplayProxy.ReadySignal,CombatMonsterDisplayProxy.ReadySignal];
		}
		
		
	}
	
}