package strLib.proxyStr
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 字串彙整
	 */
	public class ArchivesStr
	{
		
		public static const BATTLEIMAGING_VIEW:String = "BattleimagingView";//view Register
		public static const BATTLEIMAGING_SYSTEM:String = "battleimagingSystem";//proxy Register
		public static const BATTLEIMAGING_INIT_BACK:String = "battleimagingInitBack";//proxy battlefieldInit data ready
		public static const BATTLEIMAGING_DATA_READY:String = "battleimagingDataReady";//proxy battleReport already loaded
		public static const BATTLEIMAGING_BRIDGE:String = "battleimagingBridge";// v/p talking command
		public static const BATTLEIMAGING_VIEW_PREPARE:String = "battleimagingViewPrepare";
		public static const BATTLEIMAGING_VIEW_START:String = "battleimagingViewStart";
		public static const BATTLEIMAGING_VIEW_END:String = "battleimagingViewEnd";
		public static const BATTLEIMAGING_VIEW_FIGHT:String = "battleimagingViewFight";
		public static const BATTLEIMAGING_VIEW_STEPS:String = "battleimagingViewSteps";
		public static const BATTLEIMAGING_VIEW_ROUNDS:String = "battleimagingViewRounds";
		public static const BATTLEIMAGING_VIEW_SHOWEFFECT:String = "battleimagingViewShowEffect";
		public static const BATTLEIMAGING_VIEW_SHOWMISS:String = "battleimagingViewShowMiss";
		public static const BATTLEIMAGING_VIEW_DONEEFFECT:String = "battleimagingViewDoneeffect";
		public static const BATTLEIMAGING_VIEW_CHANGEEFFECT:String = "battleimagingViewChangeeffect";
		public static const BATTLEIMAGING_VIEW_STEPSFIN:String = "battleimagingViewStepfin";
		public static const BATTLEIMAGING_VIEW_OLDEAD:String = "battleimagingViewOldead";
		public static const BATTLEIMAGING_VIEW_LOG:String = "battleimagingViewLog";
		public static const BATTLEIMAGING_VIEW_DESTROY:String = "battleimagingViewDestroy";
		
		public static const TEAM_MONSTER_VIEW:String = "teamMonsterView";//team monster view register
		public static const TEAM_SHOW_VIEW:String = "teamShowView";//team show view register
		public static const TEAM_EDIT_VIEW:String = "teamEditView";//team edit view register
		public static const TEAM_DRAGDOWN_MONSTER:String = "teamDragdownMonster";//down monsterBoard
		public static const TEAM_DRAGDOWN_BOX:String = "teamDragdownBox";//down headBoxArea
		public static const TEAM_DRAGUP_TOBOX:String = "teamDragUpTobox";//up on headBoxArea
		public static const TEAM_EDIT_CHANGE:String = "teamEditChange";//change team member with edit
		
		public static const SELECTLIST_VIEW_CHOOSE:String = "selectlistViewChoose";//下拉清單工具選擇時發送點選名稱通知
		
		public static const PVP_SYSTEM:String = "pvpSystem";//pvp proxy
		public static const PVP_SYSTEM_INIT:String = "pvpSystemInit";//初始完成
		public static const PVP_SYSTEM_RANKUPDATE:String = "pvpSystemRankUpdate";//清單更新
		public static const PVP_SYSTEM_FIGHTBACK:String = "pvpSystemFightBack";//戰果顯示
		//public static const PVP_SYSTEM_DAYVARY:String = "pvpSystemDayVary";//每日刷新項目
		public static const PVP_SYSTEM_REWARD:String = "pvpSystemReward";//結算名次獎勵
		public static const PVP_CREW_EDIT:String = "pvpCrewEdit";//PVP開啟編輯隊伍時需要的編輯完成通知訊號
		
		
		public static const CREW_DEFAULT_SHOW:String = "crewDefaultShow";//crew default view show
		public static const CREW_DEFAULT_CHANGE:String = "crewDefaultChange";//crew default btn click
		public static const CREW_DEFAULT_REMOVE:String = "crewDefaultRemove";//crew default close
		public static const CREW_SYSTEM:String = "crewSystem";//crew Proxy
		public static const CREW_READY:String = "crewReady";//crew data ready
		public static const CREW_DEFAULT_VIEW:String = "crewDefaultView";//crew default View
		public static const CREW_BOARD_VIEW:String = "crewBoardView";//crew default View
		public static const CREW_EDIT_SHOW:String = "crewEditShow";//crew edit view
		public static const CREW_EDIT_REMOVE:String = "crewEditRemove";//crew edit view close
		public static const CREW_EDIT_CONFIRM:String = "crewEditConfirm";//crew edit view
		public static const CREW_NEW_BACK:String = "crewNewBack";//crew new troop server id back
		public static const CREW_INFO_NOTIFY:String = "crewInfoNotify";//crew info notify
		public static const CREW_TIPS_NOTIFY:String = "crewTipsNotify";//crew tips notify
		
		public static const PVP_SHOP_SYSTEM:String = "pvpShopSystem";//pvp shop proxy
		public static const PVP_SHOP_READY:String = "pvpShopReady";//pvp shop goods data ready
		public static const PVP_SHOP_DEAL:String = "pvpShopDeal";//pvp shop goods deal
		
		
	}
	
}