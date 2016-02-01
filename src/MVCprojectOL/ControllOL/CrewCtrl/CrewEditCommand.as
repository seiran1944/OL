package MVCprojectOL.ControllOL.CrewCtrl
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.CrewModel.CrewProxy;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import MVCprojectOL.ModelOL.TipsCenter.TipsLab.TipsDataLab;
	import MVCprojectOL.ModelOL.Troop.TroopProxy;
	import MVCprojectOL.ModelOL.Vo.Tip;
	import MVCprojectOL.ViewOL.CrewView.EditBoard.TeamEditorView;
	import MVCprojectOL.ViewOL.CrewView.MonsterMixed.TeamMonsterView;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.TeamUI.HeadDragTool;
	import MVCprojectOL.ViewOL.TeamUI.TeamWallPlugin;
	import strLib.proxyStr.ArchivesStr;
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
	public class CrewEditCommand extends Commands
	{
		
		private const TEAM_KEY:String = "SysUI_GroupTeam";//GUI00003_ANI
		private const COMMON_KEY:String = "SysUI_All";//GUI00002_ANI
		private var _vecTeam:Vector.<String> = new <String>["EditAdorn"];// new add >> editor
		private var _vecCommon:Vector.<String> = new < String > ["bg1", "sortBtn", "pageBtnM", "changeBtn", "bgBtn", "pageBtnN", "exitBtn", "olBoard", "DemonState"//原先的使用元件
		, "TipBtn", "TipBox", "Property", "Box" , "Title" , "BgB" , "BgM" , "Tab" , "ExplainBtn", "PageBtnS", "CloseBtn", "OptionsBg", "MonsterBg", "TitleBtn", "ProfessionBg", "SortBtn", "TextBg","EdgeBg","CrewBox","CheckBtn","Job"];//新增的UI區塊測試
		//20130610
		private var _aryUiStr:Array = ["TEAM_TIP_TITLE","BTN_TEAM_TIP_SURE","BTN_TEAM_TIP_RESET","TEAM_TIP_INTRO2"];
		
		//SendNotify(ArchivesStr.CREW_EDIT_SHOW, { _num : this._num , _troop : this._currentTroop } );
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			//trace("<<<<執行組隊UI起始COMMAND>>>>");
			
			//初始怪物資料素材模組
			var monDp:MonsterDisplayProxy = MonsterDisplayProxy.GetInstance();
			var vecMonster:Vector.<MonsterDisplay> = monDp.GetMonsterDisplayList();
			//20130606  若無能選擇的怪物編輯 則不做UI開啟動作 只做訊息提示
			if (!(CrewProxy(this._facaed.GetProxy(ArchivesStr.CREW_SYSTEM)).CheckPureCrew(_obj.GetClass()._troop._guid, vecMonster))) {
				this.SendNotify(ArchivesStr.CREW_INFO_NOTIFY, { _active : "OPEN" , _info : "沒有可以編輯的惡魔" , _x : 50 , _y : 100 , _btnNum : 1 } );
				return ;
			}
			
			//UiStr prepare 130610
			var vecUiStr:Vector.<Tip> = TipsDataLab.GetTipsData().GetTipsGroup(this._aryUiStr);
			var leng:int = vecUiStr.length;
			var dicUiStr:Dictionary = new Dictionary(true);
			for (var i:int = 0; i < leng; i++) 
			{
				dicUiStr[vecUiStr[i]._keyVaule] = vecUiStr[i]._tips;
			}
			
			
			//UI基本素材已經確認preload complete 的狀態下
			var sTool:SourceProxy = this._facaed.GetProxy(CommandsStrLad.SourceSystem) as SourceProxy;
			var objCommon:Object = sTool.GetMaterialSWP(PlayerDataCenter.GetInitUiKey(this.COMMON_KEY)[0], this._vecCommon);
			var objTeam:Object = sTool.GetMaterialSWP(PlayerDataCenter.GetInitUiKey(this.TEAM_KEY)[0], this._vecTeam);
			objTeam.Loading = sTool.GetLoadingMark();
			
			//20130521 怪物清單的屬性圖示改為BitmapData
			objTeam.PropertyImages = sTool.GetMovieClipHandler(new objCommon.Property(), false, "PropertyImages");
			
			for (var name:String in objCommon)
			{
				objTeam[name] = objCommon[name];
				//trace("checkCOmbine", name, objTeam[name]);
			}
			
			
			//統一層
			var spContainer:Sprite = new Sprite();
			ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameSystemView).addChild(spContainer);
			
			
			//130327新增怪物嵌入模組
			
			var monsterView:TeamMonsterView = new TeamMonsterView(ArchivesStr.TEAM_MONSTER_VIEW, spContainer);
			var spEditConter:Sprite = new Sprite();
			
			var editView:TeamEditorView = new TeamEditorView(ArchivesStr.TEAM_EDIT_VIEW, spEditConter,_obj.GetClass()._num);
			
			
			monsterView.AllMonsterListInit(vecMonster);//先建立當前全怪物清單
			
			//做非本隊伍不能選取的怪物篩選
			CrewProxy(this._facaed.GetProxy(ArchivesStr.CREW_SYSTEM)).PureCrewSorting(_obj.GetClass()._troop._guid, vecMonster);
			
			monsterView.AddElement("Team",vecMonster , objTeam);
			monsterView.MonDsPx = monDp;
			editView.MonDsPx = monDp;
			editView.SetBoxPlace(new Point(37, 60), 7, 2);
			editView.InSource(objTeam,dicUiStr, true);
			editView.InitTeamGroup(_obj.GetClass()._troop);//{ _num : this._num , _troop : this._currentTroop }
			
			//Show Image
			monsterView.CurrentTroop = _obj.GetClass()._troop;
			monsterView.AssemblyPanel();//起始怪物區塊運作//會跑到CtrlPage()會做手指頭的變更處理運行前要有導入Troop
			
			//配置EDITboardLayer  (取monsterPanel內的配置層做組裝才有同步縮放動作)
			Sprite(monsterView.GetViewConter().getChildByName("Panel")).addChild(spEditConter);
			monsterView.EditBoardView = editView;//dragTool need parent conter
			
			//Register
			this._facaed.RegisterViewCtrl(monsterView);
			this._facaed.RegisterViewCtrl(editView);
			this._facaed.RegisterProxy(monDp);
			this._facaed.RegisterCommand("", CatchTeamCombine);
			
			
			
		}
		
		
		
		
	}
	
}