package MVCprojectOL.ControllOL.Explore.Journey {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import MVCprojectOL.ControllOL.SoundControlCenter.SoundEventStrLib;
	import MVCprojectOL.ModelOL.BattleImaging.BattleImagingProxy;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Explore.Journey.ExploreAdventurePreparing;
	import MVCprojectOL.ModelOL.Explore.Vo.ExploreReport;
	import MVCprojectOL.ModelOL.Monster.MonsterProxy;
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplay;
	import MVCprojectOL.ModelOL.SourceData.UserSourceCenter;
	import MVCprojectOL.ModelOL.Vo.Battle.BattlefieldInit;
	import MVCprojectOL.ModelOL.Vo.Explore.RouteNode;
	import MVCprojectOL.ModelOL.Vo.PlayerSource;
	//import MVCprojectOL.ModelOL.Vo.RouteNode;
	import MVCprojectOL.ViewOL.ExploreView.ExplorationReport.ReportViewCtrl;
	import MVCprojectOL.ViewOL.ExploreView.Journey.JourneyViewCtrl;
	import MVCprojectOL.ViewOL.ExploreView.Journey.JourneyWallView;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import strLib.commandStr.ExploreAdventureStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.commandStr.WorldJourneyStrLib;
	import strLib.proxyStr.ProxyMonsterStr;
	import strLib.vewStr.ViewNameLib;
	import strLib.vewStr.ViewStrLib;
	
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
	import MVCprojectOL.ModelOL.Explore.Journey.ExploreAdventurePreparing;
	
	import MVCprojectOL.ModelOL.Explore.Journey.ExploreAdventure;
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.23.18.17
	 */
	public class CatchJourneyControl extends CatchCommands {
		
		
		private var _SourceProxy:SourceProxy;
		
		private var _ExploreAdventurePreparing:ExploreAdventurePreparing;
		private var _ExploreAdventure:ExploreAdventure;
		private var _ExploreDataCenter:ExploreDataCenter;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _MajidanComponentPackKey:String = "GUI00014_ANI";//魔神殿 素材包KEY碼
		
		//戰鬥素材
		/*private var _sourceKey:String="GUI00010_ANI";//素材KEY
		private var _aryBasicSource:Vector.<String> =new <String>["bg1","triangleArea","roundBoard","bottomWall","hpBar","infoBoard","play","pause","faster","leave","word_fight","word_lose","word_win"];//Class KEY*/
		
		
		//private const _GlobalComponentClassList:Vector.<String> = new < String > [ "bg1" , "pageBtnS" , "pageBtnM" , "sortBtn" , "changeBtn" , "bgBtn", "pageBtnN", "exitBtn", "Property" ];
		//private const _MajidanComponentClassList:Vector.<String> = new < String > [  "Reel", "Flame", "WhiteTower", "Fate", "CollectionStack", "CastleTown", "TortureChamber", "TimepieceTower", "Entrance", "Mud", "PracticingChurch", "StorageLibrary", "IronBridge" ];
		
		//private var _GlobalClasses:Object;
		//private var _MajidanClasses:Object;
		
		public var _currentRouteNode:RouteNode;
		
		private var _JourneyViewCtrl:JourneyViewCtrl;
		private var _ReportViewCtrl:ReportViewCtrl;
		
		private var _BattleImagingProxy:BattleImagingProxy;
		
		private var _MonsterProxy:IfProxy;

		public function CatchJourneyControl() {
			trace( "Journey Controller is on duty !! Waiting for command.------" ); 
		}
		
		
		/*private var _TimeoutID:uint = 0;
		private function StillAlive():void {
			trace( "---------------------------------------->>>" , this , "Still Alive !!!" );
			_TimeoutID = setTimeout( StillAlive , 2000 );
		}*/
		
		
		private function Ignite():void {
			
			//this._facaed.RegisterCommand( MajidanStrLib.Terminate_Majidan , Terminate_Majidan );//註冊終結事件
			
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._ExploreDataCenter = ExploreDataCenter.GetInstance();
				this._BattleImagingProxy = BattleImagingProxy.GetInstance();
				
				this._ExploreAdventurePreparing = ExploreAdventurePreparing.GetInstance();
				this._facaed.RegisterProxy( this._ExploreAdventurePreparing );
				
				this._MonsterProxy = this._facaed.GetProxy( ProxyMonsterStr.MONSTER_PROXY );	//130506
				
				this._ExploreAdventure = ExploreAdventure.GetInstance();
				this._facaed.RegisterProxy( this._ExploreAdventure );
				
				this._ExploreAdventure.InitModule( this._ExploreDataCenter._currentSelectedAreaKey , this._ExploreDataCenter._currentSelectedTeamKey , this._MonsterProxy );
				
				//this._GlobalClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClassList );
				
				this._ExploreAdventurePreparing.PrepareAreaScene( this._ExploreDataCenter._currentSelectedAreaKey );
				
				trace("公用素材OK !!" , this);
			}else {
				//若公用素材還沒有準備好 代表主程序未初始完畢  則發出終結指令終結這個command
				trace("公用素材不OK !!");
				this.TerminateThis();
			}
			
			
			
		}
		
		
		private function initJourney():void {
			trace( "開始初始探索" );
			
			
			//this._MajidanClasses = this._SourceProxy.GetMaterialSWP( this._MajidanComponentPackKey , this._MajidanComponentClassList );
			
			/*for (var i:String in this._GlobalClasses ) {
				trace( i , this._GlobalClasses[i] , "<---公用元件類" );
			}
			
			for ( i in this._MajidanClasses ) {
				trace( i , this._MajidanClasses[i] , "<---魔神殿元件類" );
			}*/
			
			trace( "開始起始ViewCtrl、相關Proxy與元件----------" );
			/*
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_MonsterCageProxy );//移除已不需要的Proxy (MonsterCageProxy)
			this._MonsterCageProxy = null;//釋放MonsterCageProxy指標
			*/
			
			
			//----------註冊所需的VIEW & PROXY
			
			
			//---------------Kai
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._JourneyViewCtrl = new JourneyViewCtrl ( ViewNameLib.View_Journey , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._JourneyViewCtrl );//註冊探索ViewCtrl
			
			this._JourneyViewCtrl.AddMajidanClasses(this._ExploreDataCenter._GlobalClasses, this._ExploreDataCenter._MajidanClasses);
			
			this._ReportViewCtrl = new ReportViewCtrl ( ViewNameLib.View_Report , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._ReportViewCtrl );//註冊探索ViewCtrl
			
			this._ReportViewCtrl.BackGroundElement(this._ExploreDataCenter._GlobalClasses);
			
			MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).RemoveClass();
			//var _JourneyObj:Object = [this._ExploreDataCenter._GlobalClasses, this._ExploreDataCenter._MajidanClasses ];
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddClass(JourneyWallView);
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddSingleSource("JourneyWallView" , _JourneyObj);
		}
		
		private function initView(_Num:uint):void{
			this._JourneyViewCtrl.BackGround(this._ExploreDataCenter._currentNodeScene);//130312 新增
			this._JourneyViewCtrl.MonsterTeam(this._ExploreDataCenter._currentSelectedTeamMemberDisplays, _Num);
			this._JourneyViewCtrl.DirectionIndicator(this._ExploreDataCenter._currentRouteNode);
			//MainSystemPanel(this._facaed.GetRegisterViewCtrl(ViewStrLib.Panel_Main)).AddVaule(this._ExploreDataCenter);
		}
		
		private function TerminateThis():void {
			this._BattleImagingProxy.EndOfShow();//刷除舊戰鬥資訊
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_Journey );
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_Report );
			
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_ExploreAdventurePreparing );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_ExploreAdventure );
			
			this._facaed.RemoveProxy(ProxyNameLib.Proxy_CombatSkillDisplayProxy);//將戰鬥物件裝配場關閉
			this._facaed.RemoveProxy(ProxyNameLib.Proxy_CombatMonsterDisplayProxy);//將戰鬥物件裝配場關閉
			
			
			//this._ExploreAdventurePreparing.TerminateModule();
			
			this._ReportViewCtrl = null;
			
			this._SourceProxy = null;
			this._JourneyViewCtrl = null;
			
			//this._ExploreDataCenter.Terminate();
			
			this._BattleImagingProxy.onRemovedProxy();
			
			//this._facaed.RemoveCommand( "" , CatchJourneyControl );
			this._facaed.RemoveALLCatchCommands( CatchJourneyControl );
			
			this.SendNotify( MajidanStrLib.End_Majidan );
			this.SendNotify( WorldJourneyStrLib.Exit );
			this.SendNotify( SoundEventStrLib.PlayBgmSync , "GUI00001_SND" );//for music test
		}
		
		
		
		//----------------------------------------------------------------------------------Command Router
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void {
			
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) {
				
				case ( ExploreAdventureStrLib.Init_ExploreAdventureSys ) :
						this.Ignite();
						//trace( "QQQQFDSFSDKPFJOSDPFIOSJFSDIOFJSDFISDJFSD" );
						//this.initJourney();
					break;	
					
				case ( ExploreAdventureStrLib.ExploreAdventurePreparing_AllReady ) :
						//this.initMajidan();//素材回來代表系統可以動了( 載入次序: 1.資料 2.素材 )
						//trace( "素材回來代表系統可以動了" );
						//this._ExploreDataCenter.GetExploreAreaRandomSceneKey();//重新亂數目前所選擇的場景 130221 wasted
						this._ExploreAdventure.GetNewRoute();//取得初始路徑節點資訊
						this.SendNotify( SoundEventStrLib.PlayBgmSync , "GUI00002_SND" );//for music test
						this.initJourney();
						
					break;
					
				case ( ExploreAdventureStrLib.ExploreAdventure_NewRouteNode ) :
						//節點資訊已回來  更新場景資訊 並刷新畫面
						var _CurrentRouteNode:RouteNode = Object( _obj.GetClass() )["NewNode"] as RouteNode;
						( _CurrentRouteNode != null ) ? this.ValueProcedure( _CurrentRouteNode ) : this.TerminateThis();
					break;
					
				case ( ExploreAdventureStrLib.ExploreAdventureView_SelectRoute ) :
						//點選路徑
						//trace(_obj.GetClass().SelectedNode,"=========");
						this._ExploreAdventure.GetNewRoute( _obj.GetClass().SelectedNode as RouteNode );//轉送由VIEW來的RouteNode
						
					break;
					
				case ( ExploreAdventureStrLib.BattleStart ) :
						this.realBattle( this._ExploreDataCenter._currentRouteNode );
					break;
					
				case ( this._MajidanComponentPackKey + "Invalid" ) :
						//trace( this._MajidanComponentPackKey , "載入錯誤   終結Majidan" );
						this.TerminateThis();
					break;
					
				case ( ExploreAdventureStrLib.ShowReport ) :
						this.ShowReport();//探索報告
						this._JourneyViewCtrl.RemoveInform("", false);
					break;
					
				case ( ExploreAdventureStrLib.RemoveALL ) :
						this.TerminateThis();//探索報告看完回到這裡130325
						MainSystemPanel(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.Panel_Main)).UseprotectedFunction("ExploreBack");
					break;
					
					
				case ( ExploreAdventureStrLib.ExploreBattleEvent ) :
						//戰鬥事件判斷  (來自戰鬥播放器)
						this.JudgeBattleEvent( _obj.GetClass()._status as String , _obj.GetClass()._content );//
						
						
						/*_status : "LEAVING" , _content : {...}
						_status : "CLOSE"    , _content : null
						_status : "READY"    , _content : null
						
						"right" : "left"   >>對應 [位置, ...]
							Object
						
						*/
						
						//回覆上下板
						//刷新怪物資料 ( 戰死 或 戰損 )
						//刷新場景怪物
						//毀滅戰敗一方
						
						//己方 勝->繼續探索 敗->退出探索
						//this.SendNotify( ViewSystem_BuildCommands. );
					break;
					
				case (ExploreAdventureStrLib.NextNode) :
						//this.JudgeExploreEnd( this._ExploreDataCenter._currentRouteNode );
						//this.JudgeExploreEnd( this._ExploreDataCenter._currentRouteNode ) == false ? null : this.TerminateThis() ;//非結束時 則開啟節點選項
						
						/*if ( this._ExploreDataCenter._currentRouteNode._valuePack != null ) {
								this._ExploreDataCenter.UpdateMonstersValues( this._ExploreDataCenter._currentRouteNode._valuePack );//更新惡魔當前數值(使用SERVER資訊)
						}*/
						
						
						//this.JudgeExploreEnd( this._ExploreDataCenter._currentRouteNode ) == false ? null : this.ShowReport() ;//非結束時 則開啟節點選項
						this._ExploreDataCenter._success = this._ExploreDataCenter._currentRouteNode._battleScript._isWin;//記錄探索失敗
						
						
						
						if ( this._ExploreDataCenter._currentDropList != null && this._ExploreDataCenter._currentDropList._material != null ) {
							var _SourceDatas:Array = [ ];
							var _DataList:Object = this._ExploreDataCenter._currentDropList._material;
							//MTL00001 = 靈魂  _type == 3
							for (var i:* in _DataList ) {
								_SourceDatas.push( _DataList[ i ] );
								//PlayerSource( _DataList[ i ] )._groupGuid == "MTL00001" ? PlayerDataCenter.addMoney( PlayerSource( _DataList[ i ] )._number ) : null;
								//PlayerSource( _DataList[ i ] )._type == 3 ? PlayerDataCenter.addMoney( PlayerSource( _DataList[ i ] )._number ) : null;
							}
							
							//PlayerDataCenter.addMoney( );
							UserSourceCenter.GetUserSourceCenter().AddSource( _SourceDatas );//回寫建材數值回系統資料中心
							
						}
						
						
						if (this._ExploreDataCenter._LvUpList.length != 0) {
							this._JourneyViewCtrl.LvUpData(this._ExploreDataCenter._LvUpList);
							setTimeout( this.ShowReport , 1500 ) ;//非結束時 則開啟節點選項
						}else {
							this.ShowReport();
						}
						
						//this._JourneyViewCtrl.LvUpData(this._ExploreDataCenter._LvUpList);
					break;
					
				case (ExploreAdventureStrLib.BackBlood) :
						//this._JourneyViewCtrl.ShowBackBlood(_obj.GetClass().Monster, this._ExploreDataCenter.GetHealEffect());
						
						// 1:回血 2:升級
						var _GetEffect:CombatSkillDisplay;
							_GetEffect = ( _obj.GetClass().Property == 1 )? this._ExploreDataCenter.GetHealEffect() : this._ExploreDataCenter.GetLvUpEffect() ;
						this._JourneyViewCtrl.ShowBackBlood( _obj.GetClass().Monster , _GetEffect );
						
					break;
					
				case (ExploreAdventureStrLib.Chest) :
						this._JourneyViewCtrl.ShowChest(this._ExploreDataCenter.GetDropReport());
					break;
					
				/*case (ExploreAdventureStrLib.ShowIndex) :
						this._JourneyViewCtrl.RemoveChest();
						//this._JourneyViewCtrl.ShowIndex(false);
						
						
						
						//---------------------顯示路徑選擇時 順便更新所拾的素材數量
						if ( this._ExploreDataCenter._currentDropList != null && this._ExploreDataCenter._currentDropList._material != null ) {
							var _SourceDatas2:Array = [ ];
							var _DataList:Object = this._ExploreDataCenter._currentDropList._material;
							//MTL00001 = 靈魂  _type == 3
							for (var i:* in _DataList ) {
								_SourceDatas2.push( _DataList[ i ] );
								//PlayerSource( _DataList[ i ] )._groupGuid == "MTL00001" ? PlayerDataCenter.addMoney( PlayerSource( _DataList[ i ] )._number ) : null;
								//PlayerSource( _DataList[ i ] )._type == 3 ? PlayerDataCenter.addMoney( PlayerSource( _DataList[ i ] )._number ) : null;
							}
							
							//PlayerDataCenter.addMoney( );
							UserSourceCenter.GetUserSourceCenter().AddSource( _SourceDatas2 );//回寫建材數值回系統資料中心
							
						}
						
					break;*/
					
				default:
					break;
			}
		}
		//------------------------------------------------------------------------END-------Command Router
		
		private function ValueProcedure( _CurrentRouteNode:RouteNode ):void {
			//當確認_CurrentRouteNode為有效封包後 繼續數值處理  並打開演示層
			
			this._ExploreDataCenter.UpdateCurrentRouteNode( _CurrentRouteNode );
							
							if ( _CurrentRouteNode._oldValuePack != null ) {
								this._ExploreDataCenter.MonsterPrimitiveValueAlignment( _CurrentRouteNode._oldValuePack );//校正惡魔原始數值(使用SERVER資訊)
							}
							
							/*if ( _CurrentRouteNode._valuePack != null ) {
								this._ExploreDataCenter.UpdateMonstersValues( _CurrentRouteNode._valuePack );//更新惡魔當前數值(使用SERVER資訊)
							}*/
							
							
							( _CurrentRouteNode._itemDrop != null ) ?
								this._ExploreDataCenter.AddToExploreReport( _CurrentRouteNode._itemDrop )//130329
								:
								this._ExploreDataCenter._currentDropList = null;//刷新當前掉落狀態
							
							
							
							//刷新畫面
							//this._ExploreDataCenter._currentRouteNode._newRouteList.length <= 0 ? this.TerminateThis() : this.RouteTypeSplit( _CurrentRouteNode );//當下一步清單為空時 則無下一步 做結束處理
							//this.RouteTypeSplit( _CurrentRouteNode );//當下一步清單為空時 則無下一步 做結束處理
							
			this.initView( 1 );//開啟探索場景刷新  //0.沒事, 1.惡魔, 2.寶箱, 3.安全, 4.魔王
			_CurrentRouteNode._battleScript != null ? this.onBattle( _CurrentRouteNode ) : null;//若有列表則開啟戰鬥 130521
							
							
		}
		
		
		
		
		private function RouteTypeSplit( _CurrentRouteNode:RouteNode ):void {
			
			/*this.initView( _CurrentRouteNode._type );//開啟探索場景刷新
			switch ( _CurrentRouteNode._type ) {//該節點的類型	//0.沒事, 1.惡魔, 2.寶箱, 3.安全, 4.魔王
				case 1 :		//惡魔
						trace( "打架" );
						_CurrentRouteNode._battleScript != null ?  this.onBattle( _CurrentRouteNode ) : null;//若有列表則開啟戰鬥
					break;
					
				case 2 :	//寶箱
						trace( "在這裡找到寶箱" );
						//this._JourneyViewCtrl.EndNode();
						//this._ReportViewCtrl.AddReportPanel();
					break;
					
				case 3 :	//安全
						trace( "回血" );
						this._ExploreDataCenter.UpdateMonstersValues( _CurrentRouteNode._valuePack );//更新怪物數值(血量)
						//this._JourneyViewCtrl.EndNode();
					break;
					
				default :
					break;
			}*/
			
			this.initView( 1 );//開啟探索場景刷新
			_CurrentRouteNode._battleScript != null ? this.onBattle( _CurrentRouteNode ) : null;//若有列表則開啟戰鬥 130521
			
		}
		
		
		private function onBattle( _CurrentRouteNode:RouteNode ):void {
			//	戰鬥預備動作
			this._BattleImagingProxy.EndOfShow();//刷除舊戰鬥資訊
			this._ExploreAdventurePreparing.GetEnemyMonsterPrepared( _CurrentRouteNode._battleScript._objEnemy );//準備敵方怪物顯示元件
				//_CurrentRouteNode._battleScript._areaPic = _CurrentRouteNode._picKey;//同步戰場背景
			this._JourneyViewCtrl.EnemyMonsterTeam(this._ExploreDataCenter._currentEnemyTeamMemberDisplays , _CurrentRouteNode._battleScript._battleId );//場景加入怪物
			this._BattleImagingProxy.ToImagingBattle( _CurrentRouteNode._battleScript , ExploreAdventureStrLib.ExploreBattleEvent );//預載戰鬥
			//this._BattleImagingProxy.EndOfShow();
		}
		
		private function realBattle( _CurrentRouteNode:RouteNode ):void {
			//開啟戰鬥
			this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SWICH,{_btnName:"Explore"}); //收起探索城牆
			this._BattleImagingProxy.PauseThrough();//開始戰鬥
		}
		
		private function JudgeBattleEvent( _InputEvent:String , _InputContent:Object = null ):void {
			switch ( _InputEvent ) {
				/*case "READY" : //戰鬥已載好
						//打開觀賞面板
						trace( "Battle Ready" );
					break;*/
					
				case "CLOSE" : //戰鬥已播放完畢			當退出戰鬥播放器或點選不觀看時會進入此段
						trace( "Battle Over" );
						this._ExploreDataCenter.UpdateMonstersValues( this._ExploreDataCenter._currentRouteNode._valuePack , this._ExploreDataCenter._currentRouteNode._oldValuePack );//更新惡魔戰損數值
						this._ExploreAdventure.AllyCasualtiesCheck();//計算傷亡結果
						
						this._BattleImagingProxy.EndOfShow();//刷除舊戰鬥資訊
						this.SendNotify( ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
						this._JourneyViewCtrl.MonsterTeam(this._ExploreDataCenter._currentSelectedTeamMemberDisplays, 5, this._ExploreDataCenter._currentRouteNode._battleScript._isWin);//130312 新增惡魔更新資訊
						this._JourneyViewCtrl.WinOrLose(this._ExploreDataCenter._currentRouteNode._battleScript._isWin);
						//用最後的數值檢查戰損資料 並更新探索戰損狀況 130313
					break;
					
				case "LEAVING" : //戰鬥正要退出
						trace( "Battle LEAVING" );
						//用當前戰鬥的值檢查戰損資料  並先行更新探索戰損狀況 130313
						this._JourneyViewCtrl.MonsterDead(_InputContent);
						//_InputContent;
					break;
					
				default:
					break;
			}
		}
		
		private function JudgeExploreEnd( _InputRouteNode:RouteNode ):Boolean {
			switch( true ) {//使探索結束的條件
				/*case ( _InputRouteNode._battleScript != null && _InputRouteNode._battleScript._isWin == false ) ://戰鬥失敗
						this._ExploreDataCenter._success = false;//記錄探索失敗
						return true;
					break;
				*/
				/*case ( _InputRouteNode._newRouteList.length <= 0 ) ://最後的探索節點
						this._ExploreDataCenter._success = true;//記錄探索成功
						this.SendNotify( WorldJourneyStrLib.CheckExploreChapterData );
						return true;
					break;*/
					
				case ( _InputRouteNode._battleScript != null ) ://戰鬥失敗
						this._ExploreDataCenter._success = _InputRouteNode._battleScript._isWin;//記錄探索失敗
						return this._ExploreDataCenter._success;
					break;
					
				default :
						return false;
					break;
			}
		}
		
		
		private function ShowReport():void {  
			var _ExploreReport:ExploreReport = this._ExploreDataCenter.GetFinalReport();//送進VIEW的報告顯示物件
			
			//ProxyMonsterStr.MONSTER_PROXY
			var _MonsterProxy:MonsterProxy = this._facaed.GetProxy( ProxyMonsterStr.MONSTER_PROXY ) as MonsterProxy;
				
			
			if ( _ExploreReport != null ) {
				this._ReportViewCtrl.AddReportPanel(_ExploreReport, this._ExploreDataCenter._LvUpList);
				//this._JourneyViewCtrl.ShowIndex(true);
				/*var _Length:uint = _ExploreReport._acquiredMaterialDisplays.length;
				for (var i:int = 0; i < _Length; i++) {
				}*/
				
				var _MonsterDatas:Array = [];
				for ( var i:* in _ExploreReport._teamMonsterDisplays  ) {
					_MonsterDatas.push( _ExploreReport._teamMonsterDisplays[ i ].MonsterData );
				}
				
				//_MonsterProxy.CalculateMonster( _MonsterDatas );//回寫己方怪物血量至資訊中心
				_MonsterProxy.ExploreBack( _MonsterDatas );//回寫己方怪物血量至資訊中心 13.05.03.15.04
				_MonsterProxy.AddMonster( this._ExploreDataCenter._ExploreReport._monsters );//回寫新獲得的怪物至資訊中心
				
				
				/*//回寫所取得之物品
				var _SourceDatas:Array = [ ];
				var _DataList:Object = this._ExploreDataCenter._currentDropList._material;
							//MTL00001 = 靈魂  _type == 3
							for (var i:* in _DataList ) {
								if ( i != "MTL00001" && i != "MTL00002" && i != "MTL00003" && i != "MTL00004" ) {//素材除外
									_SourceDatas.push( _DataList[ i ] );
								}
								
								//PlayerSource( _DataList[ i ] )._groupGuid == "MTL00001" ? PlayerDataCenter.addMoney( PlayerSource( _DataList[ i ] )._number ) : null;
								//PlayerSource( _DataList[ i ] )._type == 3 ? PlayerDataCenter.addMoney( PlayerSource( _DataList[ i ] )._number ) : null;
							}
							
							//PlayerDataCenter.addMoney( );
							UserSourceCenter.GetUserSourceCenter().AddSource( _SourceDatas );//*/
						
				
				this._ExploreDataCenter.Refresh();//必須刷新數據中心的數據
				
			}else {
				this.TerminateThis();
			}
			//var _ExploreReport2:ExploreReport = this._ExploreDataCenter.GetFinalReport();//送進VIEW的報告顯示物件
			
			//var _QQQ:String = "you are shit";
				//trace( _QQQ );
				//_ExploreReport._acquiredItemsDisplays;
				
				//須通知SERVER玩家已離開該探索
				
				
			//this.TerminateThis();
		}
		
		
		
		override public function GetListRegisterCommands():Array {
			return [ 	ExploreAdventureStrLib.Init_ExploreAdventureSys , 
						this._MajidanComponentPackKey , //MonsterCage場景所需的素材都準備完畢
						(this._MajidanComponentPackKey + "Invalid") ,  //場景所需的素材載入失敗
						ExploreAdventureStrLib.ExploreAdventurePreparing_AllReady ,
						ExploreAdventureStrLib.ExploreAdventure_NewRouteNode ,
						ExploreAdventureStrLib.ExploreAdventureView_SelectRoute ,
						ExploreAdventureStrLib.RemoveALL ,
						ExploreAdventureStrLib.BattleStart ,
						ExploreAdventureStrLib.ExploreBattleEvent,
						ExploreAdventureStrLib.NextNode,
						ExploreAdventureStrLib.BackBlood,
						ExploreAdventureStrLib.Chest,
						ExploreAdventureStrLib.ShowIndex,
						ExploreAdventureStrLib.ShowReport
					];
		}
		
	}//end class
}//end package