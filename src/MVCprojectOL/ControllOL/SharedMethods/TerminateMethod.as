package MVCprojectOL.ControllOL.SharedMethods 
{
	import MVCprojectOL.ControllOL.AlchemyCtrl.CatchAlchemyControl;
	import MVCprojectOL.ControllOL.AuctionCtrl.CatchAuctionControl;
	import MVCprojectOL.ControllOL.BattleReportCtrl.CatchBattleReportControl;
	import MVCprojectOL.ControllOL.DevilStoreCtrl.CatchDevilStoreControl;
	import MVCprojectOL.ControllOL.BuildingUpgradeCtrl.CatchBuildingUpgradeContril;
	import MVCprojectOL.ControllOL.DissolveUI.CatchDissolveControl;
	import MVCprojectOL.ControllOL.EvolutionCtrl.CatchEvolutionControl;
   // import MVCprojectOL.ControllOL.JailCtrl.CatchJailControl;
	import MVCprojectOL.ControllOL.LibraryCtrl.CatchLibraryControl;
	import MVCprojectOL.ControllOL.PVPCtrl.CatchPVPControl;
	import MVCprojectOL.ControllOL.TurntableCtrl.CatchTurntableControl;
	//import MVCprojectOL.ControllOL.LoadingMarkCtrl.CatchLoadingMarkControl;
	import MVCprojectOL.ControllOL.MonsterCage.CatchMonsterCageControl;
	import MVCprojectOL.ControllOL.StorageUI.CatchStorageControl;
	import MVCprojectOL.ControllOL.TaskListCtrl.CatchTaskListControl;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.commandStr.DissolveStrLib;
	import strLib.commandStr.MonsterCageStrLib;
	import strLib.commandStr.StorageStrLib;
	import strLib.commandStr.UICmdStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class TerminateMethod extends Commands
	{
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) 
			{
				//巢穴
				case MonsterCageStrLib.Terminate_MonsterCage:
					this._facaed.RemoveALLCatchCommands( CatchMonsterCageControl );
					this._facaed.RemoveCommand( MonsterCageStrLib.Terminate_MonsterCage , TerminateMethod );
				break;
				//溶解
				case DissolveStrLib.Terminate_Dissolve:
					this._facaed.RemoveALLCatchCommands( CatchDissolveControl );
					this._facaed.RemoveCommand( DissolveStrLib.Terminate_Dissolve , TerminateMethod );
				break;
				//儲藏室
				case StorageStrLib.Terminate_Storage:
					this._facaed.RemoveALLCatchCommands( CatchStorageControl );
					this._facaed.RemoveCommand( StorageStrLib.Terminate_Storage , TerminateMethod );
				break;
				//鍊金
				case UICmdStrLib.Terminate_Alchemy:
					this._facaed.RemoveALLCatchCommands( CatchAlchemyControl );
					this._facaed.RemoveCommand( UICmdStrLib.Terminate_Alchemy , TerminateMethod );
				break;
				//圖書館
				case UICmdStrLib.Terminate_Library:
					this._facaed.RemoveALLCatchCommands( CatchLibraryControl );
					this._facaed.RemoveCommand( UICmdStrLib.Terminate_Library , TerminateMethod );
				break;
				//牢房
				/*case UICmdStrLib.Terminate_Jail:
					this._facaed.RemoveALLCatchCommands( CatchJailControl );
					this._facaed.RemoveCommand( UICmdStrLib.Terminate_Jail , TerminateMethod );
				break;*/
				//建築物升級
				case UICmdStrLib.Terminate_BuildingUp:
					this._facaed.RemoveALLCatchCommands( CatchBuildingUpgradeContril );
					this._facaed.RemoveCommand( UICmdStrLib.Terminate_BuildingUp , TerminateMethod );
				break;
				//進化
				case UICmdStrLib.Terminate_Evolution:
					this._facaed.RemoveALLCatchCommands( CatchEvolutionControl );
					this._facaed.RemoveCommand( UICmdStrLib.Terminate_Evolution , TerminateMethod );
				break;
				//任務列表
				case UICmdStrLib.Terminate_TaskList:
					this._facaed.RemoveALLCatchCommands( CatchTaskListControl );
					this._facaed.RemoveCommand( UICmdStrLib.Terminate_TaskList , TerminateMethod );
				break;
				//PVP
				case UICmdStrLib.Terminate_PVP:
					this._facaed.RemoveALLCatchCommands( CatchPVPControl );
					this._facaed.RemoveCommand( UICmdStrLib.Terminate_PVP , TerminateMethod );
				break;
				//轉盤
				case UICmdStrLib.Terminate_Turntable:
					this._facaed.RemoveALLCatchCommands( CatchTurntableControl );
					this._facaed.RemoveCommand( UICmdStrLib.Terminate_Turntable , TerminateMethod );
				break;
				//拍賣
				case UICmdStrLib.Terminate_Auction:
					this._facaed.RemoveALLCatchCommands( CatchAuctionControl );
					this._facaed.RemoveCommand( UICmdStrLib.Terminate_Auction , TerminateMethod );
				break;
				//魔鬥商城
				case UICmdStrLib.Terminate_DevilStore:
					this._facaed.RemoveALLCatchCommands( CatchDevilStoreControl );
					this._facaed.RemoveCommand( UICmdStrLib.Terminate_DevilStore , TerminateMethod );
				break;
				//戰鬥報告
				case UICmdStrLib.Terminate_BattleReport:
					this._facaed.RemoveALLCatchCommands( CatchBattleReportControl );
					this._facaed.RemoveCommand( UICmdStrLib.Terminate_BattleReport , TerminateMethod );
				break;
				//LoadingMark
				/*case UICmdStrLib.Terminate_LoadingMark:
					this._facaed.RemoveALLCatchCommands( CatchLoadingMarkControl );
					this._facaed.RemoveCommand( UICmdStrLib.Terminate_LoadingMark , TerminateMethod );
				break;*/
			}
		}
		
	}
}