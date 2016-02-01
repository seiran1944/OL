package MVCprojectOL.ControllOL.Explore.WorldJourney {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import MVCprojectOL.ControllOL.Explore.InitExploreJourney;
	import MVCprojectOL.ControllOL.Explore.Journey.CatchJourneyControl;
	import MVCprojectOL.ControllOL.SoundControlCenter.SoundEventStrLib;
	import MVCprojectOL.ModelOL.CrewModel.CrewProxy;
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	import MVCprojectOL.ModelOL.Explore.Data.WorldJourneyDataCenter;
	import MVCprojectOL.ModelOL.Explore.Journey.ExploreAdventure;
	import MVCprojectOL.ModelOL.Explore.Journey.ExploreAdventurePreparing;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.TipsInfoProxy;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import strLib.vewStr.ViewStrLib;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	//import MVCprojectOL.ModelOL.ShowSideSys.TipsInfoProxy;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	import MVCprojectOL.ModelOL.Vo.Buildschedule;
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreArea;
	import MVCprojectOL.ViewOL.ExploreView.WorldJourney.WorldJourneyViewCtrl;
	import strLib.commandStr.UICmdStrLib;
	import strLib.proxyStr.ArchivesStr;
	import strLib.proxyStr.ProxyPVEStrList;
	//import MVCprojectOL.ViewOL.ExploreView.WorldJourney.WorldJourneyViewCtrl;
	import MVCprojectOL.ViewOL.TeamUI.TeamViewCtrl;
	import strLib.commandStr.TeamCmdStr;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.vewStr.ViewNameLib;
	
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;

	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.GameSystemStrLib;

	import strLib.proxyStr.ProxyNameLib;
	
	
	/*import strLib.vewStr.ViewStrLib;
	import strLib.vewStr.ViewNameLib;
	
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.MainView.MainViewBGSystem;
	import MVCprojectOL.ViewOL.MonsterCage.WallBtn;*/
	
	import ProjectOLFacade;
	
	import strLib.commandStr.WorldJourneyStrLib;
	import MVCprojectOL.ModelOL.Explore.WorldJourney.WorldJourneyProxy;
	
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	
	import MVCprojectOL.ModelOL.Explore.Mission.WorldJourneyMissionProxy;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.23.11.09
	 */
	public class CatchWorldJourneyControl extends CatchCommands {
		
		
		private var _SourceProxy:SourceProxy;
		private var _WorldJourneyProxy:WorldJourneyProxy;
		private var _WorldJourneyViewCtrl:WorldJourneyViewCtrl;
		
		private var _ExploreDataCenter:ExploreDataCenter;
		private var _WorldJourneyDataCenter:WorldJourneyDataCenter;
		
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _WorldJourneyComponentPackKey:String = "GUI00014_ANI";//魔神殿 素材包KEY碼
		
		private const _GlobalComponentClassList:Vector.<String> = new < String > [ "bg1" , "pageBtnS" , "pageBtnM" , "sortBtn" , "changeBtn" , "bgBtn", "pageBtnN", "exitBtn", "TipBtn", "TipBox", "olBoard", 
			"Property", "Box" , "Title" , "BgB" , "BgM" , "Tab" , "ExplainBtn", "PageBtnS", "CloseBtn", "OptionsBg", "MonsterBg", "TitleBtn", "ProfessionBg", "SortBtn", "TextBg", "DetailBoard", "SkilletBg", "Inform", "MakeBtn", "Fatigue", "Hourglass", "CheckBtn", "BgD", "ReportBg", "EdgeBg", "ContentBg", "BgL", "Wood", "Ore", "Fur", "Diamond",
			"DemonAvatar", "Paper", "EvolutionBg", "MonsterBox", "PitBg", "MapFram" , "StarBtn", "FightBtn" , "RouteDisable" , "RouteEnable" ];
		private const _WorldJourneyComponentClassList:Vector.<String> = new < String > [ "WorldJourneyView", "MajidanView", "Blank", "Index","DevilS","DevilM","CampfireS","CampfireM","ChestS","ChestM","Instruction","Inform"];
		
		private var _GlobalClasses:Object;
		private var _WorldJourneyClasses:Object;
		
		private var _currentExploreAreaList:Dictionary;
		
		private var _CrewProxy:CrewProxy = CrewProxy.GetInstance();
		
		//private var _ExploreAdventurePreparing:ExploreAdventurePreparing = ExploreAdventurePreparing.GetInstance();
		
		//private var _TimeLineProxy:TimeLineProxy = FacadeCenter.GetFacadeCenter().GetProxy( ProxyPVEStrList.TIMELINE_PROXY ) as TimeLineProxy;//TimeLineProxy   IfProxy
		private var _WorldJourneyMissionProxy:WorldJourneyMissionProxy = WorldJourneyMissionProxy.GetInstance();
		
		public function CatchWorldJourneyControl() {
			trace( "WorldJourney Controller is on duty !! Waiting for command.------" );
		}
		
		
		private function Ignite():void {
			
			//this._facaed.RegisterCommand( WorldJourneyStrLib.Terminate_WorldJourney , Terminate_WorldJourney );//註冊終結事件
			
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._WorldJourneyProxy = WorldJourneyProxy.GetInstance();
				this._WorldJourneyProxy.init( this._WorldJourneyComponentPackKey );
				
				this._ExploreDataCenter = ExploreDataCenter.GetInstance();
				this._WorldJourneyDataCenter = WorldJourneyDataCenter.GetInstance();
				
				/*this._facaed.RegisterProxy( this._WorldJourneyProxy );
				
				this._WorldJourneyProxy.init( this._WorldJourneyComponentPackKey );*/
				
				//this._WorldJourneyProxy.FlashExploreAreas();//_WorldJourneyProxy init之後自己啟動
				
				this._GlobalClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClassList );
				
				this._SourceProxy.PreloadMaterial( "GUI00002_SND" );//for music test
				trace("公用素材OK !!");
			}else {
				//若公用素材還沒有準備好 代表主程序未初始完畢  則發出終結指令終結這個command
				trace("公用素材不OK !!");
				this.TerminateThis();
			}
			
			
			
		}
		
		
		private function initWorldJourney():void {
			trace( "開始初始世界地圖" );
			this._WorldJourneyClasses = this._SourceProxy.GetMaterialSWP( this._WorldJourneyComponentPackKey , this._WorldJourneyComponentClassList );
			
			this._ExploreDataCenter._GlobalClasses = this._GlobalClasses;//將素材資料存回資料中心
			this._ExploreDataCenter._MajidanClasses = this._WorldJourneyClasses;
			
			/*for (var i:String in this._GlobalClasses ) {
				trace( i , this._GlobalClasses[i] , "---公用元件類" );
			}
			
			for ( i in this._WorldJourneyClasses ) {
				trace( i , this._WorldJourneyClasses[i] , "---魔神殿元件類" );
			}*/
			trace( "開始起始ViewCtrl、相關Proxy與元件----------" );
			/*
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			
			this._WorldJourneyViewCtrl = new WorldJourneyViewCtrl ( ViewNameLib.View_WorldJourney , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._WorldJourneyViewCtrl );//註冊溶解所ViewCtrl
			
			this._WorldJourneyViewCtrl.AddElement(this._WorldJourneyClasses, this._GlobalClasses);
			
			this._WorldJourneyViewCtrl.RefreshMapNode( this._currentExploreAreaList );//通知View進行地圖刷新與判斷*/
			
			//this.TerminateThis();
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._WorldJourneyViewCtrl = new WorldJourneyViewCtrl ( ViewNameLib.View_WorldJourney , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._WorldJourneyViewCtrl );//註冊ViewCtrl
			
			this._WorldJourneyViewCtrl.AddElement(this._GlobalClasses);
			
			//this.CheckCrewStatus();//預設組隊狀態 130507
			
			this.SendNotify( SoundEventStrLib.PlayBGM , "GUI00001_SND" );//測試用
		}
		
		private function TerminateThis():void {
			this._WorldJourneyProxy.Terminate();
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_WorldJourney );
			
			this._SourceProxy = null;
			this._ExploreDataCenter = null;
			this._WorldJourneyClasses = null;
			this._WorldJourneyViewCtrl = null;
			
			this._WorldJourneyDataCenter.Terminate();//終止臨時資訊中心的運作
			this._WorldJourneyDataCenter = null;
			
			this._WorldJourneyMissionProxy.Terminate();//終止任務條件偵測中心
			this._WorldJourneyMissionProxy = null;
			
			this._CrewProxy = null;
			
			this._facaed.RemoveCommand( "InitExploreJourney" , InitExploreJourney );
			
			//this._facaed.RemoveCommand( "" , CatchWorldJourneyControl );
			if ( this._facaed.GetCatchCommand( CatchJourneyControl ) != null ) this._facaed.RemoveALLCatchCommands( CatchJourneyControl );
			this._facaed.RemoveALLCatchCommands( CatchWorldJourneyControl );//移除這個控制中心
			//this.SendNotify( WorldJourneyStrLib.End_WorldJourney );
			this.SendNotify( SoundEventStrLib.PlayBGM , "GUI00003_SND" );//測試用
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void {
			
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) {
				
				case ( WorldJourneyStrLib.Init_WorldJourney ) :	
						this.Ignite();
						//trace( "QQQQFDSFSDKPFJOSDPFIOSJFSDIOFJSDFISDJFSD" );
					break;	
					
				//case ( this._WorldJourneyComponentPackKey ) : 
				case ( WorldJourneyStrLib.ComponentsAreReady ) : 
						this.initWorldJourney();//素材回來代表系統可以動了( 載入次序: 1.資料 2.素材 )
					break;
					
				case ( this._WorldJourneyComponentPackKey + "Invalid" ) :	
						trace( this._WorldJourneyComponentPackKey , "載入錯誤   終結WorldJourney----" , this );
						this.TerminateThis();
					break;
					
				//case ( WorldJourneyStrLib.CheckExploreChapterData ) :	//跟SERVER更新章節資料
				case ( ProxyPVEStrList.TIMELINE_SCHIDReady ) :	//當有新排程加入
						this._WorldJourneyProxy.FlashExploreChapters();
					break;
					
				case ( WorldJourneyStrLib.RenewExploreChapter ) :	//跟章節資料已回傳或更新
						this._WorldJourneyViewCtrl != null ? this._WorldJourneyViewCtrl.AddMapData( this._WorldJourneyDataCenter._ExploreChapterDisplayList ) : null;
					break;
					
				case ( WorldJourneyStrLib.CoolDownReady ) :	//當節點CD完畢
						//trace( "更新地圖資訊" );
						//this._currentExploreAreaList = this._ExploreDataCenter.ExploreAreaList as Dictionary;
						//this._WorldJourneyViewCtrl.RefreshMapNode();
						//注意起始狀態
						var _currentTarget:ExploreArea = _obj.GetClass() as ExploreArea;
						var _chapterID:String = this._WorldJourneyDataCenter.LocateChapterID_ByAreaID( _currentTarget._guid );
						this._WorldJourneyViewCtrl != null ? this._WorldJourneyViewCtrl.UpdateTimeBar( _chapterID , _currentTarget ) : null;
						//this._WorldJourneyViewCtrl != null ? this._WorldJourneyViewCtrl.AddMapData( this._WorldJourneyDataCenter._ExploreChapterDisplayList ) : null;
					break;
					
				/*case ( "選擇節點" ) :
						//選擇節點
					break;*/
					
				//case ( "選擇難易度" ) : 
						//選擇難易度    代表已經選擇節點
						/* 1.View將所選難易度數值寫給對應的ExploreArea
						 * 2.View回傳對應的ExploreArea
						 * 3.
						 */
						//this._WorldJourneyDataCenter.currentSelectedExploreArea = _obj.GetClass() as ExploreArea;
						
					//break;
					
				//case ( WorldJourneyStrLib.Difficult ) : //"點擊組隊"
						/* 1.開啟組隊畫面
						   2.
						*/
						//this.SendNotify( TeamCmdStr.TEAM_CMD_SYSTEM , WorldJourneyStrLib.ExploreTeamSelected );//發送開起組隊模組KEY    WorldJourneyStrLib.ExploreTeamSelected = 選擇完畢時發出的COMMAND
					//break;
					
				case ( WorldJourneyStrLib.ExploreTeamSelected ) : 
						//已選擇組隊 開啟探索系統
						/*var _DataPack:Object = _obj.GetClass();
						this._ExploreDataCenter._currentSelectedTeamKey = _DataPack[ "_teamGroup" ];//暫存Team Key
						this._ExploreDataCenter._currentSelectedTeamMember = _DataPack[ "_teamMember" ];//儲存組隊成員 Key 與陣型索引
						trace( this._ExploreDataCenter._currentSelectedTeamKey , "已選擇探索組隊" );
						//this.SendNotify( "開啟探索指令" , _DataPack );
						this.SendNotify( "InitExploreJourney" , _DataPack );*/
						
						this.CheckCrewStatus();//預設組隊狀態 130507
						
					break;
					
				case ( WorldJourneyStrLib.Expedition ) : //點擊出征
						//	1.判斷據點與隊伍狀態   OK=>進行探索  不OK=>跳訊息
						//	2.使節點開始CD
						
						//this.SendNotify( "InitExploreJourney" );//開啟探索系統
						// _obj.GetClass().Guid   _obj.GetClass().Star
						this._WorldJourneyDataCenter.SetSelectedExploreArea( _obj.GetClass().Guid , _obj.GetClass().Star );
						
						var _CrewStatus:int = this.CheckCrewStatus();//(-1 = 輸入type錯誤 , 0 = 閒置可出征 , 1 = 疲勞 , 2 = 學習中)
							//_CrewStatus != 0 ? this.CrewStatusCheckError( _CrewStatus ) : this.SendNotify( "InitExploreJourney" ) ;//預設組隊狀態 130507
							_CrewStatus != 0 ? this.CrewStatusCheckError( _CrewStatus ) : this.WageWar() ;//預設組隊狀態 130507
						//this.SendNotify( "InitExploreJourney" );
						//this.SendNotify( TeamCmdStr.TEAM_CMD_SYSTEM , WorldJourneyStrLib.ExploreTeamSelected );//發送開起組隊模組KEY    WorldJourneyStrLib.ExploreTeamSelected = 選擇完畢時發出的COMMAND
					break;
					
				
				case ( WorldJourneyStrLib.Team ) : //點選編輯組隊
						var _CrewNotify:Object =  { _notifyString : WorldJourneyStrLib.ExploreTeamSelected ,
													_type : 1
													}
						this.SendNotify( ArchivesStr.CREW_DEFAULT_SHOW , _CrewNotify );//發送開起組隊模組KEY    WorldJourneyStrLib.ExploreTeamSelected = 選擇完畢時發出的COMMAND
					break;
					
				//================================================================================================Other views
				case UICmdStrLib.MapData : //素材都準備好後發送
						//加入地圖資訊
						this._WorldJourneyViewCtrl.AddMapData(this._WorldJourneyDataCenter._ExploreChapterDisplayList);
					break;
					
				case UICmdStrLib.CtrlPage : 
						this._WorldJourneyViewCtrl.CtrlPage(_obj.GetClass().CtrlPageNum, _obj.GetClass().CtrlBoolean);
					break;
					
				case UICmdStrLib.RemoveALL :	
				//case WorldJourneyStrLib.Exit :
				//case ( TeamViewCtrl.TEAM_DESTROY ) :	//當關閉組隊時也同時移除
						this._WorldJourneyViewCtrl.RemoveTimeBar();
						this.TerminateThis();
						this.SendNotify( ViewSystem_BuildCommands.MAINVIEW_CREAT );
					break;
				case ProxyPVEStrList.TIP_CLOSESYS :
						this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SWICH, { _btnName:"EXIT" } );
						this._WorldJourneyViewCtrl.RemoveTimeBar();
						this.TerminateThis();
					break;
					
				case UICmdStrLib.SetTimeBar : 
						var _starTime:uint = ServerTimework.GetInstance().ServerTime;
						var _DataObj:Object = _obj.GetClass();
						var _SendTips:SendTips;
							_SendTips = new SendTips(
											"Building", 
											ProxyPVEStrList.TIP_TIMERBAR,
											_starTime,
											_DataObj._finishTime,
											_DataObj._needTime,
											-1,
											110,
											100
										);
						this._WorldJourneyViewCtrl.AddTimeBar(TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY)).GetTips(ProxyPVEStrList.TIP_TIMERBAR, _SendTips), _DataObj._FightBtn);
					break;	
					
				//=========================================================================================END====Other views
					
				case WorldJourneyStrLib.Exit ://探索結束  回到世界地圖
						//this.TerminateThis();
						//setTimeout( this.SendNotify , 1000 , WorldJourneyStrLib.InitWorldJourneyCommand );
						this._WorldJourneyViewCtrl.EnablePanel();
						var _Buildschedule:Buildschedule = this._ExploreDataCenter._currentRouteNode != null ? this._ExploreDataCenter._currentRouteNode._buildSchedule as Buildschedule : null;
						if ( _Buildschedule != null ) TimeLineObject.GetTimeLineObject().AddVoTimeLine(  [ _Buildschedule ]  );//加入CD排程
						
						this._WorldJourneyMissionProxy.goCheckMission();//確認任務條件
						//this._WorldJourneyViewCtrl.AddMapData( this._WorldJourneyDataCenter._ExploreChapterDisplayList );
						
						//this._ExploreDataCenter.Terminate();
						//this._ExploreDataCenter = ExploreDataCenter.GetInstance();
					break;
					
				/*case "當CD排程回來" :
						//_obj.GetClass().targetID;
					break;*/
					
				
				default:
					break;
			}
		}
		
		private function WageWar():void {
			this._WorldJourneyViewCtrl.DisablePanel();
			this.SendNotify( "InitExploreJourney" );
		}
		
		private function CheckCrewStatus():int {
			//type>>(0 = PVP , 1 = PVE)
			
			this._ExploreDataCenter._currentSelectedTeamKey = this._CrewProxy.GetDefaultCrewID( 1 );//暫存Team Key
			this._ExploreDataCenter._currentSelectedTeamMember = this._CrewProxy.GetDefaultCrewMember( 1 );//儲存組隊成員 Key 與陣型索引
			return this._CrewProxy.CrewSallyCheck( 1 );//(-1 = 輸入type錯誤 , 0 = 閒置可出征 , 1 = 疲勞 , 2 = 學習中)
			//this._ExploreAdventurePreparing
		}
		
		private function CrewStatusCheckError( _InputCrewStatus:int ):void {
			//(-1 = 輸入type錯誤 , 0 = 閒置可出征 , 1 = 疲勞 , 2 = 學習中)
			trace( "組隊無法出擊 : " , _InputCrewStatus );
			this._WorldJourneyViewCtrl.AddErrorInfor(_InputCrewStatus);
		}
		
		override public function GetListRegisterCommands():Array {
			return [ WorldJourneyStrLib.Init_WorldJourney , 
					 //this._WorldJourneyComponentPackKey , //場景所需的素材都準備完畢
					WorldJourneyStrLib.ComponentsAreReady , //場景所需的素材都準備完畢
					 (this._WorldJourneyComponentPackKey + "Invalid") , //場景所需的素材載入失敗
					 WorldJourneyStrLib.CheckExploreChapterData,//執行更新章節資料
					 WorldJourneyStrLib.RenewExploreChapter,//章節資料已更新
					 UICmdStrLib.RemoveALL ,
					 UICmdStrLib.CtrlPage ,
					 UICmdStrLib.MapData ,
					 UICmdStrLib.SetTimeBar,
					 TeamViewCtrl.TEAM_DESTROY ,
					 WorldJourneyStrLib.ExploreTeamSelected ,
					 WorldJourneyStrLib.Expedition,
					 WorldJourneyStrLib.Exit,
					 WorldJourneyStrLib.Team,
					 WorldJourneyStrLib.CoolDownReady,//CD排程已結束
					 ProxyPVEStrList.TIMELINE_SCHIDReady,
					 ProxyPVEStrList.TIP_CLOSESYS
					];
		}
		
	}//end class
}//end package