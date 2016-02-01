package MVCprojectOL.ControllOL.CrewCtrl
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.CrewModel.CrewProxy;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import MVCprojectOL.ModelOL.TipsCenter.TipsLab.TipsDataLab;
	import MVCprojectOL.ModelOL.Vo.Tip;
	import MVCprojectOL.ViewOL.CrewView.DefaultBoard.CrewDefaultView;
	import MVCprojectOL.ViewOL.CrewView.EditBoard.TeamShowView;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class CrewDefaultCommand extends Commands
	{
		private const TEAM_KEY:String = "SysUI_GroupTeam";//GUI00003_ANI
		private const COMMON_KEY:String = "SysUI_All";//GUI00002_ANI
		private var _vecCommon:Vector.<String> = new < String > ["Tab", "CheckBtn", "Lamp", "InfoBg", "CrewBox", "CloseBtn", "WallBg","ExplainBtn", "EdgeBg", "Title", "BgB","Job"];
		private var _vecCrew:Vector.<String> = new < String > ["EditNone"];
		//20130610 
		private var _aryUiStr:Array = ["BTN_TEAM_TIP_SET_PVP", "BTN_TEAM_TIP_SET_PVE", "BTN_TEAM_TIP_EDIT", "TEAM_TIP_TITLE", "TEAM_TIP_INTRO1"];
		
		//開啟組隊UI時發送 ArchivesStr.CREW_DEFAULT_SHOW 需要回值則夾帶Object { _notifyString , _type : (0 = PVP , 1 = PVE) }
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			trace("obj", _obj.GetClass());
			//Source Prepare
			var sTool:SourceProxy = this._facaed.GetProxy(CommandsStrLad.SourceSystem) as SourceProxy;
			var objCommon:Object = sTool.GetMaterialSWP(PlayerDataCenter.GetInitUiKey(this.COMMON_KEY)[0], this._vecCommon);
			var objCrew:Object = sTool.GetMaterialSWP(PlayerDataCenter.GetInitUiKey(this.TEAM_KEY)[0], this._vecCrew);
			
			//Str Prepare
			var vecUiStr:Vector.<Tip> = TipsDataLab.GetTipsData().GetTipsGroup(this._aryUiStr);
			var leng:int = vecUiStr.length;
			var dicUiStr:Dictionary = new Dictionary(true);
			for (var i:int = 0; i < leng; i++) 
			{
				dicUiStr[vecUiStr[i]._keyVaule] = vecUiStr[i]._tips;
			}
			
			
			//Lamp
			var aryLamp:Array = sTool.GetMovieClipHandler(new objCommon.Lamp(), false, "Lamp");
			for (i = 0; i < 3; i++) 
			{
				aryLamp[i + 5] = aryLamp[3 - i];
			}
			objCrew.aryLamp = aryLamp;
			
			for (var name:String in objCommon)
			{
				objCrew[name] = objCommon[name];
				//trace("checkCOmbine", name, objTeam[name]);
			}
			
			//統一層
			var spContainer:Sprite = new Sprite();
			spContainer.graphics.beginFill(0, 0);
			spContainer.graphics.drawRect(0, 0, 1000, 700);
			spContainer.graphics.endFill();
			ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).addChild(spContainer);
			
			//InsideCrewDefaultView of TeamMemberShow and simple action
			var vecMon:Vector.<MonsterDisplay> = MonsterDisplayProxy.GetInstance().GetMonsterDisplayList();
			
			var vecTsView:Vector.<TeamShowView> = new Vector.<TeamShowView>(3);
			var tsView:TeamShowView;
			for (i = 0; i < 3; i++) 
			{
				tsView = new TeamShowView(ArchivesStr.CREW_BOARD_VIEW + String(i),new Sprite() ,i);
				tsView.MonDsPx = MonsterDisplayProxy.GetInstance();
				tsView.SetBoxPlace(new Point(40, 105), 7, 2);
				tsView.InSource(objCrew,dicUiStr);
				vecTsView[i] = tsView;
			}
			
			//CrewData init
			var aryTroop:Array = CrewProxy.GetInstance().GetAllTroop();
			var aryDefaultNum:Array = CrewProxy.GetInstance().GetDefaultCrewNum();
			
			//VIewCtrl
			var crewDefault:CrewDefaultView = new CrewDefaultView(ArchivesStr.CREW_DEFAULT_VIEW, spContainer);
			crewDefault.SetNotifyInfo(_obj.GetClass());//空則為Null
			crewDefault.AddSource(objCrew);
			crewDefault.ShowInstance(dicUiStr["TEAM_TIP_TITLE"],dicUiStr["TEAM_TIP_INTRO1"]);//需要的字串標題與說明
			crewDefault.AddBoardMixed(vecTsView);
			crewDefault.SetTroopData(aryTroop,aryDefaultNum);
			
			//Register 
			this._facaed.RegisterProxy(MonsterDisplayProxy.GetInstance());
			this._facaed.RegisterViewCtrl(crewDefault);
			this._facaed.RegisterCommand("", CatchCrewDefault);
			this._facaed.RegisterCommand(ArchivesStr.CREW_EDIT_SHOW, CrewEditCommand);
			this._facaed.RegisterCommand(ArchivesStr.CREW_INFO_NOTIFY, InfoNotifyCmd);//提示訊息
		}
		
		
	}
	
}