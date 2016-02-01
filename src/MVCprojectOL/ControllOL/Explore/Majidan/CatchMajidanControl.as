package MVCprojectOL.ControllOL.Explore.Majidan {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import MVCprojectOL.ControllOL.Explore.InitExploreJourney;
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	import MVCprojectOL.ModelOL.Explore.Journey.ExploreAdventure;
	import MVCprojectOL.ViewOL.ExploreView.Majidan.MajidanViewCtrl;
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
	
	import strLib.commandStr.MajidanStrLib;
	import MVCprojectOL.ModelOL.Explore.Majidan.MajidanProxy;
	
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.03.05.10.58
	 */
	public class CatchMajidanControl extends CatchCommands {
		

		private var _SourceProxy:SourceProxy;
		private var _MajidanProxy:MajidanProxy;
		private var _MajidanViewCtrl:MajidanViewCtrl;
		
		private var _ExploreDataCenter:ExploreDataCenter;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _MajidanComponentPackKey:String = "GUI00014_ANI";//魔神殿 素材包KEY碼
		
		private const _GlobalComponentClassList:Vector.<String> = new < String > [ "bg1" , "pageBtnS" , "pageBtnM" , "sortBtn" , "changeBtn" , "bgBtn", "pageBtnN", "exitBtn", "TipBtn", "TipBox", "olBoard", 
		"Property", "Box" , "Title" , "BgB" , "BgM" , "Tab" , "ExplainBtn", "PageBtnS", "CloseBtn", "OptionsBg", "MonsterBg", "TitleBtn", "ProfessionBg", "SortBtn", "TextBg", "DetailBoard", "SkilletBg", "Inform", "MakeBtn", "Fatigue", "Hourglass", "CheckBtn", "BgD", "ReportBg", "EdgeBg"];
		private const _MajidanComponentClassList:Vector.<String> = new < String > [ "MajidanView", "Blank", "Index","DevilS","DevilM","CampfireS","CampfireM","ChestS","ChestM","Instruction","Inform"];
		
		private var _GlobalClasses:Object;
		private var _MajidanClasses:Object;
		
		private var _currentExploreAreaList:Dictionary;
		
		public function CatchMajidanControl() {
			trace( "Majidan Controller is on duty !! Waiting for command.------" );
		}
		
		
		private function Ignite():void {
			
			//this._facaed.RegisterCommand( MajidanStrLib.Terminate_Majidan , Terminate_Majidan );//註冊終結事件
			
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._MajidanProxy = MajidanProxy.GetInstance();
				this._ExploreDataCenter = ExploreDataCenter.GetInstance();
				
				this._facaed.RegisterProxy( this._MajidanProxy );
				
				this._MajidanProxy.init( this._MajidanComponentPackKey );
				
				//this._MajidanProxy.FlashExploreAreas();//_MajidanProxy init之後自己啟動
				
				this._GlobalClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClassList );
				trace("公用素材OK !!");
			}else {
				//若公用素材還沒有準備好 代表主程序未初始完畢  則發出終結指令終結這個command
				trace("公用素材不OK !!");
				this.TerminateThis();
			}
			
			
			
		}
		
		
		private function initMajidan():void {
			trace( "開始初始魔神殿" );
			this._MajidanClasses = this._SourceProxy.GetMaterialSWP( this._MajidanComponentPackKey , this._MajidanComponentClassList );
			
			this._ExploreDataCenter._GlobalClasses = this._GlobalClasses;//將素材資料存回資料中心
			this._ExploreDataCenter._MajidanClasses = this._MajidanClasses;
			/*for (var i:String in this._GlobalClasses ) {
				trace( i , this._GlobalClasses[i] , "---公用元件類" );
			}
			
			for ( i in this._MajidanClasses ) {
				trace( i , this._MajidanClasses[i] , "---魔神殿元件類" );
			}*/
			trace( "開始起始ViewCtrl、相關Proxy與元件----------" );
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			//var _DisplayConter:Sprite = SimulateActions._SimulateConter;
			this._MajidanViewCtrl = new MajidanViewCtrl ( ViewNameLib.View_Majidan , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._MajidanViewCtrl );//註冊溶解所ViewCtrl
			
			this._MajidanViewCtrl.AddElement(this._MajidanClasses, this._GlobalClasses);
			
			this._MajidanViewCtrl.RefreshMapNode( this._currentExploreAreaList );//通知View進行地圖刷新與判斷
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddClass(AlchemyWallExitBtn);
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddSingleSource("AlchemyWallExitBtn" , this._ComponentClasses);
			
		}
		
		private function TerminateThis():void {
			this._MajidanProxy.Terminate();
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_Majidan );
			
			this._SourceProxy = null;
			this._MajidanClasses = null;
			this._ExploreDataCenter = null;
			/*
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_MonsterCage );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_MonsterDisplayProxy );
			
			this._MonsterDisplayProxy = null;*/
			this._facaed.RegisterCommand( "InitExploreJourney" , InitExploreJourney );
			//this._facaed.RemoveCommand( "" , CatchMajidanControl );
			this._facaed.RemoveALLCatchCommands( CatchMajidanControl );
			this.SendNotify( MajidanStrLib.End_Majidan );
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void {
			
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) {
				
				case ( MajidanStrLib.Init_Majidan ) :
						this.Ignite();
						//trace( "QQQQFDSFSDKPFJOSDPFIOSJFSDIOFJSDFISDJFSD" );
					break;	
					
				case ( this._MajidanComponentPackKey ) :
						this.initMajidan();//素材回來代表系統可以動了( 載入次序: 1.資料 2.素材 )
					break;
					
				case ( this._MajidanComponentPackKey + "Invalid" ) :
						trace( this._MajidanComponentPackKey , "載入錯誤   終結Majidan" );
						this.TerminateThis();
					break;
					
				case ( MajidanStrLib.RenewExploreArea ) :
						trace( "更新地圖資訊" );
						this._currentExploreAreaList = this._ExploreDataCenter.ExploreAreaList as Dictionary;
						//this._MajidanViewCtrl.RefreshMapNode();
					break;
					
				case ( MajidanStrLib.ExploreAreaSelected ) :
						//已選擇區域 進入組隊狀態
						
						this._ExploreDataCenter._currentSelectedAreaKey = _obj.GetClass() as String;//暫存Area Key
						trace( this._ExploreDataCenter._currentSelectedAreaKey , "已選擇探索區域" );
						this.SendNotify( TeamCmdStr.TEAM_CMD_SYSTEM , MajidanStrLib.ExploreTeamSelected );//發送開起組隊模組KEY
						
					break;
					
				case ( MajidanStrLib.ExploreTeamSelected ) :
						//已選擇組隊 開啟探索系統
						var _DataPack:Object = _obj.GetClass();
						this._ExploreDataCenter._currentSelectedTeamKey = _DataPack[ "_teamGroup" ];//暫存Team Key
						this._ExploreDataCenter._currentSelectedTeamMember = _DataPack[ "_teamMember" ];//儲存組隊成員 Key 與陣型索引
						trace( this._ExploreDataCenter._currentSelectedTeamKey , "已選擇探索組隊" );
						//this.SendNotify( "開啟探索指令" , _DataPack );
						this.SendNotify( "InitExploreJourney" , _DataPack );
						
						this.TerminateThis();
						//注意 到這裡才終結魔神殿控制器 (當玩家直接關閉組隊時將回到這層)
						
					break;
					
				case ( MajidanStrLib.Exit ) :
						this.TerminateThis();
						this.SendNotify( ViewSystem_BuildCommands.MAINVIEW_CREAT );	
					break;
					
				case ( TeamViewCtrl.TEAM_DESTROY ) ://當關閉組隊時也同時移除
						this.TerminateThis();
						//this.SendNotify( ViewSystem_BuildCommands.MAINVIEW_CREAT );//重複發送會有問題
					break;
					
					
				default:
					break;
			}
		}
		
		
		override public function GetListRegisterCommands():Array {
			return [ MajidanStrLib.Init_Majidan, 
					this._MajidanComponentPackKey , //MonsterCage場景所需的素材都準備完畢
					(this._MajidanComponentPackKey + "Invalid") , //場景所需的素材載入失敗
					MajidanStrLib.Start_Team, //開啟Team系統
					MajidanStrLib.Exit,
					MajidanStrLib.RenewExploreArea,
					MajidanStrLib.ExploreAreaSelected,
					MajidanStrLib.ExploreTeamSelected,
					TeamViewCtrl.TEAM_DESTROY
					];
		}
		
	}//end class
}//end package