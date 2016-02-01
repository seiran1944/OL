package MVCprojectOL.ControllOL.Troops
{
	import flash.display.Sprite;
	import flash.events.Event;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import MVCprojectOL.ModelOL.Troop.TroopProxy;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.TeamUI.TeamWallPlugin;
	import strLib.vewStr.ViewStrLib;
	//import MVCprojectOL.ViewOL.RunwayModule.SlidingControl;
	import MVCprojectOL.ViewOL.TeamUI.MonsterShift;
	import MVCprojectOL.ViewOL.TeamUI.TeamBasic;
	import MVCprojectOL.ViewOL.TeamUI.TeamEditWork;
	import MVCprojectOL.ViewOL.TeamUI.TeamShift;
	import MVCprojectOL.ViewOL.TeamUI.TeamShowWork;
	import MVCprojectOL.ViewOL.TeamUI.TeamViewCtrl;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.TeamCmdStr;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.TroopStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.12.28.17.05
		@documentation to use this Class....
	 */
	public class TeamUICommand extends Commands
	{
		
		private const TEAM_KEY:String = "SysUI_GroupTeam";//GUI00003_ANI
		private const COMMON_KEY:String = "SysUI_All";//GUI00002_ANI
		private var _aryTeam:Vector.<String> = new <String>["editBoard", "team"];
		private var _aryCommon:Vector.<String> = new <String>["bg1","sortBtn","pageBtnM","changeBtn","bgBtn","pageBtnN","exitBtn","olBoard","DemonState"];
		
		//視狀況而定是否需要由外部傳送需要發送的字串通知內容*****
		//開啟UI時SENDNOTIFY >> (TeamCmdStr.TEAM_CMD_SYSTEM , "訊號字串名稱") 參數帶想收到的NOTIFY訊號 >> 內部會轉換MODE>> 1為挑選隊伍的模式 , 0為編輯模式
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			//trace("<<<<執行組隊UI起始COMMAND>>>>");
			
			//UI基本素材已經確認preload complete 的狀態下
			var sTool:SourceProxy = this._facaed.GetProxy(CommandsStrLad.SourceSystem) as SourceProxy;
			var objCommon:Object = sTool.GetMaterialSWP(PlayerDataCenter.GetInitUiKey(this.COMMON_KEY)[0], this._aryCommon);
			var objTeam:Object = sTool.GetMaterialSWP(PlayerDataCenter.GetInitUiKey(this.TEAM_KEY)[0], this._aryTeam);
			
			
			for (var name:String in objCommon)
			{
				objTeam[name] = objCommon[name];
				//trace("checkCOmbine", name, objTeam[name]);
			}
			
			this._facaed.RegisterCommand(TeamCmdStr.TEAM_CMD_PROCESS, TeamProcessCommand);//talking
			this._facaed.RegisterCommand(TroopStr.TROOP_READY, TroopDataCommand);//start
			//Wall build (EXIT)
			var wallLayer:MainSystemPanel = this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main) as MainSystemPanel;
			wallLayer.AddClass(TeamWallPlugin);
			wallLayer.AddSingleSource("", objTeam);
			
			//統一層
			var spContainer:Sprite = new Sprite();
			ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).addChild(spContainer);
			//同時導入MODE狀態
			var teamView:TeamViewCtrl = new TeamViewCtrl(TeamViewCtrl.TEAM_VIEWCTRL,spContainer ,_obj.GetClass()==null ? "" : String(_obj.GetClass()));
			teamView.DrawBackGround(new objTeam[this._aryCommon[0]]());
			this._facaed.RegisterViewCtrl(teamView);
			var aryWork:Array = [ new TeamShowWork() , new TeamEditWork(), new TeamShift(), new MonsterShift()];
			teamView.InitEnvironment(aryWork);
			
			var leng:int = aryWork.length;
			for (var i:int = 0; i < leng; i++)
			{
				aryWork[i].AddSource(objTeam);
			}
			
			//初始怪物資料素材模組
			this._facaed.RegisterProxy(MonsterDisplayProxy.GetInstance());
			
			//初始面板與loading
			teamView.LoadingPreview(sTool.GetLoadingMark());
			
			//初始組隊資料
			TroopProxy(this._facaed.GetProxy(TroopStr.TROOP_SYSTEM)).ConnectData();
			
			
			
		}
		
		
		
		
	}
	
}