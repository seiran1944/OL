package MVCprojectOL.ControllOL.PVPCtrl 
{
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.BattleImaging.BattleImagingProxy;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.PvpSystem.PvpSystemProxy;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.TipsInfoProxy;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleResult;
	import MVCprojectOL.ModelOL.Vo.Pvp.PvpRankingUpdate;
	import MVCprojectOL.ViewOL.BattleView.BattleViewCtrl;
	import MVCprojectOL.ViewOL.PVPView.PVPViewCtrl;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ArchivesStr;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewNameLib;
	/**
	 * ...
	 * @author brook
	 */
	public class CatchPVPControl extends CatchCommands 
	{
		private var _SourceProxy:SourceProxy;
		private var _PVPViewCtrl:PVPViewCtrl;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClassList:Vector.<String> = new < String >  [ "BgB", "Title", "EdgeBg", "ExplainBtn", "CloseBtn", "CheckBtn", "PageBtnS"
																						, "ReportBg" , "MapFram", "Box", "PitBg", "CrewBox", "PVPMap", "DemonAvatar", "Paper", "BgM", "TitleBtn","Property"];
		private var _GlobalClasses:Object;
		
		private var _schID:String;
		
		private function PVPCore():void
		{
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._GlobalClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClassList );
				trace("公用素材OK !!");
				this.StartPVP();
			}else {
				//若公用素材還沒有準備好 代表主程序未初始完畢  則發出終結指令終結這個command
				trace("公用素材不OK !!");
				this.TerminateThis();
			}
		}
		
		private function TerminateThis():void 
		{
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_PVP );
			
			this._SourceProxy = null;
			this._GlobalClasses = null;
			this._PVPViewCtrl = null;
			
			this.SendNotify( UICmdStrLib.Terminate_PVP );
		}
		
		private function StartPVP():void 
		{
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._PVPViewCtrl = new PVPViewCtrl ( ViewNameLib.View_PVP , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._PVPViewCtrl );//註冊ViewCtrl
			
			this._PVPViewCtrl.AddElement(this._GlobalClasses);
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) {
				case UICmdStrLib.Init_PVPCatch:
				    this.PVPCore();
				break;
				case UICmdStrLib.GetPlayerData:
				    PvpSystemProxy.GetInstance().GetPvpInitData();
				break;
				case UICmdStrLib.GetTeam:
				    PvpSystemProxy.GetInstance().StartCrewEditing();
				break;
				case UICmdStrLib.GoFight:
					//trace(_obj.GetClass()._Guid,"@@@@@");
					var _Num:int = PvpSystemProxy.GetInstance().StartFighting(_obj.GetClass()._Guid);
					//trace(_Num,"@@@@");
					(_Num == 4 || _Num == 5)?this._PVPViewCtrl.AddChallengeBtn(_Num, _Num):this._PVPViewCtrl.AddChallengeBtn(_Num, 0);
				break;
				case UICmdStrLib.Recall:
				    BattleImagingProxy.GetInstance().ReadyToImaging(_obj.GetClass()._Guid);
				break;
				case UICmdStrLib.GetTimeLine:
				   this._PVPViewCtrl.AddTimeLine(TimeLineProxy(this._facaed.GetProxy(ProxyPVEStrList.TIMELINE_PROXY)).GetAllLine("pvp"));
				break;
				case UICmdStrLib.SetTimeBar:
					this._schID = _obj.GetClass()._schID;
					var _starTime:uint = ServerTimework.GetInstance().ServerTime;
					var _SendTips:SendTips;
						"Building", 
						_SendTips = new SendTips(
						"pvp", 
						ProxyPVEStrList.TIP_TIMERBAR,
						_starTime,
						_obj.GetClass()._finishTime,
						_obj.GetClass()._needTime,
						10,
						140,
						130
						);
					this._PVPViewCtrl.AddTimeBar(TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).GetTips(ProxyPVEStrList.TIP_TIMERBAR, _SendTips));
				break;
				case UICmdStrLib.Reward:
				   PvpSystemProxy.GetInstance().ReceiveReward();
				   this._PVPViewCtrl.RemoveDrop();
				break;
				
				case ProxyPVEStrList.TIMELINE_SCHID_COMPLETE :
					if (this._schID == _obj.GetClass()._schid) this._PVPViewCtrl.RemoveTimeBar();
				break;
				
				case ArchivesStr.PVP_SYSTEM_INIT:
					// _fightable : -1 = 輸入type錯誤 , 0 = 閒置可出征 , 1 = 疲勞 , 2 = 學習中 , 3 = 血量不足   ,   4 = 可用出擊次數不足  ,  5 = PVP戰敗系統冷卻中
					var _Number:int = _obj.GetClass()._fightable;
					(_Number == 4 || _Number == 5)?this._PVPViewCtrl.AddChallengeBtn(_Number, _Number):this._PVPViewCtrl.AddChallengeBtn(_Number, 0);
					this._PVPViewCtrl.AddRankBoard(_obj.GetClass()._initData._rankingData._aryRankBoard);
					this._PVPViewCtrl.AddMyTeamData(PvpRankingUpdate(_obj.GetClass()._initData._rankingData).GetUserData(), PlayerDataCenter.PlayerHonor, PlayerDataCenter.PlayerHonorMax, _obj.GetClass()._initData._fightLimit, _obj.GetClass()._initData._fightTimes);
					this._PVPViewCtrl.AddDrop(_obj.GetClass()._aryDrop);
					//trace("@@@@");
				break;
				case ArchivesStr.PVP_CREW_EDIT:
					var _MyTeam:Object = PvpSystemProxy.GetInstance().GetPvpCrewDisplay();
					this._PVPViewCtrl.AddMyTeam(_MyTeam);
				break;
				case ArchivesStr.PVP_SYSTEM_RANKUPDATE:
					//>>_fightStop :戰勝 與 資料不符合狀態下為false  /  戰敗時為true
					this._PVPViewCtrl.UpDataRank(_obj.GetClass()._fightStop, _obj.GetClass()._needCD, _obj.GetClass()._fightTimes, _obj.GetClass()._rankingUpdate._aryRankBoard, PvpRankingUpdate(_obj.GetClass()._rankingUpdate).GetUserData(), PlayerDataCenter.PlayerHonor);
					//trace("@@@@");
				break;
				case ArchivesStr.PVP_SYSTEM_FIGHTBACK:
					//var _DataObj:Object = _obj.GetClass();
					this._PVPViewCtrl.AddReport(_obj.GetClass() as BattleResult);
					//trace("@@@@@");
				break;
				
				case UICmdStrLib.UpDataPlayerHonor:
					this._PVPViewCtrl.UpDataPlayerHonor(_obj.GetClass() as int);
				break;
				case UICmdStrLib.onRemoveALL:
					this._PVPViewCtrl.RemoveReport();
				break;
				case UICmdStrLib.RemoveALL:
					//this._PVPViewCtrl.StopTimeBar();
					this.TerminateThis();
					this.SendNotify( ViewSystem_BuildCommands.MAINVIEW_CREAT );
				break;
				case ProxyPVEStrList.TIP_CLOSESYS :
					if (this._facaed.GetRegisterViewCtrl(ArchivesStr.BATTLEIMAGING_VIEW) != null) BattleViewCtrl(this._facaed.GetRegisterViewCtrl(ArchivesStr.BATTLEIMAGING_VIEW)).ShutDownImmediately();
					this.TerminateThis();
				break;
			}
		}
		
		override public function GetListRegisterCommands():Array {
			return [UICmdStrLib.Init_PVPCatch,
					UICmdStrLib.RemoveALL,
					UICmdStrLib.GetPlayerData,
					UICmdStrLib.GetTeam,
					UICmdStrLib.GoFight,
					UICmdStrLib.onRemoveALL,
					UICmdStrLib.Recall,
					UICmdStrLib.GetTimeLine,
					UICmdStrLib.SetTimeBar,
					UICmdStrLib.Reward,
					ArchivesStr.PVP_SYSTEM_INIT,
					ArchivesStr.PVP_CREW_EDIT,
					ArchivesStr.PVP_SYSTEM_RANKUPDATE,
					ArchivesStr.PVP_SYSTEM_FIGHTBACK,
					ProxyPVEStrList.TIMELINE_SCHID_COMPLETE,
					UICmdStrLib.UpDataPlayerHonor,
					ProxyPVEStrList.TIP_CLOSESYS
			       ];
		}
		
	}
}