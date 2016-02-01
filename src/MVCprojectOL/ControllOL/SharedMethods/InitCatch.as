package MVCprojectOL.ControllOL.SharedMethods 
{
	import MVCprojectOL.ControllOL.AlchemyCtrl.CatchAlchemyControl;
	import MVCprojectOL.ControllOL.AuctionCtrl.CatchAuctionControl;
	import MVCprojectOL.ControllOL.BattleReportCtrl.CatchBattleReportControl;
	import MVCprojectOL.ControllOL.DevilStoreCtrl.CatchDevilStoreControl;
	import MVCprojectOL.ControllOL.BuildingUpgradeCtrl.CatchBuildingUpgradeContril;
	import MVCprojectOL.ControllOL.DissolveUI.CatchDissolveControl;
	import MVCprojectOL.ControllOL.EvolutionCtrl.CatchEvolutionControl;
	//import MVCprojectOL.ControllOL.JailCtrl.CatchJailControl;
	import MVCprojectOL.ControllOL.LibraryCtrl.CatchLibraryControl;
	import MVCprojectOL.ControllOL.PVPCtrl.CatchPVPControl;
	import MVCprojectOL.ControllOL.TurntableCtrl.CatchTurntableControl;
	//import MVCprojectOL.ControllOL.LoadingMarkCtrl.CatchLoadingMarkControl;
	import MVCprojectOL.ControllOL.StorageUI.CatchStorageControl;
	import MVCprojectOL.ControllOL.TaskListCtrl.CatchTaskListControl;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.commandStr.DissolveStrLib;
	import strLib.commandStr.StorageStrLib;
	import strLib.commandStr.UICmdStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class InitCatch extends Commands
	{
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) 
			{
				//溶解
				case DissolveStrLib.Init_DissolveCatch:
					this._facaed.RegisterCommand( "" , CatchDissolveControl );
					this._facaed.RegisterCommand( DissolveStrLib.Terminate_Dissolve , TerminateMethod );//註冊終結事件
					this._facaed.SendNotify( DissolveStrLib.Init_Dissolve );
				break;
				//儲藏室
				case StorageStrLib.Init_StorageCatch:
					this._facaed.RegisterCommand( "" , CatchStorageControl );
					this._facaed.RegisterCommand( StorageStrLib.Terminate_Storage , TerminateMethod );//註冊終結事件
					this._facaed.SendNotify( StorageStrLib.Init_Storage, _obj.GetClass());
				break;
				//鍊金
				case UICmdStrLib.Init_Alchemy:
					this._facaed.RegisterCommand( "" , CatchAlchemyControl );
					this._facaed.RegisterCommand( UICmdStrLib.Terminate_Alchemy , TerminateMethod );//註冊終結事件
					this._facaed.SendNotify( UICmdStrLib.Init_AlchemyCatch );
				break;
				//圖書館
				case UICmdStrLib.Init_Library:
					this._facaed.RegisterCommand( "" , CatchLibraryControl );
					this._facaed.RegisterCommand( UICmdStrLib.Terminate_Library , TerminateMethod );//註冊終結事件
					this._facaed.SendNotify( UICmdStrLib.Init_LibraryCatch );
				break;
				//牢房
				/*case UICmdStrLib.Init_Jail:
					this._facaed.RegisterCommand( "" , CatchJailControl );
					this._facaed.RegisterCommand( UICmdStrLib.Terminate_Jail , TerminateMethod );//註冊終結事件
					this._facaed.SendNotify( UICmdStrLib.Init_JailCatch );
				break;*/
				//建築物升級
				case UICmdStrLib.Init_BuildingUp:
					this._facaed.RegisterCommand( "" , CatchBuildingUpgradeContril );
					this._facaed.RegisterCommand( UICmdStrLib.Terminate_BuildingUp , TerminateMethod );//註冊終結事件
					this._facaed.SendNotify( UICmdStrLib.Init_BuildingUpCatch );
				break;
				//進化
				case UICmdStrLib.Init_Evolution:
					this._facaed.RegisterCommand( "" , CatchEvolutionControl );
					this._facaed.RegisterCommand( UICmdStrLib.Terminate_Evolution , TerminateMethod );
					this._facaed.SendNotify( UICmdStrLib.Init_EvolutionCatch );
				break;
				//任務列表
				case UICmdStrLib.Init_TaskList:
					this._facaed.RegisterCommand( "" , CatchTaskListControl );
					this._facaed.RegisterCommand( UICmdStrLib.Terminate_TaskList , TerminateMethod );
					this._facaed.SendNotify( UICmdStrLib.Init_TaskListCatch, _obj.GetClass());
				break;
				//PVP
				case UICmdStrLib.Init_PVP:
					this._facaed.RegisterCommand( "" , CatchPVPControl );
					this._facaed.RegisterCommand( UICmdStrLib.Terminate_PVP , TerminateMethod );
					this._facaed.SendNotify( UICmdStrLib.Init_PVPCatch );
				break;
				//轉盤
				case UICmdStrLib.Init_Turntable:
					this._facaed.RegisterCommand( "" , CatchTurntableControl );
					this._facaed.RegisterCommand( UICmdStrLib.Terminate_Turntable , TerminateMethod );
					var _Obj:Object = { _Guid:_obj.GetClass()._Guid };
					this._facaed.SendNotify( UICmdStrLib.Init_TurntableCatch, _Obj );
				break;
				//拍賣
				case UICmdStrLib.Init_Auction:
					this._facaed.RegisterCommand( "" , CatchAuctionControl );
					this._facaed.RegisterCommand( UICmdStrLib.Terminate_Auction , TerminateMethod );
					this._facaed.SendNotify( UICmdStrLib.Init_AuctionCatch);
				break;
				//魔鬥商城
				case UICmdStrLib.Init_DevilStore:
					this._facaed.RegisterCommand( "" , CatchDevilStoreControl );
					this._facaed.RegisterCommand( UICmdStrLib.Terminate_DevilStore , TerminateMethod );
					this._facaed.SendNotify( UICmdStrLib.Init_DevilStoreCatch);
				break;
				//戰鬥報告
				case UICmdStrLib.Init_BattleReport:
					this._facaed.RegisterCommand( "" , CatchBattleReportControl );
					this._facaed.RegisterCommand( UICmdStrLib.Terminate_BattleReport , TerminateMethod );
					this._facaed.SendNotify( UICmdStrLib.Init_BattleReportCatch);
				break;
				//LoadingMark
				/*case UICmdStrLib.Init_LoadingMark:
					this._facaed.RegisterCommand( "" , CatchLoadingMarkControl );
					this._facaed.RegisterCommand( UICmdStrLib.Terminate_LoadingMark , TerminateMethod );
					this._facaed.SendNotify( UICmdStrLib.Init_LoadingMarkCatch );
				break;*/
			}
		}
	}

}